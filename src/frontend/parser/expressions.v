module parser

import frontend.ast { Expr , BinaryExpr, IdentExpr, NumberExpr, StringExpr, CallExpr, ArrayExpr, ObjectExpr, ObjectProp }

fn binary (mut parser &Parser, left Expr, bp int) Expr {
	operator := parser.prev().kind()
	right := parser.expression(bp)

	return BinaryExpr{
		operator: operator,
		left: left,
		right: right
	}
}

fn grouping (mut parser &Parser) Expr {
	expr := parser.expression(0)
	parser.expect_hint(.close_paren, "Parenthesised expression did not have closing_paren. Mismatched for opening_paren")
	return expr
}

fn fun_call (mut parser &Parser, left Expr, bp int) Expr {
	// Make sure left hand side is either a string or member expression
	if !parser.is_lvalue(left) {
		err := mk_error("Attempted to use invalid lvalue in function call.", "Function caller must be lvalue: lvalue(...args)", .bad_lvalue)
		parser.error(err)
		exit(1)
	}

	// parse comma separated list
	mut args := []Expr{}

	for parser.not_eof() && parser.current().kind() != .close_paren {
		args << parser.expression(0)

		if parser.current().kind() != .close_paren {
			parser.expect_hint(.comma, "Expected comma separated list inside call expression. Make sure each argument is separated with a single comma")
		}
	}

	parser.expect_hint(.close_paren, "Function call missing closing parenthesis")

	return CallExpr{
		caller: left,
		args: args
	}
}

fn unary (mut parser &Parser) Expr {
	operator := parser.previous.kind()
	right := parser.expression(int(Precedence.prefix))
	return ast.UnaryExpr{operator: operator, right: right}
}

fn array_literal (mut parser &Parser) Expr {
	mut array_list := []Expr{}

	for parser.not_eof() && parser.current().kind() != .close_brace {

		array_list << parser.expression(0)

		if parser.current().kind() == .close_brace {
			parser.advance()
			return ArrayExpr {
				values: array_list
			}
		}

		parser.expect_hint(.comma, "Comma required for array list literal")
	}

	parser.expect_hint(.close_brace, "Array literal missing closing brace")
	// Does not actually run code
	return ArrayExpr {
		values: array_list
	}
}

fn object_literal (mut parser &Parser) Expr {
	mut values := []ObjectProp{}

	for parser.not_eof() && parser.current().kind() != .close_bracket {
		label := parser.expect_hint(.symbol, "Object literal should contain valid identifier as key").val()

		parser.expect_hint(.colon, "Missing semicolon following label inside object literal")

		val := parser.expression(int(Precedence.logical))
		values << ObjectProp{
			value: val,
			label: label
		}

		if parser.current().kind() == .close_bracket {
			parser.advance()
			return ObjectExpr {
				values: values
			}
		}

		parser.expect_hint(.comma, "Comma seperated values required object literal")
	}

	// Does not actually run code
	return ObjectExpr {
		values: values
	}
}

fn primary (mut parser &Parser) Expr {
	tk := parser.prev()
	match tk.kind() {
		.symbol { return IdentExpr{ value: tk.val() } }
		.string { return StringExpr{ value: tk.val() } }
		.number { return NumberExpr{ value: tk.val().f64() } }
		else {
			err := mk_basic_err(.unexpected_token, "Unexpected primary expression. Was expecting a valid literal expression.")
			parser.error(err)
			exit(1)
		}
	}
}
