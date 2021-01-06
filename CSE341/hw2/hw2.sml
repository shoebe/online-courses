(* Dan Grossman, CSE341 Spring 2013, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

fun all_except_option(item, list) =
    let fun tail_recur(previous, rest) =
	    case rest of
		[] => NONE
	      | head::tail => if item = head
			      then SOME (previous @ tail)
			      else tail_recur(head::previous, tail)
    in tail_recur([], list)
    end;
	
fun get_substitutions1(substitutions_list, name) =
    case substitutions_list of
	[] => []
      | possible_subs::tail =>  case all_except_option(name, possible_subs) of
				    NONE => get_substitutions1(tail, name)
				  | SOME subs => subs @ get_substitutions1(tail, name)

fun get_substitutions2(substitutions_list, name) =
    let
	fun get_substitutions_list_of_lists(previous, rest) =
	    case rest of
		[] => previous
	      | possible_subs::tail => case all_except_option(name, possible_subs) of
					   NONE => get_substitutions_list_of_lists(previous, tail)
					 | SOME subs => get_substitutions_list_of_lists(subs :: previous, tail)

	fun flatten(previous, rest) =
	    case rest of
		[] => previous
	      | []::tail => flatten(previous, tail) 
	      | (inner_head::inner_tail)::tail => flatten(inner_head::previous, inner_tail::tail)
    in
	flatten([], get_substitutions_list_of_lists([], substitutions_list))
    end;


fun similar_names(substitutions_list, {first=first_name, middle=middle_name, last=last_name}) =
    let fun helper(substitutions) =
	    case substitutions of
		[] => []
	      | head::tail => {first=head, middle=middle_name, last=last_name}::helper(tail)
    in
	helper(first_name::get_substitutions1(substitutions_list, first_name))
    end

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
      | Ace => 11 
      | _ => 10 (* Jack | Queen | King *)

fun remove_card(card_list, card, error) =
    case all_except_option(card, card_list) of
	NONE => raise error
      | SOME list => list
			 
fun all_same_color(card_list) =
    case card_list of
	head::neck::tail => if card_color(head) = card_color(neck)
			    then all_same_color(neck::tail)
			    else false
     | _::[] => true 
     | [] => true

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
	else preliminary
    end

	

fun officiate(card_list, move_list, goal) =
    let	
	fun play_round(held_cards, drawable_cards, moves) =
	    case moves of
		[] => score(held_cards, goal)
	      | current_move::future_moves =>
		case current_move of
		    Discard card => play_round(remove_card(held_cards, card, IllegalMove), drawable_cards, future_moves)
		  | Draw => case drawable_cards of
				[] => score(held_cards, goal)
			      | drawn_card::undrawn_cards => if sum_cards(drawn_card::held_cards) > goal
							     then score(drawn_card::held_cards, goal)
							     else play_round(drawn_card::held_cards, undrawn_cards, future_moves)

    in
	play_round([], card_list, move_list)
    end

fun sum_challenge(card_list, goal) =
    let
	fun count_aces(sum,cards) =
	    case cards of
		[] => sum
	      | (_, Ace)::other_cards => count_aces(sum+1, other_cards)
	      | _::other_cards  => count_aces(sum, other_cards)
							    
	fun remove_10_if_greater_than_goal(sum, max_times) =
	    if max_times <= 0 orelse sum <= goal then sum
	    else remove_10_if_greater_than_goal(sum-10, max_times-1)

    in
	(*  removing 10 from aces makes them count as 1 *)
	remove_10_if_greater_than_goal(sum_cards(card_list), count_aces(0, card_list))
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
	else preliminary
    end
	
	
fun officiate_challenge(card_list, move_list, goal) =
    let (* identical to officiate but uses the challenge functions *)
	fun play_round(held_cards, drawable_cards, moves) =
	    case moves of
		[] => score_challenge(held_cards, goal)
	      | current_move::future_moves => 
		case current_move of
		    Discard card => play_round(remove_card(held_cards, card, IllegalMove), drawable_cards, future_moves)
		  | Draw => case drawable_cards of
				[] => score_challenge(held_cards, goal)
			      | drawn_card::undrawn_cards => if sum_challenge(drawn_card::held_cards, goal) > goal
							     then score_challenge(drawn_card::held_cards, goal)
							     else play_round(drawn_card::held_cards, undrawn_cards, future_moves)
    in
	play_round([], card_list, move_list)
    end

fun careful_player(card_list, goal) =
    let
	fun try_replacing_card(held_cards, card) =
	    let fun recurse(previous, rest) =
		    case rest of
			[] => NONE
		      | head::tail => if score(card::(previous @ tail), goal) = 0
				      then SOME (Discard head)
				      else recurse(head::previous, tail)
	    in
		recurse([], held_cards)
	    end
				
	fun helper(cards_to_draw, held_cards) =
	    if score(held_cards, goal) = 0
	    then []
	    else
	    case cards_to_draw of
		[] => [Draw]
	      | drawn_card::undrawn_cards => if sum_cards(held_cards) + 10 > goal
					     then case try_replacing_card(held_cards, drawn_card) of
						      NONE => []
						    | SOME move => [move, Draw] 
					     else Draw::helper(undrawn_cards, drawn_card::held_cards)
    in
	helper(card_list, [])
    end
	    
	    
