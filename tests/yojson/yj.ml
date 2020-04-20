let data = Datagen.make 1_000 

let () = 
  let _json = `List (data |> List.map Datagen.to_json) in 
  () 
