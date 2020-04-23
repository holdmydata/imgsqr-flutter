pragma solidity >=0.4.0 <0.6.0;

import 'DigitalAsset.sol';

contract DigitalAssetLicense {

    struct DigitalAssetLicenseContract {
        /* ------------- Contract Terms ------------- */
        address public licensor; // wallet address of party who owns digital asset
        address public licensee; // wallet address of party who is licensing digital asset
        DigitalAsset public asset; // digital asset being licensed
        uint fee; // licensing fee (in Wei)

        /* ------------- Contract State ------------- */
        bool public licensorApproved = false; // boolean representing if licensor has approved the contract
        bool public licenseeApproved = false; // boolean representing if licensee has approved the contract
        bool public executed = false; // boolean representing if the contract has been executed and is in place
        bool public canceled = false; // boolean representing if the contract has been canceled
    }

    DigitalAssetLicenseContract[] public licenseContracts;



    /* ------------- Contract Events ------------- */

    event Create(address indexed initiator, address indexed licensee, address indexed licensor);
    event Modify(address indexed initiator);
    event Approve(address indexed initiator);
    event Execute(address indexed initiator);
    event Cancel(address indexed initiator);


    /* ------------- Function Modifiers ------------- */

    modifier notExecuted {
        require(!executed, "This function cannot be run on an already executed contract.");
        _;
    }
    modifier notCanceled {
        require(!canceled, "This function cannot be run on an already canceled contract.");
        _;
    }
    modifier fullyApproved {
        require(licensorApproved && licenseeApproved, "This function cannot be run until both parties have approved the contract.");
        _;
    }
    modifier onlyInvolvedParties {
        require(tx.origin == licensor || tx.origin == licensee, "This function can only be called by the contract licensor or licensee.");
        _;
    }

    /* ------------- Internal Functions ------------- */

    function modify() internal {

        // undo any previous approvals. new approvals will be required
        licensorApproved = false; 
        licenseeApproved = false;

        // emit event
        emit Modify(msg.sender);
    }

    function execute() internal fullyApproved {
        
        // transfer Ether to licensor
        licensor.transfer(address(this).balance);

        // emit event
        emit Execute(msg.sender);
    }


    /* ------------- Public Functions ------------- */
    
    constructor (address _licensor, address _licensee, DigitalAsset _asset, uint _fee) public {
        licensor = _licensor;
        licensee = _licensee;
        asset = _asset;
        fee = _fee;
    }

    function cancel() public onlyInvolvedParties notExecuted notCanceled {
        // cancel contract
        canceled = true;  

        // send funds back to licensee if any
        if (address(this).balance > 0) {
            licensee.transfer(address(this).balance);
        }

        // emit event
        emit Cancel(msg.sender);  
    }

    function modifyFee(uint newFee) public onlyInvolvedParties notExecuted notCanceled {
        fee = newFee;  // modify fee
        modify();  // reset approvals and emit event
    }

    function approve() public onlyInvolvedParties notExecuted notCanceled payable {

        // verify there is actually an action to take
        require((msg.sender == licensor && !licensorApproved) || (msg.sender == licensee && !licenseeApproved),
                "This contract has already been approved by this party.");

        // toggle the correct flag 
        if (msg.sender == licensor) {
            licensorApproved = true;
        } else {
            // verify licensee attached enough Ether to cover fee
            require(msg.value == fee, "Could not approve contract without license fee.");
            licenseeApproved = true;
        }

        // emit event
        emit Approve(msg.sender);

        // if both parties have approved, then move on to execute
        if (licensorApproved && licenseeApproved) {
            execute();
        }

    }

}