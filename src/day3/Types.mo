import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Order "mo:base/Order";
module Types {
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
  public type Order = Order.Order;
};
