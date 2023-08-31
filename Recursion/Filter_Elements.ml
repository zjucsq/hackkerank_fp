let update_or_insert hashtable key =
  let current_value = 
    try Hashtbl.find hashtable key
    with Not_found -> 0
  in
  Hashtbl.replace hashtable key (current_value + 1)

let f a k = 
  let htl = Hashtbl.create 100 in 
  List.iter (update_or_insert htl) a;

  (* Hashtbl.iter (fun num count -> 
    if count <> 0 then Printf.printf "%d:%d " num count
  ) htl;print_endline ""; *)

  let filter = (fun key value -> if value >= k then Some value else None) in
  Hashtbl.filter_map_inplace filter htl;

  (* let size = Hashtbl.length htl in  *)
  let rec build_ret l ret = 
    match l with
    | [] -> ret
    | hd :: tl ->
      (try
        let _ = Hashtbl.find htl hd in
        match List.find_opt (fun x -> x = hd) ret with
        | None -> build_ret tl (hd :: ret)
        | Some _ -> build_ret tl ret
      with
        | Not_found -> build_ret tl ret)
  in List.rev (build_ret a [])
;;

let () = 
  let t = read_int() in 
  for i = 1 to t do
    let input_list = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
    let k = List.hd(List.tl input_list) in
    let a = read_line() |> String.split_on_char ' ' |> List.map int_of_string in
    let ret = f a k in 
    if List.length ret = 0 then 
      print_endline "-1"
    else 
      (List.iter (fun x -> Printf.printf "%d " x) ret;
      print_endline "")
  done
;;