module ast

pub struct BlockStmt {
pub:
	kind NodeKind = .block_stmt
	body []Stmt
}

pub struct VarDeclarationStmt {
pub:
	kind NodeKind = .var_declaration
	local bool // whether its local or global
	ident string
	rhs   Expr
}
