let size = (1204 * 1204)

let rec bubblesort nums =
  let bsort = function
    | x::y::xs when x > y ->
        y::bubblesort(x::xs)
    | x::xs ->
        x::bubblesort(xs)
    | nums -> nums
  in
  let t = bsort nums in
    if t = nums then t
    else bsort t

let bubblesorts () = 
  let int_list = Utils.gen_random_int_list 100 0 1000 in 
  let _ = bubblesort int_list in 
  let float_list = Utils.gen_random_float_list 100 0. 1000. in
  let _ = bubblesort float_list in
    print_endline "Bubblesorts completed" 

let stdlib_sort () =
  let int_list = Utils.gen_random_int_list 10000 0 1000 in 
  let _ = List.sort (Pervasives.compare) int_list in 
  let float_list = Utils.gen_random_float_list 10000 0. 1000. in
  let _ = List.sort (Pervasives.compare) float_list in
    print_endline "Standard sort with Pervasives.compare completed" 

let main () = 
  bubblesorts (); stdlib_sort ()

let () = print_endline "Sorting"; main ()