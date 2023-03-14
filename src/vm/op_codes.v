module vm

pub enum Opcode {
	hlt

	push
	pop

	load_const
	load_global
	load_local

	set_global
	set_local

	add
	sub
	mul
	div
	mod
	exp
}
