let print_str s l r = 
  print_int (r - l + 1);
  print_string " ";
  for i = l to r do
    print_char s.[i];
  done;
  print_endline " ";;

let f x y = 
  let rec f_rec x y idx = 
    if String.length x = idx || String.length y = idx then
      idx - 1
    else
      if x.[idx] = y.[idx] then
        f_rec x y (idx + 1)
      else
        idx - 1
  in 
  let left = f_rec x y 0 in
    print_str x 0 left;
    print_str x (left + 1) (String.length x - 1);
    print_str y (left + 1) (String.length y - 1);;

let () = 
  let x = read_line() in
  let y = read_line() in
  f x y