let modulus = 1000000007

let isdigit c = '0' <= c && c <= '9'

let inv x =
  let rec f r x n =
    if n = 0 then
      r
    else
      let x' = Int64.(rem (mul x x) (of_int modulus)) in
      if n mod 2 = 0 then
        f r x' (n/2)
      else
        f Int64.(rem (mul r x) (of_int modulus)) x' (n/2)
  in
  f 1L x (modulus-2)

let () =
  while true do
  let a = read_line () in
  let isp_tbl = Hashtbl.create 10 in
  let icp_tbl = Hashtbl.create 10 in
  List.iter (fun (c,x) -> Hashtbl.replace isp_tbl c x)
    ['\x00',0; '(',1; '+',3; '-',3; '*',5; '/',5; '=',7; '_',7];
  List.iter (fun (c,x) -> Hashtbl.replace icp_tbl c x)
    ['\x00',0; ')',1; '+',4; '-',4; '*',6; '/',6; '(',9; '=',8; '_',8];

  let n = String.length a in
  let rec go st ops vs i =
    if i < n && isdigit a.[i] then
      let rec f x i =
        if i < n && isdigit a.[i] then
          f (x*10+int_of_char a.[i]-48) (i+1)
        else
          x, i
      in
      let x, i = f 0 i in
      go false ops (x::vs) i
    else
      let ic = if i = n then '\x00' else a.[i] in
      let ic =
        if st && ic = '+' then
          '='
        else if st && ic = '-' then
          '_'
        else
          ic
      in
      try
        let icp = Hashtbl.find icp_tbl ic in
        let rec pop_go (op::ops' as ops) vs =
          if Hashtbl.find isp_tbl op > icp then
            match op with
            | '=' ->
                pop_go ops' vs
            | '_' ->
                let x::vs' = vs in
                pop_go ops' @@ (modulus-x) mod modulus::vs'
            | '+' ->
                let y::x::vs' = vs in
                pop_go ops' @@ (x+y) mod modulus::vs'
            | '-' ->
                let y::x::vs' = vs in
                pop_go ops' @@ (x-y+modulus) mod modulus::vs'
            | '*' ->
                let y::x::vs' = vs in
                pop_go ops' @@ Int64.(rem (mul (of_int x) (of_int y)) (of_int modulus) |> to_int)::vs'
            | '/' ->
                let y::x::vs' = vs in
                pop_go ops' @@ Int64.(rem (mul (of_int x) (of_int y |> inv)) (of_int modulus) |> to_int)::vs'
          else
            ops, vs
        in
        let (op::ops' as ops), vs = pop_go ops vs in
        if Hashtbl.find isp_tbl op = icp then (
          if ic = '\x00' then
            List.hd vs
          else
            go false ops' vs (i+1)
        ) else
          go true (ic::ops) vs (i+1)
      with Not_found ->
        go st ops vs (i+1)
  in
  Printf.printf "%d\n" @@ go true ['\x00'] [] 0
  done;


(* 
这段OCaml代码是一个简单的计算器实现。它读取一行输入，并使用运算符优先级算法计算表达式的结果。

代码中定义了两个哈希表isp_tbl和icp_tbl，分别用于存储运算符的栈内优先级(isp)和栈外优先级(icp)。然后，通过循环遍历字符，将字符与对应的优先级存储到哈希表中。

go函数是使用递归实现的主要计算逻辑。它采用四个参数：st(标识栈顶的运算符是否为一元运算符)，ops(运算符栈)，vs(操作数栈)，i(字符索引)。

在每次迭代中，首先检测当前字符是否为数字，如果是，则连续读取数字并将其转换为整数，然后将其压入操作数栈vs中。如果不是数字，则将字符视为运算符。

接下来，根据栈内优先级和栈外优先级比较规则，通过不断弹出运算符栈中的运算符和操作数栈中的操作数，进行相应的计算，直到满足优先级条件或运算符栈为空。

最后，根据计算结果返回或继续迭代。

最后一行代码将最终的计算结果打印出来。

所以，这段OCaml代码的作用是实现一个简单的计算器，可以对输入的表达式进行计算并输出结果。 
*)
