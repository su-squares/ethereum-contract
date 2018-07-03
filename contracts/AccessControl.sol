pragma solidity ^0.4.24;

/// @title Reusable three-role access control inspired by CryptoKitties
/// @author William Entriken (https://phor.net)
/// @dev Keep the CEO wallet stored offline, I warned you.
contract AccessControl {
    /// @notice The account that can only reassign executive accounts
    address public executiveOfficerAddress;

    /// @notice The account that can collect funds from this contract
    address public financialOfficerAddress;

    /// @notice The account with administrative control of this contract
    address public operatingOfficerAddress;

    constructor() internal {
        executiveOfficerAddress = msg.sender;
    }

    /// @dev Only allowed by executive officer
    modifier onlyExecutiveOfficer() {
        require(msg.sender == executiveOfficerAddress);
        _;
    }

    /// @dev Only allowed by financial officer
    modifier onlyFinancialOfficer() {
        require(msg.sender == financialOfficerAddress);
        _;
    }

    /// @dev Only allowed by operating officer
    modifier onlyOperatingOfficer() {
        require(msg.sender == operatingOfficerAddress);
        _;
    }

    /// @notice Reassign the executive officer role
    /// @param _executiveOfficerAddress new officer address
    function setExecutiveOfficer(address _executiveOfficerAddress)
        external
        onlyExecutiveOfficer
    {
        require(_executiveOfficerAddress != address(0));
        executiveOfficerAddress = _executiveOfficerAddress;
    }

    /// @notice Reassign the financial officer role
    /// @param _financialOfficerAddress new officer address
    function setFinancialOfficer(address _financialOfficerAddress)
        external
        onlyExecutiveOfficer
    {
        require(_financialOfficerAddress != address(0));
        financialOfficerAddress = _financialOfficerAddress;
    }

    /// @notice Reassign the operating officer role
    /// @param _operatingOfficerAddress new officer address
    function setOperatingOfficer(address _operatingOfficerAddress)
        external
        onlyExecutiveOfficer
    {
        require(_operatingOfficerAddress != address(0));
        operatingOfficerAddress = _operatingOfficerAddress;
    }

    /// @notice Collect funds from this contract
    function withdrawBalance() external onlyFinancialOfficer {
        financialOfficerAddress.transfer(address(this).balance);
    }
}
