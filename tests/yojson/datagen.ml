module Y = Yojson.Basic 
module WeatherData = struct 
  (* Temperature in Celsius 2.d.p as integer *)
  type t = {
    temp_min : int;
    temp_max : int; 
  } 
  let of_json = function 
    | `Assoc [("temp_min", `Int imin); ("temp_max", `Int imax)] -> {temp_min = imin; temp_max = imax}
    | _ -> assert false
  let to_json {temp_min; temp_max} = `Assoc [("temp_min", `Int temp_min); ("temp_max", `Int temp_max)]
  let to_string t = Printf.sprintf "(min %f, max %f)" ((float_of_int t.temp_min) /. 100.) ((float_of_int t.temp_max) /. 100.)
end 

type station_record = {
  station_id : string;
  state : status;
  date : int; 
  data : WeatherData.t;
}        
and status = Idle of int | Failure of string | Collecting of int | Maintenance of int  

let pi = 3.14159
let _ = Random.init 85

(* A simple temperature model for a 24hr period *)
let temp_gen t mean = 
  7.5 *. sin((pi /. 12.) *. (t -. 6.)) +. mean

(* Extract average of min.max temp *)
let average_temp (s : station_record) = 
  (s.data.temp_min + s.data.temp_max) / 2

(* Data sensor state to JSON string *) 
let state_to_json = function 
  | Idle t -> `Assoc [("IDLE", `Int t)]
  | Failure s -> `Assoc [("FAILURE", `String s)]
  | Collecting t -> `Assoc [("COLLECTING", `Int t)]
  | Maintenance t -> `Assoc [("MAINTENANCE", `Int t)]

(* Data sensor status of strings *)
let state_of_json = function 
  | `Assoc [("IDLE", `Int t)] -> Idle t 
  | `Assoc [("FAILURE", `String s)] -> Failure s 
  | `Assoc [("COLLECTING", `Int t)] -> Collecting t 
  | `Assoc [("MAINTENANCE", `Int t)] -> Maintenance t
  | _ -> Failure "Failed parsing status of sensor"

(* Converts a station_record to json *)
let to_json {station_id; state; date; data} = 
  `Assoc
    [("station_id",`String station_id); 
      ("state", state_to_json state);
      ("date", `Int date);
      ("data", WeatherData.to_json data)
    ]

let rec find x compare = function 
  | [] -> raise (Failure ("Couldn't find " ^ x))
  | (k, v) :: lst -> if compare x k then v else find x compare lst  

let of_json = function 
  | `Assoc lst -> {
    station_id = Y.Util.to_string @@ find "station_id" String.equal lst;
    state = state_of_json @@ find "state" String.equal lst;
    date = Y.Util.to_int @@ find "date" String.equal lst; 
    data = WeatherData.of_json @@ find "data" String.equal lst
  }
  | _ -> raise (Failure "Expect assoc list")

(* Int to state *)
let int_to_state = function 
  | 0 -> Idle (Random.int 24)
  | 1 -> Failure "network error" 
  | 2 -> Collecting (Random.int 24)
  | 3 -> Maintenance (Random.int 24)
  | _ -> assert false 

(* Makes a large list of station_records *)
let make size = 
  let random_event i = 
    let t = temp_gen (float_of_int i) 10. in
    let temp_min = int_of_float ((t -. (Random.float 1.)) *. 100.) in 
    let temp_max = int_of_float ((t +. (Random.float 1.)) *. 100.) in
    let state = Random.int 4 |> int_to_state in 
    let station_id = "S1" in {station_id; state; date = i; data = {temp_min; temp_max}} in 
  List.init size random_event 
