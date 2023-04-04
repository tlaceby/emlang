mod parser;

use std::fs;

fn main() {
    let code = fs::read_to_string("./test.em").unwrap();
    parser::Parser::new().produce_ast(code);
}
