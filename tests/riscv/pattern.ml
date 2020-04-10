(* Benchmark: Pattern matching

  Pattern matching over simple and more complex 
  variants. 
*)

type simple = A | B | C | D | E 
type complex = CA of int | CB of float | CC of string 

let size = 256 

let simple_to_string = function 
  | A -> "Type simple: A"
  | B -> "Type simple: B"
  | C -> "Type simple: C"
  | D -> "Type simple: D"
  | E -> "Type simple: E"

let complex_to_string = function 
  | CA i -> string_of_int i 
  | CB f -> string_of_float f 
  | CC s -> s 

let int_to_simple = function 
  | n when n mod 5 = 0 -> A 
  | n when n mod 5 = 1 -> B
  | n when n mod 5 = 2 -> C
  | n when n mod 5 = 3 -> D
  | n when n mod 5 = 4 -> E
  | _ -> A (* Should never be reached *)

let int_to_complex = function 
  | n when n mod 3 = 0 -> CA n 
  | n when n mod 3 = 1 -> CB (float_of_int n) 
  | n when n mod 3 = 2 -> CC (string_of_int n)
  | n -> CA n (* Should never be reached *)

let () = 
  let simple_lst = List.init size int_to_simple in 
  let _string_simple = Utils.map simple_to_string simple_lst in 
  let complex_lst = List.init size int_to_complex in 
  let _string_complex = Utils.map complex_to_string complex_lst in ()