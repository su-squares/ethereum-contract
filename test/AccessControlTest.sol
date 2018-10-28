pragma solidity ^0.4.24;
import "truffle/Assert.sol";
import "./AccessControlStub.sol";

contract AccessControlTest {
    AccessControlStub subject;

    function beforeEach() public {
        subject = new AccessControlStub();
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

        Assert.equal(
            address(subject).call("setExecutiveOfficer", zeroAddress),
            false,
            "Should not be able to set CEO to zero address"
        );
        subject.setExecutiveOfficer(someAddress);
        Assert.equal(
            subject.executiveOfficerAddress(),
            someAddress,
            "CEO should set to a new value"
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
        Assert.equal(
            address(subject).call("anExecutiveTask"),
            false,
            "The not CEO should not be able to run an executive task"
        );
        Assert.equal(
            address(subject).call("setExecutiveOfficer", someAddress),
            false,
            "The not CEO should not be able to assign new CEO"
        );
        Assert.equal(
            address(subject).call("setOperatingOfficer", someAddress),
            false,
            "The not CEO should not be able to assign new COO"
        );
        Assert.equal(
            address(subject).call("setFinancialOfficer", someAddress),
            false,
            "The not CEO should not be able to assign new CFO"
        );
    }

    // COO Tests ///////////////////////////////////////////////////////////////

    function testCOOAddress() external {
        address zeroAddress = 0x0;
        address someAddress = 0x1234;

        Assert.equal(
            address(subject).call("setOperatingOfficer", zeroAddress),
            false,
            "Should not be able to set COO to zero address"
        );
        subject.setOperatingOfficer(someAddress);
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

        Assert.equal(
            address(subject).call("anOperatingTask"),
            false,
            "The not COO should not be able to run an operating task"
        );
    }

    // CFO Tests ///////////////////////////////////////////////////////////////

    function testCFOAddress() external {
        address zeroAddress = 0x0;
        address someAddress = 0x1234;

        Assert.equal(
            address(subject).call("setFinancialOfficer", zeroAddress),
            false,
            "Should not be able to set CFO to zero address"
        );
        subject.setFinancialOfficer(someAddress);
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

        Assert.equal(
            address(subject).call("aFinancialTask"),
            false,
            "The not CFO should not be able to run an operating task"
        );
        Assert.equal(
            address(subject).call("withdrawBalance"),
            false,
            "The not CFO should not be able to run an operating task"
        );
    }
}
