pragma solidity ^0.4.24;
import "truffle/Assert.sol";
import "./mocks/SupportsInterfaceTestMock.sol";

contract SupportsInterfaceTest {
    SupportsInterfaceTestMock subject;

    function beforeEach() public {
        subject = new SupportsInterfaceTestMock();
    }

    // Baseline behavior ///////////////////////////////////////////////////////

    function testERC165Id() external {
        bytes4 theInterface = 0x01ffc9a7;
        Assert.isTrue(
            subject.supportsInterface(theInterface),
            "ERC-165 interface should be supported"
        );
    }

    function testFFFFFFFF() external {
        bytes4 theInterface = 0xffffffff;
        Assert.isFalse(
            subject.supportsInterface(theInterface),
            "The 0xffffffff interface should not be supported"
        );
    }

    // Add a new interface /////////////////////////////////////////////////////

    function testNewInterface() external {
        bytes4 theInterface = 0xba5eba11;
        Assert.isFalse(
            subject.supportsInterface(theInterface),
            "The new interface should not be supported"
        );
        subject.setInterface(theInterface);
        Assert.isTrue(
            subject.supportsInterface(theInterface),
            "The new interface should not be supported"
        );
    } 
}
