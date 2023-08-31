let rec print_list l = 
  match l with
  | [] -> ()
  | hd :: tl -> (print_int hd; print_char ' '; print_list tl)
;;

let f n = 
  let rec f_rec n prev_line = 
    if List.length prev_line = n + 1 then
      ()
    else
      begin
        print_list prev_line;
        print_endline " ";
        let line_no_head = List.tl prev_line in 
        let line_no_tail = List.rev (List.tl (List.rev prev_line)) in
        let tmp_line = List.map2 (fun a b -> a + b) line_no_head line_no_tail in 
        let new_line = 1 :: (tmp_line @ [1]) in 
        f_rec n new_line
      end
  in f_rec n [1]

let () = 
  let n = read_int () in 
  f n
;;