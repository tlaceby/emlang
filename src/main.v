module main

import frontend.parsers { SourceFile }
import frontend.parsers.s_expr { SExprParser }
import frontend.compiler
import vm


fn main() {

	file := SourceFile{ name: "test.em", path: "./" }
	mut emitter := compiler.EMCompiler{parser: SExprParser{}}
	bytecode := emitter.emit_bytecode(file)

	mut virtual_machine := vm.construct_vm(bytecode, 2048)
	mut final_result := virtual_machine.eval()

	final_result.print()
}
