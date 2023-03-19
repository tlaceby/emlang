module parser

import frontend.ast { Expr, BinaryExpr, NumberExpr, Stmt }
import frontend.parser.lexer { Token, TokenKind,  }

type LED_FN = fn(mut parser &Parser, left Expr, bp int) Expr
type NUD_FN = fn (mut parser &Parser) Expr

enum Precedence {
	default = int(0)
	assignment = 1
	conditional
	sum
	product
	exponent
	prefix
	postfix
	call
	primary = 10
}

__global (
	bp_lookup map[TokenKind]Precedence
	led_lookup map[TokenKind]LED_FN
	nud_lookup map[TokenKind]NUD_FN
)



fn init () {
	mut bp_lookup := map[TokenKind]Precedence{}
	mut led_lookup := map[TokenKind]LED_FN{}
	mut nud_lookup := map[TokenKind]NUD_FN{}

	// Primary Expressions
	literal(.symbol)
	literal(.number)
	literal(.string)

	// Binary Expressions
	infix(.plus, .sum, binary)
	infix(.minus, .sum, binary)
	infix(.star, .product, binary)
	infix(.slash, .product, binary)

	prefix(.open_paren, .call, grouping)
}

fn symbol (id TokenKind, bp Precedence) {
	bp_lookup[id] = bp
}

fn literal (id TokenKind) {
	symbol(id, .default)
	nud_lookup[id] = primary
}


fn infix (id TokenKind, bp Precedence, led LED_FN) {
	if !(id in led_lookup) {
		symbol(id, bp)
	}

	led_lookup[id] = led
}

fn prefix (id TokenKind, bp Precedence, nud NUD_FN) {
	if !(id in led_lookup) {
		symbol(id, bp)
	}

	nud_lookup[id] = nud
}
