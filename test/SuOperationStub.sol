pragma solidity ^0.4.24;
import "../contracts/SuOperation.sol";

contract SuOperationStub is SuOperation {
    constructor() public {
    }

    function stealSquare(uint256 nftId) external {
        _transfer(nftId, msg.sender);
    }
}
