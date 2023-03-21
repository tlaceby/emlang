module parser

import frontend.ast { Expr , BinaryExpr, IdentExpr, NumberExpr, StringExpr }

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

fn unary (mut parser &Parser) Expr {
	operator := parser.previous.kind()
	right := parser.expression(int(Precedence.prefix))
	return ast.UnaryExpr{operator: operator, right: right}
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
