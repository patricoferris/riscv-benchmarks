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

val gen_random_array : int -> 'a -> 'b -> ('a -> 'b -> 'c) -> 'c array
(** Random array generator - the function generates the random numbers *)

external rd_cycles : unit -> int = "rd_cycles"
(** An OCaml wrapper for calling rd_cycle assembly *)

 
