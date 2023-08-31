let init output = 
  for i = 0 to 31 do 
    for j = 0 to 62 do 
      if i + j <= 30 || j - i >= 32 then 
        output.(i).(j) <- '_'
    done;
  done;
;;

let build n output = 
  let rec build_rec n output cur_n start_i start_j = 
    if cur_n <= n then
      let len = 32 lsr cur_n in 
      for i = 0 to len - 1 do
        for j = 0 to i do
          output.(start_i - i).(start_j - j) <- '_';
          output.(start_i - i).(start_j + j) <- '_';
        done;
      done;
      build_rec n output (cur_n + 1) start_i (start_j - len);
      build_rec n output (cur_n + 1) start_i (start_j + len);
      build_rec n output (cur_n + 1) (start_i - len) start_j;
  in build_rec n output 1 31 31
;;

let print_char_martix output = 
  Array.iter (fun lst -> Array.iter (fun c -> print_char c) lst; print_endline "") output
;;

let () = 
  let n = read_int() in 
  let output = Array.make_matrix 32 63 '1' in 
  init output;
  build n output;
  print_char_martix output
;;
