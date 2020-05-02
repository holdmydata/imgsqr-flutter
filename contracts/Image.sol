pragma solidity >=0.4.0 <0.6.0;

import "./DigitalAsset.sol";

contract Image is DigitalAsset {

    function generateIdentityHash(DigitalAssetStruct memory asset) internal returns (bytes32){
        return stringToBytes32(asset.externalPointer);
    }
    
    // https://ethereum.stackexchange.com/questions/9142/how-to-convert-a-string-to-bytes32
    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
    
        assembly {
            result := mload(add(source, 32))
        }
    }

}


