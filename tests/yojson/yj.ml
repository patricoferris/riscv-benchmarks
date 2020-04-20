let data = Datagen.make 1_000 

let moving_average win lst = 
  let rec sum lst = function 
    | 0 -> 0. 
    | n -> List.hd lst +. (sum List.tl (n - 1)) in 
  let rec loop = function 
    | [] | lst when List.length lst < win -> [] 
    | lst -> ((sum lst win) /. (float_of_int win)) :: loop (List.tl lst) 


let () = 
  (* Generating JSON *)
  let json  = `List (data |> List.map Datagen.to_json) in 
  (* Parsing JSON and computing statistics *) 
  let temps = 
