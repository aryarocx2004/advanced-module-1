# Avalanche Subnets - EXGEN Tokens

This is a solidity program which implements the claimRandomKey function where in the DeFi Kingdom, the user discovers different types of keys - Gold, Silver and Bronze. Each key has an associated amount of tokens which will be added to the player's account. 

This is a simple contract for exploration-based gaming experience in he DeFi kingdom where the user collects various keys to increase his number of tokens in his account.

## Description

### ERC-20 Contract

This program contains 3 events

```
event KeyReceived(address indexed recipient, KeyType keyType, uint tokensReceived);
event KeyClaimed(address indexed recipient, string keyType, uint tokensReceived);
event KeyClaimedWithStringValue(string keyTypeString);

```
where 

1. KeyReceived Event: It is triggered when a key is received by a user.
2. KeyClaimed Event: this event is triggered when a user claims a key.
3. KeyClaimedWithStringValue Event: This event is used solely for logging purposes to capture the string value of the key type.

and

#### getRandomKeyType Function:

This function uses the hash of the previous block to generate a random key type (KeyType).

To obtain the hash of the preceding block, we use the blockhash(block.number - 1).

This transforms th  hash into an unsigned integer (uint).

Next, we acertain the key type using the outcome: 

1. KeyType matches to 0. 

2. One to KeyType in bronze.

3. Then two to KeyType and silver.Gold.


```

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

```

#### claimRandomKey Function:

This function claims a random key, when it is called.

To find the key type, it makes a call to getRandomKeyType.

It sets the tokensReceived variable based on the kind of key.

Then it updates the caller's balance and the overall supply using the tokens that were received.

It then logs the token transfer by emitting the Transfer event.

It indicates the type of key and tokens received by emitting the KeyReceived event and ransforms the key type into a keyTypeString string representation.

With the received tokens and the key type string, emits the KeyClaimed event and logs the key type's string value using the KeyClaimedWithStringValue event.

'''

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

'''

### Vault contract

In order to manage deposits and withdrawals of the ERC20 token, the Vault contract communicates with the token. The Vault contract is a simple interface that manages deposits and withdrawals of the XGN token. It communicates with the token.


## Executing program

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., program.sol). Copy and paste the following code into the file:

```
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

```
## Avalanche EVM Subnet

To set-up the Avalanche EVM subnet, we need RPC URL, token symbol and Chain ID.

Subnet name: mysubnet

RPC URL: 

Chain ID: 1210

Token Symbol: XGN


## Deploying the contract

After configuring your Avalanche EVM subnet, deploy these contracts to it.

Select the "Solidity Compiler" tab from the sidebar on the left to begin compiling the code. Click the "Compile project.sol" button after ensuring that the "Compiler" option is set to "0.8.17" (or any suitable version).


We link the Remix IDE to our Metamask wallet once the contract has been built.


We then switch to the Injected Provider environment. 


You can engage with the contract to mint, burn, and transfer tokens after it is launched. 

By interacting with the claimRandomKey operator function, we cam see that out totalsupply gets updated in sequence with the key found.

If the key is gold, then total suply gets incremented by +2000

If the key is silver, then total suply gets incremented by +1500

If the key is bronze, then total suply gets incremented by +1000

## Authors

Arya pg 

aryapg2004@gmail.com

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
