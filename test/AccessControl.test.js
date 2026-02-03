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

describe("AccessControl", function () {
    let AccessControlTestMock;
    let subject;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        [owner, addr1, addr2] = await ethers.getSigners();
        AccessControlTestMock = await ethers.getContractFactory("AccessControlTestMock");
        subject = await AccessControlTestMock.deploy();
        await subject.waitForDeployment();
    });

    describe("CEO role", function () {
        it("initializes CEO to contract deployer", async function () {
            assert.equal(await subject.executiveOfficerAddress(), owner.address);
        });

        it("should not set CEO to zero address", async function () {
            await assertRevert(subject.setExecutiveOfficer(ethers.ZeroAddress));
        });

        it("CEO can set a new CEO", async function () {
            await subject.setExecutiveOfficer(addr1.address);
            assert.equal(await subject.executiveOfficerAddress(), addr1.address);
        });

        it("CEO can run executive tasks", async function () {
            await assertNotRevert(subject.anExecutiveTask());
        });

        it("CEO can set operating officer", async function () {
            await assertNotRevert(subject.setOperatingOfficer(addr1.address));
        });

        it("CEO can set financial officer", async function () {
            await assertNotRevert(subject.setFinancialOfficer(addr1.address));
        });

        it("non-CEO cannot run executive tasks", async function () {
            await subject.setExecutiveOfficer(addr1.address);
            await assertRevert(subject.anExecutiveTask());
        });

        it("non-CEO cannot set new CEO", async function () {
            await subject.setExecutiveOfficer(addr1.address);
            await assertRevert(subject.setExecutiveOfficer(addr2.address));
        });

        it("non-CEO cannot set operating officer", async function () {
            await subject.setExecutiveOfficer(addr1.address);
            await assertRevert(subject.setOperatingOfficer(addr2.address));
        });

        it("non-CEO cannot set financial officer", async function () {
            await subject.setExecutiveOfficer(addr1.address);
            await assertRevert(subject.setFinancialOfficer(addr2.address));
        });
    });

    describe("COO role", function () {
        it("should not set COO to zero address", async function () {
            await assertRevert(subject.setOperatingOfficer(ethers.ZeroAddress));
        });

        it("CEO can set COO", async function () {
            await subject.setOperatingOfficer(addr1.address);
            assert.equal(await subject.operatingOfficerAddress(), addr1.address);
        });

        it("COO can run operating tasks", async function () {
            await subject.setOperatingOfficer(addr1.address);
            await assertNotRevert(subject.connect(addr1).anOperatingTask());
        });

        it("non-COO cannot run operating tasks", async function () {
            await subject.setOperatingOfficer(addr1.address);
            await assertRevert(subject.connect(addr2).anOperatingTask());
        });
    });

    describe("CFO role", function () {
        it("should not set CFO to zero address", async function () {
            await assertRevert(subject.setFinancialOfficer(ethers.ZeroAddress));
        });

        it("CEO can set CFO", async function () {
            await subject.setFinancialOfficer(addr1.address);
            assert.equal(await subject.financialOfficerAddress(), addr1.address);
        });

        it("CFO can run financial tasks", async function () {
            await subject.setFinancialOfficer(addr1.address);
            await assertNotRevert(subject.connect(addr1).aFinancialTask());
        });

        it("non-CFO cannot run financial tasks", async function () {
            await subject.setFinancialOfficer(addr1.address);
            await assertRevert(subject.connect(addr2).aFinancialTask());
        });

        it("CFO can withdraw balance", async function () {
            await subject.setFinancialOfficer(addr1.address);
            await assertNotRevert(subject.connect(addr1).withdrawBalance());
        });

        it("non-CFO cannot withdraw balance", async function () {
            await subject.setFinancialOfficer(addr1.address);
            await assertRevert(subject.connect(addr2).withdrawBalance());
        });
    });
});
