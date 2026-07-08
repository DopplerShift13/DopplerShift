/datum/antagonist/ert/official/pallas_cat_inspector
	name = "Pallas Cargo and Transport Inspector"
	outfit = /datum/outfit/centcom/portauthority/pcat/inspector
	plasmaman_outfit = /datum/outfit/plasmaman/pcat

/datum/antagonist/ert/official/pallas_cat_inspector/greet()
	if(!ert_team)
		return

	to_chat(owner, "<span class='warningplain'><B><font size=3 color=red>You are a [name].</font></B></span>")

	to_chat(owner, "<span class='warningplain'>Pallas Cargo and Transport is sending you to [station_name()] with the task: [ert_team.mission.explanation_text]</span>")

/datum/antagonist/ert/fourthcelestialalignment

/datum/antagonist/ert/fourthcelestialalignment/greet()
	if(!ert_team)
		return

	to_chat(owner, "<span class='warningplain'><B><font size=3 color=red>You are a [name].</font></B></span>")

	var/missiondesc = "Your squad is being sent on a mission to [station_name()] by the Port Authority."
	if(leader)
		missiondesc += " Lead your squad to ensure the completion of the mission. Board the shuttle when your team is ready."
	else
		missiondesc += " Follow orders given to you by your squad leader."
	if(!rip_and_tear)
		missiondesc += " Avoid civilian casualties when possible."

	missiondesc += "<span class='warningplain'><BR><B>Your Mission</B> : [ert_team.mission.explanation_text]</span>"
	to_chat(owner,missiondesc)

/datum/antagonist/ert/fourthcelestialalignment/parc
	name = "Port Authority Response Corps Commander"
	outfit = /datum/outfit/centcom/ert/parc
	role = "Commander"

/datum/antagonist/ert/fourthcelestialalignment/parc/officer
	name = "Port Authority Response Corps Officer"
	outfit = /datum/outfit/centcom/ert/parc/officer
	role = "Officer"

// specific role prefixes are handled by ID honorifics
/datum/antagonist/ert/fourthcelestialalignment/voidcorps
	name = "Void Corps Commander"
	outfit = /datum/outfit/centcom/ert/voidcorps
	role = "Warrant Officer"
	rip_and_tear = TRUE

/datum/antagonist/ert/fourthcelestialalignment/voidcorps/autorifle
	name = "Void Corps Automatic Rifleman"
	outfit = /datum/outfit/centcom/ert/voidcorps/autorifle
	role = "Private First Class"

/datum/antagonist/ert/fourthcelestialalignment/voidcorps/breacher
	name = "Void Corps Breacher"
	outfit = /datum/outfit/centcom/ert/voidcorps/breacher
	role = "Lance Corporal"

/datum/antagonist/ert/fourthcelestialalignment/voidcorps/comtech
	name = "Void Corps Combat Technician"
	outfit = /datum/outfit/centcom/ert/voidcorps/comtech
	role = "Corporal"

/datum/antagonist/ert/fourthcelestialalignment/voidcorps/corpsman
	name = "Void Corps Corpsman"
	outfit = /datum/outfit/centcom/ert/voidcorps/corpsman
	role = "Sergeant"
