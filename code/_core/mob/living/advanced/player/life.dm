
/mob/living/advanced/player/on_life()

	if(area && !area.safe)
		var/was_protected = spawn_protection > 0
		spawn_protection =  max(0,spawn_protection - LIFE_TICK)
		if(!spawn_protection && was_protected)
			src.to_chat(span("notice","Your spawn protection has worn off."))

	return ..()

/*
/mob/living/advanced/player/handle_alpha()

	if(spawn_protection > 0 && !area.safe)
		return 10

	return ..()
*/


/mob/living/advanced/player/post_death()

	var/list/people_who_contributed = list()
	var/list/people_who_killed = list()
	var/list/people_who_killed_names = list()

	for(var/list/attack_log in attack_logs)
		if(attack_log["lethal"])
			var/mob/living/advanced/player/P = attack_log["attacker"]
			people_who_killed += P
			people_who_killed_names += P.name

		if(!attack_log["lethal"] && attack_log["critical"])
			people_who_contributed += attack_log["attacker"]

	var/date = get_date()
	var/time = get_time()

	if(last_words && length(people_who_killed) && people_who_killed[1] && people_who_killed[1] != src)
		SS_Soapstone.create_new_soapstone(get_turf(src),SOUTH,"#000000",src.real_name,src.ckey,last_words,date,time)

	attack_logs = list()

	return ..()