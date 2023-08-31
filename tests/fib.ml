(* ocamlfind ocamlc -package core -linkpkg -o fib fib.ml *)
open Core;;

let time f =
  let start = Time.now () in
  let x = f () in
  let stop = Time.now () in
  printf "Time: %F ms\n" (Time.diff stop start |> Time.Span.to_ms);
  x;;

let memoize m f =
  let memo_table = Hashtbl.create m in
  (fun x ->
     Hashtbl.find_or_add memo_table x ~default:(fun () -> f x));;

let rec fib i =
  if i <= 1 then i else fib (i - 1) + fib (i - 2);;

let fib = memoize (module Int) fib;;

let () = 
  let n = time (fun() -> fib 40) in
  print_endline ("res: " ^ (string_of_int n))
;;
