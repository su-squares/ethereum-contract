// From https://github.com/0xcert/ethereum-erc721/blob/master/test/tokens/NFToken.test.js

import assert from 'assert';
import { network } from 'hardhat';
import assertRevert from './helpers/assertRevert.js';

const { ethers } = await network.connect();

describe('NFTokenEnumerableMock', function () {
    let nftoken;
    let accounts;
    const id1 = 1;
    const id2 = 2;
    const id3 = 3;
    const id4 = 40000;

    beforeEach(async function () {
        accounts = await ethers.getSigners();
        const NFTokenEnumerable = await ethers.getContractFactory('SuNFTTestMock');
        nftoken = await NFTokenEnumerable.deploy();
        await nftoken.waitForDeployment();
    });

    it('correctly checks all the supported interfaces', async function () {
        const nftokenInterface = await nftoken.supportsInterface('0x80ac58cd');
        //const nftokenMetadataInterface = await nftoken.supportsInterface('0x5b5e139f');
        const nftokenEnumerableInterface = await nftoken.supportsInterface('0x780e9d63');
        assert.equal(nftokenInterface, true);
        //assert.equal(nftokenMetadataInterface, false);
        assert.equal(nftokenEnumerableInterface, true);
    });

    it('correctly mints a new NFT', async function () {
        await nftoken.mint(accounts[1].address, id1);
        const owner = await nftoken.ownerOf(id1);
        assert.equal(owner, accounts[1].address);
    });

    it('returns the correct total supply', async function () {
        const totalSupply = await nftoken.totalSupply();
        assert.equal(totalSupply, 10000n);
    });

    it('returns the correct token by index', async function () {
        await nftoken.mint(accounts[1].address, id1);
        await nftoken.mint(accounts[1].address, id2);
        await nftoken.mint(accounts[2].address, id3);

        let tokenId = await nftoken.tokenByIndex(0);
        assert.equal(tokenId, BigInt(id1));

        tokenId = await nftoken.tokenByIndex(1);
        assert.equal(tokenId, BigInt(id2));

        tokenId = await nftoken.tokenByIndex(2);
        assert.equal(tokenId, BigInt(id3));
    });

    it('returns the correct token by index', async function () {
        await nftoken.mint(accounts[1].address, id1);
        await nftoken.mint(accounts[1].address, id2);

        let tokenId = await nftoken.tokenByIndex(0);
        assert.equal(tokenId, BigInt(id1));

        tokenId = await nftoken.tokenByIndex(1);
        assert.equal(tokenId, BigInt(id2));

        tokenId = await nftoken.tokenByIndex(2);
        assert.equal(tokenId, BigInt(id3));
    });

    it('throws when trying to get token by non-existing index', async function () {
        await nftoken.mint(accounts[1].address, id1);
        await assertRevert(nftoken.tokenByIndex(100000));
    });

    it('returns the correct token of owner by index', async function () {
        await nftoken.mint(accounts[1].address, id1);
        await nftoken.mint(accounts[1].address, id2);
        await nftoken.mint(accounts[2].address, id3);

        const tokenId = await nftoken.tokenOfOwnerByIndex(accounts[1].address, 1);
        assert.equal(tokenId, BigInt(id2));
    });

    it('returns the correct token of owner by index after transfering a token back to the contract', async function () {
        const bob = accounts[1];
        const jane = accounts[2];
        const nftokenAddress = await nftoken.getAddress();

        await nftoken.mint(bob.address, id2);
        await nftoken.connect(bob).approve(jane.address, id2);
        await nftoken.connect(jane).transferFrom(bob.address, nftokenAddress, id2);
        let tokenId = await nftoken.tokenOfOwnerByIndex(nftokenAddress, 1);
        assert.equal(tokenId, 10000n);
        tokenId = await nftoken.tokenOfOwnerByIndex(nftokenAddress, 9999);
        assert.equal(tokenId, 2n);
    });

    it('returns the correct token of owner by index after multiple transfers', async function () {
        const bob = accounts[1];
        const jane = accounts[2];
        const sara = accounts[3];

        await nftoken.mint(bob.address, id1);
        await nftoken.mint(bob.address, id2);

        await nftoken.connect(bob).approve(jane.address, id2);
        await nftoken.connect(jane).transferFrom(bob.address, sara.address, id2);

        let tokenId = await nftoken.tokenOfOwnerByIndex(bob.address, 0);
        assert.equal(tokenId, BigInt(id1));

        await assertRevert(nftoken.tokenOfOwnerByIndex(bob.address, 1));

        tokenId = await nftoken.tokenOfOwnerByIndex(sara.address, 0);
        assert.equal(tokenId, BigInt(id2));

        await nftoken.connect(sara).approve(jane.address, id2);
        await nftoken.connect(jane).transferFrom(sara.address, bob.address, id2);

        await assertRevert(nftoken.tokenOfOwnerByIndex(sara.address, 0));

        tokenId = await nftoken.tokenOfOwnerByIndex(bob.address, 1);
        assert.equal(tokenId, BigInt(id2));
    });


    it('throws when trying to get token of owner by non-existing index', async function () {
        await nftoken.mint(accounts[1].address, id1);
        await nftoken.mint(accounts[2].address, id3);

        await assertRevert(nftoken.tokenOfOwnerByIndex(accounts[1].address, 4));
    });

    /*
    https://github.com/0xcert/ethereum-erc721/issues/150
    it('removeNFToken should correctly update ownerToIds and idToOwnerIndex', async function () {
      const NFTokenEnumerableTest = await ethers.getContractFactory('./mocks/SuNFTTestMock.sol');
      nftoken = await NFTokenEnumerableTest.deploy();
      await nftoken.waitForDeployment();
      await nftoken.mint(accounts[1].address, id1);
      await nftoken.mint(accounts[1].address, id3);
      await nftoken.mint(accounts[1].address, id2);
  
      const idToOwnerIndexId1 = await nftoken.idToOwnerIndexWrapper(id1);
      const idToOwnerIndexId3 = await nftoken.idToOwnerIndexWrapper(id3);
      const idToOwnerIndexId2 = await nftoken.idToOwnerIndexWrapper(id2);
      assert.strictEqual(idToOwnerIndexId1, 0n);
      assert.strictEqual(idToOwnerIndexId3, 1n);
      assert.strictEqual(idToOwnerIndexId2, 2n);
  
      const ownerToIdsLenPrior = await nftoken.ownerToIdsLen(accounts[1].address);
      const ownerToIdsFirst = await nftoken.ownerToIdbyIndex(accounts[1].address, 0);
      const ownerToIdsSecond = await nftoken.ownerToIdbyIndex(accounts[1].address, 1);
      const ownerToIdsThird = await nftoken.ownerToIdbyIndex(accounts[1].address, 2);
      assert.strictEqual(ownerToIdsLenPrior.toString(), '3');
      assert.strictEqual(ownerToIdsFirst, BigInt(id1));
      assert.strictEqual(ownerToIdsSecond, BigInt(id3));
      assert.strictEqual(ownerToIdsThird, BigInt(id2));
  
      await nftoken.removeNFTokenWrapper(accounts[1].address, id3);
  
      const ownerToIdsLenAfter = await nftoken.ownerToIdsLen(accounts[1].address);
      const ownerToIdsRemaining1 = await nftoken.ownerToIdbyIndex(accounts[1].address, 0);
      const ownerToIdsRemaining2 = await nftoken.ownerToIdbyIndex(accounts[1].address, 1);
      assert.strictEqual(ownerToIdsLenAfter.toString(), '2');
      assert.strictEqual(ownerToIdsRemaining1, BigInt(id1));
      assert.strictEqual(ownerToIdsRemaining2, BigInt(id2));
  
      const idToOwnerIndexId1After = await nftoken.idToOwnerIndexWrapper(id1);
      const idToOwnerIndexId2After = await nftoken.idToOwnerIndexWrapper(id2);
      assert.strictEqual(idToOwnerIndexId1After, 0n);
      assert.strictEqual(idToOwnerIndexId2After, 1n);
    });
    */

    /*
    https://github.com/0xcert/ethereum-erc721/issues/150
    it('addNFToken should correctly update ownerToIds and idToOwnerIndex', async function () {
      const NFTokenEnumerableTest = await ethers.getContractFactory('./mocks/SuNFTTestMock.sol');
      nftoken = await NFTokenEnumerableTest.deploy();
      await nftoken.waitForDeployment();
  
      const ownerToIdsLenPrior = await nftoken.ownerToIdsLen(accounts[1].address);
      assert.strictEqual(ownerToIdsLenPrior.toString(), '0');
  
      await nftoken.addNFTokenWrapper(accounts[1].address, id1);
      await nftoken.addNFTokenWrapper(accounts[1].address, id3);
      await nftoken.addNFTokenWrapper(accounts[1].address, id2);
  
      const ownerToIdsLenAfter = await nftoken.ownerToIdsLen(accounts[1].address);
      assert.strictEqual(ownerToIdsLenAfter.toString(), '3');
  
      const ownerToIdsFirst = await nftoken.ownerToIdbyIndex(accounts[1].address, 0);
      const ownerToIdsSecond = await nftoken.ownerToIdbyIndex(accounts[1].address, 1);
      const ownerToIdsThird = await nftoken.ownerToIdbyIndex(accounts[1].address, 2);
      assert.strictEqual(ownerToIdsFirst, BigInt(id1));
      assert.strictEqual(ownerToIdsSecond, BigInt(id3));
      assert.strictEqual(ownerToIdsThird, BigInt(id2));
  
      const idToOwnerIndexId1 = await nftoken.idToOwnerIndexWrapper(id1);
      const idToOwnerIndexId3 = await nftoken.idToOwnerIndexWrapper(id3);
      const idToOwnerIndexId2 = await nftoken.idToOwnerIndexWrapper(id2);
      assert.strictEqual(idToOwnerIndexId1, 0n);
      assert.strictEqual(idToOwnerIndexId3, 1n);
      assert.strictEqual(idToOwnerIndexId2, 2n);
    });
    */

    /*
    SU SQUARES DOES NOT SUPPORT BURNING
    it('corectly burns a NFT', async function () {
      await nftoken.mint(accounts[1].address, id1);
      await nftoken.mint(accounts[1].address, id2);
      await nftoken.mint(accounts[1].address, id3);
      await nftoken.burn(accounts[1].address, id2);
  
      const balance = await nftoken.balanceOf(accounts[1].address);
      assert.equal(balance, 2n);
  
      await assertRevert(nftoken.ownerOf(id2));
  
      const totalSupply = await nftoken.totalSupply();
      assert.equal(totalSupply, 2n);
  
      await assertRevert(nftoken.tokenByIndex(2));
      await assertRevert(nftoken.tokenOfOwnerByIndex(accounts[1].address, 2));
  
      let tokenId = await nftoken.tokenByIndex(0);
      assert.equal(tokenId, BigInt(id1));
  
      tokenId = await nftoken.tokenByIndex(1);
      assert.equal(tokenId, BigInt(id3));
    });
    */
});
