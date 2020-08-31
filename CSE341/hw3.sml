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
	      | _ => [] 
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

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

exception noSuitableType		  
fun typecheck_patterns datatypes ps =
    let
	fun equivalent_type (t1, t2) =
	    case (t1, t2) of
		(Anything, _) => true
	      | (_, Anything) => true
	      | (TupleT typs1, TupleT typs2) => ListPair.foldl (fn (typ1, typ2, acc) => acc andalso equivalent_type (typ1, typ2))
							       true (typs1, typs2)
	      | (Datatype s1, Datatype s2) => s1=s2 
	      | _ => t1=t2
		 
	fun get_type pat =
	    case pat of
		Variable _ => Anything
	      | Wildcard => Anything
	      | UnitP => UnitT  
	      | ConstP _ => IntT
	      | TupleP ps => TupleT (List.map get_type ps)
	      | ConstructorP (s, p) => (case List.find (fn (c, _, _) => s=c) datatypes of
					    SOME (c, d, t) => if equivalent_type (get_type p, t) then Datatype d else raise noSuitableType
					  | NONE => raise noSuitableType)

	fun more_lenient (t1, t2) =
	    case (t1, t2) of
	      (_, Anything) => t1
	      | (Anything, _) => t2
	      | (TupleT typs1, TupleT typs2) =>  TupleT ( ListPair.map more_lenient (typs1, typs2) )
	      | _ => (* assume equivalence *) t1
			 
	fun all_equivalent ls =
	    case ls of
		head::neck::tail => equivalent_type (head,neck) andalso all_equivalent (neck::tail)
	      | _ => true
			 
	val most_lenient = List.foldl more_lenient Anything
	val types_list =  List.map get_type ps 
    in
	if all_equivalent types_list
	then SOME ( most_lenient  types_list )
	else NONE
    end handle noSuitableType => NONE
