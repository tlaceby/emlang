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
	kind TypeKind = .number
	name string [required]
}

pub struct ArrayType {
	kind TypeKind = .array
	name string [required]
	contains Type [required]
}

pub struct UnionType {
	kind TypeKind = .@union
	name string [required]
	contains []Type [required]
}

pub fn num_type () Primitive { return Primitive{name: "number", kind: .number } }
pub fn str_type () Primitive { return Primitive{name: "string", kind: .string } }
pub fn none_type () Primitive { return Primitive{name: "none", kind: .@none } }
pub fn any_type () Primitive { return Primitive{name: "any", kind: .any } }
pub fn bool_type () Primitive { return Primitive{name: "boolean", kind: .boolean} }

pub fn array_type (inner_typename string) ArrayType {
	t := type_from_typename(inner_typename)
	return ArrayType{kind: .array, name: "[]${t.name}", contains: t }
}


fn type_from_typename (typename string) Type {
	match typename {
		"number"  { return num_type()   }
		"boolean" { return bool_type()  }
		"string"  { return str_type()   }
		"any"     { return any_type()   }
		"none"    { return none_type()  }
		else  {
			// Handle array types
			if typename.starts_with("[]") {
				return array_type(typename[2..])
			}

			println("Unknown type encountered in type checker ${typename}")
			exit(1)
		}
	}
}
