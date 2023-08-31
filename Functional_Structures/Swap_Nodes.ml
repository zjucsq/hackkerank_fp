type 'a node = {
  mutable left : 'a;
  mutable right : 'a;
}

let create_node left right = { left = left; right= right }

let swap_tree tree k = 
  let q = Queue.create() in 
  Queue.add (1, 1) q;
  let rec traverse() = 
    if not (Queue.is_empty q) then
      let node, level = Queue.take q in
      if level mod k = 0 then
        tree.(node) <- create_node tree.(node).right tree.(node).left;
        (* let tmp = tree.(node).left in 
        let () = tree.(node).left <- tree.(node).right in 
        tree.(node).right <- tmp; *)
      if tree.(node).left <> -1 then Queue.add (tree.(node).left, level + 1) q;
      if tree.(node).right <> -1 then Queue.add (tree.(node).right, level + 1) q;
      traverse()
  in traverse()
;;

let print_tree_level tree = 
  let q = Queue.create() in 
  Queue.add 1 q;
  let rec traverse() = 
    if not (Queue.is_empty q) then
      let node = Queue.take q in
      Printf.printf "%d " node;
      if tree.(node).left <> -1 then Queue.add tree.(node).left q;
      if tree.(node).right <> -1 then Queue.add tree.(node).right q;
      traverse()
  in traverse();
  print_endline ""
;;

let print_tree_in tree = 
  let rec print_tree_in_impl tree node = 
    if tree.(node).left <> -1 then print_tree_in_impl tree tree.(node).left;
    Printf.printf "%d " node;
    if tree.(node).right <> -1 then print_tree_in_impl tree tree.(node).right;
  in
  print_tree_in_impl tree 1;
  print_endline ""
;;

let () = 
  let n = read_int() in
  let tree = Array.make (n + 1) (create_node (-1) (-1)) in 
  for i = 1 to n do 
    let tmp = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
    let l, r = List.hd tmp, List.hd(List.tl tmp) in 
    tree.(i) <- create_node l r
    (* Cannot do this, because all node in tree is pointer to same obj
    tree.(i).left <- l;
    tree.(i).right <- r; *)
  done;
  let t = read_int() in 
  for i = 1 to t do
    let k = read_int() in 
    swap_tree tree k;
    print_tree_in tree
  done;
