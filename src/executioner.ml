(* Takes an execution log and makes sense of it *)

let open_file filename = 
  let ic = open_in filename in
  let rec lines ic acc = 
  try 
    let line = input_line ic in  
    lines ic (line::acc) 
  with End_of_file -> List.rev acc in lines ic []         

let parse_log log_file = 
  let lines = open_file log_file in 
  Utils.map (fun line -> Riscv.line_parse line) lines

let execution_freq log = 
  let freq_tbl = Hashtbl.create 30 in 
  let rec loop = function 
    | []    -> freq_tbl
    | i::is -> 
      let instr = Riscv.instr_to_string i in 
      try let f = (Hashtbl.find freq_tbl instr) in
        Hashtbl.add freq_tbl instr (f + 1); loop is
      with Not_found -> Hashtbl.add freq_tbl instr 1; loop is in loop log