let print_martix martix = Array.iter (fun arr -> Array.iter (fun x -> Printf.printf "%d " x) arr; Printf.printf "\n") martix;;

let rotate_layer layer_num matrix output_martix rotate_time = 
  let m, n = Array.length matrix, Array.length matrix.(0) in 
  let total_num = 2 * m + 2 * n - 4 * (2 * layer_num - 1) in 
  let true_rotate_time = rotate_time mod total_num in 
  let start_x, start_y = layer_num - 1, layer_num - 1 in 
  let count_target start_x start_y step = 
    let cm, cn = m - (2 * layer_num - 1), n - (2 * layer_num - 1) in 
    if step <= cm then 
      start_x + step, start_y 
    else if step <= cm + cn then 
      start_x + cm, start_y + (step - cm) 
    else if step <= 2 * cm + cn then 
      start_x + (2 * cm + cn - step), start_y + cn 
    else if step <= 2 * cm + 2 * cn then 
      start_x, start_y + (2 * cm + 2 * cn - step)
    else
      assert false 
  in
  for i = 0 to total_num - 1 do 
    let ox, oy = count_target start_x start_y i in 
    let tx, ty = count_target start_x start_y ((i + true_rotate_time) mod total_num) in 
    output_martix.(tx).(ty) <- matrix.(ox).(oy)
  done;
;;

let () = 
  let m, n, r = Scanf.scanf "%d %d %d\n" (fun a b c -> a, b, c) in 
  let martix = Array.make_matrix m n 0 in 
  for i = 0 to m - 1 do 
    for j = 0 to n - 1 do 
      martix.(i).(j) <- Scanf.scanf "%d " (fun x -> x)
    done;
  done;
  let cnt = (min m n) / 2 in 
  let output_martix = Array.make_matrix m n 0 in 
  for i = 1 to cnt do 
    rotate_layer i martix output_martix r 
  done;
  print_martix output_martix
;;

