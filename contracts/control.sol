pragma solidity ^0.4.25;

import "./doctor.sol";
import "./patient.sol";
import "./person.sol";
import "./repo.sol";

contract control {
    mapping (address => Patient) patients;
    mapping (address => bool) public patientExist;
    mapping (address => Doctor) doctors;
    mapping (address => bool) public doctorExist;
    
    modifier onlyPatient() {
        require(patientExist[msg.sender]);
        _;
    }
    
    modifier onlyDoctor() {
        require(doctorExist[msg.sender]);
        _;
    }
    
    function createPatient(string _name, uint8 _age, uint8 _gender)
        external
        payable
    {
        require(!patientExist[msg.sender]);
        patientExist[msg.sender] = true;
        patients[msg.sender] = new Patient(msg.sender, _name, _age, _gender);
    }
    
    function createDoctor(string _name, uint8 _age, uint8 _gender)
        external
        payable
    {
        require(!doctorExist[msg.sender]);
        doctorExist[msg.sender] = true;
        doctors[msg.sender] = new Doctor(msg.sender, _name, _age, _gender);
    }
    
    function giveApproval(address patient, address doctor)
        external
        onlyPatient()
    {
        require(doctorExist[doctor]);
        doctors[doctor].givenApproval(patient);
        patients[patient].giveApproval(patient, doctor);
    }
    
    function cancelApproval(address patient, address doctor)
        external
        onlyPatient()
    {
        require(doctorExist[doctor]);
        doctors[doctor].cancelledApproval(patient);
        patients[patient].cancelApproval(patient, doctor);
    }
    
    function getRecordNumber(address patient)
        external
        view
        onlyPatient()
        returns(uint)
    {
        require(patientExist[patient]);
        return patients[patient].getRecordsNumber(patient);
    }
    
    function getRecordNumber(address patient, address doctor)
        external
        view
        onlyDoctor()
        returns(uint)
    {
        require(patientExist[patient]);
        return patients[patient].getRecordsNumber(doctor);
    }
    
    function addRecord(address patient, address doctor, string symtom, string diagnosis)
        external
        onlyDoctor()
    {
        require(patientExist[patient]);
        patients[patient].addRecord(doctor, symtom, diagnosis);
    }
    
    function getRecord(uint recordId, address person)
        external
        view
        returns(uint, string, string)
    {
        return patients[person].getRecord(person, recordId);
    }
    
    
    function () public payable {
    }
}