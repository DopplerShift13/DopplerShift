#define COLOR_PA_ORANGE "#ff6821"

/datum/id_trim/centcom/commander/portauthority
	assignment = JOB_PORTAUTH_COMMANDER
	honorifics = list("Commander", "CMDR.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	trim_icon = 'modular_doppler/modular_jobs/icons/card.dmi'
	trim_state = "trim_portauthority"
	sechud_icon_state = "hudportauthority"
	department_color = COLOR_PA_ORANGE
	subdepartment_color = COLOR_PA_ORANGE

/datum/id_trim/centcom/commander/portauthority/pcat
	assignment = JOB_PCAT_MANAGER
	honorifics = list("Manager", "MNGR.")
	trim_state = "trim_pcat"
	sechud_icon_state = "hudpcat"
	department_color = COLOR_PA_ORANGE
	subdepartment_color = COLOR_PA_ORANGE

/datum/id_trim/centcom/commander/portauthority/pcat/inspector
	assignment = JOB_PCAT_INSPECTOR
	honorifics = list("Inspector", "INSP.")

/datum/id_trim/centcom/ert/voidcorps
	department_color = COLOR_PA_ORANGE
	subdepartment_color = COLOR_PA_ORANGE
	trim_icon = 'modular_doppler/modular_jobs/icons/card.dmi'
	trim_state = "trim_voidcorps_commander"
	sechud_icon_state = "hudvoidcorpscommander"

/datum/id_trim/centcom/ert/voidcorps/New()
	. = ..()
	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/datum/id_trim/centcom/ert/voidcorps/commander
	assignment = JOB_ERT_VOID_CORPS_COMMANDER
	honorifics = list("Commander", "CMDR.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	trim_state = "trim_voidcorps_commander"
	sechud_icon_state = "hudvoidcorpscommander"

/datum/id_trim/centcom/ert/voidcorps/autorifle
	assignment = JOB_ERT_VOID_CORPS_AUTORIFLE
	trim_state = "trim_voidcorps_autorifle"
	sechud_icon_state = "hudvoidcorpsautorifle"
	honorifics = list("Autorifleman", "AR.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/ert/voidcorps/breacher
	assignment = JOB_ERT_VOID_CORPS_BREACHER
	trim_state = "trim_voidcorps_breacher"
	sechud_icon_state = "hudvoidcorpsbreacher"
	honorifics = list("Breacher", "BR.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/ert/voidcorps/comtech
	assignment = JOB_ERT_VOID_CORPS_COMTECH
	trim_state = "trim_voidcorps_comtech"
	sechud_icon_state = "hudvoidcorpscomtech"
	honorifics = list("Combat Technician", "CT.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/ert/voidcorps/corpsman
	assignment = JOB_ERT_VOID_CORPS_CORPSMAN
	trim_state = "trim_voidcorps_corpsman"
	sechud_icon_state = "hudvoidcorpscorpsman"
	honorifics = list("Corpsman", "HM.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/ert/parc
	trim_icon = 'modular_doppler/modular_jobs/icons/card.dmi'
	trim_state = "trim_parc_commander"
	sechud_icon_state = "hudparccommander"
	department_color = COLOR_PA_ORANGE
	subdepartment_color = COLOR_PA_ORANGE

/datum/id_trim/centcom/ert/parc/commander
	assignment = JOB_ERT_PARC_COMMANDER
	honorifics = list("Commander", "CMDR.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	trim_state = "trim_parc_commander"
	sechud_icon_state = "hudparccommander"

/datum/id_trim/centcom/ert/parc/commander/New()
	. = ..()
	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/datum/id_trim/centcom/ert/parc/officer
	assignment = JOB_ERT_PARC_OFFICER
	honorifics = list("Officer")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	trim_state = "trim_parc_officer"
	sechud_icon_state = "hudparcofficer"

/datum/id_trim/centcom/ert/parc/officer/New()
	. = ..()
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)
