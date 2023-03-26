module analysis


fn (mut checker TypeChecker) implements_function (a Type, b FunctionType) bool {

	println("Inside implements function")
	println(a)
	println(b)

	return false
}


fn (mut checker TypeChecker) implements_array (a Type, b ArrayType) bool {
	if b.contains.kind == .any { return true }

	// for a to be a valid type it must be an array just like b
	match a {
		ArrayType{
			return checker.type_implements(a.contains, b.contains)
		}
		else { return false }
	}

	return false
}

fn (mut checker TypeChecker) implements_union (a Type, b UnionType) bool {
	if b.contains.any(it.kind == .any) { return true }

	// first check if they are both unions
	match a {
		UnionType {
			// check that each member of a is at-least in b
			for elem_a in a.contains {
				mut success := false
				for elem_b in b.contains {
					if checker.type_implements(elem_a, elem_b) {
						success = true
					}

				}

				// Having no success means that type in a not in b cannot be a strict subset of b then
				if success == false {
					return false
				}
			}

			return true
		}

		Primitive {
			return a.kind in b.contains.map(fn(t Type) TypeKind { return t.kind})
		}

		ArrayType {
			// should literally never happen?
			println("unknown/implimented type a == array and b == union?")
			// for array check if the array.contains is in the union.contains
			return false
		}
		else {}
	}

	return false
}
// type_implements Given two types makes sure a is at-least a subset of b
fn ( mut checker TypeChecker) type_implements (a Type, b Type) bool {
	if a == b {
		return true
	}

	if b.kind == .any { return true }

	match b {
		UnionType { return checker.implements_union(a, b) }
		ArrayType { return checker.implements_array (a, b) }
		FunctionType{ return checker.implements_function(a, b)}
		else { return false }
	}

	return false
}
