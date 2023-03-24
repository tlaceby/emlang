module analysis

import frontend.ast { BlockStmt }

fn (mut checker TypeChecker) block_stmt (s BlockStmt) {
	for stmt in s.body {
		checker.check_stmt(stmt)
	}
}
