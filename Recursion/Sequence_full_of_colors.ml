let f s = 
  let rec f_rec s idx r g y b = 
    if String.length s = idx then 
      r = g && y = b
    else
      if r > g + 1 || r < g - 1 then 
        false
      else if y > b + 1 || y < b - 1 then 
        false
      else if s.[idx] = 'R' then
        f_rec s (idx + 1) (r + 1) g y b
      else if s.[idx] = 'G' then
        f_rec s (idx + 1) r (g + 1) y b
      else if s.[idx] = 'Y' then
        f_rec s (idx + 1) r g (y + 1) b
      else if s.[idx] = 'B' then
        f_rec s (idx + 1) r g y (b + 1)
      else 
        assert false
  in let b = f_rec s 0 0 0 0 0 in
  if b then
    print_endline "True"
  else
    print_endline "False"
;;

let () = 
  let t = read_int () in
  for i = 1 to t do 
    let s = read_line () in
    f s
  done
;;