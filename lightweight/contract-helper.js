var Web3 = require('web3');

var getRopstenTxLink = (txHash) => "<a href=\"https://ropsten.etherscan.io/tx/"+ txHash + "\" target=\"txTarget\">" + txHash + "</a>";
var getRopstenAddressLink = (address) => "<a href=\"https://ropsten.etherscan.io/address/"+ address + "\" target=\"txTarget\">" + address + "</a>";

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

class ImageInterface {

    constructor() {
        this.imageContract = web3.eth.contract(Contracts['Image'].abi);
        this.image = this.imageContract.at(Contracts['Image'].address);
        this.address = this.image.address;
        console.log("Initializing ImageInterface:");
        console.log(this.image);

        // set up event listener
        let that = this;

        // =================== BEGIN EVENT LISTENER 1 =======================
        this.image.Created({filter: {owner: window.web3.eth.accounts[0]}}, 
            function(error, data) {
                that.createdRunning = true;
                console.log("Create Image Data: ");
                console.log(data);
                console.log("ID: " + data.args.id);
                console.log("Owner: " + data.args.owner);
                that.afterCreatedConfirmedCallbackFunction(error, data, data.args.owner, data.args.id);
                sleep(1000);
        });
        // =================== END EVENT LISTENER 1 =======================
    }

    createImage(name, description, externalPointer, afterSubmitCallbackFunction, afterConfirmedCallbackFunction) {
        this.image.createAsset(externalPointer, name, description,
                            { from: window.web3.eth.accounts[0], gasLimit: 100000 }, 
                            function(error, txHash){
                                console.log("Create Image Hash:" + txHash);
                                afterSubmitCallbackFunction(error, txHash);
                            });
        this.afterCreatedConfirmedCallbackFunction = afterConfirmedCallbackFunction;
    }

    getImageAtPosition(position, callbackFunction) {
        let that = this;
        this.image.getIdByPosition(position,
            { from: window.web3.eth.accounts[0], gasLimit: 100000 }, 
            function(error, id){
                console.log("Got Image ID at Position " + position + ": " + id);
                that.getImageById(id, callbackFunction);
            });
    }

    getImageById(id, callbackFunction) {
        this.image.getById(id,
            { from: window.web3.eth.accounts[0], gasLimit: 100000 }, 
            function(error, result){
                let img = { owner: result[0],
                            externalPointer: result[2],
                            name: result[3],
                            description: result[1],
                            id: result[4]
                            };

                console.log("Got Image with ID: " + id);
                console.log(img);

                callbackFunction(error, img);
            });
    }

    getAllImages(callbackFunction) {
        let that = this;
        this.image.getCount({ from: window.web3.eth.accounts[0], gasLimit: 100000 }, 
            function(error, count) {
                var images = [];
                for (let i=0; i<count.c[0]; i++) {
                    that.getImageAtPosition(i, function(error, img){
                        images.push(img);
                        if (images.length == count.c[0]) {
                            
                            console.log("Got all images:");
                            console.log(images);

                            callbackFunction(error, images);
                        }
                    });
                }
            });
    }
    

}

class ContractInterface {

    constructor() {
        this.licenseContract = web3.eth.contract(Contracts['LicenseContract'].abi);
        this.contract = this.licenseContract.at(Contracts['LicenseContract'].address);
        this.address = this.contract.address;
        console.log("Initializing LicenseContractInterface:");
        console.log(this.contract);

        // set up event listeners
        let that = this;

        // =================== BEGIN EVENT LISTENER 2 =======================
        this.contract.Create({filter: {initiator: window.web3.eth.accounts[0]}}, 
            function(error, data) {
                console.log("Create LicenseContract Data: ");
                console.log(data);
                console.log("Initiator: " + data.args.initiator);
                console.log("Contract ID: " + data.args.contractId);
                that.afterCreatedConfirmedCallbackFunction(error, data, data.args.initiator, data.args.contractId);
        });
        // =================== END EVENT LISTENER 2 =======================

        // =================== BEGIN EVENT LISTENER 3 =======================
        this.contract.Approve({filter: {initiator: window.web3.eth.accounts[0]}}, 
            function(error, data) {
                console.log("Approved LicenseContract Data: ");
                console.log(data);
                console.log("Initiator: " + data.args.initiator);
                console.log("Contract ID: " + data.args.contractId);
                that.afterApprovedConfirmedCallbackFunction(error, data, data.args.initiator, data.args.contractId);
        });
        // =================== BEGIN EVENT LISTENER 3 =======================

    }

    // afterCreatedConfirmedCallbackFunction = function(error, data, initiator, contractId){};
    // afterApprovedConfirmedCallbackFunction = function(error, data, initiator, contractId){};

    createContract(licensor, licensee, assetId, fee, afterSubmitCallbackFunction, afterConfirmedCallbackFunction) {
        this.afterCreatedConfirmedCallbackFunction = afterConfirmedCallbackFunction;
        this.contract.create(licensor, licensee, assetId,  web3.toWei(fee, "ether"),
                            { from: window.web3.eth.accounts[0], gasLimit: 100000 }, 
                            function(error, txHash){
                                console.log("Create LicenseContract Tx Hash: " + txHash);
                                afterSubmitCallbackFunction(error, txHash);
                            });
    }

    getContract(id, callbackFunction) {
        this.contract.licenseContracts(id,
            { from: window.web3.eth.accounts[0], gasLimit: 100000 }, 
            function(error, result){

                let tmpcontract = { licensor: result[0],
                    licensee: result[1],
                    imageId: result[2],
                    fee: result[3],
                    licensorApproved: result[4],
                    licenseeApproved: result[5],
                    executed: result[6],
                    canceled: result[7],
                    };

                console.log("Got Contract with ID: " + id);
                console.log(tmpcontract);

                callbackFunction(error, tmpcontract);
            });
    }

    approveContract(contractId, payment, afterSubmitCallbackFunction, afterConfirmedCallbackFunction) {
        this.afterApprovedConfirmedCallbackFunction = afterConfirmedCallbackFunction;
        this.contract.approve(contractId,
                                { from: window.web3.eth.accounts[0], gasLimit: 100000, value: web3.toWei(payment, "ether")}, 
                                function(error, txHash){
                                    console.log("Approve LicenseContract Tx Hash: " + txHash);
                                    afterSubmitCallbackFunction(error, txHash);
                                });
    }
    
}
