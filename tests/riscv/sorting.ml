let size = 1000
let () = Random.init 42
let stdlib_sort () =
  let int_list = Utils.gen_random_int_list size 0 1000 in 
  let _ = List.sort (Stdlib.compare) int_list in 
  let float_list = Utils.gen_random_float_list size 0. 1000. in
    ignore (List.sort (Stdlib.compare) float_list)

let main () = stdlib_sort ()

let () = main ()