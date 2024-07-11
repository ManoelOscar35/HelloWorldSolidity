pragma  solidity >=0.8.26;

library SafeMath {

	function sum(uint a, uint b) internal pure returns(uint) {
		uint c = a + b;
		require(c >= a, "Sum Overflow!");
		return c;
	}

	function sub(uint a, uint b) internal pure returns(uint) {
		require(b <= a, "Sub Underflow");
		uint c = a - b;
		return c;
	}

	function mul(uint a, uint b) internal pure returns(uint) {
		if(a == 0) {
			return 0;
		}

		uint c = a * b;
		require(c / a == b, "Mul Overflow");
		return c;
	}

	function div(uint a, uint b) internal pure returns(uint) {
		uint c = a / b;
		return c;
	}

}

contract Ownable {
	address public owner;

	event OwnershipTransferred(address newOwner);

	constructor() {
		owner = msg.sender;
	}

	modifier onlyOwner() {
		require(msg.sender == owner, "You are not the owner!");
		_;
	}

	function transferOwnership(address payable newOwner) onlyOwner public {
		owner = newOwner;

		emit OwnershipTransferred(owner);
	}

}

contract HelloWorld is Ownable {

	using SafeMath for uint;

	string public text;
	uint public number;
	address public userAddress;
	bool public answer;
	mapping (address => uint) public hasInteracted;
	mapping (address => uint) public balances;
	
	function setText(string memory myText) onlyOwner public {
		text = myText;
		setInteracted();
	}

	function setNumber(uint myNumber) public payable {
		require(msg.value >= 1 ether, "Insufficient ETH sent!");

		balances[msg.sender] = balances[msg.sender].sum(msg.value);
		number = myNumber;
		setInteracted();
	}

	function setUserAddress() public {
		userAddress = msg.sender;
		setInteracted();
	}

	function setAnswer(bool trueOrFalse) public {
		answer = trueOrFalse;
		setInteracted();
	}

	function setInteracted() private {
		hasInteracted[msg.sender] = hasInteracted[msg.sender].sum(1);
	}

	function sendETH(address payable targetAddress) public payable {
		targetAddress.transfer(msg.value);
	}

	function withdraw() public {
		require(balances[msg.sender] > 0, "Insufficients funds.");

		uint amount = balances[msg.sender];
		balances[msg.sender] = 0;
		payable(msg.sender).transfer(amount);
		
	}

	function sumStored(uint num1) public view returns(uint) {
		return num1.sum(number);
	}
}

