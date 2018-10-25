# Su Squares Ethereum Contract Deployment

*This is the full process for deploying a new version of the Su Squares smart contract. It costs money, it is painful. Measure twice, cut once!*

1. :warning: Warn the public at https://tenthousandsu.com

2. Edit code in the contracts folder

   1. Recompile `ALLINONE.sol` file, make sure it matches (automated build test)
   2. Merge latest code to `master`
   3. Run `git checkout master`, `git pull` and `git push` everywhere — no outdated code anywhere!

3. Use Remix IDE to compile code

   1. Delete all storage, add ALLINONE.sol, select `SuMain`, enable optimization, compile

   1. Save code to Gist (workaround for Etherscan bug)
   2. Save the bytecode to `bytecode.json`, this is a release artifact
   3. Save the ABI to `abi.json`, this is a release artifact
   4. Record the compiler version number

4. Use Remix IDE with CEO account to deploy contract
   1. Record the deployed address
5. Login on etherscan.io and load this contract
   1. "Add To Watch List", add description, enable email notifications
   2. Code tab, "Verify and Publish"
   3. Create ticket for "Update Token Information" for ERC-721
   4. https://etherscan.io/myaccount / add to Address Watch List + Address notes
6. Use Remix IDE as CEO account to set up contract
   1. `setFinancialOfficer` `"0x7Ca2Cf38e9dbB925e584398E5D63F1A8F0B731f9"`
   2. `setOperatingOfficer` `"0x7B91c5453eABd33E69083b55Ce0dD450D6E2c8F4"`
7. Use Remix IDE with COO account to use contract
   1. Find each owned square on the old contract
      1. `grantToken` to COO account
      2. Personalize the square
         1. Use Sublime edit to make it like this format for Remix IDE editor `["0xf7","0xe0","0x80","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xff","0xec","0xf4","0xf8","0xff","0xff","0xff","0xef","0xc2","0x0a","0xf8","0xe1","0x85","0xf1","0xc6","0x17","0xf2","0xca","0x29","0xff","0xff","0xff","0xff","0xff","0xff","0xf4…`
      3. `transferFrom` to the correct owner
8. Update cron job
   1. Edit query-blockchain.js
   2. Run a complete job
9. Update tenthousandsu.com
   1. Update address in the Javascript, update JS file version (in hyper links)
   2. Update address in the white paper (NOTE OLD ADDRESS)
   3. Remove any (WE ARE UPGRADING) note on index.html
10. Tell the world
    1. Update address at https://github.com/MyEtherWallet/ethereum-lists/blob/master/contracts/contract-abi-eth.json
    2. Make a release on smart contract GitHub project / add release artifacts / update the project URL to new etherscan contract https://github.com/su-squares/ethereum-contract
    3. Relist opensea
    4. Relist coingecko
    5. Email anybody that bought squares, if I know them somehow
11. Take money from old contract as CFO

