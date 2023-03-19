module parser

import frontend.ast { Expr , BinaryExpr, IdentExpr, NumberExpr, StringExpr }

fn binary (mut parser &Parser, left Expr, bp int) Expr {
	operator := parser.prev().val()
	right := parser.expression(bp)

	return BinaryExpr{
		operator: operator,
		left: left,
		right: right
	}
}

fn grouping (mut parser &Parser) Expr {
	expr := parser.expression(0)
	parser.expect(.close_paren)
	return expr
}

fn primary (mut parser &Parser) Expr {
	tk := parser.prev()
	match tk.kind() {
		.symbol { return IdentExpr{ value: tk.val() } }
		.string { return StringExpr{ value: tk.val() } }
		.number { return NumberExpr{ value: tk.val().f64() } }
		else {
			println("Unknown token found")
			exit(1)
		}
	}
}
