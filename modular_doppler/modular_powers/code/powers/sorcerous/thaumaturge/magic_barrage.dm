/*
	Deviates from standard norms by being a projectile spell with click functionalities, but using neither because it is too 'unique' in its application.
	Really its an example of what being clever gets you.
*/

/datum/power/thaumaturge/magical_barrage
	name = "Magical Barrage"
	desc = "Shoots a volley of magic projectiles equal to your Affinity + 2. You can either fire single shots with a short delay between shots, or shoot all your remaining shots in a barrage. \
	\nRequires Affinity 3."
	security_record_text = "Subject can conjure and shoot a volley of magical lasers."
	security_threat = POWER_THREAT_MAJOR
	value = 5

	action_path = /datum/action/cooldown/power/thaumaturge/magical_barrage
	required_powers = list(/datum/power/thaumaturge_root)

/datum/action/cooldown/power/thaumaturge/magical_barrage
	name = "Magical Barrage"
	desc = "Shoots a volley of magic projectiles equal to your Affinity + 2. Left click to fire single shots with a short delay between shots, or right click to shoot all your remaining shots in a barrage."
	button_icon = 'icons/obj/weapons/guns/projectiles.dmi'
	button_icon_state = "arcane_barrage"

	required_affinity = 3
	prep_cost = 5
	anti_magic_on_target = FALSE

	/// The projectile we fire
	var/obj/projectile/projectile_path = /obj/projectile/resonant/magic_barrage

	/// How many missiles we have left to fire.
	var/missiles_remaining = 0

	/// List of missiles currently oribing us
	var/list/orbiting_missiles = list()
	/// Times between each shot materializing
	var/time_between_initial_missiles = 0.12 SECONDS // Missiles spawned sequentially to prevent stacking.
	/// The radius in which the missiles orbit us
	var/missile_orbit_radius = 20
	/// The speed at which the missiles orbit us.
	var/missile_rotation_speed = 15

	/// world.time until we can fire our next shot
	var/next_single_shot_time = 0
	/// Cooldown for single shots in miliseconds.
	var/single_shot_delay = 3

	/// world.time wind-up before you can start casting.
	var/barrage_ready_time = 0

/datum/action/cooldown/power/thaumaturge/magical_barrage/use_action(mob/living/user, atom/target)
	// Toggle the barrage firing mode.
	if(active)
		disable_barrage(user, span_warning("You dispel the magic missiles."))
		return FALSE

	if(user != owner)
		return FALSE

	active = TRUE
	missiles_remaining = clamp(affinity + 2, 3, 10)
	next_single_shot_time = world.time // allow immediate first shot

	// prevent firing until all the projectiles are ready
	barrage_ready_time = world.time + round((missiles_remaining - 1) * time_between_initial_missiles)
	spawn_orbitals(missiles_remaining)
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_owner_clickon))
	to_chat(owner, span_notice("Magical missiles orbit you. Left-click: Fire one. Right-click: Fire all."))
	return TRUE

/// Turns off barrage mode and cleans up signals + orbitals.
/datum/action/cooldown/power/thaumaturge/magical_barrage/proc/disable_barrage(mob/living/user, message)
	if(!active)
		return

	active = FALSE
	missiles_remaining = 0

	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)

	clear_orbitals()

	if(user && message)
		to_chat(user, message)

/// Click handler while barrage mode is active.
/datum/action/cooldown/power/thaumaturge/magical_barrage/proc/on_owner_clickon(mob/living/clicker, atom/target, params)
	SIGNAL_HANDLER

	if(!active)
		return
	if(clicker != owner)
		return
	if(missiles_remaining <= 0)
		disable_barrage(owner, null)
		return

	// Don't shoot yourself dummy.
	if(target == owner)
		return

	// Params may already be a list (depends on the signal source).
	var/list/modifiers
	if(islist(params))
		modifiers = params
	else
		modifiers = params2list(params)

	// Right click: dump all remaining missiles.
	if(LAZYACCESS(modifiers, "right") || LAZYACCESS(modifiers, "button") == "right")
		if(fire_projectile_shotgun(owner, target, projectile_path, pellet_count = missiles_remaining))
			disable_barrage(owner, null)
		return

	// Left click: single shot
	if(fire_single_shot(owner, target))
		missiles_remaining--
		remove_one_orbital()
		if(missiles_remaining <= 0)
			disable_barrage(owner, null)

