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
      tree.(node) <- tree.(left_child) + tree.(right_child)
  in

  let rec query_range_sum node start stop range_start range_stop =
    if range_start > stop || range_stop < start then
      0
    else if range_start <= start && range_stop >= stop then
      tree.(node)
    else
      let mid = (start + stop) / 2 in
      let left_child = 2 * node + 1 in
      let right_child = 2 * node + 2 in
      let left_sum = query_range_sum left_child start mid range_start range_stop in
      let right_sum = query_range_sum right_child (mid + 1) stop range_start range_stop in
      left_sum + right_sum
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
      tree.(node) <- tree.(left_child) + tree.(right_child)
  in

  object
    initializer
      build_tree 0 0 (n - 1)
    
    method query_sum range_start range_stop =
      query_range_sum 0 0 (n - 1) range_start range_stop
    
    method update index value =
      update_index 0 0 (n - 1) index value
  end;;


class segment_tree (arr : int array) =
  let n = Array.length arr in
  let tree = Array.make (4 * n) 0 in
  let lazy_update = Array.make (4 * n) None in

  (* 构建线段树 *)
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

  (* 更新节点的懒惰标记 *)
  let update_lazy node value =
    lazy_update.(node) <- Some value
  in

  (* 使用懒惰标记更新节点和子节点的值 *)
  let rec propagate_lazy node start stop =
    match lazy_update.(node) with
    | None -> ()
    | Some value ->
      tree.(node) <- value;
      if start < stop then (
        let left_child = 2 * node + 1 in
        let right_child = 2 * node + 2 in
        update_lazy left_child value;
        update_lazy right_child value
      );
      lazy_update.(node) <- None
  in

  (* 查询区间最小值 *)
  let rec query_range_min node start stop range_start range_stop =
    propagate_lazy node start stop;
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

  (* 更新指定区间的值 *)
  let rec update_range node start stop range_start range_stop value =
    propagate_lazy node start stop;
    if range_start > stop || range_stop < start then
      ()
    else if range_start <= start && range_stop >= stop then
      update_lazy node value
    else
      let mid = (start + stop) / 2 in
      let left_child = 2 * node + 1 in
      let right_child = 2 * node + 2 in
      update_range left_child start mid range_start range_stop value;
      update_range right_child (mid + 1) stop range_start range_stop value;
      tree.(node) <- min tree.(left_child) tree.(right_child)
  in

  object
    (* 构造函数：构建线段树 *)
    initializer
      build_tree 0 0 (n - 1)

    (* 查询区间最小值 *)
    method query_min range_start range_stop =
      query_range_min 0 0 (n - 1) range_start range_stop

    (* 更新指定位置的值 *)
    method update index value =
      update_range 0 0 (n - 1) index index value

    (* 更新指定区间的值 *)
    method update_range range_start range_stop value =
      update_range 0 0 (n - 1) range_start range_stop value
  end
