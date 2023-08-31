(* 
Sample Input

3
1
2
3
4
Sample Output

1
1
1
2
2
2
3
3
3
4
4
4 
*)

let rec read_lines () =
    try let line = read_line () in
        int_of_string (line) :: read_lines()
    with
        End_of_file -> [];;

let rec f n arr = 
    let rec g n num = 
        if n = 1 then 
            [num]
        else
            num :: g (n - 1) num in
    match arr with
        | [] -> []
        | [x] -> g n x
        | x :: rest -> g n x @ f n rest;;
 
let () =
    let n::arr = read_lines() in
    let ans = f n arr in
    List.iter (fun x -> print_int x; print_newline ()) ans;;