module lexer


fn (mut lex Lexer) build_numeric () {
	mut num_str := ""
	mut found_decimal := false

	start_pos := Location{line: lex.line, offset: lex.offset }

	for {
		// Build tokens until either EOF or no more numbers / decimals
		if (lex.not_eof()) && ( lex.at() == '.' || lex.is_numeric()) {
			if lex.at() == '.' {
				if found_decimal {
					// Handle error for multiple decimals in numeric literal
					println("Invalid numeric literal located. Cannot have more than one decimal")
					exit(1)
				}

				found_decimal = true
			}

			num_str +=  lex.next()
		} else {
			// Leave the function after constructing the numeric token
			lex.tokens << token(.numeric, num_str, start_pos)
			return
		}
	}
}

fn (mut lex Lexer) build_identifier () {
	start_pos := Location{line: lex.line, offset: lex.offset }
	mut ident := ""

	for {
		// Allowed characters are numbers and symbols after the first character
		if lex.not_eof() && lex.is_symbol() {

			ident += lex.next()
		} else {
			lex.tokens << token(.identifier, ident, start_pos)
			return
		}
	}
}
