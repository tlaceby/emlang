module parser

import frontend.ast { Stmt, BlockStmt, NodeKind, VarDeclarationStmt, IdentExpr, IfStmt, ForStmt , WhileStmt }
import frontend.parser.lexer { TokenKind }
pub fn (mut parser Parser) statement () Stmt {
	tk := parser.current()

	if tk.kind() in stmt_lookup {
		return stmt_lookup[tk.kind()](mut parser)
	}

	expr := parser.expression(0)
	parser.expect(.semicolon)
	return expr
}

pub fn (mut parser Parser) block () Stmt {
	parser.expect(.open_bracket)
	mut block := []Stmt{}

	for parser.current().kind() != .close_bracket && parser.not_eof() {
		block << parser.statement()
	}

	parser.expect(.close_bracket)
	return BlockStmt{ body: block }
}

// Builder Functions


fn stmt (id TokenKind, s_fn STMT_FN) {
	symbol(id, .default)
	stmt_lookup[id] = s_fn
}

fn block (mut parser &Parser) Stmt {
	return parser.block()
}

fn for_stmt (mut parser &Parser ) Stmt {
	parser.advance()
	mut index_var_name := ""
	value_var_name := parser.expect_hint(.symbol, "Must provide the scoped variable name for the value").val()

	// Handle optional index var name
	if parser.current().kind() == .comma {
		parser.advance()
		index_var_name = parser.expect_hint(.symbol, "Expected variable identifier following comma in second position of for loop").val()
	}

	parser.expect_hint(.@in, "Following var & index identifiers expect in keyword inside for loop")
	iterable := parser.expression(0) // must contain a array valur on rhs

	disallowed_iterables := [NodeKind.binary_expr, NodeKind.number_expr, NodeKind.unary_expr, NodeKind.in_expr]
	// ensure rhs is value that is iterable
	if iterable.kind in disallowed_iterables {
		err := mk_error("Value inside for loop conditional is not iterable", "Make sure value is iterable. Cannot use current value in loop", .bad_rvalue)
		parser.error(err)
		exit(1)
	}

	block := parser.block() as BlockStmt

	return ForStmt{
		value: value_var_name,
		index: index_var_name,
		iterable: iterable,
		block: block
	}
}

fn while_stmt (mut parser &Parser ) Stmt {
	parser.advance()
	condition := parser.expression(0)
	block := parser.block() as BlockStmt

	return WhileStmt {
		condition: condition,
		block: block
	}
}

fn if_stmt (mut parser &Parser) Stmt {
	parser.advance()
	// parse out the condition
	condition := parser.expression(0)
	consequent := parser.block()

	if parser.current().kind() == .@else {
		parser.advance()
		st := parser.statement()

		return IfStmt{
			test: condition,
			consequent: consequent
			alternate: st
		}
	}


	return IfStmt{
		test: condition,
		consequent: consequent
	}
}

fn variable_declaration (mut parser &Parser) Stmt {
	mutable := parser.advance().kind() == .@mut
	identifier := parser.expect(.symbol).val()

	// Parse type inferred declaration
	if parser.current().kind() == .equals {
		parser.expect(.equals)
		rhs := parser.expression(0)
		parser.expect(.semicolon)

		return VarDeclarationStmt {
			mutable: mutable,
			ident: identifier,
			rhs: rhs
		}
	}

	declared_type := parser.type_at()

	// accept the variable declaration and eat semicolon
	if parser.current().kind() == .semicolon {
		parser.expect(.semicolon)
		return VarDeclarationStmt {
			mutable: mutable
			assigned_type: declared_type
			ident: identifier,
			rhs: IdentExpr { value: "null" }
		}
	}

	// Handle user given type as well as default value
	parser.expect(.equals)
	rhs := parser.expression(0)
	parser.expect(.semicolon)

	return VarDeclarationStmt {
		mutable: mutable
		assigned_type: declared_type
		ident: identifier,
		rhs: rhs
	}

}
