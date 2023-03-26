module ast

pub enum TypeNodeKind {
	@union
	array
	primitive
	function
}
pub struct Union {
	pub mut:
	types []Type  [required]
	kind TypeNodeKind = .@union
}

pub struct Array {
	pub mut:
	kind TypeNodeKind = .array
	inner Type [required]
}

pub struct Primitive {
	pub mut:
	kind TypeNodeKind = .primitive
	value string [required]
}

pub struct Function {
pub mut:
	kind TypeNodeKind = .function
	params []Type [required]
	result Type = Primitive{value: "void" } // default of none -> void
}

pub type Type = Union | Array | Primitive | Function
