#define HOLOSYNTH_BRUTEMULT 3
#define HOLOSYNTH_BURNMULT 5
#define HOLOSYNTH_RANGE 9
#define HOLOSYNTH_OPACITY 0.6

/datum/species/android/holosynth
	name = "Holosynth"
	preview_outfit = /datum/outfit/holosynth_preview
	id = SPECIES_HOLOSYNTH
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_GENELESS,
		TRAIT_NOBREATH,
		TRAIT_NOHUNGER,
		TRAIT_NOCRITDAMAGE,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_PLASMA_TRANSFORM,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_UNHUSKABLE,
		TRAIT_STABLELIVER,
		TRAIT_STABLEHEART,
		TRAIT_UNDENSE,
		TRAIT_GRABRESISTANCE,
		TRAIT_NODISMEMBER,
		TRAIT_NO_AUGMENTS,
		TRAIT_NEVER_WOUNDED,
		TRAIT_HOLOSYNTH
	)
	gib_anim = "liquify"
	exotic_bloodtype = BLOOD_TYPE_HOLOGEL
	/// Our Holographic projector that we're going to make the owner of a leash component
	var/datum/weakref/owner_projector_ref
	/// Tracks the emissive overlay glow for later deletion
	var/mutable_appearance/glow

//Species Adding and Removal

/datum/species/android/holosynth/on_species_gain(mob/living/carbon/target, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	var/mob/living/carbon/human/species_holder = target

	// make_hologram_glowless(0.5, species_holder)
	// make_emissive(species_holder)

	species_holder.physiology.brute_mod *= HOLOSYNTH_BRUTEMULT
	species_holder.physiology.burn_mod *= HOLOSYNTH_BURNMULT
	species_holder.max_grab = GRAB_PASSIVE //you're like, only half solid yk

	species_holder.AddComponent(/datum/component/glass_passer/holosynth, pass_time = 1 SECONDS, deform_glass = 0.5 SECONDS)
	species_holder.AddComponent(/datum/component/holographic_nature)
	species_holder.AddComponent(/datum/component/holosynth_effects)

	//Leashing time
	var/obj/item/holosynth_pen/owner_projector = new /obj/item/holosynth_pen (get_turf(species_holder), species_holder)
	owner_projector_ref = WEAKREF(owner_projector)
	species_holder.put_in_hands(owner_projector)

	species_holder.AddComponent(\
		/datum/component/leash,\
		owner = owner_projector,\
		distance = HOLOSYNTH_RANGE,\
		force_teleport_out_effect = /obj/effect/temp_visual/guardian/phase/out,\
		force_teleport_in_effect = /obj/effect/temp_visual/guardian/phase,\
	)

/datum/species/android/holosynth/on_species_loss(mob/living/carbon/target, datum/species/new_species, pref_load)
	. = ..()
	var/mob/living/carbon/human/species_holder = target
	species_holder.physiology.brute_mod /= HOLOSYNTH_BRUTEMULT
	species_holder.physiology.burn_mod /= HOLOSYNTH_BURNMULT
	species_holder.max_grab = GRAB_KILL

	var/comps_to_delete = list(
	species_holder.GetComponent(/datum/component/glass_passer/holosynth),
	species_holder.GetComponent(/datum/component/leash),
	species_holder.GetComponent(/datum/component/holographic_nature),
	species_holder.GetComponent(/datum/component/holosynth_effects)
	)
	for(var/comp in comps_to_delete)
		qdel(comp)


	var/obj/item/holosynth_pen/pen_to_unlink = owner_projector_ref?.resolve()
	if(pen_to_unlink)
		pen_to_unlink.linked_mob_ref = null

// Lore Box
/datum/species/android/holosynth/get_species_lore()
	return list(\
		"Somewhere between an android and a hologram, these semi-physical autonomous units are extremely vulnerable to heat and electricity \
		A niche choice more popular among wealthy customers (silicon and uploaded organics alike) - their lack of robustness makes them somewhat inept for physical activity but they are excellent at scouting or clerical work.",

		 "As of late the design of the required holoprojection equipment has shrunk considerably. \
		 With an electromagnetic controller suite, hologram projection aparatus, and a ball point writing implement all fitting into the sleek pen chassis."
	)

//Character creation Perks
/datum/species/android/holosynth/create_pref_traits_perks()
	var/list/perks = list()
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_SHIELD_ALT,
		SPECIES_PERK_NAME = "Android Aptitude",
		SPECIES_PERK_DESC = "As a synthetic lifeform, Androids are immune to many forms of damage humans are susceptible to. \
			Fire, cold, heat, pressure, radiation, and toxins are all ineffective against them. \
			They also can't overdose on drugs, don't need to breathe or eat, can't catch on fire, and are immune to being pierced.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_DNA,
		SPECIES_PERK_NAME = "Not Human After All",
		SPECIES_PERK_DESC = "There is no humanity behind the eyes of the Android, and as such, they have no DNA to genetically alter.",
	))
	return perks

