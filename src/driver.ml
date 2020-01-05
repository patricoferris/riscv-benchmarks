let helpers =
  ["utils.ml"]

let benchmarks = 
  ["intfloatarray.ml"; "sorting.ml"]

(* Converting list of files *)
let change_filetype filetype files =
  let change_end str ft = 
    let s = List.hd (String.split_on_char '.' str) in 
      s ^ ft
  in
  let rec loop ft acc = function
    | [] -> acc 
    | f::fs -> loop ft ((change_end f ft)::acc) fs
  in
    loop filetype [] files

let build () =
  let helper_files = List.fold_left (fun acc -> fun s -> acc ^ " " ^ s) "" helpers in
  let benchmark_files = List.fold_left (fun acc -> fun s -> acc ^ " " ^ s) "" benchmarks in
  let _ = Sys.command ("ocamlopt -c " ^ helper_files) in
  let _ = Sys.command ("ocamlopt -c " ^ benchmark_files) in
  let helper_cmxs = List.fold_left (fun acc -> fun s -> acc ^ " " ^ s) "" (change_filetype ".cmx" helpers) in
    List.map (fun b -> Sys.command ("ocamlopt -o " ^ (List.hd (String.split_on_char '.' b)) ^ helper_cmxs ^ " " ^ b)) (change_filetype ".cmx" benchmarks)

let clean () =
  Sys.command ("rm *.cmi *.cmx *.cmo *.o" ^ (List.fold_left (fun acc -> fun s -> acc ^ " " ^ s) "" (change_filetype "" benchmarks)))

let run () = 
  let executables = change_filetype "" benchmarks in
  List.iter (fun exec -> print_endline ("Running " ^ exec ^ " - code: " ^ (string_of_int (Sys.command  ("./" ^ exec))))) executables

let () = 
  let arg = if Array.length Sys.argv = 1 then "No Argument" else Sys.argv.(1) in
  match arg with 
    | "build" -> let _ = build () in ()
    | "clean" -> let _ = clean () in ()
    | "run"   -> run ()
    | "No Argument" -> print_endline "No argument supplied"
    | _ -> print_endline "Don't know what to do" 