import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Type "Types";

actor class Homework() {
  type Homework = Type.Homework;
  type Time = Type.Time;
  type Result<T, E> = Type.Result<T, E>;

  var homeworkDiary = Buffer.Buffer<Homework>(0);

  // Add a new homework task
   public shared func addHomework(homework : Homework) : async Nat {
    homeworkDiary.add(homework);
    var index : Nat = homeworkDiary.size() - 1;

    return index;
  };

  // Get a specific homework task by id
  public shared query func getHomework(homeworkId : Nat) : async Result<Homework, Text> {
    if (homeworkDiary.getOpt(homeworkId) == null) {

      return #err("The requested Homework Id is invalid");
    } else {
      let homework = homeworkDiary.get(homeworkId);

      return #ok(homework);
    };
  };

  // Update a homework task's title, description, and/or due date
  public shared func updateHomework(homeworkId : Nat, homework : Homework) : async Result<(), Text> {
    if (homeworkDiary.getOpt(homeworkId) == null) {
      return #err("The requested Homework Id is invalid");
    } else {
      homeworkDiary.put(homeworkId, homework);
      return #ok();
    };
  };

  // Mark a homework task as completed
  public shared func markAsCompleted(homeworkId : Nat) : async Result<(), Text> {
    if (homeworkDiary.getOpt(homeworkId) == null) {
      return #err("The requested Homework Id is invalid");
    } else {
      let homework = homeworkDiary.get(homeworkId);
      let updatedHomework : Homework = {
        title : Text = homework.title;
        description : Text = homework.description;
        dueDate : Time = homework.dueDate;
        completed : Bool = true;
      };
      homeworkDiary.put(homeworkId, updatedHomework);

      return #ok();
    };
  };

  // Delete a homework task by id
  public shared func deleteHomework(homeworkId : Nat) : async Result<(), Text> {
    if (homeworkDiary.getOpt(homeworkId) == null) {
      return #err("The requested Homework Id is invalid");
    } else {
      let remove = homeworkDiary.remove(homeworkId);

      return #ok();
    };
  };
  // Get the list of all homework tasks
  public shared query func getAllHomework() : async [Homework] {
    let homeworks : [Homework] = Buffer.toArray(homeworkDiary);
    return homeworks;
  };

  public shared query func getPendingHomework() : async [Homework] {
    let homeworks = Buffer.Buffer<Homework>(0);
    for(homework in homeworkDiary.vals()) {
      if(homework.completed == false) {
        homeworks.add(homework);
      };
    };
    return Buffer.toArray(homeworks);
  };

    public shared query func searchHomework(searchTerm : Text) : async [Homework] {
    let homeworks = Buffer.Buffer<Homework>(0);
    for(homework in homeworkDiary.vals()) {
      let letters : Text.Pattern = #text searchTerm;
      if(Text.contains(homework.title, letters) or Text.contains(homework.description, letters)) {
        homeworks.add(homework);
      };
    };
    return Buffer.toArray(homeworks);
  };
};