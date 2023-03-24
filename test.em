fn add (x number, y number) number {
    return x + y;
}

# Passing function expressions as values
var sum = [10, 20, 30, 40].reduce(fn (prev number, current number) {
    return current + prev;
});
