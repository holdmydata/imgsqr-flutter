pragma solidity >=0.4.0 <0.6.0;

contract DigitalAsset {
    
    struct DigitalAssetStruct {
        address owner;
        string externalPointer;
        string name;
        string description;
        string identityHash;
    }

    // DigitalAssetStruct[] public assets;
    mapping(string => DigitalAssetStruct ) assets;
    
    function create(string memory _externalPointer, string memory _name, string memory _description) 
        public
    {
        DigitalAssetStruct memory asset;
        asset.owner = msg.sender;
        asset.externalPointer = _externalPointer;
        asset.name = _name;
        asset.description = _description;
        asset.identityHash = generateIdentityHash(asset);
        assets[asset.identityHash] = asset;
    }

    function generateIdentityHash(DigitalAssetStruct memory) internal pure returns (string memory);

    function getDigitalAsset(string memory _identityHash) view public returns(address, string memory, string memory, string memory, string memory) {
        return (assets[_identityHash].owner,
                assets[_identityHash].externalPointer,
                assets[_identityHash].name,
                assets[_identityHash].description,
                assets[_identityHash].identityHash);
    }

    // modifier isUnique(string memory _identityHash) {
    //     bool result = true;
    //     for (uint256 i = 0; i < assets.length; i++) {
    //         if ( keccak256(bytes(assets[i].identityHash)) == keccak256(bytes(_identityHash)) ) {
    //             result = false;
    //         }
    //     }
    //     require(result, "Digital Asset with this Identity Hash already exists.");
    //     _;
    // }
}

