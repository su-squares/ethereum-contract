// From https://github.com/0xcert/ethereum-erc721/blob/master/test/helpers/assertRevert.js

import assert from 'assert';

export default async (promise) => {
    try {
        await promise;
        assert.fail('Expected revert not received');
    } catch (error) {
        const revertFound = error.message.search('revert') >= 0 ||
            error.message.search('reverted') >= 0 ||
            error.code === 'CALL_EXCEPTION' ||
            error.code === 'ACTION_REJECTED' ||
            error.code === 'INVALID_ARGUMENT';
        assert.ok(revertFound, `Expected "revert", got ${error} instead`);
    }
};
