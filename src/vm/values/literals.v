module values

pub struct NumberVal {
	kind ValueKind = .num
pub mut:
	value f64
}

pub fn (mut num NumberVal) is_truthy () bool {
	return num.value != 0
}

pub fn (mut num NumberVal) to_str () string {
	return num.str()
}

pub fn (mut num NumberVal) print () {
	println(num)
}
