import Float "mo:base/Float";
actor Calculator {
  // Define a mutable variable called counter of type Float that will be used to store the result of the most recent calculation.
  stable var counter : Float = 0;
  // Implement add, which accepts a value x of type Float and performs addition.
  public shared func add(x : Float) : async Float {
    counter += x;
    return counter;
  };
  // Implement sub, which accepts a value x of type Float and performs subtraction.
  public shared func sub(x : Float) : async Float {
    counter -= x;
    return counter;
  };
  // Implement mul, which accepts a value x of type Float and performs multiplication.
  public shared func mul(x : Float) : async Float {
    counter := counter * x;
    return counter;
  };
  // Implement div, which accepts a value x of type Float and performs division. Make sure to guard against division by 0.
  public shared func div(x : Float) : async Float {
    if (x != 0) {
      counter := counter / x;
    };
    return counter;
  };
  // Implement reset, which reset the value of counter by setting its value to zero.
  public shared func reset() : async Float {
    counter := 0;
    return counter;
  };
  // Implement a query function see that returns the value of counter
  public shared query func see() : async Float {
    return counter;
  };
  //Implement power, which accepts a value x of type Float and returns the value of counter to the power of x.
  public shared func power(x : Float) : async Float {
    counter := Float.pow(counter, x);
    return counter;
  };
  //Implement sqrt, which returns the square root of counter.
  public shared func sqrt() : async Float {
    counter := Float.sqrt(counter);
    return counter;
  };
  //Implement floor, which returns the largest integer less than or equal to counter.
  public shared func floor() : async Int{
    var counterInt : Int = Float.toInt(Float.floor(counter));
    counter := Float.fromInt(counterInt);
    return counterInt;
  };
  //Deploy the Calculator on the Internet Computer.
};