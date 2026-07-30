
/**
 * Overrides
 */

/area
	/// The type of encryption key faxes start with when loaded into this area, if any.
	var/obj/item/encryptionkey/fax_encryption_key_type


/**
 * General Station Areas
 */

/area/station/command
	fax_encryption_key_type = /obj/item/encryptionkey/headset_com

/area/station/cargo
	fax_encryption_key_type = /obj/item/encryptionkey/headset_cargo

/area/station/engineering
	fax_encryption_key_type = /obj/item/encryptionkey/headset_eng

/area/station/medical
	fax_encryption_key_type = /obj/item/encryptionkey/headset_med

/area/station/science
	fax_encryption_key_type = /obj/item/encryptionkey/headset_sci

/area/station/security
	fax_encryption_key_type = /obj/item/encryptionkey/headset_sec

/area/station/service
	fax_encryption_key_type = /obj/item/encryptionkey/headset_service


/**
 * Special Station Areas
 */

/area/station/service/lawoffice
	fax_encryption_key_type = /obj/item/encryptionkey/headset_srvsec

/area/station/medical/psychology
	fax_encryption_key_type = /obj/item/encryptionkey/headset_srvmed
