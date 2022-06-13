// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./StakingToken.sol";
import "./RewardToken.sol";


contract Farm {
  
  address public immutable owner = msg.sender;

  StakingToken public stakingToken;
  RewardToken public rewardToken;

  address[] public stakers;
  mapping(address => uint) stakingBalance;
  mapping(address => bool) hasStaked;
  mapping(address => bool) isStaking;


  modifier onlyOwner {
    require(msg.sender == owner, "You can not access");
    _;
  }


  constructor(StakingToken _stakingToken, RewardToken _rewardToken) payable {
    stakingToken = _stakingToken;
    rewardToken = _rewardToken;
  }


  function stakeTokens(uint _amount) public {
    require(_amount > 0, "You can not stake 0 tokens");

    stakingToken.transferFrom(msg.sender, address(this), _amount);
    stakingBalance[msg.sender] += _amount;
    if (!hasStaked[msg.sender]) {
      stakers.push(msg.sender);
      hasStaked[msg.sender] = true;
    }
    isStaking[msg.sender] = true;
  }

  function unstakeTokens() public {
    uint balance = stakingBalance[msg.sender];
    require(balance > 0, "You do not have staked tokens");

    stakingToken.transfer(msg.sender, balance);
    delete stakingBalance[msg.sender];
    delete isStaking[msg.sender];
  }

  function unstakeTokens(uint _amount) public {
    uint balance = stakingBalance[msg.sender];
    require(balance >= _amount, "Try to unstake fewer tokens");

    stakingToken.transfer(msg.sender, _amount);
    unchecked {
      stakingBalance[msg.sender] = balance - _amount;
    }
    if (balance == _amount) {
      delete isStaking[msg.sender];
    }
  }

  function issueTokens() public onlyOwner {
    uint length = stakers.length;

    for (uint i; i < length;) {
      address recipient = stakers[i];
      uint balance = stakingBalance[recipient];

      if (balance > 0) {
        rewardToken.transfer(recipient, balance);
      }

      unchecked {
        i++;
      }
    }
  }

}
