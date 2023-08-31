let update_or_insert hashtable key =
  let current_value = 
    try Hashtbl.find hashtable key
    with Not_found -> 0
  in
  Hashtbl.replace hashtable key (current_value + 1)

let find_missing_numbers a b =
  let count_map = Hashtbl.create (List.length b) in
  List.iter (fun num -> update_or_insert count_map num) b;

  List.iter (fun num -> 
    let count = Hashtbl.find count_map num in
    Hashtbl.replace count_map num (count - 1)
  ) a;

  (* Hashtbl.iter (fun num count -> 
    if count <> 0 then Printf.printf "%d:%d " num count
  ) count_map; *)

  let missing_numbers = ref [] in
  Hashtbl.iter (fun num count -> 
    if count <> 0 then missing_numbers := num :: !missing_numbers
  ) count_map;

  List.sort compare !missing_numbers

let () =
  (* Fatal error: exception End_of_file in hackerrank
  let _ = Scanf.scanf "%d\n" (fun x -> x) in
  let a = Scanf.scanf "%[^\n]\n" (fun x -> List.map int_of_string (String.split_on_char ' ' x)) in *)

  let _ = read_int () in
  let a = read_line () |> String.split_on_char ' ' |> List.map int_of_string in
  let _ = read_int () in
  let b = read_line () |> String.split_on_char ' ' |> List.map int_of_string in

  let missing_nums = find_missing_numbers a b in
  List.iter (fun num -> Printf.printf "%d " num) missing_nums