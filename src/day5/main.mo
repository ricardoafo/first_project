import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Bool "mo:base/Bool";
import Array "mo:base/Array";

import Type "Types";
import Ic "Ic";

actor Verifier {

    type StudentProfile = Type.StudentProfile;
    type Result<T, E> = Type.Result<T, E>;
    type TestResult = Type.TestResult;
    type TestError = Type.TestError;

    var studentProfileStore = HashMap.HashMap<Principal, StudentProfile>(0, Principal.equal, Principal.hash);
    let data1 : StudentProfile = {
        name = "Eda";
        team = "Dolphins";
        graduate = true;
    };
    //Testing data
    //let caller1 : Principal = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
    //studentProfileStore.put(caller1, data1);

    public shared ({ caller }) func addMyProfile(profile : StudentProfile) : async Result<(), Text> {
        let callerIsAnonymous : Bool = Principal.isAnonymous(caller);

        if (callerIsAnonymous) {

            return #err("You have to be login to create a profile");
        } else if (studentProfileStore.get(caller) != null) {

            return #err("You already have a profile");
        } else {

            studentProfileStore.put(caller, profile);
            return #ok();
        };
    };

    public shared query func seeAProfile(p : Principal) : async Result<StudentProfile, Text> {
        let profile = studentProfileStore.get(p);

        switch (profile) {
            case (null) {

                return #err("That student profile dosen't exits");
            };
            case (?profile) {

                return #ok(profile);
            };
        };
    };

    public shared func updateMyProfile(p : Principal, profile : StudentProfile) : async Result<StudentProfile, Text> {
        let profile = studentProfileStore.get(p);
        switch (profile) {
            case (null) {

                return #err("That student profile dosen't exits");
            };
            case (?profile) {
                studentProfileStore.put(p, profile);

                return #ok(profile);
            };
        };
    };

    public shared func deleteMyProfile(p : Principal) : async Result<(), Text> {
        let profile = studentProfileStore.get(p);
        switch (profile) {
            case (null) {

                return #err("That student profile dosen't exits");
            };
            case (?profile) {
                studentProfileStore.delete(p);

                return #ok();
            };
        };
    };

    public shared func test(canisterId : Principal) : async TestResult {
        let calculatorInterface = actor (Principal.toText(canisterId)) : actor {
            reset : shared () -> async Int;
            add : shared (x : Nat) -> async Int;
            sub : shared (x : Nat) -> async Int;
        };

        try {
            let x1 : Int = await calculatorInterface.reset();
            if (x1 != 0) {
                return #err(#UnexpectedValue("After a reset, counter should be 0!"));
            };

            let x2 : Int = await calculatorInterface.add(2);
            if (x2 != 2) {
                return #err(#UnexpectedValue("After 0 + 2, counter should be 2!"));
            };

            let x3 : Int = await calculatorInterface.sub(2);
            if (x3 != 0) {
                return #err(#UnexpectedValue("After 2 - 2, counter should be 0!"));
            };

            return #ok();
        } catch (e) {
            return #err(#UnexpectedError("Something went wrong!"));
        };
    };

    public shared func verifyOwnership(canisterId : Principal, p : Principal) : async Bool {
    try {
      let controllers = await Ic.getCanisterControllers(canisterId);

      var isOwner : ?Principal = Array.find<Principal>(controllers, func prin = prin == p);
      
      if (isOwner != null) {
        return true;
      };

      return false;
    } catch (e) {
      return false;
    };
  };

  public shared ({ caller }) func verifyWork(canisterId : Principal, p : Principal) : async Result<(), Text> {
    try {
      let isApproved = await test(canisterId); 

      if (isApproved != #ok) {
        return #err("The current work has no passed the tests");
      };

      let isOwner = await verifyOwnership(canisterId, p); 

      if (not isOwner) {
        return #err ("The received work owner does not match with the received principal");
      };

      var profile : ?StudentProfile = studentProfileStore.get(p);

      switch (profile) {
        case null { 
          return #err("The received principal does not belongs to a registered student");
        };

        case (?profile) {
          var updatedStudent = {
            name = profile.name;
            graduate = true;
            team = profile.team;
          };

          ignore studentProfileStore.replace(p, updatedStudent);
          return #ok ();      
        }
      };
    } catch(e) {
      return #err("Cannot verify the project");
    }
  };
};