(* float的IO *)

let rec read_floats () =
  try let line = read_line () in
      float_of_string (line) :: read_floats()
  with
      End_of_file -> []

let f n = 
	let rec f_rec n res cur_term cur_value = 
    (* This problem only requires the first ten terms
    if cur_term = 10 then *)
		if cur_value < 0.00001 && cur_value > -0.00001 then
			res
		else
			let next_value = cur_value *. n /. (float_of_int cur_term) in
			f_rec n (res +. next_value) (cur_term + 1) (next_value)
	in f_rec n 1.0 1 1.0

let () =
  let _ = read_int() in
  let arr = read_floats() in
  let ans = List.map f arr in
  List.iter (fun x -> Printf.printf "%.4f\n" x) ans;;