// Roundstartslimes!

#define SLIME_LIMB_BLOOD_LOSS 60

/obj/item/bodypart/head/jelly
	can_dismember = TRUE //Their organs are in their chest now, all slime subspecies, so they can safely be decapitated.

/obj/item/bodypart/head/jelly/slime/roundstart
	is_dimorphic = FALSE
	icon_greyscale = BODYPART_ICON_ROUNDSTARTSLIME
	biological_state = (BIO_FLESH|BIO_BLOODED)
	teeth_count = 0

/obj/item/bodypart/chest/jelly/slime/roundstart
	is_dimorphic = TRUE
	icon_greyscale = BODYPART_ICON_ROUNDSTARTSLIME
	biological_state = (BIO_FLESH|BIO_BLOODED)

/obj/item/bodypart/arm/left/jelly/slime/roundstart
	icon_greyscale = BODYPART_ICON_ROUNDSTARTSLIME
	biological_state = (BIO_FLESH|BIO_BLOODED)

/obj/item/bodypart/arm/right/jelly/slime/roundstart
	icon_greyscale = BODYPART_ICON_ROUNDSTARTSLIME
	biological_state = (BIO_FLESH|BIO_BLOODED)

/obj/item/bodypart/leg/left/jelly/slime/roundstart
	icon_greyscale = BODYPART_ICON_ROUNDSTARTSLIME
	biological_state = (BIO_FLESH|BIO_BLOODED)

/obj/item/bodypart/leg/right/jelly/slime/roundstart
	icon_greyscale = BODYPART_ICON_ROUNDSTARTSLIME
	biological_state = (BIO_FLESH|BIO_BLOODED)

/obj/item/bodypart/head/jelly/Initialize(mapload)
    . = ..()
    AddElement(/datum/element/splattering_limb)

/obj/item/bodypart/arm/left/jelly/Initialize(mapload)
    . = ..()
    AddElement(/datum/element/splattering_limb)

/obj/item/bodypart/arm/right/jelly/Initialize(mapload)
    . = ..()
    AddElement(/datum/element/splattering_limb)

/obj/item/bodypart/leg/left/jelly/Initialize(mapload)
    . = ..()
    AddElement(/datum/element/splattering_limb)

/obj/item/bodypart/leg/right/jelly/Initialize(mapload)
    . = ..()
    AddElement(/datum/element/splattering_limb)

/**
 * Splattering limb element
 *
 * When an /obj/item/bodypart with this is dropped,
 * instead splatter and lower the owner's blood.
 */
/datum/element/splattering_limb

/datum/element/splattering_limb/Attach(datum/target)
    . = ..()
    if(!isbodypart(target))
        return ELEMENT_INCOMPATIBLE

    RegisterSignal(target, COMSIG_BODYPART_REMOVED, PROC_REF(on_bodypart_removed))
    RegisterSignal(target, COMSIG_BODYPART_ATTACHED, PROC_REF(on_attached))

/datum/element/splattering_limb/proc/on_attached(obj/item/bodypart/source, mob/living/carbon/human/new_owner)
    SIGNAL_HANDLER
    RegisterSignal(new_owner, COMSIG_CARBON_POST_REMOVE_LIMB, PROC_REF(post_bodypart_removed))

/datum/element/splattering_limb/proc/on_bodypart_removed(obj/item/bodypart/source, mob/living/carbon/human/owner, special, dismembered)
    SIGNAL_HANDLER

    if(special || isnull(owner))
        return

    to_chat(owner, span_warning("Your [source.name] splatters with an unnerving squelch!"))
    playsound(owner, 'sound/effects/blob/blobattack.ogg', 60, TRUE)
    owner.blood_volume -= SLIME_LIMB_BLOOD_LOSS

/datum/element/splattering_limb/proc/post_bodypart_removed(mob/living/carbon/human/source, obj/item/bodypart/lost_bodypart, special, dismembered)
    SIGNAL_HANDLER

    lost_bodypart.drop_organs(null, TRUE)
    UnregisterSignal(source, COMSIG_CARBON_POST_REMOVE_LIMB)
    qdel(lost_bodypart)

#undef SLIME_LIMB_BLOOD_LOSS
