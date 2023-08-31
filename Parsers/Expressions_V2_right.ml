(* 
Expression ::= Term [+-] Expression | Term 
Term       ::= Factor [*/] Term | Factor
Factor     ::= Number | [+-] Factor | '(' Expression ')' 
*)

module Math = struct
  let m = 1000000007
  let pos_mod n m = ((n mod m) + m) mod m 
  let (%%) = pos_mod
  let rec qpow a n m = 
    if n = 0 then 
      1
    else 
      let half = qpow a (n lsr 1) m in 
      if (n land 1) = 0 then 
        (half * half) %% m 
      else 
        (((half * half) %% m) * a) %% m
  let rec qpow_tail res a n m = 
    if n = 0 then 
      res
    else 
      let new_a = (a * a) %% m in
      if (n land 1) = 0 then 
        qpow_tail res new_a (n / 2) m
      else 
        qpow_tail ((res * a) %% m) new_a (n / 2) m
  let reciprocal n m = qpow_tail 1 n (m - 2) m
end

type input_t = string * int

let get_input_string = function (s, i) -> s
let get_input_int = function (s, i) -> i
let to_string t = String.sub (get_input_string t) (get_input_int t) (String.length (get_input_string t) - (get_input_int t))

type token = 
  | INTEGER of int 
  | OP of char

exception MyException of string
let get_int_value = function INTEGER i -> i | OP _ -> raise (MyException "Not INT")
let get_op_value = function INTEGER _ -> raise (MyException "Not OP") | OP c -> c

module ParserResult = struct
  type 'a t = 
    | Success of 'a * input_t
    | Fail of string * input_t

  let (>>=) v f: 'a t = match v with
    | Success(x, i) -> f(x, i)
    | Fail(e, i) -> Fail(e, i)
end

open ParserResult

type 'a parser = input_t -> 'a ParserResult.t

let char_at str index = if index < String.length str then str.[index] else Char.chr 255
let take_char ((input, index): input_t): (char * input_t) = (char_at input index, (input, index + 1))

let gen_char_parser (f: char -> bool) (desc: string): 'a parser = fun input -> match take_char input with
  | (c, i) -> 
    if c = Char.chr 255 then 
      Fail("not enough input", input)
    else if f(c) then
      Success(OP c, i)
    else
      Fail("not a valid " ^ desc, input)

let is_alpha = function 'a' .. 'z' | 'A' .. 'Z' -> true | _ -> false
let is_digit = function '0' .. '9' -> true | _ -> false
let is_whitespace = function ' ' | '\t' | '\n' | '\r' -> true | _ -> false

let digit_parser = gen_char_parser is_digit "digit"
let char_parser = gen_char_parser is_alpha "alphabet"
let white_parser = gen_char_parser is_whitespace "whitespace"
let onechar_parser c = gen_char_parser (fun x -> x == c) (String.make 1 c)
let addop_parser = onechar_parser '+'
let subop_parser = onechar_parser '-'
let mulop_parser = onechar_parser '*'
let divop_parser = onechar_parser '/'
let lptop_parser = onechar_parser '('
let rptop_parser = onechar_parser ')'

let andThen (p1: 'a parser) (p2: 'b parser): ('a * 'b) parser = fun input ->
  p1 input >>= fun (r1, i1) -> p2 i1 >>= fun (r2, i2) -> Success((r1, r2), i2)
let orElse (p1: 'a parser) (p2: 'a parser): 'a parser = fun input -> 
  match p1 input with Success(r1, i1) -> Success(r1, i1) | Fail _ -> p2 input
