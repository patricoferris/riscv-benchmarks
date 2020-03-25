val map : ('a -> 'b) -> 'a list -> 'b list 
(** Tail-recursive mapping *)

val map2 : ('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list 

val random_int_between : int -> int -> int
(** Given two ints a and b returns an int x s.t. if a < b theb a <= x < b *)

val random_float_between : float -> float -> float
(** Given two floats a and b returns an float x s.t. if a < b theb a <= x < b *)

val gen_random_int_list : int -> int -> int -> int list 
(** Random list generation with size, min and max arguments *)


val gen_random_float_list : int -> float -> float -> float list 
(** Random list generation with size, min and max arguments *)

let gen_random_float_list size a b =
  let rec aux acc a b = function 
    | 0 -> acc
    | n -> aux ((random_float_between a b)::acc) a b (n - 1) 
  in 
    aux [] a b size 

let gen_random_array size a b f =
  Array.map (fun _ -> f a b) (Array.make size 0)

(* Calling rdcycles for number of cycles *)
let rd_cycles  

 
