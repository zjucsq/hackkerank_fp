let rec pow x n = 
  if n == 0 then
    1
  else 
    x * pow x (n - 1)
;;

let f x n = 
  let rec f_rec x n max_base = 
    (* Printf.printf "call f(%d,%d,%d)" x n max_base; *)
    if x < 0 then
      0
    else if x = 0 then
      1
    else
      let ret = ref 0 in
      for i = max_base - 1 downto 1 do
        ret := !ret + f_rec (x - (pow i n)) n i
      done;
      !ret
  in f_rec x n (int_of_float(sqrt(float_of_int x))+1)
;;

let () =
  let x = read_int() in 
  let n = read_int() in 
  let res = f x n in 
  print_int res
;;
