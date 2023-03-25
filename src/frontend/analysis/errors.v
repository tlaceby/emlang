module analysis

import term

enum ErrorKind {
	mismatching_types
	variable_re_declaration
	undefined_identifier
	unknown_ast
	invalid_operation
}

struct TypeError {
	message string  [required]
	kind ErrorKind  [required]
	hint string
}

pub fn (err TypeError) display () {
	header := term.bright_red("TypeError") + "::" + term.bold(err.kind.str()) + "  " + err.hint
	println(header)
	println(err.message + "\n")
}

pub fn (mut checker TypeChecker) produce_error (kind ErrorKind, message string) Type {
	checker.errors << TypeError{message: message, kind: kind }
	return Primitive{kind: .@none, name: "none" }
}

pub fn (mut checker TypeChecker) hint_error (kind ErrorKind, hint string , message string) Type {
	checker.errors << TypeError{message: message, kind: kind, hint: hint }
	return Primitive{kind: .@none, name: "none" }
}
