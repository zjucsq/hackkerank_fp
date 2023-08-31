let rec gcd a b = if b = 0 then a else gcd b (a mod b)

let cnt n = 
  let ret = ref 0 in
  for i = 1 to n do
    if n mod i = 0 then
      ret := !ret + 1
  done;
  !ret

let () = 
  let t = read_int() in 
  for i = 1 to t do
    let input_list = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
    let a = List.hd input_list in
    let b = List.hd(List.tl input_list) in
    let c = gcd a b in 
    print_endline (string_of_int(cnt c))
  done
;;