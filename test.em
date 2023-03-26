type NumberOrString = number | string;
fn tuple (x NumStr, y NumStr) []NumStr {
    return [x, y];
}

fn add (x number, y number) number {
    return x + y;
}

var x = 45.21 + add(10,20);
var y = x /2;

var tuple_maker = tuple;
var elements = tuple_maker(x, y);
