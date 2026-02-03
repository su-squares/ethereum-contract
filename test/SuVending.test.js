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

describe("SuVending", function () {
    let SuVendingTestMock;
    let subject;
    let owner;
    let addr1;

    const SALE_PRICE = ethers.parseEther("0.5");

    beforeEach(async function () {
        [owner, addr1] = await ethers.getSigners();
        SuVendingTestMock = await ethers.getContractFactory("SuVendingTestMock");
        subject = await SuVendingTestMock.deploy();
        await subject.waitForDeployment();
    });

    describe("Sale price", function () {
        it("has correct sale price", async function () {
            assert.equal(await subject.getSalePrice(), SALE_PRICE);
        });
    });

    describe("Vending", function () {
        it("can purchase a square", async function () {
            const squareId = 721;

            await subject.purchase(squareId, { value: SALE_PRICE });

            assert.equal(await subject.ownerOf(squareId), owner.address);
        });

        it("should not purchase already purchased square", async function () {
            const squareId = 721;
            await subject.purchase(squareId, { value: SALE_PRICE });

            await assertRevert(
                subject.connect(addr1).purchase(squareId, { value: SALE_PRICE })
            );
        });

        it("should not purchase already owned square", async function () {
            const squareId = 721;
            await subject.stealSquare(squareId);

            await assertRevert(
                subject.connect(addr1).purchase(squareId, { value: SALE_PRICE })
            );
        });

        it("should not purchase invalid square 0", async function () {
            await assertRevert(
                subject.purchase(0, { value: SALE_PRICE })
            );
        });

        it("should not purchase invalid square 10001", async function () {
            await assertRevert(
                subject.purchase(10001, { value: SALE_PRICE })
            );
        });

        it("should not purchase without payment", async function () {
            const squareId = 721;

            await assertRevert(
                subject.purchase(squareId)
            );
        });

        it("should not purchase with wrong payment amount", async function () {
            const squareId = 721;
            const wrongPrice = ethers.parseEther("0.4");

            await assertRevert(
                subject.purchase(squareId, { value: wrongPrice })
            );
        });
    });
});
