# Su Squares Ethereum Contract Deployment

*This is the full process for deploying a new version of the Su Squares smart contract. It costs money, it is painful. Measure twice, cut once!*

1. :warning: Warn the public at <https://tenthousandsu.com>
2. Edit code in the contracts folder

   1. Recompile `ALLINONE.sol` file, make sure it matches (automated build test)
   2. Merge latest code to `master`
   3. Run `git checkout master`, `git pull` and `git push` everywhere — no outdated code anywhere!
3. Use Remix IDE to compile code

   1. Delete all storage, add ALLINONE.sol, select `SuMain`, enable optimization, compile

   1. Save code to Gist (workaround for Etherscan bug)
   1. Save the bytecode to `bytecode.json`, this is a release artifact
   1. Save the ABI to `abi.json`, this is a release artifact
   1. Record the compiler version number
4. Use Remix IDE with CEO account to deploy contract
   1. Record the deployed address
   2. `setFinancialOfficer` `"0x7Ca2Cf38e9dbB925e584398E5D63F1A8F0B731f9"`
   3. `setOperatingOfficer` `"0x7B91c5453eABd33E69083b55Ce0dD450D6E2c8F4"`
5. Use Remix IDE with COO account to use contract
   1. For old contract, find all squares that were granted or purchased
   2. Use `ownerOf` and `suSquares[squareNumber]` for each square to migrate
   3. For each square:
      1. `grantToken` to COO account
      2. `personalize` using old personalization (if any)
      3. transferFrom` to the correct owner
6. Login on etherscan.io and load this contract
   1. "Add To Watch List", add description, enable email notifications
   2. Code tab, "Verify and Publish"
   3. Create ticket for "Update Token Information" for ERC-721
7. Update cron job
   1. Edit query-blockchain.js
   2. Run a complete job
8. Update tenthousandsu.com
   1. Update address in the Javascript, update JS file version (in hyper links)
   2. Update address in the white paper (NOTE OLD ADDRESS)
   3. Remove any (WE ARE UPGRADING) note on index.html
9. Tell the world
   1. Make a release on smart contract GitHub project / add release artifacts / update the project URL to new etherscan contract <https://github.com/su-squares/ethereum-contract>
   2. Update address at <https://github.com/MyEtherWallet/ethereum-lists/blob/master/contracts/contract-abi-eth.json>
   3. Relist opensea
   4. Relist coingecko
   5. Email anybody that bought squares, if I know them somehow
10. Take money from old contract as CFO
