module MonoStack = struct
  type 'a t = {
    stack: 'a list;
    cmp: 'a -> 'a -> bool;
  }

  let create cmp = { stack = [0]; cmp = cmp; }

  let is_empty t = t.stack = []

  let push element stack = element :: stack
end