/datum/species/android/holosynth/create_pref_unique_perks()
	var/list/perks = list()
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_SHIELD_HEART,
		SPECIES_PERK_NAME = "Some Components Optional",
		SPECIES_PERK_DESC = "Androids have very few internal organs. While they can survive without many of them, \
			they don't have any benefits from them either.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_ROBOT,
		SPECIES_PERK_NAME = "Synthetic",
		SPECIES_PERK_DESC = "Being synthetic, Androids are vulnernable to EMPs.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_MAGNIFYING_GLASS,
		SPECIES_PERK_NAME = "Translucency",
		SPECIES_PERK_DESC = "Holosynths can pass through glass, though you'll leave any physical items behind",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_NOTES_MEDICAL,
		SPECIES_PERK_NAME = "Regenerator",
		SPECIES_PERK_DESC = "Being made of light, your projector and controller will mend tears in your form and aerogel",
	))
	return perks

/datum/species/android/get_species_description()
	return "Holosynths are a subtype of Androids; they're made of soft-light, only semi-solid and dependant on a projection device"

/datum/outfit/holosynth_preview
	name = "Holosynth (Species Preview)"

/datum/species/android/holosynth/prepare_human_for_preview(mob/living/carbon/human/human_for_preview)
	human_for_preview.set_haircolor("#CCECFF", update = FALSE)
	human_for_preview.set_hairstyle("Mia", update = TRUE)
	human_for_preview.eye_color_left = "#66CCFF"
	human_for_preview.eye_color_right = "#66CCFF"
	human_for_preview.dna.features["frame_list"] = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot/android/mc,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot/android/bs_one,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/android/bs_one,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/android/bs_one,
		)
	regenerate_organs(human_for_preview)
	human_for_preview.update_body(is_creating = TRUE)

/datum/component/holosynth_effects
	/// Tracks the emissive overlay glow for later deletion
	var/mutable_appearance/glow
	/// Our Parent as a human since some of the fields we're accessing aren't on /datum
	var/mob/living/carbon/human/parent_as_human

/datum/component/holosynth_effects/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	parent_as_human = parent
	. = ..()

/datum/component/holosynth_effects/RegisterWithParent()
	make_hologram_glowless()
	glow = make_emissive()

/datum/component/holosynth_effects/UnregisterFromParent()
	parent_as_human.remove_filter(list("HOLO: Color and Transparent","HOLO: Scanline"))
	parent_as_human.cut_overlay(glow)


/datum/component/holosynth_effects/proc/make_hologram_glowless()
	parent_as_human.add_filter("HOLO: Color and Transparent", 1, color_matrix_filter(rgb(125,180,225, HOLOSYNTH_OPACITY * 255)))
	var/atom/movable/scanline = new(null)
	scanline.icon = 'icons/effects/effects.dmi'
	scanline.icon_state = "scanline"
	scanline.appearance_flags |= RESET_TRANSFORM
	var/static/uid_scan = 0
	scanline.render_target = "*HoloScanline [uid_scan]"
	uid_scan++
	parent_as_human.add_filter("HOLO: Scanline", 2, alpha_mask_filter(render_source = scanline.render_target))
	parent_as_human.add_overlay(scanline)
	qdel(scanline)

/datum/component/holosynth_effects/proc/make_emissive()
	if(!parent_as_human.render_target)
		var/static/uid = 0
		parent_as_human.render_target = "HOLOGRAM [uid]"
		uid++
	var/static/atom/movable/render_step/emissive/glow
	if(!glow)
		glow = new(null)
	glow.render_source = parent_as_human.render_target
	SET_PLANE_EXPLICIT(glow, initial(glow.plane), parent_as_human)
	var/mutable_appearance/glow_appearance = new(glow)
	parent_as_human.add_overlay(glow_appearance)
	LAZYADD(parent_as_human.update_overlays_on_z, glow_appearance)
	return glow_appearance

#undef HOLOSYNTH_BRUTEMULT
#undef HOLOSYNTH_BURNMULT
#undef HOLOSYNTH_RANGE
#undef HOLOSYNTH_OPACITY
