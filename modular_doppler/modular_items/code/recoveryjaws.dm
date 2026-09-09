// Redefines restricted access to allow paramedics to open more departments.
/obj/item/crowbar/power/paramedic
	blacklisted_access = list(
		ACCESS_COMMAND,
		ACCESS_BRIG,
		ACCESS_AI_UPLOAD,
		ACCESS_CAPTAIN,
		ACCESS_HOP,
		ACCESS_ARMORY,
		ACCESS_HOS,
		ACCESS_DETECTIVE,
		ACCESS_CE,
		ACCESS_CMO,
		ACCESS_QM,
		ACCESS_VAULT,
		ACCESS_RD,
		ACCESS_SYNDICATE,
	)
