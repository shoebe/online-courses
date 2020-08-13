(* Dan Grossman, CSE341 Spring 2013, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

fun all_except_option(item, list) =
    let fun list_until_option(previous, rest) =
	    case rest of
		[] => NONE
	      | head::tail => if item = head
			      then SOME (previous @ tail)
			      else list_until_option(head::previous, tail)
    in list_until_option([], list)
    end;
	
fun get_substitutions1(substitutions_list, name) =
    case substitutions_list of
	[] => []
      | possible_subs::tail =>  case all_except_option(name, possible_subs) of
				    NONE => get_substitutions1(tail, name)
				  | SOME subs => subs @ get_substitutions1(tail, name)

fun get_substitutions2(substitutions_list, name) =
    let
	fun tail_recur(previous, rest) =
	    case rest of
		[] => previous
	      | possible_subs::tail => case all_except_option(name, possible_subs) of
					   NONE => tail_recur(previous, tail)
					 | SOME subs => tail_recur(subs :: previous, tail)

	fun flatten(previous, rest) =
	    case rest of
		[] => previous
	      | []::tail => flatten(previous, tail) 
	      | (inner_head::inner_tail)::tail => flatten(inner_head::previous, inner_tail::tail)
    in
	flatten([], tail_recur([], substitutions_list))
    end;

fun similar_names(substitutions_list, {first=first_name, middle=middle_name, last=last_name}) =
    let fun tail_recur(previous, rest) =
	    case rest of
		[] => previous
	      | substitution::tail => tail_recur({first=substitution, middle=middle_name, last=last_name}::previous, tail)
    in
	{first=first_name, middle=middle_name, last=last_name} :: tail_recur([], get_substitutions2(substitutions_list, first_name))
    end;

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

fun card_color(suit, _) =
    case suit of
	Clubs => Black
      | Spades => Black
      | Hearts => Red
      | Diamonds => Red 

fun card_value(_, rank) =
    case rank of
	Num number => number
      | _ => 10 (* Jack | Queen | King | Ace *)

fun remove_card(cs, c, e) =
    case all_except_option(c, cs) of
	NONE => raise e
      | SOME list => list
			 
fun all_same_color(card_list) =
    case card_list of
	head::neck::tail => if card_color(head) = card_color(neck)
			    then all_same_color(tail)
			    else false
     | [] => true
     | _::_ => true (* one item *)

fun sum_cards(card_list) =
    let fun tail_recur(sum, rest) =
	    case rest of
		[] => sum
	      | head::tail => tail_recur(sum+card_value(head), tail)
    in
	tail_recur(0, card_list)
    end

fun score(card_list, goal) =
    let
	val sum = sum_cards(card_list)
	val preliminary = if sum > goal
			  then (sum - goal) * 3
			  else (goal - sum)
    in
	if all_same_color(card_list)
	then preliminary div 2
	else premilinary
    end

	

fun officiate(card_list, move_list, goal) =
    let
	fun play_round(held_cards, drawable_cards, []) = score(held_cards)
	  | play_round(held_cards, drawable_cards, current_move::future_moves) = 
	    case current_move of
		Discard card => remove_card(held_cards, card, IllegalMove)
	      | Draw => case drawable_cards of
			    [] => score(held_cards)
			  | drawn_card::undrawn_cards => if sum(drawn_card::held_cards) > goal
							 then score(drawn_card::held_cards)
							 else play_round(drawn_card::held_cards, undrawn_cards, future_moves)
    in
	play_round([], card_list, move_list)
    end

fun sum_challenge(card_list, goal) =
    let
	fun count_aces(sum,cards) =
	    case cards of
		[] => sum
	      | (_, rank):: other_cards => if rank = Ace then contains_ace(sum+1, other_cards)
					   else contains_ace(sum, other_cards)
							    
	fun remove_10_if_greater_than_goal(sum, max_times) =
	    if max_times <= 0 orelse goal > sum then sum
	    else remove_10_if_greater_than_goal(sum-10, max_times-1)
					       
	val ace_count = count_aces(0, card_list)
	
    in
	(* to make aces count as 11 add 1 for every ace
	   removing 10 then makes them count as 1 *)
	remove_10_if_greater_than_goal(sum_cards(card_list) + ace_count, ace_count)
    end
	

fun score_challenge(card_list, goal) =
    let
	
	val sum = sum_challenge(card_list, goal)
	val preliminary = if sum > goal
			  then (sum - goal) * 3
			  else (goal - sum)
    in
	if all_same_color(card_list)
	then preliminary div 2
	else premilinary
    end
	
	
fun officiate_challenge(card_list, move_list, goal) =
    let
	fun play_round(held_cards, drawable_cards, []) = score_challenge(held_cards)
	  | play_round(held_cards, drawable_cards, current_move::future_moves) = 
	    case current_move of
		Discard card => remove_card(held_cards, card, IllegalMove)
	      | Draw => case drawable_cards of
			    [] => score(held_cards)
			  | drawn_card::undrawn_cards => if sum_challenge(drawn_card::held_cards) > goal
							 then score_challenge(drawn_card::held_cards)
							 else play_round(drawn_card::held_cards, undrawn_cards, future_moves)
    in
	play_round([], card_list, move_list)
    end
