pragma solidity ^0.4.24;

import "./ERC165.sol";

/// @title A reusable contract to comply with ERC-165
/// @author William Entriken (https://phor.net)
contract SupportsInterface is ERC165 {
    /// @dev Every interface that we support, do not set 0xffffffff to true
    mapping(bytes4 => bool) internal supportedInterfaces;

    constructor() internal {
        supportedInterfaces[0x01ffc9a7] = true; // ERC165
    }

    /// @notice Query if a contract implements an interface
    /// @param interfaceID The interface identifier, as specified in ERC-165
    /// @dev Interface identification is specified in ERC-165. This function
    ///  uses less than 30,000 gas.
    /// @return `true` if the contract implements `interfaceID` and
    ///  `interfaceID` is not 0xffffffff, `false` otherwise
    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return supportedInterfaces[interfaceID] && (interfaceID != 0xffffffff);
    }
}
