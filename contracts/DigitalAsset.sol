pragma solidity >=0.4.0 <0.6.0;

contract DigitalAsset {
    
    struct DigitalAssetStruct {
        address owner;
        string externalPointer;
        string name;
        string description;
        bytes32 id;
        bool exists;
    }

    bytes32[] public getIdByPosition;
    mapping(bytes32 => DigitalAssetStruct ) public getById;

    event Created(address indexed owner, bytes32 id);
    
    function createAsset(string memory _name, string memory _description, string memory _externalPointer)
        public
    {
        DigitalAssetStruct memory asset;
        asset.owner = msg.sender;
        asset.externalPointer = _externalPointer;
        asset.name = _name;
        asset.description = _description;
        asset.id = generateIdentityHash(asset);
        asset.exists = true;
        require(!getById[asset.id].exists, "Asset with this Idendity Hash (id) already exists.");
        getById[asset.id] = asset;
        getIdByPosition.push(asset.id);
        emit Created(msg.sender, asset.id);
        
    }

    function getCount() public view returns (uint) {
        return getIdByPosition.length;
    }

    function generateIdentityHash(DigitalAssetStruct memory) internal returns (bytes32);

}

