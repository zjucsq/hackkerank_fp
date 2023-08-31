(* Area Under Curves and Volume of Revolving a Curve *)

let read_vals () = 
  let line = read_line () in 
  let splitted = Str.split (Str.regexp " ") (String.trim line) in
  List.map int_of_string splitted

let area cal_area coef exp left right = 
  let coef_de = List.map2 ( *) coef exp in
  let exp_de = List.map (fun x -> x - 1) exp in 


let () =
  let coef = read_vals() in
  let exp = read_vals() in
  let left = read_int() in
  let right = read_int() in
  let area = cal_area coef exp left right in
  let volume = cal_area coef exp left right in
  print_endline (string_of_float area);
  print_endline (string_of_float volume)
  