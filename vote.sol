contract Vote {
  address owner;
  enum VoteTypes { Yes, No }
  mapping (address => VoteTypes) votes;
  address[] voted;
  function Vote() {
    owner=msg.sender;
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
