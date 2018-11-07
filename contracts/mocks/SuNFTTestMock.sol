pragma solidity ^0.4.24;
import "../../contracts/SuNFT.sol";

contract SuNFTTestMock is SuNFT {
    constructor() public {
    }

    function stealSquare(uint256 nftId) external mustBeValidToken(nftId) {
        _transfer(nftId, msg.sender);
    }

    function mint(address to, uint256 nftId) 
        external
        mustBeValidToken(nftId)
        mustBeOwnedByThisContract(nftId)
    {
        _transfer(nftId, to);
    }
}
