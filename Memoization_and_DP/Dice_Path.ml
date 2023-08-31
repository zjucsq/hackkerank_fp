(* top face state:
1 3 6 4
5 3 2 4
6 3 1 4
2 3 5 4 *)

let precalculate m n = 
  let top = [|[|1;3;6;4|];[|5;3;2;4|];[|6;3;1;4|];[|2;3;5;4|]|] in
  let cache = Array.make_matrix m n 0 in
  let cal cm cn = 
    if cm = 0 && cn = 0 then
      cache.(cm).(cn) <- 1;
    if cm > 0 then 
      cache.(cm).(cn) <- max cache.(cm).(cn) (cache.(cm-1).(cn) + top.(cm mod 4).(cn mod 4));
    if cn > 0 then
      cache.(cm).(cn) <- max cache.(cm).(cn) (cache.(cm).(cn-1) + top.(cm mod 4).(cn mod 4));
  in
  for i = 0 to m-1 do
    for j = 0 to n-1 do
      cal i j 
    done;
  done;
  cache
;; 

let () = 
  let cache = precalculate 60 60 in
  let t = read_int() in 
  for i = 1 to t do
    let input_list = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
    let m = List.hd input_list in
    let n = List.hd(List.tl input_list) in
    print_endline (string_of_int(cache.(m-1).(n-1)))
  done
;;