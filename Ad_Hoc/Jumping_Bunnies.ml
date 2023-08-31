let rec gcd a b = if b = 0 then a else gcd b (a mod b)

(* Cannot a * b / (gcd a b), may overflow *)
let lcm a b = a / (gcd a b) * b

let () = 
  let _ = read_int () in 
  let speeds = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
  let res = List.fold_left lcm 1 speeds in 
  print_int res
;;
