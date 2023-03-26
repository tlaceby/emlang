type num = number;
type str = string;
type NumStr = str | num;

fn tuple (x NumStr, y NumStr) []NumStr {
    return [x, y];
}

fn add (x number, y num) number {
    return x + y;
}

var foo = tuple(add(1.234, 43), "32");
