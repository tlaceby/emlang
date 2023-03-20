module parser


import term	{ bright_red, bright_yellow, cyan, bold }
import os
import frontend.parser.lexer { Token }

enum ParserError {
	unexpected_eof
	unexpected_token
}

fn (mut parser Parser) validate_nud () {
	// Make sure there exists a nud
	tk := parser.previous
	if !(tk.kind() in nud_lookup) {
		hint := "Consider using a different token?"
		err := mk_error("Token provided does not contain a valid nud function\n${parser.prev()}", hint, .unexpected_token)
		parser.error(err)
		exit(1)
	}
}

fn (mut parser Parser) err_header (err ParserError) {
	loc := parser.previous.loc()
	filename := parser.file.name
	path := parser.file.path

	print(bright_red(bold("CompilationError")))
	println("::${bold(err.str())} in ${path}${filename}[${loc.line}:${loc.offset}]")
}

enum ErrorLineLoc {
		above
		error_line
		below
}

fn repeat_char_str (str string, count int) string {
	mut s := ""
	for i := 0; i < count; i++ {
		s += str
	}

	return s
}

fn (mut parser Parser) generate_err_line (loc ErrorLineLoc) string {
	lines := (os.read_lines(parser.file.path + parser.file.name) or {
		panic(err)
	})

	total_lines_in_file := lines.len

	mut ln := parser.previous.loc().line
	mut line := ""
	// Handle bounds checks
	if loc == .above {
		ln -= 1
	} else if loc == .below { ln += 1 }

	line = "${bold((ln + 1).str() + " |")}${repeat_char_str(" ", 2)}"


	if ln < 0 || ln == total_lines_in_file {
		return line
	}

	if loc == .error_line {
		line += lines[ln]
	} else {
		line += term.gray(lines[ln])
	}


	return line
}

struct ErrorMessage {
	message string     [required]
	kind ParserError = .unexpected_token
	hint string
}

fn mk_basic_err (kind ParserError, message string) ErrorMessage {
	return ErrorMessage{ message: message, kind: kind }
}

fn mk_error (message string, hint string ,kind ParserError) ErrorMessage {
	return ErrorMessage{ message: message, hint: hint, kind: kind }
}

fn (mut parser Parser) error (err ErrorMessage) {
	parser.err_header(err.kind)
	top := parser.generate_err_line(.above)
	line := parser.generate_err_line(.error_line)
	below := parser.generate_err_line(.below)

	println(top)
	print(line)

	if err.hint.len > 0 {
		println("  ${term.gray("  <-- ")}${cyan(err.hint)}")
	} else {
		// add the needed new line to the print
		print("\n")
	}

	println(below)

	print("\n")
	print(bright_yellow("error_message: "))
	println("${err.message}")
}

fn (mut parser Parser) validate_led () {
	// Make sure there exists a nud
	tk := parser.previous

	if !(tk.kind() in led_lookup){
		hint := "Consider using a different token?"
		err := mk_error("Token provided does not contain a valid led function\n${parser.prev()}", hint, .unexpected_token)
		parser.error(err)
		exit(1)
	}
}

