//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFound {
    struct Project {
        string name;
        string description;
        address payable founder;
        uint funds;
        uint goal;
        string state;
    }
    Project public project;

    event financedProject (address contributor, uint amount);
    event modifiedProject (address modifiers, string status);

    constructor(string memory _name, string memory _description, uint _goal){
        project = Project(_name, _description, payable(msg.sender), 0, _goal, "Opened");
    }

    modifier excluyeFounder(){
        require(project.founder != msg.sender , "The founder cannot invest here");
        _;
    }

    modifier onlyFounder(){
        require(project.founder == msg.sender , "Only Founder can modifier state Project");
        _;
    }

    function fundProject() public payable excluyeFounder{
        project.founder.transfer(msg.value);
        project.funds = project.funds + msg.value;
        emit financedProject (msg.sender, msg.value);
    }

    function changeProjectState(string calldata newState ) public onlyFounder{
        project.state = newState;
        emit modifiedProject(msg.sender, project.state);
    }
}