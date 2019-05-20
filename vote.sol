pragma solidity 0.4.25;
contract Vote {
  address owner;
  enum VoteTypes { NotVoted, Yes, No }
  mapping (address => VoteTypes) public votes;
  address[] public voters;
  string public question;
  ERC20 theDAO = ERC20(0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413);
  modifier onlyOwner() {require( msg.sender == owner ); _;}



  constructor(string _question) public{
    question = _question;
    owner=msg.sender;
    votes[0x0000000000000000000000000000000000000000]=VoteTypes.NotVoted;
  }

  function voteYes() public returns (bool success) {
    if(!addressInArray(msg.sender)){voters.push(msg.sender);}
    votes[msg.sender] = VoteTypes.Yes;
    return true;
  }

  function voteNo() public returns (bool success) {
    if(!addressInArray(msg.sender)){voters.push(msg.sender);}
    votes[msg.sender]=VoteTypes.No;
    return true;
  }

  function removeVote() public {
    require (addressInArray(msg.sender));
    votes[msg.sender]=VoteTypes.NotVoted;
    for(uint i=0; i<voters.length;i++){
      if(voters[i]==msg.sender){
        voters[i]=0x0000000000000000000000000000000000000000;
      }
    }
  }




  function results() public view returns (uint yesVotes, uint noVotes){
    uint _yesVotes = 0;
    uint _noVotes = 0;
    for(uint i=0; i<voters.length;i++){
      if(votes[voters[i]]==VoteTypes.No){
        _noVotes++;
      }
      if(votes[voters[i]]==VoteTypes.Yes){
        _yesVotes++;
      }
    }
    return ( _yesVotes, _noVotes );
  }



  function resultsWeightedByTokens() public view returns (uint yesVotes, uint noVotes){
    uint _yesVotes = 0;
    uint _noVotes = 0;
    for(uint i=0; i<voters.length;i++){
      if(votes[voters[i]]==VoteTypes.No){
        _noVotes = _noVotes + theDAO.balanceOf(voters[i]);
      }
      if(votes[voters[i]]==VoteTypes.Yes){
        _yesVotes = _yesVotes + theDAO.balanceOf(voters[i]);
      }
    }
    return ( _yesVotes, _noVotes );
  }

  function resultsWeightedByEther() public view returns (uint yesVotes, uint noVotes){
    uint _yesVotes = 0;
    uint _noVotes = 0;
    for(uint i=0; i<voters.length;i++){
      if(votes[voters[i]]==VoteTypes.No){
        _noVotes = _noVotes + voters[i].balance;
      }
      if(votes[voters[i]]==VoteTypes.Yes){
        _yesVotes = _yesVotes + voters[i].balance;
      }
    }
    return ( _yesVotes, _noVotes );
  }

  function kill() public onlyOwner {
    selfdestruct(owner);
  }

  function addressInArray(address inAddress) private view returns (bool inArray){
    for(uint i=0; i<voters.length;i++){
      if(voters[i]==inAddress){
        return true;
      }
    }
    return false;
  }
}

contract ERC20 {
    function balanceOf(address tokenOwner) public view returns (uint balance);
}
