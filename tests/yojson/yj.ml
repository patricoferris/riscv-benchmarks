module Y = Yojson.Basic

let data = Datagen.make 1_000 

(* Calculating moving average over a list for a given window size *)
let moving_average win lst = 
  let rec sum lst = function 
    | 0 -> 0 
    | n -> List.hd lst + (sum (List.tl lst) (n - 1)) in 
  let rec loop = function 
    | [] -> [] 
    | lst when List.length lst < win -> [] 
    | lst -> (float_of_int (sum lst win) /. (float_of_int win)) :: loop (List.tl lst) 
  in 
    loop lst 

let () = 
  (* Generating JSON *)
  let json  = `List (data |> List.map Datagen.to_json) in 
  let _s = Y.to_string json in 
  (* Parsing JSON and computing statistics *) 
  let lst = Y.Util.to_list json in 
  let data = List.map Datagen.of_json lst in 
  let temps = List.map Datagen.average_temp data in 
  let _moving = moving_average 10 temps in ()
