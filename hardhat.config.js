import { defineConfig } from "hardhat/config";
import hardhatToolboxMochaEthers from "@nomicfoundation/hardhat-toolbox-mocha-ethers";

export default defineConfig({
    plugins: [hardhatToolboxMochaEthers],
    solidity: {
        version: "0.4.24",
        settings: {
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    }
});
