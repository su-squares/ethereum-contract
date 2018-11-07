pragma solidity ^0.4.24;

contract ERC721ReceiverTestMock {
    function onERC721Received(address, address, uint256, bytes) 
        external
        pure
        returns(bytes4)
    {
        return 0x150b7a02;
    }

}