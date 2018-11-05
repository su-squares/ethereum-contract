# Su Squares Ethereum Contract

[![Build Status](https://travis-ci.org/su-squares/ethereum-contract.svg?branch=master)](https://travis-ci.org/su-squares/ethereum-contract) [![Join the chat at https://gitter.im/Su-Squares/Lobby](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Su-Squares/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

⬛️🔲⬛️ *Su Squares are cute squares you own and personalize. This repository holds the Ethereum smart contract which handles the ownership, personalization and sales logic of Su Squares.* 🔲⬛️🔲

## Development

We recommend using Remix IDE to develop and test the Su Squares Ethereum Contract.

1. `git clone https://github.com/su-squares/ethereum-contract.git su-squares-ethereum-contract`
2. `cd su-squares-ethereum-contract`
3. `npx remixd -s .`
4. Open [Remix IDE](http://remix.ethereum.org)
5. Click the link icon (:link:) on the top to connect
6. Edit code, and then run tests using the "Testing" tab on the right

You can also run tests locally by running `npm test`. Read some [details on how that works](package.json).

## Project scope

This repository is open so that you may study the Su Squares Ethereum Contract code and become confident that it works correctly. This project is deployed already and so upgrades are expensive (see [deployment section](#deployment). We always welcome contributions (issues, pull requests) that improve testing of the smart contract. Changes to the smart contract code will be deployed only if they fix a serious problem (see [bug bounty section](#bug-bounty)). Other changes may be accepted into a branch, which might sit there for a long time.

## Deployment

Our smart contract deployment process is expensive and requires updating or informing every part of the world that touches the contract. We do not intend to do it often. Each release is expected to be the final release. But we will redeploy if it protects our customers from a documented problem.

Read the full [deployment process documentation](DEPLOY.md).

## Bug bounty

You are somebody that reads documentation on smart contracts and understands how Su Squares works. So you have unique skills and your time is valuable. We will pay you for your contributions to Su Squares in the form of bug reports.

If your project depends on ERC-721 or you want to help improve the assuarance of this project then you can pledge a bounty. This means you will commit to pay researchers that demonstrate a problem. Contact us at Su@TenThousandSu.com if interested. Thank you.

Read the full [bug bounty program](BUG-BOUNTY.md).

## License

Copyright 2018 Su & William Entriken. All rights reserved.

We commit to rerelease this project under the MIT license when 20% of the squares have been sold. At that time we will also release our back-end scripts and other code that you might be interested in also under MIT license.
