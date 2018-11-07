// From https://github.com/0xcert/ethereum-erc721/blob/master/test/tokens/NFToken.test.js

const NFTokenMetadata = artifacts.require('SuNFTTestMock');
const assertRevert = require('./helpers/assertRevert');

contract('NFTokenMetadataMock', (accounts) => {
  let nftoken;
  const id1 = 1;
  const id2 = 2;
  const id3 = 3;
  const id4 = 40000;
  const expectedSymbol = 'SU';
  const expectedName = 'Su Squares';

  beforeEach(async () => {
    nftoken = await NFTokenMetadata.new();
  });

  it('correctly checks all the supported interfaces', async () => {
    const nftokenInterface = await nftoken.supportsInterface('0x80ac58cd');
    const nftokenMetadataInterface = await nftoken.supportsInterface('0x5b5e139f');
    const nftokenNonExistingInterface = await nftoken.supportsInterface('0xba5eba11');
    assert.equal(nftokenInterface, true);
    assert.equal(nftokenMetadataInterface, true);
    assert.equal(nftokenNonExistingInterface, false);
  });

  it('returns the correct issuer name', async () => {
    const name = await nftoken.name();
    assert.equal(name, expectedName);
  });

  it('returns the correct issuer symbol', async () => {
    const symbol = await nftoken.symbol();
    assert.equal(symbol, expectedSymbol);
  });

  it('correctly mints and checks NFT id 2 url', async () => {
    const tokenURI = await nftoken.tokenURI(id2);
    assert.equal(tokenURI, 'https://tenthousandsu.com/erc721/00002.json');
  });

  it('throws when trying to get URI of invalid NFT ID', async () => {
    await assertRevert(nftoken.tokenURI(id4));
  });

  /*
  SU SQUARES DOES NOT SUPPORT BURNING
  it('correctly burns a NFT', async () => {
    await nftoken.mint(accounts[1], id2, 'url');
    const { logs } = await nftoken.burn(accounts[1], id2);
    const transferEvent = logs.find(e => e.event === 'Transfer');
    assert.notEqual(transferEvent, undefined);
    const clearApprovalEvent = logs.find(e => e.event === 'Approval');
    assert.equal(clearApprovalEvent, undefined);

    const balance = await nftoken.balanceOf(accounts[1]);
    assert.equal(balance, 0);

    await assertRevert(nftoken.ownerOf(id2));

    const uri = await nftoken.checkUri(id2);
    assert.equal(uri, '');
  });
  */
});