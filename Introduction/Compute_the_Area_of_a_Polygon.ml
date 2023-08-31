(* 一行多个数字怎么处理 *)
(* 平面任意多边形求面积（凹多边形也行）
https://blog.csdn.net/lemongirl131/article/details/51130659
https://zhuanlan.zhihu.com/p/110025234 *)

let read_points n = 
  let rec read_points_r n ret = 
    if n <> 0 then 
      let line = read_line () in 
      let splitted = Str.split (Str.regexp " ") line in
      let int_list = List.map int_of_string splitted in
      read_points_r (n - 1) (int_list :: ret)
    else
      ret
  in read_points_r n []

let f p =
  let first = List.hd p in
  let triangle_area second third = 0.5 *. (float_of_int ((List.nth second 0 - List.nth first 0) * (List.nth third 1 - List.nth first 1) - (List.nth third 0 - List.nth first 0) * (List.nth second 1 - List.nth first 1))) in
  let remove_head_p = List.tl p in
  let remove_head_head_p = List.tl remove_head_p in
  let remove_head_tail_p = List.rev (List.tl (List.rev remove_head_p)) in
  let area_l = List.map2 triangle_area remove_head_tail_p remove_head_head_p in 
  abs_float(List.fold_left (+.) 0. area_l)

let () =
  let n = read_int() in
  let points = read_points n in 
  let res = f points in
  Printf.printf "%f\n" res
  