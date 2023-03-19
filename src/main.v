module main

import frontend.parser.lexer { SourceFile }
import frontend.compiler
import vm

fn main() {
	println("\n")
	file := SourceFile{ name: "test.em", path: "./" }
	mut emitter := compiler.EMCompiler{}
	bytecode := emitter.emit_bytecode(file)

	mut virtual_machine := vm.construct_vm(bytecode, 2048)
	_ := virtual_machine.eval()
}