let many (p: 'a parser): 'a list parser = fun input -> 
  let rec loop acc input = match p input with
    | Success(r, i) -> loop (r :: acc) i
    | Fail _ -> (List.rev acc, input) in
  let (r, i) = loop [] input in
  Success(r, i)
let many1 p = andThen p @@ many p
let optional p = fun input -> match p input with 
  | Fail _ -> Success(None, input)
  | Success(r, i) -> Success(Some r, i)
let (>>.) p q = fun input -> match andThen p q input with
  | Success((_, r2), i) -> Success(r2, i)
  | Fail(e, i) -> Fail(e, i)
let (>>) = andThen 
let (||.) = orElse

let lptop_parser: token parser = many white_parser >>. lptop_parser
let rptop_parser: token parser = many white_parser >>. rptop_parser
let addsub_parser = orElse addop_parser subop_parser
let muldiv_parser = orElse mulop_parser divop_parser
let number_parser: token parser = fun input -> many1 digit_parser input >>= fun ((r, r_l), i) -> Success(INTEGER (int_of_string ((String.make 1 (get_op_value r)) ^ (String.concat "" (List.map (fun c -> String.make 1 (get_op_value c)) r_l)))), i)
let addsub_parser: token parser = many white_parser >>. addsub_parser
let muldiv_parser: token parser = many white_parser >>. muldiv_parser
let number_parser: token parser = many white_parser >>. number_parser

let rec expr_parser: token parser = fun input -> (term_parser >> many(addsub_parser >> term_parser)) input >>= fun (r, i) -> match r with
  | (INTEGER n1, ls) -> 
    (* let _ = Printf.printf "expr: %s\n" (to_string i) in *)
    let rec cal ret ls = 
      match ls with
      | [] -> ret
      | (token_c, token_n) :: tl -> 
        let c = get_op_value token_c in 
        let n = get_int_value token_n in
        cal (if c = '+' then ret + n else -(ret + n)) tl
    in let ret = n1 + cal 0 (List.rev ls) 
    in Success(INTEGER (Math.pos_mod ret Math.m), i)
  | _ -> Fail("not a valid expr", i)
and term_parser: token parser = fun input -> (factor_parser >> many(muldiv_parser >> factor_parser)) input >>= fun (r, i) -> match r with
  | (INTEGER n1, ls) -> 
    (* let _ = Printf.printf "term: %s\n" (to_string i) in *)
    (* let _ = List.iter (fun (op, v) -> Printf.printf "%c %d\n" (get_op_value op) (get_int_value v)) ls in *)
    let rec cal ret ls = 
      match ls with
      | [] -> ret
      | (token_c, token_n) :: tl -> 
        let c = get_op_value token_c in 
        let n = get_int_value token_n in 
        let cur_ret = Math.pos_mod (if c = '*' then (ret * n) else Math.reciprocal ((ret * n) mod Math.m) Math.m) Math.m in
        (* Printf.printf "%d " cur_ret; *)
        cal cur_ret tl
    in let ret = n1 * cal 1 (List.rev ls) 
    in Success(INTEGER (Math.pos_mod ret Math.m), i)
  | _ -> Fail("not a valid term", i)
and factor_parser: token parser = fun input -> (number_parser ||. addsub_parser ||. lptop_parser) input >>= fun (r, i) -> match r with
  | INTEGER n -> Success(INTEGER n, i)
  | OP o -> 
    if o = '+' || o = '-' then 
      factor_parser i >>= fun (r1, i1) -> match r1 with 
        | INTEGER n1 -> if o = '+' then Success(INTEGER n1, i1) else Success(INTEGER (-n1), i1)
        | _ -> Fail("factor return token without int type", i)
    else if o = '(' then 
      (expr_parser >> rptop_parser) i >>= fun (r2, i2) -> match r2 with 
        | (INTEGER n2, OP ')') -> Success(INTEGER n2, i2)
        | (INTEGER _, OP _) -> Fail("Cannot get a )", i2)
        | _ -> Fail("expr return token without int type", i)
    else
      Fail("factor return a char not in +, -, (", i)
    
let () = 
  (* while true do *)
  let s = read_line() in 
  let input = (s, 0) in 
  let res = expr_parser input in
  match res with
    | Success(r, i) -> Printf.printf "%d\n" (get_int_value r)
    | Fail(e, i) -> Printf.printf "%s\n" e
  (* done; *)
;;

(* 65*91+87/97+(2/1)-(64*(15+20)/32-(55-37+44*26-20-(18/7*10*36/(20/(15+3/58)+21/85)+91*80+43)-50+94-62+70)+90*26-84/69)-3*82*43+(18+14*62*44-65*54*92*22)-100*39+23*11*(40*(91+35)-(65+50+(32+86+68)*12/83-50*(85+51*(13-(48/51/18)/9/98*68/(8+(90-60)/65+65+1+31+49+49+37)/98+85+42-65/14)+81+100/41)*54)*14*51)-49+68/16/53-83-78/27/10 *)