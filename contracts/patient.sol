pragma solidity ^0.4.25;

import "./person.sol";
import "./repo.sol";

contract Patient is Person {

    repository.Record[] private records;
    
    constructor(address _owner, string _name, uint8 _age, uint8 _gender)
        public
    {
        controller = msg.sender;
        owner = _owner;
        name = _name;
        age = _age;
        gender = _gender;
    }
    
    function giveApproval(address patientId, address doctorId)
        external
        onlyOwner(patientId)
    {
        approvals[doctorId] = true;
    }
    
    function cancelApproval(address patientId, address doctorId)
        external
        onlyOwner(patientId)
    {
        approvals[doctorId] = false;
    }
    
    function getRecord(address personId, uint256 recordIndex)
        external
        view
        onlyApproved(personId)
        returns(uint, string, string)
    {
        repository.Record memory record = records[recordIndex];
        return (record.time, record.symtom, record.diagnosis);
    }
    
    function getRecordsNumber(address personId)
        external
        view
        onlyApproved(personId)
        returns(uint)
    {
        return records.length;
    }
    
    function addRecord(address doctorId, string symtom, string diagnosis)
        external
        onlyApproved(doctorId)
    {
        uint recordId = uint(keccak256(abi.encodePacked(symtom, diagnosis, doctorId)));
        records.push(repository.Record(recordId, now, symtom, diagnosis, doctorId));
    }
}