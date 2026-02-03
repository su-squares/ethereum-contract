pragma solidity ^0.4.24;
import "../SuOperation.sol";
import "./SuNFTStealableTestMock.sol";

contract SuOperationTestMock is SuOperation, SuNFTStealableTestMock {
    constructor() public {}
}
