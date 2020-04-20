
module WeatherData = struct 
  open Yojson.Basic
  type t = {
    temp_min : float;
    temp_max : float; 
  } 
  let to_json {temp_min, temp_max} = `Assoc [("temp_min", `Float temp_min); ("temp_max", `Float temp_max)]
  let to_string t = Printf.sprintf "(min %f, max %f)" t.temp_min t.temp_max
end 

type station_record = {
  station_id : string;
  date : int; 
  data : WeatherData.t;
}        

let pi = 3.14159
let _ = Random.init 85

let temp_gen t mean = 
  7.5 *. sin((pi /. 12.) *. (t -. 6.)) +. mean

(* Converts a station_record to json *)
let to_json {station_id; date; data} = 
  let open Yojson.Basic in 
    `Assoc
      [("station_id",`String station_id); 
       ("date", `Int date);
       ("data", WeatherData.to_json data)
      ]

(* Makes a large list of station_records *)
let make size = 
  let random_event i = 
    let t = temp_gen (float_of_int i) 10. in
    let temp_min = t -. (Random.float 1.) in 
    let temp_max = t +. (Random.float 1.) in 
    let station_id = "S1" in {station_id; date = i; data = {temp_min; temp_max}} in 
  List.init random_event size 
