# Variable Scopes
local foo = 45;                 # only in the current local scope
local name string;              # If the variable is typed then the value does not need to be initialized
global bar = "Hello world";     # does not matter where declared is hoisted to global scope

# Functions & Declaring types
fn as_list (x number, y number) (number, number) []number {
    return [x, y];
}

type Color = "red" | "blue" | "green";
interface Person {
   name         Str,
   age          Str,
   fav_color    Color
};

global numbers []number = [10, 20, 30];

local tyler Person = {
    age: 22, name: "Tyler", fav_color: "green"
};
