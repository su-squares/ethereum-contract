pragma solidity ^0.4.24;

import "./AccessControl.sol";
import "./SuNFT.sol";
import "./SuOperation.sol";
import "./SuPromo.sol";
import "./SuVending.sol";

/// @title The features that deed owners can use
/// @author William Entriken (https://phor.net)
contract SuMain is AccessControl, SuNFT, SuOperation, SuVending, SuPromo {
    constructor() public {
    }
}
