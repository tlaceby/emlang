module values

pub enum ValueKind {
	num
	str
	bool
	null
}


pub interface EmValue {
	kind ValueKind
	is_truthy () bool
	to_str () string
	print ()
}
