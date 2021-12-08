// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CAC is ERC20("Cryptoids Administrator Coin", "CAC"), Ownable {
  uint256 public constant maxSupply = 10 ** 26;
  address public accessContractAddr;
  event GameCharge(address indexed from, uint256 amount);
  event SetAccessContract(address);

  function setAccessContract(address _addr) external onlyOwner {
    accessContractAddr = _addr;
    emit SetAccessContract(_addr);
  }
  
  function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
    _mint(_to, _amount);
    require(totalSupply() <= maxSupply, "reach max supply");
    return true;
  }

  function charge(uint256 _amount) external {
    if (accessContractAddr == address(0)) {
      _burn(msg.sender, _amount);
    } else {
      _transfer(msg.sender, accessContractAddr, _amount);
    }
    emit GameCharge(msg.sender, _amount);
  }
}