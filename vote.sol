contract Vote {
  address owner;
  enum VoteTypes { NotVoted, Yes, No }
  mapping (address => VoteTypes) votes;
  address[] voted;
  string public question;
  DAO theDAO = DAO(0xbb9bc244d798123fde783fcc1c72d3bb8c189413);
  function Vote(string _question) {
    question = _question;
    owner=msg.sender;
    votes[0x0000000000000000000000000000000000000000]=VoteTypes.NotVoted;
  }

  function voteYes() returns (bool success) {
    if(!addressInArray(msg.sender)){voted.push(msg.sender);}
    votes[msg.sender] = VoteTypes.Yes;
    return true;
  }

  function voteNo() returns (bool success) {
    if(!addressInArray(msg.sender)){voted.push(msg.sender);}
    votes[msg.sender]=VoteTypes.No;
    return true;
  }

  function removeVote() {
    if(!addressInArray(msg.sender)) throw;
    votes[msg.sender]=VoteTypes.NotVoted;
    for(uint i=0; i<voted.length;i++){
      if(voted[i]==msg.sender){
        voted[i]=0x0000000000000000000000000000000000000000;
      }
    }
  }

  function addressInArray(address inAddress) private returns (bool inArray){
    for(uint i=0; i<voted.length;i++){
      if(voted[i]==inAddress){
        return true;
      }
    }
    return false;
  }

  function countYesVotes() constant returns (uint yesVotes){
    uint _yesVotes = 0;
    for(uint i=0; i<voted.length;i++){
      if(votes[voted[i]]==VoteTypes.Yes){
        _yesVotes++;
      }
    }
    return _yesVotes;
  }

  function countNoVotes() constant returns (uint noVotes){
    uint _noVotes = 0;
    for(uint i=0; i<voted.length;i++){
      if(votes[voted[i]]==VoteTypes.No){
        _noVotes++;
      }
    }
    return _noVotes;
  }
  

  function countYesVotesWeightedByTokens() constant returns (uint yesVotesWeightedByTokens){
    uint _yesVotes = 0;
    for(uint i=0; i<voted.length;i++){
      if(votes[voted[i]]==VoteTypes.Yes){
        _yesVotes = _yesVotes + theDAO.balanceOf(voted[i]);
      }
    }
    return _yesVotes;
  }

  function countNoVotesWeightedByTokens() constant returns (uint noVotesWeightedByTokens){
    uint _noVotes = 0;
    for(uint i=0; i<voted.length;i++){
      if(votes[voted[i]]==VoteTypes.No){
        _noVotes = _noVotes + theDAO.balanceOf(voted[i]);
      }
    }
    return _noVotes;
  }

  function kill() {
    if (msg.sender==owner){
      suicide(owner);
    }
  }
}
contract DAO {
    function balanceOf(address _owner) constant returns (uint256 balance);
}
