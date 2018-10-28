pragma solidity ^0.4.24;
import "truffle/Assert.sol";
import "./SupportsInterfaceStub.sol";

contract SupportsInterfaceTest {
    SupportsInterfaceStub subject;

    function beforeEach() public {
        subject = new SupportsInterfaceStub();
    }

    // Baseline behavior ///////////////////////////////////////////////////////

    function testERC165Id() external {
        bytes4 theInterface = 0x01ffc9a7;
        Assert.equal(
            subject.supportsInterface(theInterface),
            true,
            "ERC-165 interface should be supported"
        );
    }

    function testFFFFFFFF() external {
        bytes4 theInterface = 0xffffffff;
        Assert.equal(
            subject.supportsInterface(theInterface),
            false,
            "The 0xffffffff interface should not be supported"
        );
    }

    // Add a new interface /////////////////////////////////////////////////////

    function testNewInterface() external {
        bytes4 theInterface = 0xba5eba11;
        Assert.equal(
            subject.supportsInterface(theInterface),
            false,
            "The new interface should not be supported"
        );
        subject.setInterface(theInterface);
        Assert.equal(
            subject.supportsInterface(theInterface),
            true,
            "The new interface should not be supported"
        );
    } 
}
