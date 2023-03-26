module analysis

import frontend.ast

pub enum TypeKind {
	@none
	any
	number
	string
	boolean
	uninitialized

	// Complex Types
	array
	@interface
	@union
	function
}

interface Type {
	kind TypeKind
	name string
}

pub struct Primitive {
pub:
	kind TypeKind = .number
	name string [required]
}

pub struct ArrayType {
pub:
	kind TypeKind = .array
	name string [required]
	contains Type [required]
}

pub struct UnionType {
pub:
	kind TypeKind = .@union
	name string [required]
	contains []Type [required]
}

pub struct FunctionType {
	pub:
	kind TypeKind = .@union
	name string [required]
	params []Type [required]
	result Type [required]
}

pub fn (mut checker TypeChecker) num_type () Primitive { return Primitive{name: "number", kind: .number } }
pub fn (mut checker TypeChecker) uninitialized_type () Primitive { return Primitive{name: "uninitialized", kind: .uninitialized} }
pub fn (mut checker TypeChecker) str_type () Primitive { return Primitive{name: "string", kind: .string } }
pub fn (mut checker TypeChecker) none_type () Primitive { return Primitive{name: "none", kind: .@none } }
pub fn (mut checker TypeChecker) any_type () Primitive { return Primitive{name: "any", kind: .any } }
pub fn (mut checker TypeChecker) bool_type () Primitive { return Primitive{name: "boolean", kind: .boolean} }

pub fn (mut checker TypeChecker) array_type (array ast.Array) ArrayType {
	t := checker.type_from_ast(array.inner)
	return ArrayType{kind: .array, name: "[]${t.name}", contains: t }
}

pub fn (mut checker TypeChecker) function_type (func ast.Function) FunctionType {
	params := func.params.map(fn[mut checker](t ast.Type) Type {
		kind := checker.type_from_ast(t)
		return kind
	})

	result := checker.type_from_ast(func.result)
	// check type here
	if result.kind == .@none {
		checker.produce_error(.bad_return_type, "Function cannot return typeof none. ${func.str()}")
	}

	result_name := result.name
	params_name := params.map(it.name).join(",")

	return FunctionType{
		params: params,
		kind: .function
		name: "fn(${params_name})${result_name}"
		result: result
	}
}

pub fn (mut checker TypeChecker) union_type (union_type ast.Union) UnionType {
	contains := union_type.types.map(fn[mut checker](val ast.Type) Type {
		return checker.type_from_ast(val)
	})

	mut name := contains.map(fn(val Type) string{
		return val.name
	}).join(" | ")

	return UnionType{
		name: "(${name})", contains: contains
	}
}


fn (mut checker TypeChecker) type_from_ast (node ast.Type) Type {
	match node {
		ast.Primitive {
			match node.value {
				"number"  		{ return checker.num_type()   }
				"boolean"		{ return checker.bool_type()  }
				"string"  		{ return checker.str_type()   }
				"none"    		{ return checker.none_type()  }
				"any"     		{ return checker.any_type()   }
				"void"     		{ return Primitive{name: "void", kind: .uninitialized} }
				"uninitialized" { return checker.uninitialized_type()   }
				else 	  {
					// Handle type literals and user defined types
					return checker.env.lookup_type(node.value)
				}
			}
		}
		ast.Function { return checker.function_type(node) }
		ast.Array { return checker.array_type(node) }
		ast.Union {
			return checker.union_type(node)
		}
	}

	println("Unknown type encountered in type checker ${node.str()}")
	exit(1)
}
