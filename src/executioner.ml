(* Takes an execution log and makes sense of it *)

let open_file filename = 
  let ic = open_in filename in
  let rec lines ic = 
  try 
    let line = input_line ic in  
    line :: (lines ic) 
  with End_of_file -> [] in lines ic          

let parse_log log_file = 
  let lines = open_file log_file in 
  List.map (fun line -> Riscv.line_parse line) lines
