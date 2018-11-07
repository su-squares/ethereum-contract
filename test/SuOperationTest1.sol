pragma solidity ^0.4.24;
import "truffle/Assert.sol";
import "./mocks/SuOperationTestMock.sol";

contract SuOperationTest1 {
    SuOperationTestMock subject;

    function beforeEach() public {
        subject = new SuOperationTestMock();
    }

    // Personalize and get back data ///////////////////////////////////////////

    function testPersonalizeASquare() public {
        uint256 aSquareId = 721;
        bytes memory rgbData = hex"070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201";
        string memory title = "Su Squares: Cute squares you own and personalize";
        string memory href = "https://tenthousandsu.com";
        subject.stealSquare(aSquareId);
        subject.personalizeSquare(aSquareId, rgbData, title, href);

        uint256 retvalVersion;
        bytes memory retvalRgbData;
        string memory retvalTitle;
        string memory retvalHref;
        (retvalVersion, retvalRgbData, retvalTitle, retvalHref) = subject.suSquares(aSquareId);
        Assert.equal(
            retvalTitle,
            title,
            "The title should be as set"
        );
        Assert.equal(
            retvalHref,
            href,
            "The href should be as set"
        );
        Assert.equal(
            keccak256(retvalRgbData),
            keccak256(rgbData),
            "The rgbData should be as set"
        );
    }

    // Version increments //////////////////////////////////////////////////////

    function testPersonalizeShouldIncrementVersion() public {
        uint256 aSquareId = 721;
        bytes memory rgbData = hex"070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201070201";
        string memory title = "Su Squares: Cute squares you own and personalize";
        string memory anotherTitle = "Su Squares: Cute squares you own and personalizeXX";
        string memory href = "https://tenthousandsu.com";
        subject.stealSquare(aSquareId);

        uint256 retvalVersion;
        bytes memory retvalRgbData;
        string memory retvalTitle;
        string memory retvalHref;
        (retvalVersion, retvalRgbData, retvalTitle, retvalHref) = subject.suSquares(aSquareId);
        Assert.equal(
            retvalVersion,
            0,
            "Untouched version should be 0"
        );

        subject.personalizeSquare(aSquareId, rgbData, title, href);
        (retvalVersion, retvalRgbData, retvalTitle, retvalHref) = subject.suSquares(aSquareId);
        Assert.equal(
            retvalVersion,
            1,
            "Personalized version should be 1"
        );

        subject.personalizeSquare(aSquareId, rgbData, anotherTitle, href);
        (retvalVersion, retvalRgbData, retvalTitle, retvalHref) = subject.suSquares(aSquareId);
        Assert.equal(
            retvalVersion,
            2,
            "Next personalized version should be 2"
        );
    }
}
