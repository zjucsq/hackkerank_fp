open Core
(* open Ecaml *)

let memoize m f =
  let memo_table = Hashtbl.create m in
  (fun x ->
     Hashtbl.find_or_add memo_table x ~default:(fun () -> f x));;

let rec fib i =
  print_endline ("call fib" ^ (string_of_int i));
  if i <= 1 then i else fib (i - 1) + fib (i - 2);;

let fib = memoize (module Int) fib;;

let () = 
  let n = fib 40 in
  Out_channel.output_string stdout (string_of_int n);
  print_endline "";;

(* let () = 
  print_endline "hello world";; *)