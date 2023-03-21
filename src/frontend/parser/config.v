module parser

import frontend.ast { Expr, Stmt }
import frontend.parser.lexer { Token, TokenKind,  }

type LED_FN = fn(mut parser &Parser, left Expr, bp int) Expr
type NUD_FN = fn (mut parser &Parser) Expr

type STMT_FN = fn (mut parser &Parser) Stmt

enum Precedence {
	default = int(0)
	assignment = 1
	conditional
	logical
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
	stmt_lookup map[TokenKind]STMT_FN
	nud_lookup map[TokenKind]NUD_FN
)



fn init () {
	mut bp_lookup := map[TokenKind]Precedence{}
	mut led_lookup := map[TokenKind]LED_FN{}
	mut stmt_lookup := map[TokenKind]STMT_FN{}
	mut nud_lookup := map[TokenKind]NUD_FN{}

	// Primary Expressions
	literal(.symbol)
	literal(.number)
	literal(.string)

	// Logical
	infix(.is_equals, .logical, binary)
	infix(.not_equals, .logical, binary)
	infix(.less, .logical, binary)
	infix(.less_eq, .logical, binary)
	infix(.greater, .logical, binary)
	infix(.greater_eq, .logical, binary)

	// Conditional
	infix(.and, .conditional, binary)
	infix(.@or, .conditional, binary)

	// Sum
	infix(.plus, .sum, binary)
	infix(.minus, .sum, binary)

	// Product
	infix(.star, .product, binary)
	infix(.slash, .product, binary)
	infix(.percent, .product, binary)

	// Unary
	prefix(.plus, .prefix, unary)
	prefix(.minus, .prefix, unary)
	prefix(.not, .prefix, unary)
	prefix(.open_paren, .call, grouping)

	infix(.open_paren, .call, fun_call)

	// Statements
	stmt(.open_bracket, block)
	stmt(.global, variable_declaration)
	stmt(.local, variable_declaration)

	$if debug {
		println(bp_lookup)
		println(led_lookup)
		println(stmt_lookup)
		println(nud_lookup)
	}

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
