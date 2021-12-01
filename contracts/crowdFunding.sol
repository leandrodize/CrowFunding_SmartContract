//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFound {
    string public name;
    string public description;
    address payable public founder;
    uint public funds;
    uint public goal;
    string public state = "Opened";

    event financedProject (address contributor, uint amount);
    event modifiedProject (address modifiers, string status);

    constructor(string memory _name, string memory _description, uint _goal){
        name = _name;
        description = _description;
        goal = _goal;
        founder = payable(msg.sender);
    }
    modifier excluyeFounder(){
        require(founder != msg.sender , "The founder cannot invest here");
        _;
    }
    modifier onlyFounder(){
        require(founder == msg.sender , "Only Founder can modifier state Project");
        _;
    }
    function fundProject() public payable excluyeFounder{
        founder.transfer(msg.value);
        funds = funds + msg.value;
        emit financedProject (msg.sender, msg.value);
    }
    function changeProjectState(string calldata newState ) public onlyFounder{
        state = newState;
        emit modifiedProject(msg.sender, state);
    }
}