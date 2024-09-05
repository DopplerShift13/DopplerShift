/// If you need to make edits to existing bodyparts, do so in here.
/obj/item/bodypart/head
	/// Override of the eyes icon file - used for slugcats as test dummies, followed by teshies, vox, possibly moths & insects, and more!
	var/eyes_icon

/obj/item/bodypart/head/lizard
	head_flags = HEAD_ALL_FEATURES

/obj/item/bodypart/head/moth
	head_flags = HEAD_ALL_FEATURES

/obj/item/bodypart/head/robot
	head_flags = HEAD_EYESPRITES | HEAD_FACIAL_HAIR | HEAD_HAIR | HEAD_EYECOLOR

/obj/item/bodypart/head/snail
	head_flags = HEAD_EYESPRITES | HEAD_DEBRAIN | HEAD_FACIAL_HAIR | HEAD_HAIR
