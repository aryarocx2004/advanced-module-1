// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ERC20 {
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "EXGEN";
    string public symbol = "XGN";
    uint8 public decimals = 18;

    enum KeyType { Bronze, Silver, Gold }

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event KeyReceived(address indexed recipient, KeyType keyType, uint tokensReceived);
    event KeyClaimed(address indexed recipient, string keyType, uint tokensReceived);
    event KeyClaimedWithStringValue(string keyTypeString);
    
    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function getRandomKeyType() private view returns (KeyType) {
    bytes32 hash = blockhash(block.number - 1); // Use the previous block's hash
    uint randomNumber = uint(hash) % 3;

    if (randomNumber == 0) {
        return KeyType.Bronze;
    } else if (randomNumber == 1) {
        return KeyType.Silver;
    } else {
        return KeyType.Gold;
    }
    }

    function claimRandomKey() external {
    KeyType keyType = getRandomKeyType();
    uint tokensReceived;

    if (keyType == KeyType.Bronze) {
        tokensReceived = 1000;
    } else if (keyType == KeyType.Silver) {
        tokensReceived = 1500;
    } else if (keyType == KeyType.Gold) {
        tokensReceived = 2000;
    }

    balanceOf[msg.sender] += tokensReceived;
    totalSupply += tokensReceived;

    emit Transfer(address(0), msg.sender, tokensReceived);
    emit KeyReceived(msg.sender, keyType, tokensReceived);

    // Convert the key type to a string representation
    string memory keyTypeString;
    if (keyType == KeyType.Bronze) {
        keyTypeString = "Bronze";
    } else if (keyType == KeyType.Silver) {
        keyTypeString = "Silver";
    } else if (keyType == KeyType.Gold) {
        keyTypeString = "Gold";
    }

    // Emit an event to indicate the key type and tokens received
    emit KeyClaimed(msg.sender, keyTypeString, tokensReceived);
    
    // Use this event to log the string value
    emit KeyClaimedWithStringValue(keyTypeString);
  }

}



interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Vault {
    IERC20 public immutable token;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
    }

    function deposit(uint _amount) external {
        /*
        a = amount
        B = balance of token before deposit
        T = total supply
        s = shares to mint

        (T + s) / T = (a + B) / B 

        s = aT / B
        */
        uint shares;
        if (totalSupply == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalSupply) / token.balanceOf(address(this));
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint _shares) external {
        /*
        a = amount
        B = balance of token before withdraw
        T = total supply
        s = shares to burn

        (T - s) / T = (B - a) / B 

        a = sB / T
        */
        uint amount = (_shares * token.balanceOf(address(this))) / totalSupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
    }
}
































