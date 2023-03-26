module analysis

import frontend.ast { BlockStmt, VarDeclarationStmt }
import term { bold, magenta, yellow, cyan, bright_cyan, bright_yellow }


fn (mut checker TypeChecker) return_stmt (s ast.ReturnStmt) Type {
	return checker.check(s.rvalue)
}

fn (mut checker TypeChecker) function_declaration (s ast.FnDeclaration) Type {
	fn_name := s.name
	fn_type := checker.function_type(s.fn_type)

	mut found_return_types := []Type{}
	prev_env := checker.env
	checker.env = TypeEnv{ parent: prev_env }

	// add all params to function env
	for param in s.params {
		checker.env.lookup[param.name] = checker.type_from_ast(param.param_type)
	}

	// create a new scope for the function to live in and add the params to the function's scope
	// validate that the return type matches the mentioned type

	for stmt in s.body.body {
		match stmt {
			ast.ReturnStmt { found_return_types << checker.check(stmt.rvalue) }
			else { checker.check( stmt )} // check statement but dont check for return
		}
	}

	// Restore the environment
	checker.env = prev_env

	// check for empty array as that means the function never returns
	if found_return_types.len == 0 {
		hint := bold("${fn_type.name}")
		message := "Declaration for function `${bold(fn_name)}` returns no value. Function return type was specified as ${bold(bright_yellow(fn_type.result.name))} however function returns nothing."
		checker.hint_error(.bad_return_type, hint, message)
	}

	// check that each element in the array is the same as the expected return type
	for t in found_return_types {
		if checker.type_impliments(t, fn_type.result) == false {
			hint := bold("${fn_type.name}")
			message := "Declaration for function `${bold(fn_name)}` has a mismatching return type. Function return type specified does not match the one provided.\nExpected: ${bright_cyan(fn_type.result.name)} but function returns ${bright_yellow(t.name)} instead."
			checker.hint_error(.bad_return_type, hint, message)
		}
	}

	checker.env.lookup[fn_name] = fn_type
	return fn_type
}


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
	t := checker.type_from_ast(s.value)
	checker.env.define_type(s.typename, t)
	return t
}

fn (mut checker TypeChecker) var_declaration (s VarDeclarationStmt) Type {

	if s.ident in checker.env.lookup {
		hint := s.ident + " cannot be re-declared in the same scope"
		return checker.hint_error(.variable_re_declaration, hint, "Attempted to redeclare variable twice in the same scope. Did you mean to reassign the variable instead?")
	}

	rhs := checker.check(s.rhs)
	expected_type := checker.type_from_ast(s.assigned_type)

	// check for array literals and object literals for default empty literals and any
	// eg: [] | {}
	match s.rhs {
		ast.ArrayExpr {
			if s.rhs.values.len == 0 {
				checker.env.lookup[s.ident] = expected_type
				return expected_type
			}
		}
		ast.ObjectExpr{
			if s.rhs.values.len == 0 {
				checker.env.lookup[s.ident] = expected_type
				return expected_type
			}
		}
		else {
			// Check for any on rhs. This would
			if rhs.name == "uninitialized" {
				checker.env.lookup[s.ident] = expected_type
				return expected_type
			}
		}
	}

	if expected_type.kind == .any {
		checker.env.lookup[s.ident] = rhs
		return rhs
	}

	if checker.type_impliments(rhs, expected_type) {
		checker.env.lookup[s.ident] = rhs
		return rhs
	}

	part := if s.mutable { "mut" } else { "var" }
	hint := "${part} ${s.ident} ${yellow(expected_type.name)} -> ${magenta(rhs.name)}"
	message := "Variable declaration contains mis-matched types. Expected: ${cyan(expected_type.name)} but received ${yellow(rhs.name)} instead."
	return checker.hint_error(.mismatching_types, hint, message)
}
