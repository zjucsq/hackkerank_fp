let take_while pred arr start is_forward =
  let rec aux count idx = 
    if idx >= 0 && idx < Array.length arr then 
      count
    else if pred arr.(idx) then
      if is_forward then
        aux (count + 1) (idx + 1)
      else
        aux (count + 1) (idx - 1)
    else
      count
  in
  aux 0 start
;;

class split_blocks (arr : int array) = 
  let len = Array.length arr in 
  let block_len = int_of_float(sqrt(float_of_int len)) in 
  let remainder = len mod block_len in
  let block_num = if remainder = 0 then len / block_len else len / block_len + 1 in 
  let data = Array.make_matrix block_num block_len 1000000009 in 
  let min_block = Array.make block_num 0 in

  let init =
    Array.iteri (fun idx value -> let b_id, b_idx = idx / block_len, idx mod block_len in data.(b_id).(b_idx) <- value) arr;
    Array.iteri (fun idx value -> min_block.(idx) <- Array.fold_left min 1000000009 value) data
  
  in 

  let count_middle idx minv = 
    0

  in 

  let count_other b_idx minv is_forward = 
    if min_block.(b_idx) >= minv then 
      block_len
    else
      take_while (fun x -> x >= minv) data.(b_idx) is_forward

  in

  let get_longest_subarray_impl idx minv maxv = 
    let b_id, b_idx = idx / block_len, idx mod block_len in 
    let s_idx, e_idx = b_id * block_len, b_id * block_len + block_len - 1 in
    let pred = (fun v -> v >= minv && v <= maxv) in
    let c1 = take_while pred data.(b_id) (b_idx + 1) true in 
    let c2 = take_while pred data.(b_id) (b_idx - 1) false in 
    let c3 = if c1 = block_len - b_idx - 1 then (take_while pred min_block (b_id + 1) true else 0 in
    let c4 = if c2 = b_idx then take_while pred min_block (b_id - 1) false else 0 in




  object
    initializer 
      init

    method get_longest_subarray d m = 
      get_longest_subarray_impl idx data.(d) data.(d) + m 

end;;

let () = 
  let _ = read_int() in 
  let arr = read_line() |> String.split_on_char ' ' |> List.map int_of_string |> Array.of_list in 
  let b = new split_blocks arr in
  let q = read_int() in 
  for i = 1 to q do 
    let t = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
    let d m = List.nth t 0, List.nth t 1 in 
    let res = b@get_longest_subarray d m in 
    print_endline (string_of_int res)
  done;
;;