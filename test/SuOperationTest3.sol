pragma solidity ^0.4.24;
import "truffle/Assert.sol";
import "./SuOperationStub.sol";

// Proxy contract for testing throws
// Use because .call() problem https://github.com/ethereum/solidity/issues/5321
contract CallProxy {
    address private target;
    bool public callResult;

    constructor(address _target) public {
        target = _target;
    }

    function() external payable {
        callResult = target.call.value(msg.value)(msg.data); // solium-disable-line
    }
}

contract SuOperationTest3 {
    // https://www.truffleframework.com/docs/truffle/testing/writing-tests-in-solidity#testing-ether-transactions
    uint public initialBalance = 1 ether;

    SuOperationStub subject;
    CallProxy subjectCallProxy;

    function beforeEach() public {
        subject = new SuOperationStub();
        subjectCallProxy = new CallProxy(subject);
    }

    // Invalid personalizations ////////////////////////////////////////////////

    function testShouldNotPersonalizeWithoutAuthorization() public {
        uint256 aSquareId = 721;
        bytes memory rgbData = hex"070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201";
        string memory title = "Su Squares: Cute squares you own and personalize";
        string memory href = "https://tenthousandsu.com";

        // SuOperationStub(address(subjectCallProxy)).stealSquare(aSquareId);

        SuOperationStub(address(subjectCallProxy)).personalizeSquare(aSquareId, rgbData, title, href);
        Assert.isFalse(subjectCallProxy.callResult(), "Should not personalize a square not owned");
    }

    function testShouldNotPersonalizeTooMuchRgb() public {
        uint256 aSquareId = 721;
        bytes memory rgbData = hex"07020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020107020199";
        string memory title = "Su Squares: Cute squares you own and personalize";
        string memory href = "https://tenthousandsu.com";

        SuOperationStub(address(subjectCallProxy)).stealSquare(aSquareId);

        SuOperationStub(address(subjectCallProxy)).personalizeSquare(aSquareId, rgbData, title, href);
        Assert.isFalse(subjectCallProxy.callResult(), "Should not personalize with invalid parameters");
    }

    function testShouldNotPersonalizeTooLittleRgb() public {
        uint256 aSquareId = 721;
        bytes memory rgbData = hex"0702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702010702";
        string memory title = "Su Squares: Cute squares you own and personalize";
        string memory href = "https://tenthousandsu.com";

        SuOperationStub(address(subjectCallProxy)).stealSquare(aSquareId);

        SuOperationStub(address(subjectCallProxy)).personalizeSquare(aSquareId, rgbData, title, href);
        Assert.isFalse(subjectCallProxy.callResult(), "Should not personalize with invalid parameters");
    }

    function testShouldNotPersonalizeTooMuchTitle() public {
        uint256 aSquareId = 721;
        bytes memory rgbData = hex"070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201";
        string memory title = "Su Squares: Cute squares you own and personalizexxxxxxxxxxxxxxxxx";
        string memory href = "https://tenthousandsu.com";

        SuOperationStub(address(subjectCallProxy)).stealSquare(aSquareId);

        SuOperationStub(address(subjectCallProxy)).personalizeSquare(aSquareId, rgbData, title, href);
        Assert.isFalse(subjectCallProxy.callResult(), "Should not personalize with invalid parameters");
    }

    function testShouldNotPersonalizeTooMuchHref() public {
        uint256 aSquareId = 721;
        bytes memory rgbData = hex"070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201";
        string memory title = "Su Squares: Cute squares you own and personalize";
        string memory href = "https://tenthousandsu.comxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

        SuOperationStub(address(subjectCallProxy)).stealSquare(aSquareId);

        SuOperationStub(address(subjectCallProxy)).personalizeSquare(aSquareId, rgbData, title, href);
        Assert.isFalse(subjectCallProxy.callResult(), "Should not personalize with invalid parameters");
    }
}
