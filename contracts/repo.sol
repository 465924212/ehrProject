pragma solidity ^0.4.25;


contract repository {
    struct Record {
        uint256 id;
        uint256 time;
        string symtom;
        string diagnosis;
        address signature;
    }
}