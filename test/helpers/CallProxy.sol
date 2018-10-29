pragma solidity ^0.4.24;

// Proxy contract for testing throws
// Use because .call() problem https://github.com/ethereum/solidity/issues/5321
contract CallProxy {
    address private target;
    bool public callResult;

    constructor(address _target) public {
        target = _target;
    }

    function() external payable {
        callResult = target.call.value(msg.value)(msg.data); // solium-disable-line
    }
}
