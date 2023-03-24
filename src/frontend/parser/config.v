module parser

import frontend.ast { Expr, Stmt }
import frontend.parser.lexer { TokenKind }

type LED_FN = fn(mut parser &Parser, left Expr, bp int) Expr
type NUD_FN = fn (mut parser &Parser) Expr

type STMT_FN = fn (mut parser &Parser) Stmt

enum Precedence {
	default = int(0)
	assignment = 1
	logical
	comparison
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

	// Assignments
	infix(.equals, .assignment, assignment)
	// Complex Assignment
	infix(.plus_eq, .assignment, assignment)
	infix(.minus_eq, .assignment, assignment)
	infix(.star_eq, .assignment, assignment)
	infix(.slash_eq, .assignment, assignment)

	// Logical
	infix(.is_equals, .comparison, binary)
	infix(.not_equals, .comparison, binary)
	infix(.less, .comparison, binary)
	infix(.less_eq, .comparison, binary)
	infix(.greater, .comparison, binary)
	infix(.greater_eq, .comparison, binary)

	infix(.@in, .logical, in_expression)

	// Conditional
	infix(.and, .logical, binary)
	infix(.@or, .logical, binary)

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
	infix(.open_brace, .call, member_expr)
	infix(.dot, .call, member_expr)

	// Complex Literals
	prefix(.open_bracket, .prefix, object_literal)
	prefix(.open_brace, .call, array_literal)

	// Statements
	stmt(.open_bracket, block)
	stmt(.@mut, variable_declaration)
	stmt(.var, variable_declaration)
	stmt(.@if, if_stmt)
	stmt(.@for, for_stmt)
	stmt(.while, while_stmt)

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
