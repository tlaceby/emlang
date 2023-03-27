module parser

import frontend.parser.lexer { TokenKind }
import frontend.ast { Type, TypeNodeKind, Array, Primitive, Union, Stmt }

type TYPE_LED_FN = fn(mut parser &Parser, left Type, bp int) Type
type TYPE_NUD_FN = fn (mut parser &Parser) Type

enum TypePrecedence {
	default = int(0)
	@union
	prefix
	grouping
	primitive
}

__global (
	type_bp_lookup map[TokenKind]TypePrecedence
	type_led_lookup map[TokenKind]TYPE_LED_FN
	type_nud_lookup map[TokenKind]TYPE_NUD_FN
)



fn init_type_parser () {
	mut type_bp_lookup := map[TokenKind]TypePrecedence{}
	mut type_led_lookup := map[TokenKind]TYPE_LED_FN{}
	mut type_nud_lookup := map[TokenKind]TYPE_NUD_FN{}

	// // Primary Expressions
	type_literal(.symbol)

	type_infix(.bar, .@union, union_builder)
	type_prefix(.open_paren, .grouping, type_grouping)
	type_prefix(.open_brace, .prefix, array_builder)

	// // Complex Literals
	// prefix(.open_bracket, .prefix, object_literal)
	// prefix(.open_brace, .call, array_literal)
	//
	// // Statements
	// stmt(.open_bracket, block)
	// stmt(.@mut, variable_declaration)
	// stmt(.var, variable_declaration)
	// stmt(.@fn, fn_declaration)
	// stmt(.@if, if_stmt)
	// stmt(.@for, for_stmt)
	// stmt(.while, while_stmt)
	// stmt(.@type, type_stmt)
	//
	// stmt(.@return, return_stmt)

	$if debug {
		println(type_bp_lookup)
		println(type_led_lookup)
		println(type_nud_lookup)
	}
}

fn type_symbol (id TokenKind, bp TypePrecedence) {
	type_bp_lookup[id] = bp
}

fn type_primary (mut parser Parser) Type {
	match parser.prev().val() {
		"number" { return Primitive {value: "number"} }
		"string" { return Primitive {value: "string"} }
		"boolean" { return Primitive {value: "boolean"} }
		"any" { return Primitive {value: "any" } }
		"none" { return Primitive {value: "none"} }
		else { return Primitive { value: parser.prev().val()} }
	}
}

fn type_literal (id TokenKind) {
	type_symbol(id, .default)
	type_nud_lookup[id] = type_primary
}


fn type_infix (id TokenKind, bp TypePrecedence, led TYPE_LED_FN) {
	if !(id in type_led_lookup) {
		type_symbol(id, bp)
	}

	type_led_lookup[id] = led
}

fn type_grouping (mut parser &Parser) Type {
	expr := parser.type_expr(0)
	parser.expect_hint(.close_paren, "Parenthesised expression did not have closing_paren. Mismatched for opening_paren")
	return expr
}


fn union_builder (mut parser &Parser, left Type, bp int) Type {
	mut types := []Type{}

	types << left

	ending := [TokenKind.close_paren, .semicolon, .open_bracket, .close_bracket]
	for parser.not_eof() {
		types << parser.type_expr(bp)

		if !(parser.current().kind() in ending) {
			parser.expect(.bar)
		} else { break }
	}

	return Union {
		types: types
	}
}

fn array_builder (mut parser &Parser) Type {
	parser.expect_hint(.close_brace, "Closing bracket expected following opening for types")
	rhs := parser.type_expr(int(TypePrecedence.prefix))
	return Array{
		inner: rhs
	}
}

fn type_prefix (id TokenKind, bp TypePrecedence, nud TYPE_NUD_FN) {
	if !(id in type_led_lookup) {
		type_symbol(id, bp)
	}

	type_nud_lookup[id] = nud
}


pub fn (mut parser Parser) type_expr (rbp int) Type {
	mut tk := parser.advance()
	parser.validate_type_nud()
	mut nud := type_nud_lookup[tk.kind()]
	mut left := nud(mut parser)

	for parser.not_eof() && rbp < int(type_bp_lookup[parser.current().kind()]) {
		tk = parser.advance()

		parser.validate_type_led()
		led := type_led_lookup[tk.kind()]
		left = led(mut parser, left, int(type_bp_lookup[tk.kind()]))
	}

	return left
}

fn type_stmt (mut parser &Parser) Stmt {
	parser.advance()
	typename := parser.expect(.symbol).val()
	parser.expect(.equals)
	t := parser.type_expr(0)

	parser.expect(.semicolon)
	return ast.TypeStmt{
		typename: typename, value:t
	}
}


fn extern_stmt (mut parser &Parser) Stmt {
	parser.advance()
	func_name := parser.expect(.symbol).val()
	parser.expect_hint(.open_paren, "Missing open paren inside extern statement. Expected functions parameters")

	mut params := []Type{}
	for parser.not_eof() && parser.current().kind() != .close_paren {
		params << parser.type_expr(0)

		if parser.current().kind() == .close_paren {
			break
		}

		parser.expect(.comma)
	}

	parser.expect_hint(.close_paren, "Missing closing paren for external fn stmt")

	if parser.current().kind() == .semicolon {
		parser.expect(.semicolon)
		func_type := ast.Function{
			params: params
		}

		return ast.ExternStmt{
			func_name: func_name, func_type: func_type
		}
	}

	result := parser.type_expr(0)
	func_type := ast.Function{
		params: params, result: result
	}

	parser.expect(.semicolon)
	return ast.ExternStmt{
		func_name: func_name, func_type: func_type
	}
}
