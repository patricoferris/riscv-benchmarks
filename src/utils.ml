(* Tail-recursive mapping *)
let map2 f a b =
  let rec loop a b acc = match a with 
    | [] -> acc
    | _  -> loop (List.tl a) (List.tl b) ( (f (List.hd a) (List.hd b)) :: acc)
  in
    List.rev (loop a b [])

(** Given two ints a and b returns an int x s.t. if a < b theb a <= x < b *)
let random_int_between a b = 
  let r = if a < b then Random.int (b - a) else Random.int (a - b) in
  r + a 

(* Given two floats a and b returns an float x s.t. if a < b theb a <= x < b *)
let random_float_between a b = 
  let r = if a < b then Random.float (b -. a) else Random.float (a -. b) in
  r +. a 

(* Array and list generation *)
let gen_random_int_list size a b =
  let rec aux acc a b = function 
    | 0 -> acc
    | n -> aux ((random_int_between a b)::acc) a b (n - 1) 
  in 
    aux [] a b size 

let gen_random_float_list size a b =
  let rec aux acc a b = function 
    | 0 -> acc
    | n -> aux ((random_float_between a b)::acc) a b (n - 1) 
  in 
    aux [] a b size 

let gen_random_array size a b f =
  Array.map (fun x -> f a b) (Array.make size 0)

 
