
module WeatherData = struct 
  type t = {
    temp_min : float;
    temp_max : float; 
  } 
  let to_json {temp_min; temp_max} = `Assoc [("temp_min", `Float temp_min); ("temp_max", `Float temp_max)]
  let to_string t = Printf.sprintf "(min %f, max %f)" t.temp_min t.temp_max
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

(* Data sensor state to JSON string *) 
let state_to_json = function 
  | Idle t -> `String ("idle for " ^ (string_of_int t) ^ " minutes") 
  | Failure s -> `String ("failure - cause: " ^ s)  
  | Collecting t -> `String ("collecting: " ^ (string_of_int t) ^ " minutes") 
  | Maintenance t -> `String ("maintenance period:  " ^ (string_of_int t) ^ " minutes")

(* Converts a station_record to json *)
let to_json {station_id; state; date; data} = 
    `Assoc
      [("station_id",`String station_id); 
       ("status", state_to_json state);
       ("date", `Int date);
       ("data", WeatherData.to_json data)
      ]

let rec find x compare = function 
  | [] -> None 
  | (k, v) :: lst -> if compare x k then Some v else find x compare lst  

let replace_if_none = 

let of_json = function 
  | `Assoc lst -> {
    station_id = find "station_id" String.equal lst;
    state = 
  }

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
    let temp_min = t -. (Random.float 1.) in 
    let temp_max = t +. (Random.float 1.) in
    let state = Random.int 4 |> int_to_state in 
    let station_id = "S1" in {station_id; state; date = i; data = {temp_min; temp_max}} in 
  List.init size random_event 
