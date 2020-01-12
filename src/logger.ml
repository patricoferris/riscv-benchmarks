(* Takes an execution log and makes sense of it *)
let open_file filename =
  open_in filename 

let read_file ic chunk = 
  let rec lines ic acc = function 
    | 0 -> (List.rev acc, ic, false)
    | n -> try let line = input_line ic in  
      lines ic (line::acc) (n - 1)
  with End_of_file -> close_in ic; (List.rev acc, ic, true) in lines ic [] chunk       

let parse_log ic chunk = 
  let (lines, nic, closed) = read_file ic chunk in 
    (Utils.map (fun line -> Riscv.line_parse line) lines, nic, closed)

let execution_freq freq_tbl log = 
  let rec loop = function 
    | []    -> ()
    | i::is -> 
      let instr = Riscv.instr_to_string i in 
      try let f = (Hashtbl.find freq_tbl instr) in
        Hashtbl.replace freq_tbl instr (f + 1); loop is
      with Not_found -> Hashtbl.add freq_tbl instr 1; loop is in loop log

(********** CSV Output ***********)
let print_csv oc k v =
  Printf.fprintf oc "%s,%i\n" k v

let to_csv filename tbl = 
  let oc = open_out filename in 
  let print = print_csv oc in
    Printf.fprintf oc "%s,%s\n" "instruction" "frequency";
    Hashtbl.iter print tbl; 
  close_out oc

(* Files are too big for memory - read in chuncks *)
let main chunks () =
  let ic = open_file "test.txt" in
  let freq_tbl = Hashtbl.create 50 in 
  let rec loop in_c = 
    let (log, nin_c, closed) = parse_log in_c chunks in
        if closed then (execution_freq freq_tbl log; freq_tbl) else 
        (execution_freq freq_tbl log; loop nin_c) 
  in loop ic
