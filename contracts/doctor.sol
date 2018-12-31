pragma solidity ^0.4.25;

import "./person.sol";
import "./repo.sol";

contract Doctor is Person {
    
    constructor(address _owner, string _name, uint8 _age, uint8 _gender)
        public
    {
        controller = msg.sender;
        owner = _owner;
        name = _name;
        age = _age;
        gender = _gender;
    }
    
    function givenApproval(address patient)
        external
    {
        approvals[patient] = true;
    }
    
    function cancelledApproval(address patient)
        external
        onlyApproved(patient)
    {
        approvals[patient] = false;
    }
}