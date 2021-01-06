use "hw1.sml";

val test1 = is_older ((1,2,3),(2,3,4)) = true

val test2 = number_in_month ([(2012,2,28),(2013,12,1)],2) = 1

val test3 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 3

val test4 = dates_in_month ([(2012,2,28),(2013,12,1)],2) = [(2012,2,28)]

val test5 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]

val test6 = get_nth (["hi", "there", "how", "are", "you"], 2) = "there"

val test7 = date_to_string (2013, 6, 1) = "June 1, 2013"

val test8 = number_before_reaching_sum (10, [1,2,3,4,5]) = 3

val test9 = what_month 70 = 3

val test10 = month_range (31, 34) = [1,2,2,2]

val test11 = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)

(* custom tests *)

val d1 = (2013, 02, 29);
val d2 = (2013, 02, 28);

val dates_man = [d1, d2, (2012, 03, 23), (2010, 10, 23), (2002, 01, 23), (2032, 03, 06)];
								  
val t1 = number_in_month(dates_man, 10) = 1;
val t2 = number_in_months(dates_man, [2,3]) = 4;
val t3 = dates_in_month(dates_man, 10) = [(2010, 10, 23)];
val t4 = dates_in_months(dates_man, [2,3]) = [d1, d2, (2012, 03, 23), (2032, 03, 06)];
val t5 = get_nth(["1","2","3","4","5"],4) = "4";
val t6 = date_to_string(d1) = "February 29, 2013";
val t7 = number_before_reaching_sum(10, [1,2,3,4,5,6,7,8]) = 3;
val t8 = what_month(122) = 5;
val t9 = month_range(28, 33) = [1,1,1,1,2,2]; 
val t10 = oldest(dates_man) = SOME (2002, 01, 23);
val t11 = number_in_months_challenge(dates_man, [2,2,3]) = 4;
val t12 = reasonable_date(2020,2,29) = true;
val t13 = reasonable_date(2019,2,29) = false;
