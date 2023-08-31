let sum_str s = 
  let rec sum_rec s start sum = 
    (* Printf.printf "%s %d %d\n" s start sum; *)
    if start = String.length s then
      sum
    else
      sum_rec s (start + 1) (sum + int_of_char s.[start] - int_of_char '0')
  in sum_rec s 0 0
;;

let sum_int num = sum_str (string_of_int num);;

let rec f num = 
  if num >= 1 && num <= 9 then 
    num
  else 
    f (sum_int num)
;;

let () = 
  let tmp = read_line () |> String.split_on_char ' ' in
  let n, k = (List.hd tmp), int_of_string (List.nth tmp 1) in
  let r = k * (sum_str n) in
  let res = f r in
  print_int res
;;