pragma solidity ^0.4.24;
import "../../contracts/AccessControl.sol";

contract AccessControlTestMock is AccessControl {
    constructor() public {
    }

    function anExecutiveTask() onlyExecutiveOfficer view external {
    }

    function anOperatingTask() onlyOperatingOfficer view external {
    }

    function aFinancialTask() onlyFinancialOfficer view external {
    }
}
