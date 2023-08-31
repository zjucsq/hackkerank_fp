type 'a tree = {
  value : 'a;
  children : 'a tree list;
}

let create_tree value children =
  { value; children }

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

let () = 
  let tree1 = create_tree "Node 1" [] in
  let tree2 = create_tree "Node 2" [] in 
  let tree3 = create_tree "Node 3" [tree1; tree2] in 
  let tree4 = create_tree "Node 4" [] in
  let tree5 = create_tree "Node 5" [tree4]in 
  let tree6 = create_tree "Node 6" [tree3; tree5] in
  print_tree_with_level tree6