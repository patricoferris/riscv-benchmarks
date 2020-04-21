let size = 8585
let () = Random.init 42
let is_none = function 
  | None   -> true
  | Some _ -> false

let random_some_none_list size = 
  let rec loop acc = function 
    | 0 -> acc
    | n -> 
      let value = if (Random.int 2) = 0 then Some n else None in 
        loop (value::acc) (n - 1)
    in 
      loop [] size

let benchmark () =
  let big_list = random_some_none_list size in 
  ignore (Utils.map (fun x -> is_none x) big_list)

let () = benchmark ()
