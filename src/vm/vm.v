module vm

import vm.values { CodeVal, EmValue, NumberVal  }

[noinit]
pub struct EMVirtualMachine {
mut:
	block CodeVal  			[required]
	stack_size int			[required]
	stack []values.EmValue  [required]
	ip int
	sp int
	fp int
}

pub fn construct_vm (global_block values.CodeVal, stack_size int) EMVirtualMachine {
	return EMVirtualMachine {
		block: global_block,
		stack_size: stack_size,
		stack: []values.EmValue { cap: stack_size }
	}
}

pub fn (mut vm EMVirtualMachine) eval () values.EmValue {
	return NumberVal{value: 43.2}
}
