/obj/item/reagent_containers/blood/sap
	blood_type = BLOOD_TYPE_SAP

/obj/item/reagent_containers/blood/sap/examine()
	. = ..()
	. += span_notice("A blood-bag filled with sap, for Viridians.")
