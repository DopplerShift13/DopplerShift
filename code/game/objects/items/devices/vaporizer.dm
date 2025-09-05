/obj/item/clothing/accessory/vaporizer
	name = "hydro-vaporizer"
//	desc = ""
	icon_state = "vaporizer"
	base_icon_state = "vaporizer"

/obj/item/clothing/accessory/vaporizer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/hydrating)

/obj/item/clothing/accessory/vaporizer/Destroy()
	. = ..()
	qdel(GetComponent(/datum/component/hydrating))

/obj/item/clothing/accessory/vaporizer/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_CTRL_LMB] = "Toggle hiding"

/obj/item/clothing/accessory/vaporizer/examine(mob/user)
	. = ..()
	. += "It can be hidden. Ctrl + left-click to toggle."

/obj/item/clothing/accessory/vaporizer/item_ctrl_click(mob/user)
	. = ..()
	if(!ishuman(user))
		return CLICK_ACTION_BLOCKING
	var/mob/living/carbon/human/wearer = user
	if(wearer.get_active_held_item() != src)
		to_chat(wearer, span_warning("You must hold the [src] in your hand to do this!"))
		return CLICK_ACTION_BLOCKING
	if(icon_state == "[base_icon_state]")
		icon_state = "[base_icon_state]_hidden"
		worn_icon_state = "[base_icon_state]_hidden"
		balloon_alert(wearer, "hidden")
	else
		icon_state = "[base_icon_state]"
		worn_icon_state = "[base_icon_state]"
		balloon_alert(wearer, "shown")
	update_icon()
	return CLICK_ACTION_SUCCESS

/mob/living/carbon/human/emp_act(severity)
	. = ..()
	var/obj/item/clothing/under/worn_uniform = w_uniform
	if(w_uniform)
		var/obj/item/clothing/accessory/vaporizer/vaporizer = locate() in worn_uniform.attached_accessories
		vaporizer?.on_emp()

/obj/item/clothing/accessory/vaporizer/emp_act(severity)
	. = ..()
	var/turf/open/tile = get_turf(src)
	var/list/nearby_mobs = get_hearers_in_view(4, tile)
	if(istype(tile))
		tile.atmos_spawn_air("[GAS_WATER_VAPOR]=50;[TURF_TEMPERATURE(1000)]")
	tile.balloon_alert_to_viewers("overloaded!")
	to_chat(tile, span_warning("[src] overloads, exploding in a cloud of hot steam!"))
	playsound(tile, 'sound/effects/spray.ogg', 80)
	for(var/mob/living/victim in nearby_mobs)
		victim.set_jitter_if_lower(15 SECONDS)
		victim.set_eye_blur_if_lower(5 SECONDS)
	qdel(src)

/obj/item/clothing/accessory/vaporizer/proc/on_emp()
	var/obj/item/clothing/under/attached_to = loc
	detach(attached_to) // safely remove the status effect
	emp_act(EMP_LIGHT)
