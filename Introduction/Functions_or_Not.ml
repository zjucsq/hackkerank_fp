(* Functions or Not?
使用Str记得
ocaml str.cma sample4.ml *)

let read_int_trim () = int_of_string(String.trim(read_line()))

let read_points n = 
  let rec read_points_r n ret = 
    if n <> 0 then 
      let line = read_line () in 
      let splitted = Str.split (Str.regexp " ") (String.trim line) in
      let int_list = List.map int_of_string splitted in
      read_points_r (n - 1) (int_list :: ret)
    else
      ret
  in read_points_r n []

let rec has_duplicates p = 
  let rec has_duplicates_imp p cur =
    match p with
      | [] -> false
      | hd :: tl -> 
        if (List.hd cur) = (List.hd hd) then
          true
        else
          has_duplicates_imp (List.tl p) cur in
  match p with 
    | [] -> false
    | hd :: tl -> (has_duplicates_imp tl hd) || (has_duplicates tl)

let () =
  let t = read_int_trim() in
  for i = 1 to t do
    let n = read_int_trim() in
    let points = read_points n in 
    let res = has_duplicates points in
    if res = true then
      print_endline "NO"
    else
      print_endline "YES"
  done
  