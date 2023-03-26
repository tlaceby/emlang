module parser


import term	{ bright_red, bright_yellow, cyan, bold }
import os

enum ParserError {
	unexpected_eof
	unexpected_token
	bad_lvalue
	bad_rvalue
	bad_type_assertion
}

fn (mut parser Parser) validate_nud () {
	// Make sure there exists a nud
	tk := parser.previous
	if !(tk.kind() in nud_lookup) {
		hint := "This syntax is unsupported in ${term.bold("em")}"
		err := mk_error("Token provided does not contain a valid nud function\n${term.dim(parser.prev().str())}", hint, .unexpected_token)
		parser.error(err)
		exit(1)
	}
}

fn (mut parser Parser) validate_type_nud () {
	// Make sure there exists a nud
	tk := parser.previous
	if !(tk.kind() in type_nud_lookup) {
		hint := "This syntax is unsupported in ${term.bold("em")}"
		err := mk_error("Token provided does not contain a valid type_nud function\n${term.dim(parser.prev().str())}", hint, .unexpected_token)
		parser.error(err)
		exit(1)
	}
}


fn (mut parser Parser) err_header (err ParserError) {
	loc := parser.previous.loc()
	filename := parser.file.name
	path := parser.file.path

	print(bright_red(bold("CompilationError")))
	println("::${bold(err.str())} in ${path}${filename}[${loc.line + 1}:${loc.offset}]")
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
		mut below_line := "\n" + repeat_char_str(" ", 5)
		line += lines[ln]

		// add red line underneath error location
		err_offset := parser.previous.loc().offset
		err_tk_len := parser.previous.val().len

		below_line += repeat_char_str(" ", err_offset)
		below_line += term.bright_red(repeat_char_str("▔", err_tk_len))

		line += below_line
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
	println(line)

	println(below)

	// Print error hint if
	if err.hint.len > 0 {
		println("\n${term.bright_yellow(err.hint)}")
	} else {
		print("\n")
	}
	println("${err.message}")
}

fn (mut parser Parser) validate_led () {
	// Make sure there exists a nud
	tk := parser.previous

	if !(tk.kind() in led_lookup){
		hint := "This syntax is unsupported in ${term.bold("em")}"
		err := mk_error("Token provided does not contain a valid led function\n${term.dim(parser.prev().str())}", hint, .unexpected_token)
		parser.error(err)
		exit(1)
	}
}

fn (mut parser Parser) validate_type_led () {
	// Make sure there exists a nud
	tk := parser.previous

	if !(tk.kind() in type_led_lookup){
		hint := "This syntax is unsupported in ${term.bold("em")}"
		err := mk_error("Token provided does not contain a valid type_led function\n${term.dim(parser.prev().str())}", hint, .unexpected_token)
		parser.error(err)
		exit(1)
	}
}

