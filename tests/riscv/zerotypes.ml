(* Types that map to 0 (native-int 1) in the OCaml data representation *)
let is_zero = function 
	| 0 -> true
	| _ -> false

(* This doesn't but will allocated on the heap - testing the GC customisations *)
let is_zerof = function 
	| 0. -> true
	| _  -> false 

let is_empty = function 
	| []   -> true
	| _::_ -> false

let is_none = function 
	| None   -> true 
	| Some _ -> false 

let size = 8000
let () = Random.init 42
let floats = Utils.gen_random_float_list size 0. 100.
let nums =  Utils.gen_random_int_list size 0 100
let lists = Utils.map (fun x -> Utils.gen_random_int_list x 0 100) nums
let somes = Utils.map (fun x -> if (Random.int 2) = 0 then Some x else None) nums

let () =
	(* Gc.set {(Gc.get ()) with Gc.verbose = 0x01 }; *)
	ignore (List.map (fun x -> is_zero x) nums);
  ignore (List.map (fun x -> is_zerof x) floats);
  ignore (List.map (fun x -> is_empty x) lists);
  ignore (List.map (fun x -> is_none x) somes);
