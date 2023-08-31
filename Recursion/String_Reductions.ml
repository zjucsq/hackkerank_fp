let rec find c b = 
  match b with 
  | [] -> false
  | hd :: tl -> 
    if hd = c then 
      true
    else
      find c tl
;;

let f s = 
  let l = String.length s in
  let res = ref [] in 
  for i = 0 to l - 1 do 
    if not (find s.[i] !res) then 
      res := s.[i] :: !res
  done;
  List.rev !res
;;

let () = 
  let s = read_line () in
  let char_list = f s in
  (* print_int (List.length char_list); *)
  let str = String.concat "" (List.map (String.make 1) char_list) in
  print_endline str
;;