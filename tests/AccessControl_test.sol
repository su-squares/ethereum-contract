pragma solidity ^0.4.24;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "./AccessControlStub.sol";

contract TestAccessControl {
    AccessControl subject;
    
    function beforeEach() {
        subject = new AccessControlStub();
    }
    
    // CEO functions ///////////////////////////////////////////////////////////
    
    function testCEOInitialization() external {
        Assert.equal(
            subject.executiveOfficerAddress(), 
            address(this), 
            "CEO should initialize to contract deployer"
        );
    }
    
    function testCEOChange() external {
        subject.setExecutiveOfficer(0x1234);
        Assert.equal(
            subject.executiveOfficerAddress(), 
            address(0x1234), 
            "CEO should set to a new value"
        );
    }
    
    function testCEONegativeAccess() external {
        subject.setExecutiveOfficer(0x1234);
        Assert.equal(
            subject.call("setExecutiveOfficer", [0x1235]),
            false, 
            "The non-CEO should not be able to set CEO"
        );
    }
    
    
}
