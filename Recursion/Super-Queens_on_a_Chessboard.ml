let f n = 
  let res = ref 0 in 
  let rec f_rec x_pos_list next_line n = 
    if n + 1 = next_line then 
      res := !res + 1
    else 
      

let () = 
  let n = read_int() in 
  let 