let rec valid_bst preorder = 
  let n = List.length preorder in 
  if n = 0 || n = 1 then 
    true
  else
    let rval, lst = List.hd preorder, List.tl preorder in
    let rec split pivot left right = 
      match right with
        | [] -> (List.rev left, right)
        | hd :: tl -> 
          if hd < pivot then 
            split pivot (hd :: left) tl 
          else
            (List.rev left, right)
    in 
    let left, right = split rval [] lst in 
    let is_samll = List.map (fun x -> if x <= rval then 1 else 0) right in 
    let indicator = List.fold_left (+) 0 is_samll in 
    if indicator = 0 then 
      valid_bst left && valid_bst right
    else 
      false

let () = 
  let t = read_int() in 
  for i = 1 to t do 
    let _ = read_int() in 
    let preorder = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
    let res = valid_bst preorder in 
    if res then 
      print_endline "YES"
    else
      print_endline "NO"
  done;