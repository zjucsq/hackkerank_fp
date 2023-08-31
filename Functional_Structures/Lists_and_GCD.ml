let read_num () = 
  let l = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
  let htb = Hashtbl.create (List.length l) in 
  let rec make_htb ls = 
    match ls with
    | [] -> ()
    | k :: v :: tl ->
      Hashtbl.add htb k v;
      make_htb tl
    | _ -> failwith "Invalid input: list length is odd"
  in 
  make_htb l;
  htb
;;

let rec read_all q ret =
  match q with
  | 0 -> ret 
  | _ -> read_all (q - 1) (read_num() :: ret)
;;

let gcd htb1 htb2 = 
  let ret_htb = Hashtbl.create (Hashtbl.length htb1) in
  Hashtbl.iter (fun k v1 ->
    if Hashtbl.mem htb2 k then
      let v2 = Hashtbl.find htb2 k in 
      if v1 > v2 then 
        Hashtbl.add ret_htb k v2 
      else 
        Hashtbl.add ret_htb k v1 
  ) htb1;
  ret_htb
;;

let print_hashtbl_order ht =
  let sorted_keys = Hashtbl.fold (fun k _ acc -> k :: acc) ht [] |> List.sort compare in
  List.iter (fun k -> Printf.printf "%d %d " k (Hashtbl.find ht k)) sorted_keys
;;

let () = 
  let q = read_int () in 
  let input = read_all q [] in
  let hd = List.hd input in
  let tl = List.tl input in
  let final_htb = List.fold_left gcd hd tl in 
  print_hashtbl_order final_htb
;;