
fun is_older(date1: int * int * int,  date2: int * int * int) =
    if #1 date1 = #1 date2
    then
	if #2 date1 = #2 date2
	then
	    #3 date1 < #3 date2
	else
	    #2 date1 < #2 date2
    else
	#1 date1 < #1 date2;

fun number_in_month(dates: (int * int * int) list, month: int) =
    if null dates
    then 0
    else
	if #2 (hd dates) = month
	then 1 + number_in_month(tl dates, month)
	else number_in_month(tl dates, month);

fun number_in_months(dates: (int * int * int) list, months: int list) =
    if null months
    then 0
    else
	number_in_month(dates, hd months) + number_in_months(dates, tl months);

fun dates_in_month(dates: (int * int * int) list, month: int) =
    if null dates
    then []
    else
	if #2 (hd dates) = month
	then hd dates :: dates_in_month(tl dates, month)
	else dates_in_month (tl dates, month);

fun dates_in_months(dates: (int * int * int) list, months: int list) =
    if null months
    then []
    else
	dates_in_month(dates, hd months) @ dates_in_months(dates, tl months);

fun get_nth(strings: string list, i: int) =
    if i = 1
    then hd strings
    else get_nth(tl strings, i-1);

fun date_to_string(date: int * int * int) =
    let
	val month_names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    in
	get_nth(month_names, #2 date) ^ " " ^
	Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end;

fun number_before_reaching_sum(sum: int, xs: int list) =
    if sum - hd xs < 1
    then 0
    else
	1 + number_before_reaching_sum(sum - hd xs, tl xs);

fun what_month(day_num: int) =
    let
	val month_counts = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
	number_before_reaching_sum(day_num, month_counts) + 1
    end;

fun month_range(day1: int, day2: int) =
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1 + 1, day2);

fun oldest(dates: (int * int * int) list) =
    if null dates
    then NONE
    else
	let
	    val oldest_in_tl = oldest(tl dates)
	in
	    if not(isSome oldest_in_tl) orelse is_older(hd dates, valOf oldest_in_tl)  (* if oldest_in_tl is NONE or hd is bigger *)
	    then SOME (hd dates)
	    else oldest_in_tl
	end;

fun number_in_months_challenge(dates: (int * int * int) list, months: int list) =
    let
	fun unique_months_list(months_list) =
	    let
		fun list_without_hd_months_list(ls: int list) =
		    if null ls
		    then []
		    else
			if hd ls = hd months_list
			then list_without_hd_months_list(tl ls)
			else hd ls :: list_without_hd_months_list(tl ls);
	    in
		if null months_list
		then []
		else hd months_list :: unique_months_list(list_without_hd_months_list(tl months_list))
	    end;
    in
	number_in_months(dates, unique_months_list(months))
    end;

fun reasonable_date(date: int * int * int) =
    let
	val year = #1 date
	val month = #2 date
	val day = #3 date
	fun is_leap_year() =
	    if (year) mod 4 = 0
	    then (year) mod 100 <> 0 orelse (year) mod 400 = 0
	    else false
		     
	val month_day_count = [31, ~1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	fun get_nth(ls: int list, i: int) =
	    if i = 1
	    then hd ls
	    else get_nth(tl ls, i-1)
    in
	if year > 0 andalso month > 0 andalso month < 13 andalso day > 0
	then
	    if month = 2
	    then day < 29 orelse (day = 29 andalso is_leap_year())
	    else day < get_nth(month_day_count, month)
	else
	    false
    end;
	
