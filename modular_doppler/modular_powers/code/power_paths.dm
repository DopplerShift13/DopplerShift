/// Singleton metadata for a selectable power path and its preferences UI presentation.
/datum/power_path
	abstract_type = /datum/power_path

	/// Stable UI key used throughout TGUI and middleware maps.
	var/path_key
	/// The POWER_PATH_* define value powers in this path point at.
	var/power_path
	/// The archetype metadata this path belongs to.
	var/datum/power_archetype/archetype_type
	/// Ordering within the archetype.
	var/path_sort_order = 0
	/// Human-readable name for the path.
	var/display_name
	/// Optional icon asset from tgui/packages/tgui/assets.
	var/icon_asset_name
	/// Whether this path should be clickable in preferences.
	var/is_available = TRUE
	/// Path-specific mechanics copy shown in the preferences page.
	var/mechanics_text = ""
	/// Path-specific overview copy shown in the preferences page.
	var/overview_text = ""
	/// Accent color used by the preferences page.
	var/theme_color = "#ffffff"
	/// Whether this path bypasses the 2-path selection limit.
	var/path_limit_exempt = FALSE

/datum/power_path/New()
	. = ..()

	ASSERT(abstract_type != type, "Attempted to instantiate abstract power path datum [type]")
	ASSERT(!isnull(path_key), "Power path datum [type] is missing path_key")
	ASSERT(!isnull(power_path), "Power path datum [type] is missing power_path")
	ASSERT(!isnull(archetype_type), "Power path datum [type] is missing archetype_type")
	ASSERT(!isnull(GLOB.all_power_archetypes[initial(archetype_type.archetype_id)]), "Power path datum [type] references unregistered archetype [archetype_type]")
	ASSERT(!isnull(display_name), "Power path datum [type] is missing display_name")

/datum/power_path/proc/get_archetype()
	return GLOB.all_power_archetypes[initial(archetype_type.archetype_id)]

/datum/power_path/proc/to_ui_data()
	var/datum/power_archetype/archetype_data = get_archetype()
	return list(
		"displayName" = display_name,
		"archetypeId" = archetype_data.archetype_id,
		"iconAssetName" = icon_asset_name,
		"isAvailable" = is_available,
		"mechanicsText" = mechanics_text,
		"overviewText" = overview_text,
		"pathLimitExempt" = path_limit_exempt,
		"themeColor" = theme_color,
	)

/// Metadata for archetypes, in which the paths are contained.
/datum/power_archetype
	abstract_type = /datum/power_archetype

	/// Stable UI key used for landing page grouping.
	var/archetype_id
	/// Display title for the archetype group.
	var/title
	/// Ordering on the landing page.
	var/sort_order = 0

/datum/power_archetype/New()
	. = ..()

	ASSERT(abstract_type != type, "Attempted to instantiate abstract power archetype datum [type]")
	ASSERT(!isnull(archetype_id), "Power archetype datum [type] is missing archetype_id")
	ASSERT(!isnull(title), "Power archetype datum [type] is missing title")

/datum/power_archetype/sorcerous
	archetype_id = "sorcerous"
	title = "Sorcerous"
	sort_order = POWER_ARCHETYPE_SORT_SORCEROUS

/datum/power_archetype/resonant
	archetype_id = "resonant"
	title = "Resonant"
	sort_order = POWER_ARCHETYPE_SORT_RESONANT

/datum/power_archetype/mortal
	archetype_id = "mortal"
	title = "Mortal"
	sort_order = POWER_ARCHETYPE_SORT_MORTAL

/// Constructs the global archetype registry by instantiating every concrete /datum/power_archetype subtype.
/proc/generate_power_archetypes()
	RETURN_TYPE(/list/datum/power_archetype)

	var/list/datum/power_archetype/all_power_archetypes = list()
	var/list/archetype_types = sort_list(subtypesof(/datum/power_archetype), GLOBAL_PROC_REF(cmp_power_archetypes_asc))

	for(var/datum/power_archetype/archetype_path as anything in archetype_types)
		if(initial(archetype_path.abstract_type) == archetype_path)
			continue

		var/datum/power_archetype/archetype_data = new archetype_path
		if(!isnull(all_power_archetypes[archetype_data.archetype_id]))
			stack_trace("Duplicate power archetype id [archetype_data.archetype_id] detected while registering [archetype_path]. Existing archetype datum: [all_power_archetypes[archetype_data.archetype_id]]")
			qdel(archetype_data)
			continue

		all_power_archetypes[archetype_data.archetype_id] = archetype_data

	return all_power_archetypes

