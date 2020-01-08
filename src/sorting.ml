let size = (10000)

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
    ignore (bubblesort float_list)

let stdlib_sort () =
  let int_list = Utils.gen_random_int_list 10000 0 1000 in 
  let _ = List.sort (Pervasives.compare) int_list in 
  let float_list = Utils.gen_random_float_list 10000 0. 1000. in
    ignore (List.sort (Pervasives.compare) float_list)
    

let main () = 
  bubblesorts (); stdlib_sort ()

let () = main ()