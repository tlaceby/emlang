module ast

pub enum TypeNodeKind {
	@union
	array
	primitive
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

pub type Type = Union | Array | Primitive
