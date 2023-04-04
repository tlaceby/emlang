#[derive(Debug)]
pub enum TokenKind {
    EndOfFile,
    Numeric(f64),
    // String(String),
    Identifier(String),

    // Grouping
    OpenParen,
    CloseParen,
    // OpenBracket,
    // CloseBracket,
    // OpenBrace,
    // CloseBrace,

    // // Keywords
    // Var,
    // Mut,
    // Fn,
    // Break,
    // Continue,
    // Return,
    // Pub,
    // Import,
    // And,
    // Or,
    // If,
    // Else,
    // For,
    // While,

    // Binary Operators
    Plus,
    PlusEquals,
    // Minus,
    // Star,
    // Slash,
    // Percent,
    // Comparison
    // Less,
    // LessEq,
    // Greater,
    // GreaterEq,
    // NotEq,
    // IsEqual,

    // // Other
    // Equals,
    // Dot,
    // Comma,
    // Colon,
    // Semicolon,
    // Question,
    // Bang,
}

#[derive(Debug)]
pub struct TkPosition {
    pub line: usize,
    pub offset: usize,
    pub length: usize,
}

impl TkPosition {
    pub fn new(line: usize, offset: usize, length: usize) -> Self {
        return Self {
            line,
            offset,
            length,
        };
    }
}

#[derive(Debug)]
pub struct Token {
    pub location: TkPosition,
    pub kind: TokenKind,
}
