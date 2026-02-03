// From https://github.com/0xcert/ethereum-erc721/blob/master/test/tokens/NFToken.test.js

import assert from 'assert';
import { network } from 'hardhat';
import assertRevert from './helpers/assertRevert.js';

const { ethers } = await network.connect();

describe('NFTokenMock', function () {
    let nftoken;
    let accounts;
    let TokenReceiverMock;
    const id1 = 1;
    const id2 = 2;
    const id3 = 3;
    const id4 = 40000;

    beforeEach(async function () {
        accounts = await ethers.getSigners();
        const NFToken = await ethers.getContractFactory('SuNFTTestMock');
        nftoken = await NFToken.deploy();
        await nftoken.waitForDeployment();
        TokenReceiverMock = await ethers.getContractFactory('ERC721ReceiverTestMock');
    });

    it('correctly checks all the supported interfaces', async function () {
        const nftokenInterface = await nftoken.supportsInterface('0x80ac58cd');
        const nftokenNonExistingInterface = await nftoken.supportsInterface('0xba5eba11');
        assert.equal(nftokenInterface, true);
        assert.equal(nftokenNonExistingInterface, false);
    });

    it('returns correct balanceOf after mint', async function () {
        await nftoken.mint(accounts[0].address, id1);
        const count = await nftoken.balanceOf(accounts[0].address);
        assert.equal(count, 1n);
    });

    it('throws when trying to mint 2 NFTs with the same claim', async function () {
        await nftoken.mint(accounts[0].address, id2);
        await assertRevert(nftoken.mint(accounts[0].address, id2));
    });

    it('throws trying to mint NFT with empty claim', async function () {
        await assertRevert(nftoken.mint(accounts[0].address, ''));
    });

    it('throws when trying to mint NFT to 0x0 address ', async function () {
        await assertRevert(nftoken.mint(ethers.ZeroAddress, id3));
    });

    it('finds the correct amount of NFTs owned by account', async function () {
        await nftoken.mint(accounts[1].address, id2);
        await nftoken.mint(accounts[1].address, id3);
        const count = await nftoken.balanceOf(accounts[1].address);
        assert.equal(count, 2n);
    });

    it('throws when trying to get count of NFTs owned by 0x0 address', async function () {
        await assertRevert(nftoken.balanceOf(ethers.ZeroAddress));
    });

    it('finds the correct owner of NFToken id', async function () {
        await nftoken.mint(accounts[1].address, id2);
        const address = await nftoken.ownerOf(id2);
        assert.equal(address, accounts[1].address);
    });

    it('throws when trying to find owner od non-existing NFT id', async function () {
        await assertRevert(nftoken.ownerOf(id4));
    });

    it('correctly approves account', async function () {
        await nftoken.mint(accounts[0].address, id2);
        await nftoken.approve(accounts[1].address, id2);

        const address = await nftoken.getApproved(id2);
        assert.equal(address, accounts[1].address);
    });

    it('correctly cancels approval of account[1]', async function () {
        await nftoken.mint(accounts[0].address, id2);
        await nftoken.approve(accounts[1].address, id2);
        await nftoken.approve(ethers.ZeroAddress, id2);
        const address = await nftoken.getApproved(id2);
        assert.equal(address, ethers.ZeroAddress);
    });

    it('throws when trying to get approval of non-existing NFT id', async function () {
        await assertRevert(nftoken.getApproved(id4));
    });


    it('throws when trying to approve NFT ID which it does not own', async function () {
        await nftoken.mint(accounts[1].address, id2);
        await assertRevert(nftoken.connect(accounts[2]).approve(accounts[2].address, id2));
        const address = await nftoken.getApproved(id2);
        assert.equal(address, ethers.ZeroAddress);
    });

    it('throws when trying to approve NFT ID which it already owns', async function () {
        await nftoken.mint(accounts[1].address, id2);
        await assertRevert(nftoken.approve(accounts[1].address, id2));
        const address = await nftoken.getApproved(id2);
        assert.equal(address, ethers.ZeroAddress);
    });

    it('correctly sets an operator', async function () {
        await nftoken.mint(accounts[0].address, id2);
        await nftoken.setApprovalForAll(accounts[6].address, true);
        const isApprovedForAll = await nftoken.isApprovedForAll(accounts[0].address, accounts[6].address);
        assert.equal(isApprovedForAll, true);
    });

    it('correctly sets then cancels an operator', async function () {
        await nftoken.mint(accounts[0].address, id2);
        await nftoken.setApprovalForAll(accounts[6].address, true);
        await nftoken.setApprovalForAll(accounts[6].address, false);

        const isApprovedForAll = await nftoken.isApprovedForAll(accounts[0].address, accounts[6].address);
        assert.equal(isApprovedForAll, false);
    });

    /*
    THIS IS NOT PART OF THE STANDARD
    https://github.com/0xcert/ethereum-erc721/issues/148
    it('throws when trying to set a zero address as operator', async function () {
      await assertRevert(nftoken.setApprovalForAll(ethers.ZeroAddress, true));
    });
    */

    it('corectly transfers NFT from owner', async function () {
        const sender = accounts[1];
        const recipient = accounts[2];

        await nftoken.mint(sender.address, id2);
        await nftoken.connect(sender).transferFrom(sender.address, recipient.address, id2);

        const senderBalance = await nftoken.balanceOf(sender.address);
        const recipientBalance = await nftoken.balanceOf(recipient.address);
        const ownerOfId2 = await nftoken.ownerOf(id2);

        assert.equal(senderBalance, 0n);
        assert.equal(recipientBalance, 1n);
        assert.equal(ownerOfId2, recipient.address);
    });

    it('corectly transfers NFT from approved address', async function () {
        const sender = accounts[1];
        const recipient = accounts[2];
        const owner = accounts[3];

        await nftoken.mint(owner.address, id2);
        await nftoken.connect(owner).approve(sender.address, id2);

        await nftoken.connect(sender).transferFrom(owner.address, recipient.address, id2);

        const ownerBalance = await nftoken.balanceOf(owner.address);
        const recipientBalance = await nftoken.balanceOf(recipient.address);
        const ownerOfId2 = await nftoken.ownerOf(id2);

        assert.equal(ownerBalance, 0n);
        assert.equal(recipientBalance, 1n);
        assert.equal(ownerOfId2, recipient.address);
    });

    it('corectly transfers NFT as operator', async function () {
        const sender = accounts[1];
        const recipient = accounts[2];
        const owner = accounts[3];

        await nftoken.mint(owner.address, id2);
        await nftoken.connect(owner).setApprovalForAll(sender.address, true);
        await nftoken.connect(sender).transferFrom(owner.address, recipient.address, id2);

        const ownerBalance = await nftoken.balanceOf(owner.address);
        const recipientBalance = await nftoken.balanceOf(recipient.address);
        const ownerOfId2 = await nftoken.ownerOf(id2);

        assert.equal(ownerBalance, 0n);
        assert.equal(recipientBalance, 1n);
        assert.equal(ownerOfId2, recipient.address);
    });

    it('throws when trying to transfer NFT as an address that is not owner, approved or operator', async function () {
        const sender = accounts[1];
        const recipient = accounts[2];
        const owner = accounts[3];

        await nftoken.mint(owner.address, id2);
        await assertRevert(nftoken.connect(sender).transferFrom(owner.address, recipient.address, id2));
    });

    it('throws when trying to transfer NFT to a zero address', async function () {
        const owner = accounts[3];

        await nftoken.mint(owner.address, id2);
        await assertRevert(nftoken.connect(owner).transferFrom(owner.address, ethers.ZeroAddress, id2));
    });

    it('throws when trying to transfer an invalid NFT', async function () {
        const owner = accounts[3];
        const recipient = accounts[2];

        await nftoken.mint(owner.address, id2);
        await assertRevert(nftoken.connect(owner).transferFrom(owner.address, recipient.address, id3));
    });

    it('corectly safe transfers NFT from owner', async function () {
        const sender = accounts[1];
        const recipient = accounts[2];

        await nftoken.mint(sender.address, id2);
        await nftoken.connect(sender)["safeTransferFrom(address,address,uint256)"](sender.address, recipient.address, id2);

        const senderBalance = await nftoken.balanceOf(sender.address);
        const recipientBalance = await nftoken.balanceOf(recipient.address);
        const ownerOfId2 = await nftoken.ownerOf(id2);

        assert.equal(senderBalance, 0n);
        assert.equal(recipientBalance, 1n);
        assert.equal(ownerOfId2, recipient.address);
    });

    it('throws when trying to safe transfers NFT from owner to a smart contract', async function () {
        const sender = accounts[1];
        const nftokenAddress = await nftoken.getAddress();

        await nftoken.mint(sender.address, id2);
        await assertRevert(nftoken.connect(sender)["safeTransferFrom(address,address,uint256)"](sender.address, nftokenAddress, id2));
    });

    it('corectly safe transfers NFT from owner to smart contract that can recieve NFTs', async function () {
        const sender = accounts[1];
        const tokenReceiverMock = await TokenReceiverMock.deploy();
        await tokenReceiverMock.waitForDeployment();
        const recipient = await tokenReceiverMock.getAddress();

        await nftoken.mint(sender.address, id2);
        await nftoken.connect(sender)["safeTransferFrom(address,address,uint256)"](sender.address, recipient, id2);

        const senderBalance = await nftoken.balanceOf(sender.address);
        const recipientBalance = await nftoken.balanceOf(recipient);
        const ownerOfId2 = await nftoken.ownerOf(id2);

        assert.equal(senderBalance, 0n);
        assert.equal(recipientBalance, 1n);
        assert.equal(ownerOfId2, recipient);
    });

    /*
    SU SQUARES DOES NOT SUPPORT BURNING
    it('corectly burns a NFT', async function () {
      await nftoken.mint(accounts[1].address, id2);
      await nftoken.burn(accounts[1].address, id2);
  
      const balance = await nftoken.balanceOf(accounts[1].address);
      assert.equal(balance, 0n);
  
      await assertRevert(nftoken.ownerOf(id2));
    });
    */

    /*
    SU SQUARES DOES NOT SUPPORT BURNING
    it('throws when trying to burn non existant NFT', async function () {
      await assertRevert(nftoken.burn(accounts[1].address, id2));
    });
    */
});
