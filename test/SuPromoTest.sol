pragma solidity ^0.4.24;
import "truffle/Assert.sol";
import "./mocks/SuPromoTestMock.sol";
import "./helpers/CallProxy.sol";

contract SuPromoTest {
    SuPromoTestMock subject;
    CallProxy subjectCallProxy;

    function beforeEach() public {
        subject = new SuPromoTestMock();
        subjectCallProxy = new CallProxy(subject);
    }

    // Grant should work ///////////////////////////////////////////////////////

    function testGrantOne() external {
        uint256 aSquareId = 721;
        address someAddress = 0x1234;

        subject.setOperatingOfficer(this);
        Assert.equal(
            subject.promoCreatedCount(), 
            0, 
            "Should start with no promos granted"
        );
        subject.grantToken(aSquareId, someAddress);
        Assert.equal(
            subject.promoCreatedCount(), 
            1, 
            "Should increment if one granted"
        );
        Assert.equal(
            subject.ownerOf(aSquareId),
            someAddress, 
            "Should grant to correct owner"
        );
    }

    // Grant should be disallowed sometimes ////////////////////////////////////

    function testGrantAlreadyGranted() external {
        uint256 aSquareId = 721;
        address someAddress = 0x1234;

        subject.setOperatingOfficer(this);
        subject.grantToken(aSquareId, someAddress);

        subject.setOperatingOfficer(subjectCallProxy);

        SuPromoTestMock(address(subjectCallProxy)).grantToken(aSquareId, someAddress);
        Assert.isFalse(subjectCallProxy.callResult(), "Regrant should fail");
    }

    function testGrantAlreadyOwned() external {
        uint256 aSquareId = 721;
        address someAddress = 0x1234;

        subject.stealSquare(aSquareId);

        subject.setOperatingOfficer(subjectCallProxy);

        SuPromoTestMock(address(subjectCallProxy)).grantToken(aSquareId, someAddress);
        Assert.isFalse(subjectCallProxy.callResult(), "Grant should fail if already owned");
    }

    function testGrantBogusSquare0() external {
        uint256 aSquareId = 0;
        address someAddress = 0x1234;

        subject.setOperatingOfficer(subjectCallProxy);

        SuPromoTestMock(address(subjectCallProxy)).grantToken(aSquareId, someAddress);
        Assert.isFalse(subjectCallProxy.callResult(), "Grant should fail if square invalid");
    }

    function testGrantBogusSquare10001() external {
        uint256 aSquareId = 10001;
        address someAddress = 0x1234;

        subject.setOperatingOfficer(subjectCallProxy);

        SuPromoTestMock(address(subjectCallProxy)).grantToken(aSquareId, someAddress);
        Assert.isFalse(subjectCallProxy.callResult(), "Grant should fail if square invalid");
    }

    function testGrantTooMany() external {
        uint256 aSquareId = 721;
        address someAddress = 0x1234;

        subject.setOperatingOfficer(this);
        subject.useUpAllGrants();

        subject.setOperatingOfficer(subjectCallProxy);

        SuPromoTestMock(address(subjectCallProxy)).grantToken(aSquareId, someAddress);
        Assert.isFalse(subjectCallProxy.callResult(), "Grant should fail if promo limit reached");
    }
}
