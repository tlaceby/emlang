local names []string = ["Joe", "Cole", "Sabrina", "Julia", "Mark", "Kendal"];
local x number;

# Iterator style for loops
for value, index in names {
    println(value, index);
}

# Conditional Loops
while x < 10 {
    x += 1;
    println(x);
}

# Conditional Blocks
if 30 in [10, 20, 30, 40] {
    println("30 is in numbers array");
} else if 10 <= 11 {
    println("10 is less than eq to 11");
} else {
    println("This is the else case");
}
