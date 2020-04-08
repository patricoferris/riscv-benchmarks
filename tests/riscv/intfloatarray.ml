(* Benchmark: Arrays, integers and floats 

  This benchmark uses the polymorphic greater than operator and 
  as much prior knowledge of the types has been removed in order 
  to force the compiler to make checks of the values at runtime 
  using the Is_long macro which has been swapped for inline-asm 
  to the caml_is_int custom instruction 
*)

(* Set size *)
let size =
    if Array.length Sys.argv = 1
    then 1024 else int_of_string Sys.argv.(1)

(* Numbers: can be integers or floats *)
(* In OCaml, integers are not heap-allocated (tag bit 1) whereas floats are (boxed)*)
type number = Int of int | Float of float 

let print_number = function
  | Int n   -> print_int n
  | Float f -> print_float f

let random_between a b = 
  if (Random.int 2) = 0 then Int (Utils.random_int_between a b) else Float (Utils.random_float_between (Float.of_int a) (Float.of_int b))

(** Creates a new array of type Number Array with the same variant in each place as the supplied array *)
let from_num_array a b arr =  
  let random_from_type = function 
    | Int _   -> Int (Utils.random_int_between a b) 
    | Float _ -> Float (Utils.random_float_between (Float.of_int a) (Float.of_int b)) in
  Array.map (fun x -> random_from_type x) arr 

let greater_than a b = if a > b then a else b

(** Greater than for number types - in the case of two different variants the integer is cast to a float *)
let gt2 a b = 
  let greater_than_2 = function 
    | (Int a, Int b)     -> if a > b then Int a else Int b
    | (Float f, Float g) -> if f > g then Float f else Float g 
    | (Int a, Float f)   -> if (Float.of_int a) > f then Int a else Float f 
    | (Float f, Int a)   -> if f > (Float.of_int a) then Float f else Int a 
  in 
    greater_than_2 (a, b)

let mixed_types () = 
  let array_one = Utils.gen_random_array size 0 100 (random_between) in 
  let array_two = Utils.gen_random_array size 0 100 (random_between) in 
  let gt = Array.map2 gt2 array_one array_two in 
    gt

let int_list () =
  let random_int_list_one = Utils.gen_random_int_list size 0 100 in 
  let random_int_list_two = Utils.gen_random_int_list size 0 100 in 
  let gt_list = Utils.map2 greater_than random_int_list_one random_int_list_two in 
    gt_list

let float_list () =
  let random_float_list_one = Utils.gen_random_float_list size 0. 100. in 
  let random_float_list_two = Utils.gen_random_float_list size 0. 100. in 
  let gt_list = Utils.map2 greater_than random_float_list_one random_float_list_two in 
    gt_list

let benchmark () = 
  ignore (int_list ()) ; ignore (float_list ()) ; ignore (mixed_types ())

let () = benchmark ()
