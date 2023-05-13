import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Type "Types";



actor StudentWall {
  type Content = Type.Content;
  type Message = Type.Message;
  type Result<T, E> = Type.Result<T, E>;
  type Order = Type.Order;

  
  var messageId : Nat = 0;
  var wall = HashMap.HashMap<Nat, Message>(1, Nat.equal, Hash.hash);

  public shared ({ caller }) func writeMessage(c : Content) : async Nat {
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

  public shared query func getMessage(messageId : Nat) : async Result<Message, Text> {
    let message : ?Message = wall.get(messageId);

    switch (message) {
      case (null) {
        return #err("The message dosen't exits");
      };
      case (?message) {
        return #ok(message);
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

  public shared func deleteMessage(messageId : Nat) : async Result<(), Text> {
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

  public shared func upVote(messageId : Nat) : async Result<(), Text> {
    let message : ?Message = wall.get(messageId);

    switch (message) {
      case (null) {
        return #err("The message dosen't exits");
      };
      case (?message) {
        let updatedMessage : Message = {
          vote = (message.vote + 1);
          content = message.content;
          creator = message.creator;
        };

        wall.put(messageId, updatedMessage);
        return #ok();
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

  public shared query func getAllMessages() : async [Message] {
    var wallBuffer = Buffer.Buffer<Message>(0);
    for (message in wall.vals()) {
      wallBuffer.add(message);
    };
    
    Debug.print(debug_show (Buffer.toArray(wallBuffer).size()));
    return Buffer.toArray(wallBuffer);
  };

  private func _getAllMessagesRanked(a : Message, b : Message) : Order {
    if(a.vote > b.vote) {
      return #less;
    } else if (a.vote < b.vote) {
      return #greater;
    } else {
      return #equal
    };
  };
  
  public shared query func getAllMessagesRanked() : async [Message] {
  let iterWall : Iter.Iter<Message> = wall.vals();
  let sortedIterWall : Iter.Iter<Message> = Iter.sort(iterWall, _getAllMessagesRanked);
  return Iter.toArray<Message>(sortedIterWall);
  };
};