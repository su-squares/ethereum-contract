import assert from 'assert';
import { network } from "hardhat";

const { ethers } = await network.connect();

async function assertRevert(promise) {
    try {
        await promise;
        assert.fail('Expected revert not received');
    } catch (error) {
        const revertFound = error.message.search('revert') >= 0 ||
            error.message.search('reverted') >= 0 ||
            error.code === 'CALL_EXCEPTION' ||
            error.code === 'ACTION_REJECTED';
        assert.ok(revertFound, `Expected "revert", got ${error} instead`);
    }
}

async function assertNotRevert(promise) {
    try {
        await promise;
    } catch (error) {
        assert.fail(`Expected no revert, but got: ${error}`);
    }
}

describe("SuOperation", function () {
    let SuOperationTestMock;
    let subject;
    let owner;
    let addr1;

    // Valid RGB data (300 bytes = 10x10 pixels * 3 bytes per pixel)
    const validRgbData = "0x" + "070201".repeat(100);
    const validTitle = "Su Squares: Cute squares you own and personalize";
    const validHref = "https://tenthousandsu.com";

    beforeEach(async function () {
        [owner, addr1] = await ethers.getSigners();
        SuOperationTestMock = await ethers.getContractFactory("SuOperationTestMock");
        subject = await SuOperationTestMock.deploy();
        await subject.waitForDeployment();
    });

    describe("Personalize a square", function () {
        it("can personalize a square after stealing it", async function () {
            const squareId = 721;
            await subject.stealSquare(squareId);
            await subject.personalizeSquare(squareId, validRgbData, validTitle, validHref);

            const result = await subject.suSquares(squareId);
            assert.equal(result.title, validTitle);
            assert.equal(result.href, validHref);
        });

        it("increments version on personalization", async function () {
            const squareId = 721;
            await subject.stealSquare(squareId);

            // Check initial version is 0
            let result = await subject.suSquares(squareId);
            assert.equal(result.version, 0n);

            // Personalize once, version should be 1
            await subject.personalizeSquare(squareId, validRgbData, validTitle, validHref);
            result = await subject.suSquares(squareId);
            assert.equal(result.version, 1n);

            // Personalize again, version should be 2
            await subject.personalizeSquare(squareId, validRgbData, "Another title", validHref);
            result = await subject.suSquares(squareId);
            assert.equal(result.version, 2n);
        });
    });

    describe("Invalid personalizations", function () {
        it("should not personalize without authorization", async function () {
            const squareId = 721;
            // Don't steal the square, try to personalize directly
            await assertRevert(
                subject.personalizeSquare(squareId, validRgbData, validTitle, validHref)
            );
        });

        it("should not personalize with too much RGB data", async function () {
            const squareId = 721;
            const tooMuchRgb = "0x" + "070201".repeat(100) + "99"; // 301 bytes
            await subject.stealSquare(squareId);

            await assertRevert(
                subject.personalizeSquare(squareId, tooMuchRgb, validTitle, validHref)
            );
        });

        it("should not personalize with too little RGB data", async function () {
            const squareId = 721;
            const tooLittleRgb = "0x" + "070201".repeat(99); // 297 bytes
            await subject.stealSquare(squareId);

            await assertRevert(
                subject.personalizeSquare(squareId, tooLittleRgb, validTitle, validHref)
            );
        });

        it("should not personalize with too long title", async function () {
            const squareId = 721;
            // Title max is 64 characters
            const tooLongTitle = "Su Squares: Cute squares you own and personalizexxxxxxxxxxxxxxxxx"; // 65+ chars
            await subject.stealSquare(squareId);

            await assertRevert(
                subject.personalizeSquare(squareId, validRgbData, tooLongTitle, validHref)
            );
        });

        it("should not personalize with too long href", async function () {
            const squareId = 721;
            // Href max is 96 characters
            const tooLongHref = "https://tenthousandsu.comxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"; // 97+ chars
            await subject.stealSquare(squareId);

            await assertRevert(
                subject.personalizeSquare(squareId, validRgbData, validTitle, tooLongHref)
            );
        });
    });

    describe("Paid personalization", function () {
        it("requires payment after 3 personalizations", async function () {
            const squareId = 721;
            await subject.stealSquare(squareId);

            // First 3 personalizations are free
            await subject.personalizeSquare(squareId, validRgbData, validTitle, validHref);
            await subject.personalizeSquare(squareId, validRgbData, "Title 2", validHref);
            await subject.personalizeSquare(squareId, validRgbData, "Title 3", validHref);

            // Fourth personalization should require payment
            await assertRevert(
                subject.personalizeSquare(squareId, validRgbData, "Title 4", validHref)
            );

            // With payment it should succeed
            const fee = ethers.parseEther("0.01");
            await assertNotRevert(
                subject.personalizeSquare(squareId, validRgbData, "Title 4", validHref, { value: fee })
            );
        });
    });
});
