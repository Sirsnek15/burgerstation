/obj/hud/
	appearance_flags = NO_CLIENT_COLOR | PIXEL_SCALE | LONG_GLIDE | TILE_BOUND

	var/user_colors = TRUE

	var/mob/owner

	interaction_flags = FLAG_INTERACTION_LIVING | FLAG_INTERACTION_DEAD | FLAG_INTERACTION_NO_DISTANCE

	initialize_type = 0x0 //This type does not get initialized.

	var/delete_on_no_owner = TRUE
	var/bad_delete = TRUE

/obj/hud/proc/update_owner(var/mob/desired_owner)

	if(owner == desired_owner)
		return FALSE

	if(owner)
		owner.remove_button(src)

	if(!desired_owner && delete_on_no_owner)
		bad_delete = FALSE
		qdel(src)
		return TRUE

	owner = desired_owner
	if(owner)
		owner.add_button(src)
		update_sprite()

	return TRUE

/obj/hud/Destroy()
	owner = null
	. = ..()

/obj/hud/update_icon()

	if(user_colors)
		icon = initial(icon)
		var/icon/I = new/icon(icon,icon_state)
		swap_colors(I)
		icon = I

	return ..()

/obj/hud/attack(var/atom/attacker,var/atom/victim,var/list/params=list(),var/atom/blamed,var/ignore_distance = FALSE, var/precise = FALSE,var/damage_multiplier=1,var/damagetype/damage_type_override)
	CRASH_SAFE("WARNING: [attacker] TRIED TO ATTACK [victim] WITH A HUD OBJECT!")
	return FALSE

/obj/hud/proc/swap_colors(var/icon/I)

	var/list/color_scheme = DEFAULT_COLORS

	if(owner && owner.client && owner.client.settings)
		color_scheme = owner.client.settings.loaded_data["hud_colors"]

	I.SwapColor(rgb(255,0,0),color_scheme[1])
	I.SwapColor(rgb(0,255,0),color_scheme[2])
	I.SwapColor(rgb(0,0,255),color_scheme[3])

	I.SwapColor(rgb(255,255,0),color_scheme[4])
	I.SwapColor(rgb(255,0,255),color_scheme[5])
	I.SwapColor(rgb(0,255,255),color_scheme[6])


/obj/hud/Initialize()
	CRASH("HUD objects should never be Initialized!")

/obj/hud/PostInitialize()
	CRASH("HUD objects should never be PostInitialized!")

/obj/hud/Finalize()
	CRASH("HUD objects should never be Finalized!")

/obj/hud/Generate()
	CRASH("HUD objects should never be Generated!")



/obj/hud/MouseEntered(location,control,params)
	. = ..()
	if(desc_extended && mouse_opacity > 0)
		var/list/split_screen_loc = splittext(src.screen_loc,",")
		if(length(split_screen_loc) == 2)

			var/x_offset = 0
			var/y_offset = 0

			if(findtext(screen_loc,"TOP"))
				y_offset = -1
			else if(findtext(screen_loc,"BOTTOM"))
				y_offset = 1


			if(findtext(screen_loc,"RIGHT"))
				x_offset = -1
			else if(findtext(screen_loc,"LEFT"))
				x_offset = 1

			var/desired_screen_loc = "[split_screen_loc[1]]+[x_offset],[split_screen_loc[2]]+[y_offset]"
			usr.tooltip?.set_text("[src.name]\n\n[src.desc_extended]",desired_screen_loc)


/obj/hud/MouseExited(location,control,params)
	. = ..()
	usr.tooltip?.set_text(null)