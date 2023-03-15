module values

pub enum ValueKind {
	code // represents a block of code
	num
	str
	bool
	null
}


pub interface EmValue {
	kind ValueKind
mut:
	is_truthy () bool
	to_str () string
	print ()
}