/// Proc for firing a single shot.
/datum/action/cooldown/power/thaumaturge/magical_barrage/proc/fire_single_shot(mob/living/user, atom/target)
	if(world.time < next_single_shot_time) // anti spam-click.
		return FALSE

	next_single_shot_time = world.time + single_shot_delay

	playsound(owner, 'sound/effects/magic/magic_missile.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	return fire_projectile(user, target, projectile_path)


/// Special proc for shotgunning it.
/datum/action/cooldown/power/thaumaturge/magical_barrage/proc/fire_projectile_shotgun(mob/living/user, atom/target, obj/projectile/projectile, pellet_count = 5, cone_degrees = 18, angle_jitter_degrees = 1)
	SHOULD_CALL_PARENT(TRUE)

	if(!can_fire_now(user))
		return FALSE

	var/projectile_path = projectile
	if(!projectile_path || !user || !target)
		return FALSE

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(target)
	if(!user_turf || !target_turf)
		return FALSE

	pellet_count = clamp(pellet_count, 1, 50)
	cone_degrees = clamp(cone_degrees, 0, 90)
	angle_jitter_degrees = clamp(angle_jitter_degrees, 0, 15)

	// Base angle from shooter to clicked turf
	var/base_angle = get_angle(user_turf, target_turf)

	// Evenly distribute pellets across [-cone/2 .. +cone/2]
	var/half_cone = cone_degrees / 2
	var/step = (pellet_count > 1) ? (cone_degrees / (pellet_count - 1)) : 0

	var/fired_any = FALSE

	for(var/pellet_index in 1 to pellet_count)
		var/angle_offset

		if(pellet_count <= 1 || cone_degrees <= 0)
			angle_offset = 0
		else
			angle_offset = -half_cone + (pellet_index - 1) * step

		// Small jitter so it doesn't look like a perfectly spaced laser fan
		if(angle_jitter_degrees)
			angle_offset += rand(-angle_jitter_degrees * 10, angle_jitter_degrees * 10) / 10

		var/obj/projectile/projectile_instance = new projectile_path(user_turf)
		ready_projectile(projectile_instance, target, user)

		projectile_instance.fire(base_angle + angle_offset, target)
		projectile_instance.spread = 2
		fired_any = TRUE

	playsound(owner, 'sound/effects/magic/magic_missile.ogg', 75, TRUE)
	return fired_any

/// checks if we're allowed to fire after cast
/datum/action/cooldown/power/thaumaturge/magical_barrage/proc/can_fire_now(mob/living/user)
	if(world.time < barrage_ready_time)
		user.balloon_alert(user, "Wait for the missiles!")
		return FALSE
	return TRUE


// the projectile in question
/obj/projectile/resonant/magic_barrage
	name = "magic missile"
	icon_state = "arcane_barrage"
	damage = 9
	damage_type = BURN
	armour_penetration = 25 // Great for civilian use, less-so on armored opponents.
	armor_flag = LASER
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE // unfortunately for you this is a magical LASER

/* Code for orbitals below */
/obj/effect/magic_missile_orbiter
	name = "magic missile"
	icon = 'icons/obj/weapons/guns/projectiles.dmi'
	icon_state = "arcane_barrage"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	alpha = 180

/// Spawns the oribitng effects around the mob.
/datum/action/cooldown/power/thaumaturge/magical_barrage/proc/spawn_orbitals(amount)
	clear_orbitals()
	if(amount <= 0 || QDELETED(owner))
		return

	for(var/missile_num in 1 to amount)
		var/time_until_created = (missile_num - 1) * time_between_initial_missiles
		if(time_until_created <= 0)
			create_orbital()
		else
			addtimer(CALLBACK(src, PROC_REF(create_orbital)), time_until_created)

/// Creates one missile and makes it orbit
/datum/action/cooldown/power/thaumaturge/magical_barrage/proc/create_orbital()
	if(QDELETED(src) || QDELETED(owner))
		return

	var/obj/effect/magic_missile_orbiter/orbiter = new(get_turf(owner))
	orbiter.transform = matrix()
	orbiter.transform.Scale(0.5, 0.5)
	orbiter.icon = projectile_path.icon // if you end up editing the projectile, it should also affect the orbitals.
	orbiter.icon_state = projectile_path.icon_state // ditto on above
	orbiting_missiles += orbiter
	orbiter.orbit(owner, missile_orbit_radius, rotation_speed =  missile_rotation_speed)
	RegisterSignal(orbiter, COMSIG_QDELETING, PROC_REF(on_orbiter_deleted))
	playsound(owner, 'sound/effects/magic/blink.ogg', 75, TRUE)

/// Clears all orbiting missiles.
/datum/action/cooldown/power/thaumaturge/magical_barrage/proc/clear_orbitals()
	if(!length(orbiting_missiles))
		return
	QDEL_LIST(orbiting_missiles)
	orbiting_missiles.Cut()

/// Removes exactly one orbital.
/datum/action/cooldown/power/thaumaturge/magical_barrage/proc/remove_one_orbital()
	if(!length(orbiting_missiles))
		return FALSE
	qdel(orbiting_missiles[1])
	return TRUE

/// On qdel signaler that removes it from the orbiting list.
/datum/action/cooldown/power/thaumaturge/magical_barrage/proc/on_orbiter_deleted(obj/effect/magic_missile_orbiter/orbiter)
	SIGNAL_HANDLER

	if(!(orbiter in orbiting_missiles))
		return

	if(!QDELETED(owner))
		orbiter.stop_orbit(owner.orbiters)

	orbiting_missiles -= orbiter

// Dispel functionality
/datum/action/cooldown/power/thaumaturge/magical_barrage/Grant(mob/granted_to)
	. = ..()
	if(resonant)
		RegisterSignal(granted_to, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))

/datum/action/cooldown/power/thaumaturge/magical_barrage/Remove(mob/removed_from)
	. = ..()
	if(resonant)
		UnregisterSignal(removed_from, COMSIG_ATOM_DISPEL)

/// On dispel, poof there go your orbitals.
/datum/action/cooldown/power/thaumaturge/magical_barrage/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	if(!active)
		return NONE
	disable_barrage(owner, span_userdanger("Your magic missiles vanish as they are dispelled!"))
	return DISPEL_RESULT_DISPELLED
