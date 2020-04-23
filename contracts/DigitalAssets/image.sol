pragma solidity >=0.4.0 <0.6.0;

import "./DigitalAsset.sol";

contract Image is DigitalAsset {

    // todo: Implement this function
    function generateIdentityHash(DigitalAssetStruct memory asset) internal pure returns (string memory){
        return asset.name;
    }

}


