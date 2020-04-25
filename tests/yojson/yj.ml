module Y = Yojson.Basic

let data = 
  let size = if Array.length Sys.argv > 1 then int_of_string Sys.argv.(1) else 8585 in 
    Datagen.make size 

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
  (* Converting to pretty string *)
  let s = Y.prettify @@ Y.to_string json in 
  (* Parsing JSON from string to list *) 
  let lst = Y.Util.to_list (Y.from_string s) in 
  (* Convert JSON back to Datagen.t *)
  let data = List.map Datagen.of_json lst in
  (* Extract the temperatures from the readings as an average *) 
  let temps = List.map Datagen.average_temp data in 
  (* Calculate the 10-hour moving average *)
  let _moving = moving_average 10 temps in ()