/// Constructs the global power path registry by instantiating every concrete /datum/power_path subtype.
/proc/generate_power_paths()
	RETURN_TYPE(/list/datum/power_path)

	var/list/datum/power_path/all_power_paths = list()
	var/list/path_types = sort_list(subtypesof(/datum/power_path), GLOBAL_PROC_REF(cmp_power_paths_asc))

	for(var/datum/power_path/path_type as anything in path_types)
		if(initial(path_type.abstract_type) == path_type)
			continue

		var/datum/power_path/path_data = new path_type
		if(!isnull(all_power_paths[path_data.path_key]))
			stack_trace("Duplicate power path key [path_data.path_key] detected while registering [path_type]. Existing path datum: [all_power_paths[path_data.path_key]]")
			qdel(path_data)
			continue

		all_power_paths[path_data.path_key] = path_data

	return all_power_paths

/// Constructs a lookup keyed by the POWER_PATH_* define value.
/proc/generate_power_paths_by_define()
	RETURN_TYPE(/list/datum/power_path)

	var/list/datum/power_path/power_paths_by_define = list()

	for(var/path_key in GLOB.all_power_paths)
		var/datum/power_path/path_data = GLOB.all_power_paths[path_key]
		if(!isnull(power_paths_by_define[path_data.power_path]))
			stack_trace("Duplicate power path define [path_data.power_path] detected while indexing [path_data.type]. Existing path datum: [power_paths_by_define[path_data.power_path]]")
			continue
		power_paths_by_define[path_data.power_path] = path_data

	return power_paths_by_define

/// Builds the server-owned TGUI config map for every registered power path.
/proc/generate_power_path_ui_data()
	RETURN_TYPE(/list)

	var/list/power_path_ui_data = list()

	for(var/path_key in GLOB.all_power_paths)
		var/datum/power_path/path_data = GLOB.all_power_paths[path_key]
		power_path_ui_data[path_key] = path_data.to_ui_data()

	return power_path_ui_data

/// Builds the ordered archetype list TGUI uses on the landing page.
/proc/generate_power_path_archetypes()
	RETURN_TYPE(/list)

	var/list/power_path_archetypes = list()
	var/list/archetype_entries_by_id = list()

	for(var/archetype_id in GLOB.all_power_archetypes)
		var/datum/power_archetype/archetype_data = GLOB.all_power_archetypes[archetype_id]
		var/list/archetype_entry = list(
			"id" = archetype_data.archetype_id,
			"title" = archetype_data.title,
			"pathIds" = list(),
		)
		archetype_entries_by_id[archetype_data.archetype_id] = archetype_entry
		power_path_archetypes += list(archetype_entry)

	for(var/path_key in GLOB.all_power_paths)
		var/datum/power_path/path_data = GLOB.all_power_paths[path_key]
		var/datum/power_archetype/archetype_data = path_data.get_archetype()
		var/list/archetype_entry = archetype_entries_by_id[archetype_data.archetype_id]
		var/list/path_ids = archetype_entry["pathIds"]
		path_ids += path_data.path_key

	return power_path_archetypes

/// Returns the first registered power path key for UI fallback selection.
/proc/generate_fallback_power_path_id()
	for(var/list/archetype_entry as anything in GLOB.power_path_archetypes)
		var/list/path_ids = archetype_entry["pathIds"]
		if(length(path_ids))
			return path_ids[1]
	return null

GLOBAL_LIST_INIT_TYPED(all_power_archetypes, /datum/power_archetype, generate_power_archetypes())
GLOBAL_LIST_INIT_TYPED(all_power_paths, /datum/power_path, generate_power_paths())
GLOBAL_LIST_INIT_TYPED(power_paths_by_define, /datum/power_path, generate_power_paths_by_define())
GLOBAL_LIST_INIT(power_path_ui_data, generate_power_path_ui_data())
GLOBAL_LIST_INIT(power_path_archetypes, generate_power_path_archetypes())
GLOBAL_VAR_INIT(fallback_power_path_id, generate_fallback_power_path_id())

/// Sorts power archetypes by archetype order.
/proc/cmp_power_archetypes_asc(datum/power_archetype/first_archetype, datum/power_archetype/second_archetype)
	var/first_sort_order = initial(first_archetype.sort_order)
	var/second_sort_order = initial(second_archetype.sort_order)

	if(first_sort_order != second_sort_order)
		return first_sort_order - second_sort_order

	return sorttext(initial(second_archetype.archetype_id), initial(first_archetype.archetype_id))

/// Sorts power paths by archetype and then path order.
/proc/cmp_power_paths_asc(datum/power_path/first_path, datum/power_path/second_path)
	var/datum/power_archetype/first_archetype = GLOB.all_power_archetypes[initial(first_path.archetype_type.archetype_id)]
	var/datum/power_archetype/second_archetype = GLOB.all_power_archetypes[initial(second_path.archetype_type.archetype_id)]

	if(first_archetype.sort_order != second_archetype.sort_order)
		return first_archetype.sort_order - second_archetype.sort_order

	var/first_path_order = initial(first_path.path_sort_order)
	var/second_path_order = initial(second_path.path_sort_order)

	if(first_path_order != second_path_order)
		return first_path_order - second_path_order

	return sorttext(initial(second_path.path_key), initial(first_path.path_key))
