// From https://github.com/0xcert/ethereum-erc721/blob/master/test/tokens/NFToken.test.js

import assert from 'assert';
import { network } from 'hardhat';
import assertRevert from './helpers/assertRevert.js';

const { ethers } = await network.connect();

describe('NFTokenMetadataMock', function () {
    let nftoken;
    let accounts;
    const id1 = 1;
    const id2 = 2;
    const id3 = 3;
    const id4 = 40000;
    const expectedSymbol = 'SU';
    const expectedName = 'Su Squares';

    beforeEach(async function () {
        accounts = await ethers.getSigners();
        const NFTokenMetadata = await ethers.getContractFactory('SuNFTTestMock');
        nftoken = await NFTokenMetadata.deploy();
        await nftoken.waitForDeployment();
    });

    it('correctly checks all the supported interfaces', async function () {
        const nftokenInterface = await nftoken.supportsInterface('0x80ac58cd');
        const nftokenMetadataInterface = await nftoken.supportsInterface('0x5b5e139f');
        const nftokenNonExistingInterface = await nftoken.supportsInterface('0xba5eba11');
        assert.equal(nftokenInterface, true);
        assert.equal(nftokenMetadataInterface, true);
        assert.equal(nftokenNonExistingInterface, false);
    });

    it('returns the correct issuer name', async function () {
        const name = await nftoken.name();
        assert.equal(name, expectedName);
    });

    it('returns the correct issuer symbol', async function () {
        const symbol = await nftoken.symbol();
        assert.equal(symbol, expectedSymbol);
    });

    it('correctly mints and checks NFT id 2 url', async function () {
        const tokenURI = await nftoken.tokenURI(id2);
        assert.equal(tokenURI, 'https://tenthousandsu.com/erc721/00002.json');
    });

    it('throws when trying to get URI of invalid NFT ID', async function () {
        await assertRevert(nftoken.tokenURI(id4));
    });

    /*
    SU SQUARES DOES NOT SUPPORT BURNING
    it('correctly burns a NFT', async function () {
      await nftoken.mint(accounts[1].address, id2, 'url');
      await nftoken.burn(accounts[1].address, id2);
  
      const balance = await nftoken.balanceOf(accounts[1].address);
      assert.equal(balance, 0n);
  
      await assertRevert(nftoken.ownerOf(id2));
  
      const uri = await nftoken.checkUri(id2);
      assert.equal(uri, '');
    });
    */
});
