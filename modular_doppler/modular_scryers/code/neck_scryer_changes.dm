/**
 * Overrides and additions to base TG MODlink Scryers.
 */

/obj/item/clothing/neck/link_scryer/Initialize(mapload)
	. = ..()
	set_label(label) // Update for var-edited labels.

/obj/item/clothing/neck/link_scryer/examine(mob/user)
	. = ..()
	if(label)
		. += span_notice("Its current label is '[html_encode(label)]'.")

// Fully overrides parent attack_self.
/obj/item/clothing/neck/link_scryer/attack_self(mob/user, modifiers)
	if(label)
		balloon_alert(user, "reset label")
		set_label(null)
		return

	var/new_label = reject_bad_text(tgui_input_text(user, "Change the visible label", "Set Label", label, MAX_NAME_LEN, encode = FALSE))
	if(QDELETED(user) || !user.is_holding(src))
		return
	if(!new_label)
		balloon_alert(user, "invalid label!")
		return

	set_label(new_label)
	balloon_alert(user, "set label")
	return

/obj/item/clothing/neck/link_scryer/proc/set_label(new_label)
	label = new_label
	mod_link.visual_name = new_label ? "[new_label] (Scryer)" : "Unlabeled Scryer"

// Fully overrides parent process.
/obj/item/clothing/neck/link_scryer/process(seconds_per_tick)
	if(isnull(mod_link.link_call))
		return
	cell.use(MODLINK_STANDARD_DISCHARGE_RATE * seconds_per_tick, force = TRUE)
