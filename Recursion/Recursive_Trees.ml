let build_tree n output = 
  let rec build_tree_rec n output cur_n start_i start_j = 
    if cur_n <= n then
      let len = 32 lsr cur_n in 
      for i = 0 to len - 1 do
        output.(start_i - i).(start_j) <- '1';
        output.(start_i - len - i).(start_j - i - 1) <- '1';
        output.(start_i - len - i).(start_j + i + 1) <- '1';
      done;
      build_tree_rec n output (cur_n + 1) (start_i - 2 * len) (start_j - len);
      build_tree_rec n output (cur_n + 1) (start_i - 2 * len) (start_j + len)
  in build_tree_rec n output 1 62 49 

let print_char_martix output = 
  Array.iter (fun lst -> Array.iter (fun c -> print_char c) lst; print_endline "") output

let () = 
  let n = read_int() in 
  let output = Array.make_matrix 63 100 '_' in 
  build_tree n output;
  print_char_martix output
;;

  