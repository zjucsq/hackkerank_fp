module GlobalVariable = struct
  let cache = Hashtbl.create 100
end

let rec count n k = 
  try 
    let v = Hashtbl.find GlobalVariable.cache (n, k) in 
      v
  with 
    | Not_found ->
      if k = 0 || k = n then 
        (Hashtbl.add GlobalVariable.cache (n, k) 1;
        1)
      else
        (Hashtbl.add GlobalVariable.cache (n, k) ((count (n - 1) (k - 1) + count (n - 1) k) mod 100000007);
        Hashtbl.find GlobalVariable.cache (n, k))

let () = 
  let t = read_int() in 
  for i = 1 to t do
    let input_list = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
    let n = List.hd input_list in
    let k = List.hd(List.tl input_list) in
    let c = count n k in 
    print_endline (string_of_int(c))
  done
;;