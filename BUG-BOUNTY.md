# Su Squares Ethereum Contract Bug Bounty

*This documents our bug bounty process and how you get paid for finding issues with the Su Squares project.*

## Leaderboard

First, let's give credit to the security researchers that found issues!

| Issue                                                        | Researcher   | Reward   |
| ------------------------------------------------------------ | ------------ | -------- |
| [#1](https://github.com/su-squares/ethereum-contract/issues/1) Incorrect comment `[]` | @sz-piotr    | 1 square |
| [#2](https://github.com/su-squares/ethereum-contract/issues/2) Incorrect price | @sz-piotr    | 1 square |
| [#3](https://github.com/su-squares/ethereum-contract/issues/5) Clear approval | @paulbarclay | 1 square |
| [#10](https://github.com/su-squares/ethereum-contract/issues/10) Operator Send does not use correct check | @dfinzer     | 1 square |

## Sponsors

**Sponsor this bug bounty if you support ERC-721**. This means you will commit to pay researchers that demonstrate a problem. Contact us at <Su@TenThousandSu.com> if interested. Thank you.

**Now featured on GitCoin, you can check them out here <https://twitter.com/GetGitcoin>**

---

## Scope of this bounty program

This bounty is open for an unlimited time. Previous limited-time bounty programs were:

* Round 1 — **2018-03-01 at 00:01 GMT** to **2018-03-04 at 23:59 GMT**
* Round 2 — **2018-07-02 at 00:01 GMT** to **2018-07-07 at 23:59 GMT**

Help us find any problems with this contract and with ERC-721 in general. This bounty program's function scope includes:

* Overflow or break parts of the program
* Steal ownership of a square
* Take over an admin account
* Give a square to somebody else and double spend it or revert it back to your control
* Any undocumented and unintuitive behavior

## Rules and rewards

* Issues that have already been published here or are already disclosed to the Su Squares team are not eligible for rewards
* Social engineering, XKCD#538 attacks, bringing down Mainnet/Infura are not in scope and will NOT be paid a reward
* Only the official mainnet contract is in scope, our website is not in scope
* GitHub issues is the only way to report issues and request rewards
* The Su Squares team has complete and final judgement on acceptability of issue reports

Following is a risk threat model that judges the impact of an issue based on its likelihood and impact.

|                 | NOT LIKELY      | :left_right_arrow: | VERY LIKELY          |
| --------------- | --------------- | ------------------ | -------------------- |
| **HIGH IMPACT** | Medium severity | High severity      | **Highest severity** |
| :arrow_up_down: | Low severity    | Medium severity    | High severity        |
| **LOW IMPACT**  | *Notable*       | Low severity       | Medium severity      |

Rewards:

* **High severity / highest severity** — you will received two Su Squares on the deployed website (worth $1000 USD)
* **Low / medium / high / highest** — all of these reports will receive an honorable mention, which is also visible from [the Su Squares website](https://tenthousandsu.com)
* Additional rewards may be announced by sponsors? See [sponsors section](#sponsors) above.

Examples of impact:

* High: Steal a square from someone else, impersonate an admin
* Medium: Cause personalization to fail so that the wrong data goes on the blockchain
* Low: Cause a transaction counterparty that carefully reads the contract documentation to make a mistake on some edge case type of transaction

How to win:

* Be descriptive and detailed when describing your issue
* Fix it — recommend a way to solve the problem
* Include a Hardhat or detailed test case that we can reproduce

Rules for bounty sponsor:

* We will respond quickly to your questions (within 2 business days)
* We will adjudicate all prizes quickly (within 5 business days)
* Bounty sponsors are not eligible

## More questions

* Will things change during the bounty program?
  * Yes, we are seeking sponsors and will add additional prizes here if that happens.
  * Yes, we will update the code and redeploy the contract. So, click STAR and WATCH above on this repo for updates.
* Taxes?
  * If sponsors give us so much money that you will need to fill out a tax form, then we will ask you to fill out a tax form. This whole program is subject to the laws of Pennsylvania.
* I read to the bottom of the file.
  * That's not even a question. Good, you're the type of person we're seeking. Here's a hint, you can see the [CryptoKitties bounty program](https://github.com/axiomzen/cryptokitties-bounty) and everything that happened there. We stole lots of ideas from them, thank you. And see also [the Su Squares Gitter](https://gitter.im/Su-Squares/Lobby#).

Copyright 2018 William & Su Entriken. All rights reserved.
