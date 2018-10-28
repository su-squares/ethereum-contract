pragma solidity ^0.4.24;
import "../contracts/SupportsInterface.sol";

contract SupportsInterfaceStub is SupportsInterface {
    constructor() public {
    }

    function setInterface(bytes4 newInterface) external {
        supportedInterfaces[newInterface] = true;
    }
}
