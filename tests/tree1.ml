type 'a tree = {
  value : 'a;
  mutable children : 'a tree list;
}

let create_tree value children =
  { value; children }

let add_child tree child = tree.children <- child :: tree.children; tree

let print_tree_with_level tree =
  let rec aux queue level =
    match queue with
    | [] -> ()
    | node :: rest ->
      Printf.printf "%s%s\n" (String.make (2 * level) ' ') node.value;
      List.iter (fun child -> aux (child :: rest) (level + 1)) node.children;
      aux rest level
  in
  aux [tree] 0

let print_address obj =
  let addr = Obj.repr obj in
  Printf.printf "Address: %x\n" (Obj.magic addr : int)

let () = 
  let tree1 = create_tree "Node 1" [] in
  let tree2 = create_tree "Node 2" [] in
  let tree3 = create_tree "Node 3" [tree1] in
  let root = create_tree "root" [tree3] in
  print_address tree3;
  print_tree_with_level tree1;
  print_tree_with_level tree2;
  print_tree_with_level tree3;
  print_tree_with_level root;
  let tree4 = add_child tree3 tree2 in
  print_address tree3;
  print_address tree4;
  print_tree_with_level tree3;
  print_tree_with_level tree4;
  print_tree_with_level root;
