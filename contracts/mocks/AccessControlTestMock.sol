pragma solidity ^0.4.24;
import "../AccessControl.sol";

contract AccessControlTestMock is AccessControl {
    constructor() public {}

    function anExecutiveTask() external view onlyExecutiveOfficer {}

    function anOperatingTask() external view onlyOperatingOfficer {}

    function aFinancialTask() external view onlyFinancialOfficer {}
}
