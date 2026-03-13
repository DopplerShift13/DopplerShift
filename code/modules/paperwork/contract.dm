/* For employment contracts */

/obj/item/paper/employment_contract
	icon_state = "paper_words"
	throw_range = 3
	throw_speed = 3
	item_flags = NOBLUDGEON
	var/employee_name = ""

/obj/item/paper/employment_contract/Initialize(mapload, new_employee_name)
	if(!new_employee_name)
		return INITIALIZE_HINT_QDEL
	AddElement(/datum/element/update_icon_blocker)
	. = ..()
	employee_name = new_employee_name
	name = "paper- [employee_name] employment contract"
	//DOPPLER EDIT BEGIN - Changes the Employment Contract text.

	/*
	add_raw_text("<center>Conditions of Employment</center>\
	<BR><BR><BR><BR>\
	This Agreement is made and entered into as of the date of last signature below, by and between [employee_name] (hereafter referred to as SLAVE), \
	and Nanotrasen (hereafter referred to as the omnipresent and helpful watcher of humanity).\
	<BR>WITNESSETH:<BR>WHEREAS, SLAVE is a natural born human or humanoid, possessing skills upon which he can aid the omnipresent and helpful watcher of humanity, \
	who seeks employment in the omnipresent and helpful watcher of humanity.<BR>WHEREAS, the omnipresent and helpful watcher of humanity agrees to sporadically provide payment to SLAVE, \
	in exchange for permanent servitude.<BR>NOW THEREFORE in consideration of the mutual covenants herein contained, and other good and valuable consideration, the parties hereto mutually agree as follows:\
	<BR>In exchange for paltry payments, SLAVE agrees to work for the omnipresent and helpful watcher of humanity, \
	for the remainder of his or her current and future lives.<BR>Further, SLAVE agrees to transfer ownership of his or her soul to the loyalty department of the omnipresent and helpful watcher of humanity.\
	<BR>Should transfership of a soul not be possible, a lien shall be placed instead.\
	<BR>Signed,<BR><i>[employee_name]</i>")
	*/

	//DOPPLER EDIT ORIGINAL ABOVE
	add_raw_text("<center>Conditions of Employment</center>\
	<BR>\
	<p>This Agreement is made and entered into as of the date of last signature below, by and between [employee_name] (hereafter referred to as Pallas Aspiring Worker, or PAW), \
	and Pallas Cargo and Transport (hereafter referred to as P-CAT). </p>\
	\
	<p><BR>WITNESSETH:<BR>WHEREAS, PAW is a Sapient being or otherwise Sophont possessing skills upon which they are able aid to P-CAT and seeks employment therein.</p>\
	\
	<p><BR>WHEREAS, P-CAT agrees to provide payment to PAW, via either direct liquid capital or common stock of P-CAT itself, in exchange agreed upon services.</p>\
	\
	<p><BR>NOW THEREFORE in consideration of the mutual covenants herein contained, and other good and valuable consideration, the parties hereto mutually agree as follows:\
	<BR>In exchange for these further negotiated compensations, PAW agrees to work for P-CAT, \
	for the remainder of this fiscal cycle.\
	\
	<p><BR>Further, PAW agrees that P-CAT cannot be held financially liable for the unpredictable hazards found in Crusoe's Rest.\
	<BR>Some exceptions apply, made at the discretion of the P-CAT Commitee members or their appointed Captains.</p>\
	<BR>Signed,<BR><i>[employee_name]</i>")
	//DOPPLER EDIT END
