pragma solidity ^0.4.25;

contract Person {
    address controller;
    address owner;
    uint256 id;
    string name;
    uint8 age;
    uint8 gender;
    
    mapping (address => bool) approvals;
    
    modifier onlyController() {
        require(msg.sender == controller);
        _;
    }
    
    modifier onlyOwner(address _sender) {
        require(isOwner(_sender));
        _;
    }
    
    modifier onlyApproved(address _sender) {
        require(isApproved(_sender));
        _;
    }
    
    function isApproved(address _sender) public view returns(bool) {
        if (approvals[_sender] || isOwner(_sender)) {
            return true;
        }
        return false;
    }
    
    function isOwner(address _sender) public view returns(bool) {
        return _sender == owner;
    }
    
}