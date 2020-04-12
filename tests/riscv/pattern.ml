(* Benchmark: Pattern matching

  Pattern matching over simple and more complex 
  variants. 
*)

type const = A | B | C | D | E 
type nonconst = CA of int | CB of float | CC of string | CD of bool
type poly = [`Int of int | `String of string | `Float of float | `Bool of bool]

let size = 256 

let simple_to_string = function 
  | A -> "Type simple: A"
  | B -> "Type simple: B"
  | C -> "Type simple: C"
  | D -> "Type simple: D"
  | E -> "Type simple: E"

let print_simple = function 
  | A -> print_string "Type simple: A\n"
  | B -> print_string "Type simple: B\n"
  | C -> print_string "Type simple: C\n"
  | D -> print_string "Type simple: D\n"
  | E -> print_string "Type simple: E\n"

let nonconst_to_string = function 
  | CA i -> string_of_int i 
  | CB f -> string_of_float f 
  | CC s -> s 
  | CD b -> string_of_bool b

let print_nonconst = function 
  | CA _ -> print_string "Type complex: CA of int\n"
  | CB _ -> print_string "Type complex: CB of float\n"
  | CC _ -> print_string "Type complex: CC of string\n" 
  | CD _ -> print_string "Type complex: CD of bool\n"

let poly_to_string = function 
  | `Int _ -> "Type poly: `Int"
  | `String _ -> "Type poly: `String"
  | `Float _ -> "Type poly: `Float"
  | `Bool _ -> "Type poly: `Bool"

let print_poly = function 
  | `Int i -> print_string "Type Poly of Int"
  | `String s -> print_string "Type Poly of String"
  | `Float f -> print_string "Type Poly of Float"
  | `Bool b -> print_string "Type Poly of Bool"

(* Integers to variant types *)
let int_to_simple = function 
  | n when n mod 5 = 0 -> A 
  | n when n mod 5 = 1 -> B
  | n when n mod 5 = 2 -> C
  | n when n mod 5 = 3 -> D
  | n when n mod 5 = 4 -> E
  | _ -> A (* Should never be reached *)

let int_to_nonconst = function 
  | n when n mod 4 = 0 -> CA n 
  | n when n mod 4 = 1 -> CB (float_of_int n) 
  | n when n mod 4 = 2 -> CC (string_of_int n)
  | n when n mod 4 = 3 -> CD true
  | n -> CA n (* Should never be reached *)

let int_to_poly = function 
  | n when n mod 4 = 0 -> `Int n
  | n when n mod 4 = 1 -> `String (string_of_int n) 
  | n when n mod 4 = 2 -> `Float (float_of_int n)
  | n when n mod 4 = 3 -> `Bool true
  | n -> `Int n (* Should never be reached *)

let () = 
  let simple_lst = List.init size int_to_simple in 
  let _string_simple = List.iter print_simple simple_lst; Utils.map simple_to_string simple_lst in 
  let nonconst_lst = List.init size int_to_nonconst in 
  let _string_nonconst = List.iter print_nonconst nonconst_lst; Utils.map nonconst_to_string nonconst_lst in 
  let poly_lst = List.init size int_to_poly in 
  let _string_poly = List.iter print_poly poly_lst; Utils.map poly_to_string poly_lst in () 