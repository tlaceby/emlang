module analysis

import frontend.ast { BlockStmt }

fn (mut checker TypeChecker) block_stmt (s BlockStmt) Type {
	for stmt in s.body {
		checker.check(stmt)
	}

	return Primitive{kind: .@none, name:"none" }
}
