import TrieMap "mo:base/TrieMap";
import Trie "mo:base/Trie";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";

import Account "Account";
import BootcampLocalActor "BootcampLocalActor";

actor MotoCoin {
    type BootcampLocalActor = BootcampLocalActor.BootcampLocalActor;
    type Result<T, E> = Result.Result<T, Text>;
    type Account = Account.Account;

    var ledger = TrieMap.TrieMap<Account, Nat>(Account.accountsEqual, Account.accountsHash);

    public shared query func name() : async Text {
        return "MotoCoin";
    };

    public shared query func symbol() : async Text {
        return "MOC";
    };

    public shared query func totalSupply() : async Nat {
        var sum : Nat = 0;
        for (key in ledger.vals()) {
            sum += key;
        };
        return sum;
    };

    public shared query func balanceOf(account : Account) : async Nat {
        let balance = ledger.get(account);

        switch (balance) {
            case (null) {
                return 0;
            };
            case (?balance) {
                return balance;
            };
        };
    };

    public shared func transfer(from : Account, to : Account, amount : Nat) : async Result<(), Text> {
        let fromBalance = ledger.get(from);
        let toBalance = ledger.get(to);

        switch (fromBalance) {
            case (null) {
                return #err("Sender does not exist");
            };
            case (?fromBalance) {
                switch (toBalance) {
                    case (null) {
                        return #err("Receiver does not exist");
                    };
                    case (?toBalance) {
                        if (fromBalance < amount) {
                            return #err("Insufficient funds");
                        } else {
                            ledger.put(from, fromBalance - amount);
                            ledger.put(to, toBalance + amount);
                            return #ok(());
                        };
                    };
                };
            };
        };
    };

    let RemoteActor = actor ("rww3b-zqaaa-aaaam-abioa-cai") : actor {
        getAllStudentsPrincipal : shared () -> async [Principal];
    };
    public shared func airdrop() : async Result<(), Text> {
        try {
            let students = await RemoteActor.getAllStudentsPrincipal();
            for (student in students.vals()) {
                var account = { owner = student; subaccount = null };
                ledger.put(account, 100);
            };

            return #ok(());
        } catch (err) {
            return #err("Remote actor not found");
        };
    };
};
