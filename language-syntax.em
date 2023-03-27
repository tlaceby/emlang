module main;

# Use with caution as this will make the type-checker thing these exist.
extern  println (any)      void;
extern  print   (any)      void;
extern  typeof  (any)      string;
extern  equals  (any,any)  boolean;
extern  as_str  (any)      string;
extern  as_num  (any)      number;
extern  as_bool (any)      boolean;
extern  exit    (number)   void;

# Demo of imports from std
import math;
import random;
import fs;

# importing other em code
import other from "../other";
import foo   from "../lib/foo";

# Exporting some basic math functions
pub fn add (x number, y number) number { return x + y; }
pub fn sub (x number, y number) number { return x - y; }
pub fn mul (x number, y number) number { return x * y; }
pub fn div (x number, y number) number { return x / y; }

# Define a few types
type NumStr = number | string;
type Location = { x number, y number }
type Person = {
    name string,
    age  number,
    birthday fn ()void,
    location: Location
}

# Control Flow
var rnd number = math.random();
if rnd < 100 {
    println("less than 100");
} else if math.random() == 7 {
    println("Lucky");
} else {
    println("Quitting the program");
    exit(1);
}

match typeof(rnd) {
    "number" {
        println("Number");
    }
    else {
        println("This should have been a number!");
    }
}

# Loops
for num, index in array.generate_numbers(100) {
    println ("Current number is {} at index {}".format(number, index));
}


while time.hour() != 12 {
    println("Still not noon!");
}

# Literals

# Creating objects is easy
var person Person = {
    name: "Tyler",
    age: 22,
    birthday: fn () {
        println("Happy birthday");
    },
    location: {
        x: -12.03,
        y: 10232.383
    }
};

# so is creating array literals

mut numbers_and_strings []NumStr = ["Hello world", 21.33, "Foo", 32.4, -23, "Baz"];
numbers_and_strings.push(10);
numbers_and_strings.push("Baz");

# In Expressions
if "Foo" in numbers_and_strings {
    println("Foo exists in array");
}
