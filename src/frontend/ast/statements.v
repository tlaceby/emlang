module ast

pub struct BlockStmt {
	kind NodeKind = .block_stmt
	body []Stmt
}
