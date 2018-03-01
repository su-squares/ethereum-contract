# Su Squares Bounty Program

Su Squares Bounty Program recognizes necessity of security researchers to keep our community secure and fun. Su Squares is launching very soon and we will love if the community can help to find and disclose security vulnerabilities via this bounty program.

## What you need to know about Su Squares

Su Squares are collectable property which you can personalize and show off! Your ownership of this property can't be taken away from you.

Su Squares is the first public implementation of the new EIP-ready [ERC-721](https://github.com/ethereum/eips/issues/721) standard for non-fungible tokens (deeds). This bounty greatly contributes to the ERC-721 standardization process.

You can personalize your Su Square by adding an image, text and a hyperlink to your website

## The scope of this bounty program

This bounty program will run within the Ropsten network from 2018-03-01 at 00:01 GMT to 2018-03-04 at 23:59 GMT. All of the discussions and code in this bounty program are publicly available in this repository. Help us find any problems with this contract and with ERC-721 in general:

- Overflow or break parts of the program

- Steal ownership of a square

- Take over an admin account

- Give a square to somebody else and double spend it or revert it back to your control 

- Any undocumented and unintuitive behavior

**The contract is deployed on Ropsten network at [0x7bc6cfb376e2d607c0f0d608a3823ab3826173f6](https://ropsten.etherscan.io/address/0x7bc6cfb376e2d607c0f0d608a3823ab3826173f6).**

## Rules and rewards

- Issues that have already been published here or are already disclosed to the Su Squares team are not eligible for rewards

- Social engineering, XKCD#538 attacks, bringing down Ropsten/Metamask/Infura are not in scope and will be paid a reward

- Only the contract above is in scope, our website is not in scope

- GitHub issues is the only way to report issues and request rewards

- The Su Squares team has complete and final judgement on acceptability of issue reports

Following is a risk threat model that judges the impact of an issue based on its likelihood and impact.

|                 | NOT LIKELY      | —               | VERY LIKELY      |
| --------------- | --------------- | --------------- | ---------------- |
| **HIGH IMPACT** | Medium severity | High severity   | Highest severity |
| —               | Low severity    | Medium severity | High severity    |
| **LOW IMPACT**  | Notable         | Low severity    | Medium severity  |

Rewards:

* **High / highest severity** — you will received two Su Squares on the deployed website (worth $1000 USD)
* **Low / medium / high / highest** — all of these reports will receive an honorable mention, which is also visible from the final Su Squares website
* Additional rewards may be announced, want to sponsor? Contact us at Su@TenThousandSu.com

Examples of impact:

* High: Steal a square from someone else, impersonate an admin
* Medium: Cause personalization to fail so that the wrong data goes on the block chain
* Low: Cause a transaction counterparty that carefully reads the contract documentation to make a mistake on some edge case type of transaction

How to win:

* Be descriptive and detailed when describing your issue
* Fix it — recommend a way to solve the problem
* Include a truffle or detailed test case that we can reproduce

Rules for bounty sponsor:

* We will respond quickly to your questions (within 2 business days)
* We will adjudicate all prizes quickly (within 5 business days)
* Bounty sponsors are not eligible

## More questions

* Can I use this code in my project?
  * No. This code is provided to you solely for this security research program, please do not use it for other purposes. We plan to release some of this code to OpenZeppelin after the program is over.
* Will things change during the bounty program?
  * Yes, we are seeking sponsors and will add additional prizes here if that happens.
  * Yes, we will update the code and redeploy the contract. So, click STAR and WATCH above on this repo for updates.
* Taxes?
  * If sponsors give us so much money that you will need to fill out a tax form, then we will ask you to fill out a tax form. This whole program is subject to the laws of Pennsylvania.
* I read to the bottom of the file. That's not even a question.
  * Good, you're the type of person we're seeking. Here's a hint, you can see the [CryptoKitties bounty program](https://github.com/axiomzen/cryptokitties-bounty) and everything that happened there. We stole lots of ideas from them, thank you. And see also [the Su Squares Gitter](https://gitter.im/Su-Squares/Lobby#).

Copyright 2018 William & Su Entriken. All rights reserved.