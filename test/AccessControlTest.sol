pragma solidity ^0.4.24;
import "truffle/Assert.sol";
import "./mocks/AccessControlTestMock.sol";
import "./helpers/CallProxy.sol";

contract AccessControlTest {
    AccessControlTestMock subject;
    CallProxy subjectCallProxy;

    function beforeEach() public {
        subject = new AccessControlTestMock();
        subjectCallProxy = new CallProxy(subject);
    }

    // Me tests ////////////////////////////////////////////////////////////////

    function testIAmCeo() external {
        Assert.equal(
            subject.executiveOfficerAddress(),
            address(this),
            "CEO should initialize to contract deployer"
        );
    }

    // CEO role tests //////////////////////////////////////////////////////////

    function testCEOAddress() external {
        address zeroAddress = 0x0;
        address someAddress = 0x1234;

        subject.setExecutiveOfficer(subjectCallProxy);

        AccessControlTestMock(address(subjectCallProxy)).setExecutiveOfficer(zeroAddress);
        Assert.isFalse(subjectCallProxy.callResult(), "Should net be able to set CEO to zero address");

        AccessControlTestMock(address(subjectCallProxy)).setExecutiveOfficer(someAddress);
        Assert.isTrue(subjectCallProxy.callResult(), "CEO should set to a new value");

        Assert.equal(
            subject.executiveOfficerAddress(),
            someAddress,
            "CEO new value should be correct"
        );
    }

    function testCEOAccess() external {
        address someAddress = 0x1234;

        subject.anExecutiveTask();
        subject.setOperatingOfficer(someAddress);
        subject.setFinancialOfficer(someAddress);
        // We lose permissions after this next step...
        subject.setExecutiveOfficer(someAddress);
    }

    function testNotCEOAccess() external {
        address someAddress = 0x1234;

        subject.setExecutiveOfficer(someAddress);

        AccessControlTestMock(address(subjectCallProxy)).anExecutiveTask();
        Assert.isFalse(subjectCallProxy.callResult(), "The not CEO should not be able to run an executive task");

        AccessControlTestMock(address(subjectCallProxy)).setExecutiveOfficer(someAddress);
        Assert.isFalse(subjectCallProxy.callResult(), "The not CEO should not be able to assign new CEO");

        AccessControlTestMock(address(subjectCallProxy)).setOperatingOfficer(someAddress);
        Assert.isFalse(subjectCallProxy.callResult(), "The not CEO should not be able to assign new COO");

        AccessControlTestMock(address(subjectCallProxy)).setFinancialOfficer(someAddress);
        Assert.isFalse(subjectCallProxy.callResult(), "The not CEO should not be able to assign new CFO");
    }

    // COO Tests ///////////////////////////////////////////////////////////////

    function testCOOAddress() external {
        address zeroAddress = 0x0;
        address someAddress = 0x1234;

        subject.setExecutiveOfficer(subjectCallProxy);

        AccessControlTestMock(address(subjectCallProxy)).setOperatingOfficer(zeroAddress);
        Assert.isFalse(subjectCallProxy.callResult(), "Should not be able to set COO to zero address");

        AccessControlTestMock(address(subjectCallProxy)).setOperatingOfficer(someAddress);
        Assert.isTrue(subjectCallProxy.callResult(), "Should be able to set COO to some address");

        Assert.equal(
            subject.operatingOfficerAddress(),
            someAddress,
            "COO should set to a new value"
        );
    }

    function testCOOAccess() external {
        address someAddress = 0x1234;

        subject.setOperatingOfficer(address(this));
        subject.setExecutiveOfficer(someAddress);
        // We have now renounced CEO privileges

        subject.anOperatingTask();
    }

    function testNotCOOAccess() external {
        address someAddress = 0x1234;

        subject.setExecutiveOfficer(someAddress);
        // We have now renounced CEO privileges

        AccessControlTestMock(address(subjectCallProxy)).anOperatingTask();
        Assert.isFalse(subjectCallProxy.callResult(), "The not COO should not be able to run an operating task");
    }

    // CFO Tests ///////////////////////////////////////////////////////////////

    function testCFOAddress() external {
        address zeroAddress = 0x0;
        address someAddress = 0x1234;

        subject.setExecutiveOfficer(subjectCallProxy);

        AccessControlTestMock(address(subjectCallProxy)).setFinancialOfficer(zeroAddress);
        Assert.isFalse(subjectCallProxy.callResult(), "Should not be able to set CFO to zero address");

        AccessControlTestMock(address(subjectCallProxy)).setFinancialOfficer(someAddress);
        Assert.isTrue(subjectCallProxy.callResult(), "Should be able to set CFO to some address");

        Assert.equal(
            subject.financialOfficerAddress(),
            someAddress,
            "CFO should set to a new value"
        );
    }

    function testCFOAccess() external {
        address someAddress = 0x1234;

        subject.setFinancialOfficer(address(this));
        subject.setExecutiveOfficer(someAddress);
        // We have now renounced CEO privileges

        subject.aFinancialTask();
        subject.withdrawBalance();
    }

    // Allow incoming money for testCFOAccess above
    function () external payable {
    }

    function testNotCFOAccess() external {
        address someAddress = 0x1234;

        subject.setFinancialOfficer(someAddress);
        // We have now renounced CEO privileges

        AccessControlTestMock(address(subjectCallProxy)).aFinancialTask();
        Assert.isFalse(subjectCallProxy.callResult(), "The not CFO should not be able to run a financial task");

        AccessControlTestMock(address(subjectCallProxy)).withdrawBalance();
        Assert.isFalse(subjectCallProxy.callResult(), "The not CFO should not be able to run a financial task");
    }
}
