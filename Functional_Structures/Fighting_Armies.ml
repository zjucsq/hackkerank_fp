type 'a tree =
  | Empty
  | Node of int * 'a * 'a tree * 'a tree

let cmp a b = a > b

let rank = function
  | Empty -> 0
  | Node (r, _, _, _) -> r

let value = function
| Empty -> 0
| Node (_, v, _, _) -> v

let make_node x a b =
  if rank a >= rank b then
    Node (rank b + 1, x, a, b)
  else
    Node (rank a + 1, x, b, a)

let rec merge a b =
  match a, b with
  | Empty, t | t, Empty -> t
  | Node(_, x, a1, b1), Node(_, y, a2, b2) ->
      let tmp = if cmp x y then make_node x a1 (merge b1 b) else make_node y a2 (merge b2 a) in 
      match tmp with
      | Empty -> assert false
      | Node(r, v, aa, bb) -> 
        let nr = max (rank aa) (rank bb) in
        if rank aa < rank bb then
          Node(nr, v, bb, aa)
        else
          Node(nr, v, aa, bb)

let add x a =
  merge (make_node x Empty Empty) a

let top = function
  | Empty -> raise Not_found
  | Node(_, x, a, b) -> x

let delete = function
  | Empty -> raise Not_found
  | Node(_, x, a, b) -> merge a b

let () = 
  let n, q = Scanf.scanf "%d %d" (fun a b -> a, b) in 
  let armies = Array.make (n + 1) Empty in
  for i = 1 to q do 
    let t = Scanf.scanf "\n%d " (fun a -> a) in 
    let a, b = if t = 3 || t = 4 then Scanf.scanf "%d %d" (fun a b -> a, b) else Scanf.scanf "%d" (fun a -> a, 0) in 
    if t = 1 then 
      Printf.printf "%d\n" (value armies.(a))
    else if t = 2 then 
      armies.(a) <- delete armies.(a)
    else if t = 3 then
      armies.(a) <- add b armies.(a)
    else if t = 4 then 
      armies.(a) <- merge armies.(a) armies.(b)
  done;
;;