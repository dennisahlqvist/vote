contract Vote {
  address owner;
  enum VoteTypes { NotVoted, Yes, No }
  mapping (address => VoteTypes) votes;
  address[] voted;
  string public question;
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
  function kill() {
    if (msg.sender==owner){
      suicide(owner);
    }
  }
}
