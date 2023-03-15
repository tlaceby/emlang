module values



pub struct CodeVal {
	kind ValueKind = .code
pub mut:
	globals   []EmValue
	constants []EmValue
}


pub fn (mut co CodeVal) is_truthy () bool {
	return true
}

pub fn (mut co CodeVal) to_str () string {
	return co.str()
}

pub fn (mut co CodeVal) print () {
	println(co)
}
