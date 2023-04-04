mod lexer;

pub struct Parser {
    tokens: Vec<lexer::Token>,
    position: usize,
}

impl Parser {
    pub fn new() -> Self {
        return Self {
            tokens: vec![],
            position: 0,
        };
    }

    pub fn produce_ast(mut self, contents: String) -> () {
        let mut lex = lexer::Lexer::new(contents);
        self.tokens = lex.tokenize();

        for token in self.tokens {
            println!("{:?}", token);
        }
    }
}
