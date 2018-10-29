pragma solidity ^0.4.24;
import "../../contracts/SuNFT.sol";

contract SuNFTStealableTestMock is SuNFT {
    constructor() public {
    }

    function stealSquare(uint256 nftId) external {
        _transfer(nftId, msg.sender);
    }
}
