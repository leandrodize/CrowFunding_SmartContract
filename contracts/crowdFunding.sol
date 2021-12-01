//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFound {
    enum FundrasingState {
        Open, 
        Close
    }

    struct Project {
        string name;
        string description;
        address payable founder;
        uint funds;
        uint goal;
        FundrasingState state;
    }
    
    Project public project;

    event financedProject (address contributor, uint amount);
    event modifiedProject (address modifiers, FundrasingState status);

    constructor(string memory _name, string memory _description, uint _goal){
        project = Project(_name, _description, payable(msg.sender), 0, _goal, FundrasingState.Open);
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
        require(project.state == FundrasingState.Open, "The project can not receive funds");
        project.founder.transfer(msg.value);
        project.funds = project.funds + msg.value;
        emit financedProject (msg.sender, msg.value);
    }

    function changeProjectState(FundrasingState newState ) public onlyFounder{
        project.state = newState;
        emit modifiedProject(msg.sender, project.state);
    }
}