contract Vote {
  address owner;
  function Vote() {
    owner=msg.sender;

  }
  function kill() {
    if (msg.sender==owner){
      suicide(owner);
    }
  }
}
