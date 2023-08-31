class segment_tree (arr : int array) =
  let n = Array.length arr in
  let tree = Array.make (4 * n) 0 in

  let rec build_tree node start stop =
    if start = stop then
      tree.(node) <- arr.(start)
    else
      let mid = (start + stop) / 2 in
      let left_child = 2 * node + 1 in
      let right_child = 2 * node + 2 in
      build_tree left_child start mid;
      build_tree right_child (mid + 1) stop;
      tree.(node) <- min tree.(left_child) tree.(right_child)
  in

  let rec query_range_min node start stop range_start range_stop =
    if range_start > stop || range_stop < start then
      max_int
    else if range_start <= start && range_stop >= stop then
      tree.(node)
    else
      let mid = (start + stop) / 2 in
      let left_child = 2 * node + 1 in
      let right_child = 2 * node + 2 in
      let left_min = query_range_min left_child start mid range_start range_stop in
      let right_min = query_range_min right_child (mid + 1) stop range_start range_stop in
      min left_min right_min
  in

  let rec update_index node start stop index value =
    if start = stop then
      tree.(node) <- value
    else
      let mid = (start + stop) / 2 in
      let left_child = 2 * node + 1 in
      let right_child = 2 * node + 2 in
      if index <= mid then
        update_index left_child start mid index value
      else
        update_index right_child (mid + 1) stop index value;
      tree.(node) <- min tree.(left_child) tree.(right_child)
  in

  object
    initializer
      build_tree 0 0 (n - 1)
    
    method query_min range_start range_stop =
      query_range_min 0 0 (n - 1) range_start range_stop
    
    method update index value =
      update_index 0 0 (n - 1) index value
  end


let () = 
  let t = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
  let n, m = (List.nth t 0), (List.nth t 1) in 
  let arr = read_line() |> String.split_on_char ' ' |> List.map int_of_string |> Array.of_list in 
  let s = new segment_tree arr in 
  for i = 1 to m do 
    let t = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
    let l, r = (List.nth t 0), (List.nth t 1) in 
    let res = s#query_min l r in 
    print_endline (string_of_int res)
  done;
;;
    