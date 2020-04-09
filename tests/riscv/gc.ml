(* Allocating and Finalising all over the place *)
let () = Random.init 42
(* A Functor for Maps that track their size *)
module SizedMap (M: Map.S) = struct 
  type 'a t = { size: int; map: 'a M.t }
  let add k v map =  { size = map.size + 1; map = M.add k v map.map }
  let remove k map = { size = map.size - 1; map = M.remove k map.map }
  let size map = map.size 
  let empty () = { size = 0; map = M.empty }
end  

module SizedStringMap = SizedMap (Map.Make(String))

let iteration = 10_000
let max_size = 100 
let generate_string n = String.make 512 (char_of_int (n mod 256))
let generate_k_v n = (generate_string n, n)

let remove map n = 
  if SizedStringMap.size map >= max_size then SizedStringMap.remove (generate_string (n - 1)) map else map

let add_remove n map = 
  let k, v = generate_k_v n in 
  let augmented = SizedStringMap.add k v map in 
    remove augmented n

(* Generate a large map that inserts and removes elements *)
let benchmark () = 
  let map = SizedStringMap.empty () in 
  let rec loop map = function 
    | 0 -> map
    | n -> loop (add_remove n map) (n - 1)
  in 
    loop map iteration

let () =
  benchmark () |> ignore
