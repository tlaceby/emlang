module parser

import frontend.ast { Expr, Primitive, NodeKind, MemberExpr, AssignmentExpr , FnExpr, FnParam, InExpr , BinaryExpr, IdentExpr, NumberExpr, StringExpr, CallExpr, ArrayExpr, ObjectExpr, ObjectProp, BlockStmt }
import term

fn binary (mut parser &Parser, left Expr, bp int) Expr {
	operator := parser.prev().kind()
	right := parser.expression(bp)

	return BinaryExpr{
		operator: operator,
		left: left,
		right: right
	}
}

fn assignment (mut parser &Parser, lvalue Expr, bp int) Expr {
	assignment_kind := parser.previous.kind()
	// check valid l_value
	valid_lvalues := [NodeKind.ident_expr, .member_expr]
	if !(lvalue.kind in valid_lvalues) {
		err := mk_error("Bad lvalue provided inside assignment expression. Received: ${term.bright_magenta(lvalue.kind.str())}", "lvalue must be an assignable type such as identifier or member expression", .bad_lvalue)
		parser.error(err)
		exit(1)
	}

	rvalue := parser.expression(bp)

	return AssignmentExpr{
		operator: assignment_kind
		lvalue: lvalue,
		rvalue: rvalue
	}
}

fn in_expression (mut parser &Parser, left Expr, bp int) Expr {
	allowed_lhs := [NodeKind.string_expr, .call_expr, .ident_expr, .number_expr, .array_literal, .object_literal, .member_expr, .binary_expr]
	if !(left.kind in allowed_lhs) {
		msg := mk_basic_err(.bad_lvalue, "Invalid lvalue for in expression: ${left.kind}")
		parser.error(msg)
		exit(1)
	}

	rhs := parser.expression(bp)

	return InExpr{
		lhs: left,
		rhs: rhs
	}
}

fn fn_expression (mut parser &Parser) Expr {
	parser.expect(.open_paren)
	mut params_list := []FnParam{}

	for parser.not_eof() && parser.current().kind() != .close_paren {
		param_name := parser.expect(.symbol).val()

		// Validate token is not a comma and a type
		if parser.current().kind() == .comma {
			err := mk_basic_err(.unexpected_token, "Missing parameter type inside lambda function expression.")
			parser.error(err)
			exit(1)
		}

		declared_type := parser.type_expr(0)

		if parser.current().kind() != .close_paren {
			parser.expect(.comma)
		}

		params_list << FnParam{
			name: param_name,
			param_type: declared_type
		}
	}

	parser.expect(.close_paren)
	mut return_type := Primitive{ value: "none" }

	// Check for block open. If it is not there then a return type was passed
	if parser.current().kind() != .open_bracket {
		return_type = parser.type_expr(0) as ast.Primitive
	}

	body := parser.block() as BlockStmt

	return FnExpr {
		params: params_list,
		returns: return_type,
		body: body,
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
		args << parser.expression(bp)

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

fn member_expr (mut parser &Parser, left Expr, bp int) Expr {
	computed := parser.prev().kind() == .open_brace

	if computed {
		right := parser.expression(0)
		println(right)
		println(parser.current().kind())
		parser.expect_hint(.close_brace, "Expected closing brace for member expression that is computed ex: foo['bar']")
		return MemberExpr {
			computed: computed,
			lhs: left
			rhs: right
		}
	}

	right := parser.expression(bp)
	return MemberExpr {
		computed: false,
		lhs: left
		rhs: right
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
