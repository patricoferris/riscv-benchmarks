let helpers =
  ["utils.ml"; "riscv.ml"]

let benchmarks = 
        ["intfloatarray.ml"; "sorting.ml"; "someornone.ml"; "zerotypes.ml"; "logger.ml"]

(* Printing *)
let echo str file =
  ignore (Sys.command ("echo \'" ^ str ^ "\' >> " ^ file))

let expand str = 
  if (String.length str) mod 2 = 0 then str else str ^ "="

let surround str total_length = 
  let padd = total_length - (String.length str) in 
  let half = (String.make (padd / 2) '=')in
    half ^ str ^ half

let print_and_execute exec prefix =
  let head = expand exec in 
  let header = surround head 50 in 
    print_endline header; 
    ignore (Sys.command  (prefix ^ exec)); 
    print_endline (String.make 50 '=')

let print_header exec = 
    let head = expand exec in 
    let header = surround head 50 in 
      header

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

let stringify xs = List.fold_left (fun acc -> fun s -> acc ^ " " ^ s) "" xs  

(* Builds the helpers and benchmarks as cmxs then links - optitional compiler and arguments *)
let build ?compiler:(compiler="ocamlopt") ?args:(args="") ?verbose:(verbose=false) ?asm:(asm=false) ?outputc:(outputc=false) ?output:(output="results.txt") () =
  let asm = if asm then " -S" else "" in
  let helper_files = stringify helpers in
  let benchmark_files = stringify benchmarks in
  let helper_comp = (compiler ^ asm ^ " -c " ^ helper_files) in 
  let benchmark_comp = (compiler ^ asm ^ " -c " ^ benchmark_files) in 
    if verbose then (print_endline helper_comp; ignore (Sys.command helper_comp); print_endline benchmark_comp; ignore (Sys.command benchmark_comp))
    else ignore (Sys.command helper_comp); ignore (Sys.command benchmark_comp);
  let helper_cmxs = stringify (change_filetype ".cmx" helpers) in
    List.iter 
      (fun b -> 
        let command = (compiler ^ " " ^ args ^ " -o " ^ ((List.hd (String.split_on_char '.' b)) ^ ".out") ^ helper_cmxs ^ " " ^ b) in 
        if verbose then (print_endline command; ignore (Sys.command command)) else ignore (Sys.command command)
      ) (change_filetype ".cmx" benchmarks); if outputc then echo (print_header compiler) output

let clean ?verbose:(verbose=false) () =
  let command = "rm *.cmi *.cmx *.o *.out *.s *.txt" in 
  if verbose then (print_endline command; ignore (Sys.command command)) else ignore (Sys.command command)

let run () = 
  let executables = change_filetype ".out" benchmarks in
  List.iter (fun exec -> print_and_execute exec "./") executables

let spike ?spikeargs:(spikeargs="") ?pkargs:(pkargs="") ?output:(output="results.txt") () = 
  let executables = change_filetype ".out" benchmarks in
  let spike_instructions = List.map (fun exec -> "spike" ^ spikeargs ^ "$pk " ^ pkargs ^ " ./" ^ exec) executables in 
    List.iter2 
      (fun exec -> fun sp -> 
        let cmd = ("echo \'" ^ print_header exec ^ "\' >> " ^ output ^ " && " ^ sp ^ " >> " ^ output ^ " && echo '\n'" ) in 
        print_endline cmd;
        ignore (Sys.command cmd)
      ) executables spike_instructions

(*********** COMMAND LINE TOOL ***********)
let command = 
  Core.Command.basic 
    ~summary:"🐫  RISC-V Benchmark Tool: a CLI for easier compilation 🐫"
    Core.Command.Let_syntax.(
      let%map_open 
            mode = anon (maybe ("mode" %: string))
        and compiler = flag "-c" (optional string) ~doc:"<compiler> ocamlopt to use"
        and args     = flag "-args" (optional string) ~doc:"<argument-list> arguments to pass in"
        and verbose  = flag "-v" no_arg ~doc:" printing build commands etc."
        and spikearg = flag "-spike" (optional string) ~doc:"<argument-list> spike arguments"
        and pkargs   = flag "-pk" (optional string) ~doc:"<argument-list> proxy kernel arguments"
        and asm      = flag "-asm" no_arg ~doc:" produces .s assembly files during the building phase"
        and log      = flag "-log" (optional string) ~doc:"<csv|print>"
        and output   = flag "-o" (optional string) ~doc:"filename where the results should be stored"
      in
        fun () -> 
          match mode with 
            | Some "clean" -> clean ~verbose () 
            | Some "run"   -> run ()
            | Some "spike" ->
              begin match (spikearg, pkargs, output) with 
                | (None, None, None)        -> spike ()
                | (None, None, Some output) -> spike ~output ()
                | (None, Some pkargs, None) -> spike ~pkargs ()
                | (None, Some pkargs, Some output) -> spike ~pkargs ~output ()
                | (Some spikeargs, None, None)     -> spike ~spikeargs () 
                | (Some spikeargs, None, Some output) -> spike ~spikeargs ~output () 
                | (Some spikeargs, Some pkargs, None) -> spike ~pkargs ~spikeargs () 
                | (Some spikeargs, Some pkargs, Some output) -> spike ~spikeargs ~pkargs ~output () end
            | Some "spike-build" -> 
              begin match (compiler, output) with 
                | (Some compiler, Some output) -> build ~compiler ~args:"-ccopt -static" ~verbose:true ~asm:true ~outputc:true ~output ()
                | (_, _) -> build ~args:"-ccopt -static" ~verbose:true ~asm:true () end
            | Some "build" -> 
              begin match (compiler, args) with 
                | (None, None) -> build ~verbose ~asm ()
                | (None, Some args) -> build ~args ~verbose ~asm ()
                | (Some compiler, None) -> build ~compiler ~verbose ~asm ()
                | (Some compiler, Some args) -> build ~compiler ~args ~verbose ~asm () end
            | Some "log" -> let tbl = Logger.main 100 () in 
              begin match log with 
                | Some "print"  -> let print_kv k v = print_endline (k ^ ": " ^ (string_of_int v)) in Hashtbl.iter print_kv tbl
                | Some "csv"    -> Logger.to_csv "log.csv" tbl 
                | Some _ | None -> print_endline "Invalid argument" end 
            | None | Some _ -> print_endline "Please provide either build, spike-build, run, spike, log or clean as mode"
    )

let () = Core.Command.run command 
