import Time "mo:base/Time";
import Result "mo:base/Result";
module {
  public type Time = Time.Time;
  public type Result<T, E> = Result.Result<T, E>;
  public type Homework = {
    title : Text;
    description : Text;
    dueDate : Time;
    completed : Bool;
  };
};