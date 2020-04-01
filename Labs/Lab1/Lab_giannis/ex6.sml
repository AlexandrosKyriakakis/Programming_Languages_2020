fun powerset [] = [[]]
  | powerset (x::xs) =
    let
      val power_subset = powerset xs
    in
      (List.map (fn L => x::L) power_subset) @ power_subset
    end