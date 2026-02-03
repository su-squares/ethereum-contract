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

describe("SuPromo", function () {
    let SuPromoTestMock;
    let subject;
    let owner;
    let addr1;

    beforeEach(async function () {
        [owner, addr1] = await ethers.getSigners();
        SuPromoTestMock = await ethers.getContractFactory("SuPromoTestMock");
        subject = await SuPromoTestMock.deploy();
        await subject.waitForDeployment();
    });

    describe("Grant tokens", function () {
        it("COO can grant a token", async function () {
            const squareId = 721;
            await subject.setOperatingOfficer(owner.address);

            assert.equal(await subject.promoCreatedCount(), 0n);

            await subject.grantToken(squareId, addr1.address);

            assert.equal(await subject.promoCreatedCount(), 1n);
            assert.equal(await subject.ownerOf(squareId), addr1.address);
        });

        it("should not grant already granted token", async function () {
            const squareId = 721;
            await subject.setOperatingOfficer(owner.address);
            await subject.grantToken(squareId, addr1.address);

            await assertRevert(
                subject.grantToken(squareId, addr1.address)
            );
        });

        it("should not grant already owned token", async function () {
            const squareId = 721;
            await subject.stealSquare(squareId);
            await subject.setOperatingOfficer(owner.address);

            await assertRevert(
                subject.grantToken(squareId, addr1.address)
            );
        });

        it("should not grant invalid square 0", async function () {
            await subject.setOperatingOfficer(owner.address);

            await assertRevert(
                subject.grantToken(0, addr1.address)
            );
        });

        it("should not grant invalid square 10001", async function () {
            await subject.setOperatingOfficer(owner.address);

            await assertRevert(
                subject.grantToken(10001, addr1.address)
            );
        });

        it("should not grant if promo limit reached", async function () {
            const squareId = 721;
            await subject.setOperatingOfficer(owner.address);
            await subject.useUpAllGrants();

            await assertRevert(
                subject.grantToken(squareId, addr1.address)
            );
        });

        it("non-COO cannot grant tokens", async function () {
            const squareId = 721;
            await subject.setOperatingOfficer(addr1.address);

            await assertRevert(
                subject.grantToken(squareId, addr1.address)
            );
        });
    });
});
