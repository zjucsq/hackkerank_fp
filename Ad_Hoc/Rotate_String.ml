let f s = 
  let print s idx = 
    let len = String.length s in
    for i = idx to idx + len - 1 do
      print_char s.[i mod len]
    done;
    print_char ' '
  in let len = String.length s in
  for i = 1 to len do
    print s i
  done;
  print_endline ""
;;

let () = 
  let t = read_int () in
  for i = 1 to t do 
    let s = read_line () in
    f s
  done
;;