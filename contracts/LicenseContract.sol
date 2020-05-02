pragma solidity >=0.4.0 <0.6.0;

contract LicenseContract {

    struct DigitalAssetLicenseContract {
        /* ------------- Contract Terms ------------- */
        address payable licensor; // wallet address of party who owns digital asset
        address payable licensee; // wallet address of party who is licensing digital asset
        bytes32 assetId; // digital asset being licensed
        uint fee; // licensing fee (in Wei)

        /* ------------- Contract State ------------- */
        bool licensorApproved; // boolean representing if licensor has approved the contract
        bool licenseeApproved; // boolean representing if licensee has approved the contract
        bool executed; // boolean representing if the contract has been executed and is in place
        bool canceled; // boolean representing if the contract has been canceled
    }

    DigitalAssetLicenseContract[] public licenseContracts;


    /* ------------- Contract Events ------------- */

    event Create(address indexed initiator, uint contractId);
    event Modify(address indexed initiator, uint contractId);
    event Approve(address indexed initiator, uint contractId);
    event Execute(address indexed initiator, uint contractId);
    event Cancel(address indexed initiator, uint contractId);


    /* ------------- Function Modifiers ------------- */

    modifier notExecuted(uint id) {
        require(!licenseContracts[id].executed, "This function cannot be run on an already executed contract.");
        _;
    }
    modifier notCanceled(uint id) {
        require(!licenseContracts[id].canceled, "This function cannot be run on an already canceled contract.");
        _;
    }
    modifier fullyApproved(uint id) {
        require(licenseContracts[id].licensorApproved && licenseContracts[id].licenseeApproved, "This function cannot be run until both parties have approved the contract.");
        _;
    }
    modifier onlyInvolvedParties(uint id) {
        require(tx.origin == licenseContracts[id].licensor || tx.origin == licenseContracts[id].licensee, "This function can only be called by the contract licensor or licensee.");
        _;
    }

    /* ------------- Internal Functions ------------- */

    function modify(uint id) internal {

        // undo any previous approvals. new approvals will be required
        licenseContracts[id].licensorApproved = false;
        licenseContracts[id].licenseeApproved = false;

        // emit event
        emit Modify(msg.sender, id);
    }

    function execute(uint id) internal fullyApproved(id) {
        
        // transfer Ether to licensor
        licenseContracts[id].licensor.transfer(address(this).balance);
        licenseContracts[id].executed = true;

        // emit event
        emit Execute(msg.sender, id);
    }


    /* ------------- Public Functions ------------- */
    
    function create(address payable _licensor, address payable _licensee, bytes32 _assetId, uint _fee) public {
        
        DigitalAssetLicenseContract memory cont;
        cont.licensor = _licensor;
        cont.licensee = _licensee;
        cont.assetId = _assetId;
        cont.fee = _fee;
        cont.licensorApproved = false;
        cont.licenseeApproved = false;
        cont.executed = false;
        cont.canceled = false;
        
        uint contractId = licenseContracts.length;
        licenseContracts.push(cont);

        emit Create(msg.sender, contractId);
    }

    function cancel(uint id) public onlyInvolvedParties(id) notExecuted(id) notCanceled(id) {
        // cancel contract
        licenseContracts[id].canceled = true;  

        // send funds back to licensee if any
        if (address(this).balance > 0) {
            licenseContracts[id].licensee.transfer(address(this).balance);
        }

        // emit event
        emit Cancel(msg.sender, id);  
    }

    function modifyFee(uint id, uint newFee) public onlyInvolvedParties(id) notExecuted(id) notCanceled(id) {
        licenseContracts[id].fee = newFee;  // modify fee
        modify(id);  // reset approvals and emit event
    }

    function approve(uint id) public onlyInvolvedParties(id) notExecuted(id) notCanceled(id) payable {

        // verify there is actually an action to take
        require((msg.sender == licenseContracts[id].licensor && !licenseContracts[id].licensorApproved) || (msg.sender == licenseContracts[id].licensee && !licenseContracts[id].licenseeApproved),
                "This contract has already been approved by this party.");

        // toggle the correct flag 
        if (msg.sender == licenseContracts[id].licensor) {
            licenseContracts[id].licensorApproved = true;
        } else {
            // verify licensee attached enough Ether to cover fee
            require(msg.value == licenseContracts[id].fee, "Could not approve contract without payment.");
            licenseContracts[id].licenseeApproved = true;
        }

        // emit event
        emit Approve(msg.sender, id);

        // if both parties have approved, then move on to execute
        if (licenseContracts[id].licensorApproved && licenseContracts[id].licenseeApproved) {
            execute(id);
        }

    }

}
