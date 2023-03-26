module analysis

pub enum TypeKind {
	@none
	any
	number
	string
	boolean

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

pub fn (mut checker TypeChecker) num_type () Primitive { return Primitive{name: "number", kind: .number } }
pub fn (mut checker TypeChecker) str_type () Primitive { return Primitive{name: "string", kind: .string } }
pub fn (mut checker TypeChecker) none_type () Primitive { return Primitive{name: "none", kind: .@none } }
pub fn (mut checker TypeChecker) any_type () Primitive { return Primitive{name: "any", kind: .any } }
pub fn (mut checker TypeChecker) bool_type () Primitive { return Primitive{name: "boolean", kind: .boolean} }

pub fn (mut checker TypeChecker) array_type (inner_typename string) ArrayType {
	t := checker.type_from_typename(inner_typename)
	return ArrayType{kind: .array, name: "[]${t.name}", contains: t }
}

pub fn (mut checker TypeChecker) union_type (inner_typename string) UnionType {
	types := inner_typename
		.replace("|", " ")
		.split(" ")
		.filter(it != "").map(fn [mut checker](t string) Type {
			return checker.type_from_typename(t)
		})

	cleaned_inner_str := types.map(fn(t Type) string {
		return t.name
	}).join(" | ")

	return UnionType{
		name: "union(${cleaned_inner_str})", contains: types
	}
}

// Given two types makes sure a is at-least a subset of b
fn ( mut checker TypeChecker) type_impliments (a Type, b Type) bool {
	if a == b {
		return true
	}

	if b.kind == .any { return true }

	match b {
		UnionType { return a in b.contains }
		ArrayType {
			if b.contains.kind == .any { return true }
		}
		else { return false }
	}

	return false
}
fn (mut checker TypeChecker) type_from_typename (typename string) Type {
	match typename {
		"number"  { return checker.num_type() }
		"boolean" { return checker.bool_type()  }
		"string"  { return checker.str_type()   }
		"any"     { return checker.any_type()   }
		"none"    { return checker.none_type()  }
		else  {
			// Handle array types
			if typename.starts_with("[]") {
				return checker.array_type(typename[2..])
			}

			if typename.starts_with("union") {
				return checker.union_type(typename[6..typename.len - 1])
			}

			t := checker.env.lookup_type(typename)
			if t.kind != .@none {
				return t
			}

			println("Unknown type encountered in type checker ${typename}")
			exit(1)
		}
	}
}
