module analysis

import term { bold, bright_red, bright_yellow, bright_magenta }

struct NoEnv {}

type EnvNode = NoEnv | TypeEnv
struct TypeEnv {
	pub mut:
	parent EnvNode = NoEnv{}
	lookup map[string]Type // used to lookup variables
	types map[string]Type  // used to lookup type_names
}

pub fn (mut env TypeEnv) resolve_var_type (name string) ?Type {
	if name in env.lookup {
		return env.lookup[name]
	}

	match mut env.parent {
		TypeEnv {
			return env.parent.resolve_var_type(name)
		}
		else { return none }
	}
}

pub fn (mut env TypeEnv) lookup_type (typename string) Type {
	if typename in env.types {
		return env.types[typename]
	}

	match mut env.parent {
		TypeEnv{ return env.parent.lookup_type(typename) }
		else {
			kind := "unknown_type"
			hint := "could not resolve type ${bold(bright_yellow(typename))}"
			message := "Attempted to lookup typename ${typename} however this type does not exist."
			header := bright_red("TypeError") + "::" + bold(kind) + "  " + hint

			println(header)
			println(message)
			exit(1)
		}
	}

}

pub fn (mut env TypeEnv) define_type (typename string, value Type) Type {
	if typename in env.types {
		println("type ${typename} already is defined in the current env")
		exit(1)
	}

	env.types[typename] = value
	return value
}
