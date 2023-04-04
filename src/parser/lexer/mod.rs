mod tokens;
use std::error::Error;

pub use tokens::*;

enum ErrorKind {
    UnknownCharacter,
    InvalidNumber,
    InvalidIdentifier,
    UnexpectedEOF,
}

struct LexicalError {
    pub kind: ErrorKind,
    pub line: usize,
    pub offset: usize,

    pub message: String,
}

impl LexicalError {
    pub fn new(kind: ErrorKind, line: usize, offset: usize, message: String) -> Self {
        return Self {
            kind,
            line,
            offset,
            message,
        };
    }
}

pub struct Lexer {
    tokens: Vec<Token>,
    source: String,

    // File Location
    line: usize,
    offset: usize,
    position: usize,

    // Error handling
    errors: Vec<LexicalError>,
}

impl Lexer {
    pub fn new(contents: String) -> Self {
        return Self {
            tokens: vec![],
            errors: vec![],
            source: contents,
            line: 0,
            offset: 0,
            position: 0,
        };
    }

    pub fn tokenize(mut self) -> Vec<Token> {
        self.init();

        // Iterate through each character inside source file and build tokens
        while self.not_eof() {
            match self.at() {
                b'\n' => self.new_line(),
                b' ' => self.next(),

                // Handle Grouping Operators & Symbols

                // Handle Comparison & Logical Operators

                // Handle Arithmatic Operators
                b'+' => {
                    if self.peak() == b'=' {
                        // Produce += token
                        self.next();
                        self.token(TokenKind::PlusEquals, 2);
                        continue;
                    } else {
                        self.token(TokenKind::Plus, 1);
                    }
                }
                _ => {
                    self.build_error(
                        ErrorKind::UnknownCharacter,
                        format!("Unexpected character found in source file: {}", self.at()),
                    );

                    self.next()
                }
            }
        }

        // Add final EOF token then return created tokens
        return self.tokens;
    }
}

impl Lexer {
    fn init(&mut self) {
        self.line = 0;
        self.offset = 0;
        self.position = 0;
        self.tokens = vec![];
    }

    fn build_error(&mut self, kind: ErrorKind, message: String) {
        self.errors
            .push(LexicalError::new(kind, self.line, self.offset, message));
    }
}

// Utilities
impl Lexer {
    fn not_eof(&self) -> bool {
        self.position < self.source.len()
    }

    fn at(&self) -> u8 {
        return self.source.as_bytes()[self.position];
    }

    fn next(&mut self) -> u8 {
        let previous = self.at();
        self.position += 1;
        return previous;
    }

    fn new_line(&mut self) -> u8 {
        self.line += 1;
        self.position += 1;
        self.offset = 0;

        return self.at();
    }

    fn peak(&self) -> u8 {
        // TODO: Bounds Check
        return self.source.as_bytes()[self.position + 1];
    }
}

// Token Construction Methods
impl Lexer {
    fn token(&mut self, kind: TokenKind, length: usize) -> u8 {
        let location = tokens::TkPosition::new(self.line, self.offset, length);
        self.tokens.push(tokens::Token { location, kind });

        return self.at();
    }
}
