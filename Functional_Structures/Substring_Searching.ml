(* 
7
paddthceqirlndjpojjpsodmrohzjkexocqdhpdy
lhtixjeaiybwzpgqeuujaxkwablyyzdntuevhjlj
utkibcybixucoglcnjjlcoocdikaplizbgapbhity
utkibcybixucoglcnjjlcoo
shpxozhkbnzhhycaqojoctjmcejskpufpehrcar
caqojoc
mzsiahlihrabgbdtyqhcwdoramscbxysdzqanuiiswpvryscs
wwuryvxljfggbnxscimmgebsmzvpcdmlytpgfygggsxbxxazj
jgwhosbkdscjwrabzhivzmqhmexepzuvomrtngaqykmuvqgrme
mgzydphujvsqgpvsomejpqyxxjdbsamsipeceiufowljbllihb
qabworhuozfyqecgqvg
orhuozfyqecgqvg
guzbhoyomkddggslvyigrzmxwqpqajxofeuznlwiijua
iwdodbzjfdvxdcstwqwlxfipryjtdfztzwagvrqdabrm
 *)

let base_search pat text = 
  let m = String.length pat in 
  let n = String.length text in 
  let rec search_helper i j = 
    if i = m then 
      j - m
    else if j = n then 
      -1
    else
      if pat.[i] = text.[j] then 
        search_helper (i + 1) (j + 1)
      else
        search_helper 0 (j - i + 1)
  in search_helper 0 0
;;

let rk_search pat text = 
  let prime = 31 in 
  let modm = 1000000009 in
  let m = String.length pat in 
  let n = String.length text in 
  let pow_precal = Array.make m 1 in 
  for i = m - 2 downto 0 do 
    pow_precal.(i) <- pow_precal.(i + 1) * prime mod modm
  done;
  (* Array.iter (fun x -> Printf.printf "%d " x) pow_precal; *)
  let get_char_int c = int_of_char c - int_of_char 'a' in
  let pat_hash = (Array.fold_left (+) 0 (Array.mapi (fun idx value -> value * get_char_int (String.get pat idx)) pow_precal)) mod modm in 
  let text_hash = (Array.fold_left (+) 0 (Array.mapi (fun idx value -> value * get_char_int (String.get text idx)) pow_precal)) mod modm in 
  let rec str_match pat_hash text_hash text_start_idx text_end_idx = 
    (* Printf.printf "%d %d\n" pat_hash text_hash; *)
    if pat_hash = text_hash && pat = String.sub text text_start_idx m then 
      text_start_idx
    else
      if text_end_idx = n then 
        -1
      else
        (* Here, the number be moded may be negative *)
        let pos_mod a b = (a mod b + b) mod b in
        let pos_mod_here = (fun a -> pos_mod a modm) in
        str_match pat_hash ((prime * (text_hash - pow_precal.(0) * (get_char_int (String.get text text_start_idx))) + get_char_int (String.get text text_end_idx)) |> pos_mod_here) (text_start_idx + 1) (text_end_idx + 1)
  in
  str_match pat_hash text_hash 0 m
;;

let kmp_search pat text = 
  let m = String.length pat in 
  let n = String.length text in 
  let build_next s = 
    let l = String.length s in 
    let next = Array.make l 0 in 
    let i = ref 1 in 
    let tmp = ref 0 in 
    while !i < l do 
      if s.[!tmp] = s.[!i] then (
        incr tmp;
        incr i;
        next.(!i) <- !tmp
       ) else if !tmp <> 0 then 
        tmp := next.(!tmp - 1)
      else
        incr i
    done;
    next
  in 
  let next = build_next pat in 
  let i = ref 0 in 
  let j = ref 0 in 
  let res = ref (-1) in
  while !i < n do 
    let () = 
    if text.[!i] = pat.[!j] then (
      incr i;
      incr j
    ) else
      i := next.(!i)
    in
    if !res = -1 && !j = m then 
      res := !i - !j
  done;
  !res
;;

let bm_search pat text = 
  (* Bad Character *)
  let bctable s = 
    let bc = Array.make 26 (-1) in
    let len = String.length s in 
    for i = 0 to len - 1 do
      bc.(i) <- i
    done;
    bc 
  in 
  let 
  let m = String.length pat in 
  let n = String.length text in 


let () = 
  let t = read_int () in
  for i = 1 to t do
    let text = read_line() in
    let pat = read_line() in
    let pos = kmp_search pat text in
    if pos = -1 then 
      print_endline "NO"
    else
      print_endline "YES"
    done
;;
