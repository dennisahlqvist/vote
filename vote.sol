contract Vote {
  address owner;
  enum VoteTypes { NotVoted, Yes, No }
  mapping (address => VoteTypes) public votes;
  address[] public voters;
  string public question;
  DAO theDAO = DAO(0xbb9bc244d798123fde783fcc1c72d3bb8c189413);
  modifier onlyOwner() {if ( msg.sender != owner ) throw; _}
  function Vote(string _question) {
    question = _question;
    owner=msg.sender;
    votes[0x0000000000000000000000000000000000000000]=VoteTypes.NotVoted;
  }

  function voteYes() returns (bool success) {
    if(!addressInArray(msg.sender)){voters.push(msg.sender);}
    votes[msg.sender] = VoteTypes.Yes;
    return true;
  }

  function voteNo() returns (bool success) {
    if(!addressInArray(msg.sender)){voters.push(msg.sender);}
    votes[msg.sender]=VoteTypes.No;
    return true;
  }

  function removeVote() {
    if(!addressInArray(msg.sender)) throw;
    votes[msg.sender]=VoteTypes.NotVoted;
    for(uint i=0; i<voters.length;i++){
      if(voters[i]==msg.sender){
        voters[i]=0x0000000000000000000000000000000000000000;
      }
    }
  }

  function addressInArray(address inAddress) private returns (bool inArray){
    for(uint i=0; i<voters.length;i++){
      if(voters[i]==inAddress){
        return true;
      }
    }
    return false;
  }




  function results() constant returns (uint yesVotes, uint noVotes){
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



  function resultsWeightedByTokens() constant returns (uint yesVotes, uint noVotes){
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

  function resultsWeightedByEther() constant returns (uint yesVotes, uint noVotes){
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

  function kill() onlyOwner {
    suicide(owner);
  }
}
contract DAO {
    function balanceOf(address _owner) constant returns (uint256 balance);
}
