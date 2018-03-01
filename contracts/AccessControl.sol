pragma solidity ^0.4.20;

/// @title A reusable three-role access control mechanism
/// @author William Entriken (https://phor.net)
contract AccessControl {

    // We separate duties into three roles. Inspired by CryptoKitties.
    //
    //   - Executive officer can reassign these three roles.
    //
    //   - Finance officer can withdraw funds from this contract.
    //
    //   - Operating officer can grant promo SuSquares and pre-sale SuSquares.
    //
    // This separation of duties means that the executive officer role is
    // useless for day-to-day operations. That wallet should staff offline in a
    // safe. That role becomes useful only if another account is compromised.
    address public executiveOfficerAddress;
    address public financialOfficerAddress;
    address public operatingOfficerAddress;

    function AccessControl() internal {
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

    /// @dev Reassign the executive officer role
    /// @param _executiveOfficerAddress new officer address
    function setExecutiveOfficer(address _executiveOfficerAddress)
        external
        onlyExecutiveOfficer
    {
        require(_executiveOfficerAddress != address(0));
        executiveOfficerAddress = _executiveOfficerAddress;
    }

    /// @dev Reassign the financial officer role
    /// @param _financialOfficerAddress new officer address
    function setFinancialOfficer(address _financialOfficerAddress)
        external
        onlyExecutiveOfficer
    {
        require(_financialOfficerAddress != address(0));
        financialOfficerAddress = _financialOfficerAddress;
    }

    /// @dev Reassign the operating officer role
    /// @param _operatingOfficerAddress new officer address
    function setOperatingOfficer(address _operatingOfficerAddress)
        external
        onlyExecutiveOfficer
    {
        require(_operatingOfficerAddress != address(0));
        operatingOfficerAddress = _operatingOfficerAddress;
    }

    /// @dev Take payment of money in this contract
    function withdrawBalance() external onlyFinancialOfficer {
        financialOfficerAddress.transfer(this.balance);
    }
}
