(* ocamlfind ocamlc -package base -linkpkg -o Tree_manager Tree_manager.ml *)
(* open Base;; *)

type 'a node = {
  mutable value : 'a;
  father : 'a node option;
  mutable children : 'a node list;
};;

let print_address obj =
  let addr = Obj.repr obj in
  Printf.printf "Address: %x\n" (Obj.magic addr : int);;

let eq node1 node2 = node1 == node2;;

let change_value node new_value = node.value <- new_value;;

let print node = 
  print_endline (string_of_int node.value);;

let create_node value father children =
  { value; father; children };;

let visit_parent node = 
    match node.father with
  | Some v -> v
  | None -> failwith "No parent node";;

let get_option_value option =
  match option with
  | Some value -> value
  | None -> raise (Invalid_argument "Option.get_option_value");;

let findi lst obj = 
  let rec findi_impl lst obj idx = 
    match lst with
    | [] -> None
    | hd :: tl -> 
      if eq hd obj then 
        Some idx 
      else 
        findi_impl tl obj (idx + 1)
  in findi_impl lst obj 0;;
  
let visit_left node = 
  let fa = visit_parent node in 
  let idx = findi fa.children node |> get_option_value in 
  List.nth fa.children (idx - 1);;

let visit_right node = 
  let fa = visit_parent node in 
  let idx = findi fa.children node |> get_option_value in 
  List.nth fa.children (idx + 1);;

let visit_child node n = List.nth node.children (n - 1);;

let rec insert_before obj new_obj lst =
  match lst with
  | [] -> []
  | hd :: tl ->
    if eq hd obj then
      new_obj :: hd :: tl
    else
      hd :: insert_before obj new_obj tl;;

let rec insert_after obj new_obj lst = 
  match lst with
  | [] -> []
  | hd :: tl ->
    if eq hd obj then
      hd :: new_obj :: tl
    else
      hd :: insert_after obj new_obj tl;;

let insert_left node x = 
  let fa = visit_parent node in 
  fa.children <- insert_before node (create_node x node.father []) fa.children;;

let insert_right node x = 
  let fa = visit_parent node in 
  fa.children <- insert_after node (create_node x node.father []) fa.children;;

let insert_child node x = node.children <- (create_node x (Some node) []) :: node.children;;

let rec delete_in_list obj lst = 
  match lst with
  | [] -> []
  | hd :: tl ->
    if eq hd obj then
      tl
    else
      hd :: delete_in_list obj tl;;

let delete node = 
  let fa = visit_parent node in 
  fa.children <- delete_in_list node fa.children;
  fa;;

let () = 
  let n = read_int() in 
  let it_node = ref (create_node 0 None []) in
  let f () = 
    let tmp = read_line() |> String.split_on_char ' ' in 
    match tmp with 
    | [x] -> 
      if x = "print" then 
        print !it_node
      else if x = "delete" then 
        it_node := delete !it_node
    | [x; y] ->
      if x = "change" then 
        change_value !it_node (int_of_string y)
      else if x = "visit" then
        if y = "left" then 
          it_node := visit_left !it_node
        else if y = "right" then 
          it_node := visit_right !it_node
        else if y = "parent" then 
          it_node := visit_parent !it_node
    | [x; y; z] ->
      let value = int_of_string z in
      if x = "visit" then 
        it_node := visit_child !it_node value
      else if x = "insert" then
        if y = "left" then 
          insert_left !it_node value
        else if y = "right" then 
          insert_right !it_node value
        else if y = "child" then 
          insert_child !it_node value
      | _ -> ()
  in
  for i = 1 to n do 
    f ()
  done;
;;