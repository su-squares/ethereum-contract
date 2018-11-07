pragma solidity ^0.4.24;
import "truffle/Assert.sol";
import "./mocks/SuVendingTestMock.sol";
import "./helpers/CallProxy.sol";

contract SuVendingTest {
    // https://www.truffleframework.com/docs/truffle/testing/writing-tests-in-solidity#testing-ether-transactions
    uint public initialBalance = 20 ether;

    SuVendingTestMock subject;
    CallProxy subjectCallProxy;

    function beforeEach() public {
        subject = new SuVendingTestMock();
        subjectCallProxy = new CallProxy(subject);
    }

    function testVendPriceCHEATING() external {
        Assert.equal(
            subject.getSalePrice(),
            500 finney, // 0.5 Ether
            "Should have 0.5 Ether sale price"
        );
    }

    // Vending should work /////////////////////////////////////////////////////

    function testVendOne() external {
        uint256 aSquareId = 721;

        subject.purchase.value(subject.getSalePrice())(aSquareId);

        Assert.equal(
            subject.ownerOf(aSquareId),
            this, 
            "Should vend to correct owner"
        );
    }

    function testVendOneOnWithProxy() external {
        uint256 aSquareId = 721;

        Assert.isAbove(
            address(this).balance,
            subject.getSalePrice(),
            "Should have enough money to buy a square"
        );
        SuVendingTestMock(subjectCallProxy).purchase.value(subject.getSalePrice())(aSquareId);
        Assert.equal(
            subject.ownerOf(aSquareId),
            subjectCallProxy, 
            "Should vend to correct owner"
        );
    }

    // Grant should be disallowed sometimes ////////////////////////////////////

    function testVendAlreadyVended() external {
        uint256 aSquareId = 721;

        subject.purchase.value(subject.getSalePrice())(aSquareId);

        SuVendingTestMock(address(subjectCallProxy)).purchase.value(subject.getSalePrice())(aSquareId);
        Assert.isFalse(subjectCallProxy.callResult(), "Revend should fail");
    }

    function testVendAlreadyOwned() external {
        uint256 aSquareId = 721;

        subject.stealSquare(aSquareId);

        SuVendingTestMock(address(subjectCallProxy)).purchase.value(subject.getSalePrice())(aSquareId);
        Assert.isFalse(subjectCallProxy.callResult(), "Vend should fail if already owned");
    }

    function testVendBogusSquare0() external {
        uint256 aSquareId = 0;

        SuVendingTestMock(address(subjectCallProxy)).purchase.value(subject.getSalePrice())(aSquareId);
        Assert.isFalse(subjectCallProxy.callResult(), "Vend should fail if square invalid");
    }

    function testVendBogusSquare10001() external {
        uint256 aSquareId = 10001;

        SuVendingTestMock(address(subjectCallProxy)).purchase.value(subject.getSalePrice())(aSquareId);
        Assert.isFalse(subjectCallProxy.callResult(), "Vend should fail if square invalid");
    }

    function testVendForFree() external {
        uint256 aSquareId = 721;

        SuVendingTestMock(address(subjectCallProxy)).purchase(aSquareId);
        Assert.isFalse(subjectCallProxy.callResult(), "Vend should fail without paying fee");
    }
}
