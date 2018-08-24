pragma solidity ^0.4.24;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }
  
  

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {

  address public owner;

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
   constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner)public onlyOwner {
    require(newOwner != address(0));
    owner = newOwner;
  }
}


contract token {

    function balanceOf(address _owner) public constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    
}


contract FiatContract {

    function USD(uint _id) constant public returns (uint256);

}


contract CewnoteICO is Ownable{
    
    FiatContract price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591); // MAINNET ADDRESS
    //FiatContract price = FiatContract(0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909); // TESTNET ADDRESS (ROPSTEN)

    using SafeMath for uint256;
    
    //This sale have 12 stages
    enum State {
        Week1,
        Week2,
        Week3,
        Week4,
        Week5,
        Week6,
        Week7,
        Week8,
        Week9,
        Week10,
        Week11,
        Week12,
        Successful
    }
    
    //public variables
    State public state; //Set initial stage
    uint256 tokenPrice; // token price
    uint256 public hardCap = 43200000; // 43.2 million USD
    uint256 public softCap = 980000; //  0.98 million USD
    uint256 public totalRaised; //eth in wei
    uint256 public totalDistributed; //tokens distributed
    token public tokenReward; //Address of the valid token used as reward

    //events for log
    event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
    event LogBeneficiaryPaid(address _beneficiaryAddress);
    event LogFundingSuccessful(uint _totalRaised);
    event LogFunderInitialized(address _creator);
    event LogContributorsPayout(address _addr, uint _amount);


    modifier notFinished {
        require(state != State.Successful);
        _;
    }
    
    
    /**
    * @notice constructor
    * @param _addressOfTokenUsedAsReward is the token totalDistributed
    */
    constructor(token _addressOfTokenUsedAsReward) public {
        state = State.Week1;
        tokenReward = token(_addressOfTokenUsedAsReward);
        emit LogFunderInitialized(owner);
    }


    /**
    * @notice contribution handler
    */
    function contribute() public notFinished payable {
        
        uint256 tokenBought; //Variable to store amount of tokens bought
        uint256 bonus;
        //uint256 ethCent = price.USD(0); //1 cent value in wei
        
        
        // For testing -- REMOVE IT IN PRODUCTION
        uint256 ethCent = 14915066160000;  //

        
        // 0.7 $ = 1 CEW & 12 % bonus
        if (state >= State.Week1 && state <= State.Week3) {
            tokenPrice = ethCent.mul(7); 
            tokenBought = msg.value.mul(10 ** 18).div(tokenPrice);
            bonus = tokenBought.mul(12).div(100);
        }
        
        // 0.13 $ = 1 CEW & 10 % bonus
        if (state == State.Week4){
            tokenPrice = ethCent.mul(13);
            tokenBought = msg.value.mul(10 ** 18).div(tokenPrice);
            bonus = tokenBought.mul(10).div(100);
        }
        
        // 0.19 $ = 1 CEW & 10 % bonus
        if (state == State.Week5){
            tokenPrice = ethCent.mul(19);
            tokenBought = msg.value.mul(10 ** 18).div(tokenPrice);
            bonus = tokenBought.mul(10).div(100);
        }
        
        // 0.25 $ = 1 CEW & 10 % bonus
        if (state == State.Week6){
            tokenPrice = ethCent.mul(25);
            tokenBought = msg.value.mul(10 ** 18).div(tokenPrice);
            bonus = tokenBought.mul(10).div(100);
        }
        
        // 0.31 $ = 1 CEW & 8 % bonus
        if (state == State.Week7){
            tokenPrice = ethCent.mul(31);
            tokenBought = msg.value.mul(10 ** 18).div(tokenPrice);
            bonus = tokenBought.mul(8).div(100);
        }
        
        // 0.36 $ = 1 CEW & 8 % bonus
        if (state == State.Week8){
            tokenPrice = ethCent.mul(36);
            tokenBought = msg.value.mul(10 ** 18).div(tokenPrice);
            bonus = tokenBought.mul(8).div(100);
        }
        
        // 0.42 $ = 1 CEW & 6 % bonus
        if (state == State.Week9){
            tokenPrice = ethCent.mul(42);
            tokenBought = msg.value.mul(10 ** 18).div(tokenPrice);
            bonus = tokenBought.mul(6).div(100);
        }
        
        // 0.48 $ = 1 CEW & 6 % bonus
        if (state == State.Week10){
            tokenPrice = ethCent.mul(48);
            tokenBought = msg.value.mul(10 ** 18).div(tokenPrice);
            bonus = tokenBought.mul(6).div(100);
        }
        
        // 0.54 $ = 1 CEW & 4 % bonus
        if (state == State.Week11){
            tokenPrice = ethCent.mul(54);
            tokenBought = msg.value.mul(10 ** 18).div(tokenPrice);
            bonus = tokenBought.mul(4).div(100);
        }
        
        // 0.60 $ = 1 CEW & 2 % bonus
        if (state == State.Week12){
            tokenPrice = ethCent.mul(60);
            tokenBought = msg.value.mul(10 ** 18).div(tokenPrice);
            bonus = tokenBought.mul(2).div(100);
        }
        
        tokenBought = tokenBought.add(bonus);
        
        totalRaised = totalRaised.add(msg.value); //Save the total eth totalRaised (in wei)
        totalDistributed = totalDistributed.add(tokenBought); //Save to total tokens distributed
        
        tokenReward.transfer(msg.sender,tokenBought); //Send Tokens to user
        owner.transfer(msg.value); // Send ETH to owner
        
        //LOGS
        emit LogBeneficiaryPaid(owner);
        emit LogFundingReceived(msg.sender, msg.value, totalRaised);
        emit LogContributorsPayout(msg.sender,tokenBought);

    }

    function nextState() onlyOwner public {
        require(state != State.Week12);
        state = State(uint(state) + 1);
    }
    
    function previousState() onlyOwner public {
        require(state != State.Week12);
        state = State(uint(state) - 1);
    }
    
    
    /**
    * @notice Function for closure handle
    */
    function finished() onlyOwner public { 
        
        uint256 remainder = tokenReward.balanceOf(this); //Remaining tokens on contract
        
        //Funds(ETH) send to creator if any
        if(address(this).balance > 0) {
            owner.transfer(address(this).balance);
            emit LogBeneficiaryPaid(owner);
        }
 
        
        tokenReward.transfer(address(0),remainder); // Burn Remaining Tokens

        state = State.Successful; // updating the state
    }


    /**
    * @notice Function to burn any tokens left after ICO
    */
    function burnTokens() onlyOwner public {
        
        uint256 remainder = tokenReward.balanceOf(this); //Check remainder tokens
        tokenReward.transfer(address(0),remainder); // Burn Remaining Tokens
    }


    /**
    * @notice Function to handle eth transfers
    * @dev BEWARE: if a call to this functions doesn't have
    * enought gas, transaction could not be finished
    */
    function() public payable {
        contribute();
    }
    
}
