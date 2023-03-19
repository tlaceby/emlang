module parser

import frontend.ast { Expr , BinaryExpr, IdentExpr, NumberExpr, StringExpr }

fn sum (mut parser &Parser, left Expr, bp int) Expr {
	operator := parser.advance().val()
	right := parser.expression(bp)

	return BinaryExpr{
		operator: operator,
		left: left,
		right: right
	}
}

fn primary ( mut parser &Parser) Expr {
	tk := parser.advance()

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
