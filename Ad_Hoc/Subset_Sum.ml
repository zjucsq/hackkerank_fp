
let () = 
  let n = read_int() in 
  let a = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
  let t = read_int() in 
  for 