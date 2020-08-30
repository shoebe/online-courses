(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

val only_capitals = List.filter (fn x => (Char.isUpper o String.sub) (x,0))

val longest_string1 = List.foldl (fn (x,acc) => if String.size x > String.size acc then x else acc) ""

val longest_string2 = List.foldl (fn (x,acc) => if String.size x >= String.size acc then x else acc) ""

fun longest_string_helper f = List.foldl (fn (x, acc) => if f (String.size x, String.size acc) then x else acc) ""

val longest_string3 = longest_string_helper (fn (x_len,acc_len) => x_len > acc_len)
val longest_string4 = longest_string_helper (fn (x_len,acc_len) => x_len >= acc_len)
					    
val longest_capitalized = longest_string1 o only_capitals

val rev_string = String.implode o List.rev o String.explode

(*fun first_answer f xs =
    case List.mapPartial f xs of
	[] => raise NoAnswer
      | head::tail => head *)

fun first_answer f xs =
    case xs of
	[] => raise NoAnswer
      | x::xs' => case f x of
			  SOME v => v
			| NONE => first_answer f xs'

fun all_answers f xs =
    let fun option_fold (f,xs,acc) =
	    case xs of
		[] => acc
	      | x::xs' => case f x of
			     NONE => []
			   | SOME lst => option_fold (f, xs', lst @ acc)
    in case option_fold(f,xs,[]) of
	    [] => NONE
	  | lst => SOME lst
    end

val count_wildcards = g (fn () => 1) (fn x => 0)
	
val count_wild_and_variable_lengths = g (fn () => 1) String.size

fun count_some_var (var, p) = g (fn () => 0) (fn s => if s=var then 1 else 0) p

fun check_pat p =
    (* accumulate previously viewed strings in acc
       if any new string is in acc, raise exception*)
    let
	exception NotUnique
	fun helper (pattern,acc) =
	    case pattern of
		TupleP ps => List.foldl (fn (p, acc) => helper (p, acc) @ acc) acc ps
	      | Variable s => if List.exists (fn x => x=s) acc then raise NotUnique
			      else [s]
    in
	let val _ = helper(p, [])
	in true
	end handle NotUnique => false
    end 

fun match (valu, pattern) =
    case (valu, pattern) of
	(_, Wildcard) => SOME []
     | (_, Variable s) => SOME [(s, valu)]
     | (Unit, UnitP) => SOME []
     | (Const x, ConstP y) => if x=y then SOME [] else NONE
     | (Tuple vs, TupleP ps) => if List.length vs = List.length ps then all_answers match (ListPair.zip (vs, ps)) else NONE
     | (Constructor(s1,v), ConstructorP(s2,p)) => if s1 = s2 then match (v, p) else NONE
     | _ => NONE

fun first_match value ps =
    let val answer = first_answer (fn x => match (value, x)) ps
    in SOME answer end handle NoAnswer => NONE

fun typecheck_patterns typs ps =
    let
	fun typ_match (constructor, typ, pat) =
	    case (typ, pat) of
		(Anything, _) => SOME typ
	      | (UnitT, UnitP) => SOME typ
	      | (IntT, ConstP x) => SOME typ
	      | (TupleT typs, TupleP ps) => if isSome all_answers typ_match (ListPair.zip (typs, ps))
					   then SOME typ
					   else NONE
	      | (Dataytpe s1, ConstructorP s2 p) => if s = t then SOME typ else NONE
	      | _ => NONE

	val count_more_general = ListPair.foldl (fn (typ1, typ2, acc) => acc + more_general (typ1, typ2)) 0

	fun more_general (typ1,typ2) =>
	    case (typ1, typ2) of
		(Anything, Anything) => 0
		(Anything, _) => 1
	      | (_, Anything) => -1
	      | (TupleT typs1, TupleT typs2) => Integer.sign count_more_general (typs1, typs2)
	      | _ => 0
    in
	
