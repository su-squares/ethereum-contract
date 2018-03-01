pragma solidity ^0.4.20;

import "./ERC165.sol";

/// @title A reusable contract to comply with ERC-165
/// @author William Entriken (https://phor.net)
contract PublishInterfaces is ERC165 {
    /// @dev You must not set element 0xffffffff to true
    mapping(bytes4 => bool) internal supportedInterfaces;

    function PublishInterfaces() internal {
        supportedInterfaces[0x01ffc9a7] = true; // ERC165
    }

    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return supportedInterfaces[interfaceID];
    }
}
