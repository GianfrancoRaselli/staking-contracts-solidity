// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;


contract StakingToken {

  string public name = "Staking Token";
  string public symbol = "ST";
  uint public totalSupply = 100000000000; // 1.000.000 tokens
  uint8 public decimals = 5;

  mapping(address => uint) public balanceOf;
  mapping(address => mapping(address => uint)) public allowance;


  event Transfer(
    address indexed from,
    address indexed to,
    uint value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint value
  );


  constructor() payable {
    balanceOf[msg.sender] = totalSupply;
  }
  
  
  function transfer(address _to, uint _value) public returns (bool success) {
    require(balanceOf[msg.sender] >= _value);

    unchecked {
      balanceOf[msg.sender] -= _value; 
    }
    balanceOf[_to] += _value;

    emit Transfer(msg.sender, _to, _value);

    return true;
  }

  function approve(address _spender, uint _value) public returns (bool success) {
    allowance[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);

    return true;
  }

  function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
    require(balanceOf[_from] >= _value);
    require(allowance[_from][msg.sender] >= _value);

    unchecked {
      balanceOf[_from] -= _value; 
      allowance[_from][msg.sender] -= _value;
    }
    balanceOf[_to] += _value;

    emit Transfer(_from, _to, _value);

    return true;
  }

}
