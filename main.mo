actor {
  public type Result<T, E> = Result.Result<T, E>;
  public type Content = {
    #Text : Text;
    #Image : Blob;
    #Video : Blob;
  };
  public type Message = {
    vote : Int;
    content : Content;
    creator : Principal;
  };
  var messageId : Nat = 0;
  var wall = HashMap.HashMap<Nat, Message>(1, Nat.equal, Hash.hash);

  public shared ({ caller }) func writeMessage(c : Content) : async Nat {
    Debug.print(debug_show (messageId));
    var id : Nat = messageId;

    let message : Message = {
      vote = 0;
      content = c;
      creator = caller;
    };

    wall.put(messageId, message);
    messageId += 1;
    return id;
  };

  public shared query func getMessage(messageId : Nat) : async Result<?Message, Text> {
    let message : ?Message = wall.get(messageId);

    switch (message) {
      case (null) {
        return #err("The message dosen't exits");
      };
      case (?message) {
        return #ok(?message);
      };
    };
  };

  public shared ({ caller }) func updateMessage(messageId : Nat, c : Content) : async Result<(), Text> {
    let message : ?Message = wall.get(messageId);

    switch (message) {
      case (null) {
        return #err("The message dosen't exits");
      };
      case (?message) {
        if (Principal.equal(message.creator, caller)) {
          let updatedMessage : Message = {
            vote = message.vote;
            content = c;
            creator = message.creator;
          };

          wall.put(messageId, updatedMessage);
          return #ok();
        } else {
          return #err("You are not the creator of this message");
        };
      };
    };
  };

  public shared func deleteMessage(meessageId : Nat) : async Result<(), Text> {
    let message : ?Message = wall.get(messageId);

    switch (message) {
      case (null) {
        return #err("The message dosen't exits");
      };
      case (?message) {
        wall.delete(messageId);
        return #ok();
      };
    };
  };
};
    };
  };

  public shared func downVote(messageId : Nat) : async Result<(), Text> {
    let message : ?Message = wall.get(messageId);

    switch (message) {
      case (null) {
        return #err("The message dosen't exits");
      };
      case (?message) {
        let updatedMessage : Message = {
          vote = (message.vote - 1);
          content = message.content;
          creator = message.creator;
        };

        wall.put(messageId, updatedMessage);
        return #ok();
      };
    };
  };
};
