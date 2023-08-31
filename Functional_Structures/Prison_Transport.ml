module UnionFind  = struct
  type uf = {
    fa: int array;
    count: int;
  }

  let create n = { fa = Array.make (n + 1) (-1); count = n; }

  let rec find uf x = 
    if uf.fa.(x) < 0 then 
      x 
    else (
      uf.fa.(x) <- find uf uf.fa.(x);
      uf.fa.(x)
    )

  let union uf x y = 
    let rx = find uf x in 
    let ry = find uf y in 
    if rx <> ry then
      let nx = uf.fa.(rx) in 
      let ny = uf.fa.(ry) in 
      if nx > ny then (
        uf.fa.(rx) <- ry;
        uf.fa.(ry) <- nx + ny 
      ) else (
        uf.fa.(ry) <- rx;
        uf.fa.(rx) <- nx + ny 
      )

  let father uf x = uf.fa.(x)

  let size uf x = -uf.fa.(find uf x)
end  

let sqrt_ceil n =
  let r = int_of_float(sqrt(float_of_int n)) in
  if r * r < n then r + 1 else r

let () = 
  let n = read_int() in 
  let m = read_int() in 
  let uf = UnionFind.create n in 
  for i = 1 to m do 
    let tmp = read_line() |> String.split_on_char ' ' |> List.map int_of_string in 
    let p = List.hd tmp in 
    let q = List.nth tmp 1 in
    (* let p, q = Scanf.scanf "%d %d\n" (fun a b -> a, b) in  *)
    UnionFind.union uf p q;
  done;
  let res = ref 0 in
  for i = 1 to n do
    let size = -UnionFind.father uf i in
    if size > 0 then 
      res := !res + sqrt_ceil size
  done;
  Printf.printf "%d\n" !res
