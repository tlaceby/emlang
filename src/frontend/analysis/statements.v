module analysis

import frontend.ast { BlockStmt, VarDeclarationStmt }
import term { bold, magenta, yellow, cyan }

fn (mut checker TypeChecker) block_stmt (s BlockStmt) Type {
	prev_env := checker.env as TypeEnv
	checker.env = TypeEnv{parent: prev_env}

	for stmt in s.body {
		checker.check(stmt)
	}

	checker.env = prev_env
	return Primitive{kind: .@none, name: "none" }
}

fn (mut checker TypeChecker) type_stmt (s ast.TypeStmt) Type {
	panic("Unimplimented in typechecker")
	// t := checker.type_from_typename(s.value)
	// checker.env.define_type(s.typename, t)
	// return t
}

fn (mut checker TypeChecker) var_declaration (s VarDeclarationStmt) Type {

	if s.ident in checker.env.lookup {
		hint := s.ident + " cannot be re-declared in the same scope"
		return checker.hint_error(.variable_re_declaration, hint, "Attempted to redeclare variable twice in the same scope. Did you mean to reassign the variable instead?")
	}

	rhs := checker.check(s.rhs)
	expected_type := s.assigned_type

	if expected_type == "inferred" {
		checker.env.lookup[s.ident] = rhs
		return rhs
	}

	if checker.type_impliments(rhs, checker.type_from_typename(expected_type)) {
		checker.env.lookup[s.ident] = rhs
		return rhs
	}

	part := if s.mutable { "mut" } else { "var" }
	hint := "${part} ${s.ident} ${yellow(expected_type)} -> ${magenta(rhs.name)}"
	message := "Variable declaration contains mis-matched types. Expected: ${cyan(expected_type)} but received ${yellow(rhs.name)} instead."
	return checker.hint_error(.mismatching_types, hint, message)
}
