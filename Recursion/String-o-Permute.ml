let f () = 
  let b = Bytes.of_string(read_line ()) in 
  let l = Bytes.length b in 
  for i = 0 to l / 2 - 1 do
    let tmp = Bytes.get b (i * 2) in 
    Bytes.set b (i * 2) (Bytes.get b (i * 2 + 1));
    Bytes.set b (i * 2 + 1) tmp;
  done;
  print_endline (Bytes.to_string b)
;;

let () = 
  let t = read_int () in
  for i = 1 to t do 
    f ()
  done
;;