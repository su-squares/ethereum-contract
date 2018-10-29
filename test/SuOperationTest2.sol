pragma solidity ^0.4.24;
import "truffle/Assert.sol";
import "./mocks/SuOperationTestMock.sol";
import "./helpers/CallProxy.sol";

contract SuOperationTest2 {
    // https://www.truffleframework.com/docs/truffle/testing/writing-tests-in-solidity#testing-ether-transactions
    uint public initialBalance = 1 ether;

    SuOperationTestMock subject;
    CallProxy subjectCallProxy;

    function beforeEach() public {
        subject = new SuOperationTestMock();
        subjectCallProxy = new CallProxy(subject);
    }

    // Personalization call cost ///////////////////////////////////////////////

    function testThreePersonalizeShouldBeFree() public {
        uint256 aSquareId = 721;
        bytes memory rgbData = hex"070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201";
        string memory title = "Su Squares: Cute squares you own and personalize";
        string memory anotherTitle = "Su Squares: Cute squares you own and personalizeXX";
        string memory href = "https://tenthousandsu.com";
        subject.stealSquare(aSquareId);

        subject.personalizeSquare(aSquareId, rgbData, title, href);
        subject.personalizeSquare(aSquareId, rgbData, anotherTitle, href);
        subject.personalizeSquare(aSquareId, rgbData, title, href);
    }

    function testThisContractHasMoney() public {
        address(0x0).transfer(10 finney);
    }

    function testFourthPersonalizeWorksWithMoney() public {
        uint256 aSquareId = 721;
        bytes memory rgbData = hex"070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201";
        string memory title = "Su Squares: Cute squares you own and personalize";
        string memory href = "https://tenthousandsu.com";
        subject.stealSquare(aSquareId);

        subject.personalizeSquare(aSquareId, rgbData, title, href);
        subject.personalizeSquare(aSquareId, rgbData, title, href);
        subject.personalizeSquare(aSquareId, rgbData, title, href);
        subject.personalizeSquare.value(10 finney)(aSquareId, rgbData, title, href);
    }

    function testFourthPersonalizeFailsWithoutMoney() public {
        uint256 aSquareId = 721;
        bytes memory rgbData = hex"070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201";
        string memory title = "Su Squares: Cute squares you own and personalize";
        string memory href = "https://tenthousandsu.com";
        subject.stealSquare(aSquareId);

        subject.personalizeSquare(aSquareId, rgbData, title, href);
        subject.personalizeSquare(aSquareId, rgbData, title, href);

        SuOperationTestMock(address(subjectCallProxy)).stealSquare(aSquareId);

        SuOperationTestMock(address(subjectCallProxy)).personalizeSquare(aSquareId, rgbData, title, href);
        Assert.isTrue(subjectCallProxy.callResult(), "Third personalization should work");

        SuOperationTestMock(address(subjectCallProxy)).personalizeSquare(aSquareId, rgbData, title, href);
        Assert.isFalse(subjectCallProxy.callResult(), "Fourth free personalization should fail");
    }
}
