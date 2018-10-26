pragma solidity ^0.4.0;
import "../contracts/AccessControl.sol";

contract AccessControlStub is AccessControl {
    constructor() public {
    }

    function anExecutiveTask() onlyExecutiveOfficer view external {
    }

    function anOperatingTask() onlyOperatingOfficer view external {
    }

    function aFinancialTask() onlyFinancialOfficer view external {
    }
}
