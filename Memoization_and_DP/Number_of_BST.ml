module GlobalVariable = struct
  let cache = Array.make 1010 (-1)
end

let () = 
  GlobalVariable.cache.(0) <- 1;
  GlobalVariable.cache.(1) <- 1;
  GlobalVariable.cache.(2) <- 2
;;

let rec f n = 
  if GlobalVariable.cache.(n) != -1 then 
    GlobalVariable.cache.(n)
  else begin
    GlobalVariable.cache.(n) <- 0;
    for i = 0 to n - 1 do 
      GlobalVariable.cache.(n) <- (GlobalVariable.cache.(n) + (f i) * (f (n - i - 1)))
    done;
    GlobalVariable.cache.(n) <- GlobalVariable.cache.(n) mod 100000007;
    GlobalVariable.cache.(n)
  end
;;

let () =
  let t = read_int() in
  for i = 1 to t do
    let n = read_int() in 
    let res = f n in
    print_endline (string_of_int res)
  done
;;