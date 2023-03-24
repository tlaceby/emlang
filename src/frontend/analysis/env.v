module analysis

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
		else { return Primitive { kind: .@none, name: "none" }}
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
