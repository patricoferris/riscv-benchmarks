let helpers =
  ["utils.ml"]

let benchmarks = 
  ["intfloatarray.ml"; "sorting.ml"; "someornone.ml"]

(* Printing *)
let expand str = 
  if (String.length str) mod 2 = 0 then str else str ^ "="

let surround str total_length = 
  let padd = total_length - (String.length str) in 
  let half = (String.make (padd / 2) '=')in
    half ^ str ^ half

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
let build ?compiler:(compiler="ocamlopt") ?args:(args="") ?verbose:(verbose=false) ?asm:(asm=false) () =
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
      ) (change_filetype ".cmx" benchmarks)

let clean ?verbose:(verbose=false) () =
  let command = "rm *.cmi *.cmx *.o *.out *.s" in 
  if verbose then (print_endline command; ignore (Sys.command command)) else ignore (Sys.command command)

let print_and_execute exec prefix =
  let head = expand exec in 
  let header = surround head 50 in 
    print_endline header; 
    ignore (Sys.command  ("./" ^ exec)); 
    print_endline (String.make 50 '=')

let run () = 
  let executables = change_filetype ".out" benchmarks in
  List.iter (fun exec -> print_and_execute exec "./") executables

let spike ?args:(args="") () = 
  let executables = change_filetype ".out" benchmarks in
  List.iter (fun exec -> print_and_execute exec ("spike $pk " ^ args ^ " ./")) executables

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
        and asm      = flag "-asm" no_arg ~doc:" produces .s assembly files during the building phase"
      in
        fun () -> 
          match mode with 
            | Some "clean" -> clean ~verbose () 
            | Some "run"   -> run ()
            | Some "spike" ->
              begin match spikearg with 
                | None     -> spike ()
                | Some args -> spike ~args () end 
            | Some "build" -> 
              begin match (compiler, args) with 
                | (None, None) -> build ~verbose ~asm ()
                | (None, Some args) -> build ~args ~verbose ~asm ()
                | (Some compiler, None) -> build ~compiler ~verbose ~asm ()
                | (Some compiler, Some args) -> build ~compiler ~args ~verbose ~asm () end
            | None | Some _ -> print_endline "Please provide either build, run, spike or clean as mode"
    )

let () = Core.Command.run command 