// Only random shipping containers

/obj/effect/spawner/random/salvage/container
	name = "random shipping container"
	icon_state = "container"
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot,
	)

/obj/effect/spawner/random/salvage/container/medical_or_research
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/medical_or_research,
	)

/obj/effect/spawner/random/salvage/container/construction
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/construction,
	)

/obj/effect/spawner/random/salvage/container/civilian_supply
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/civilian_supply,
	)

/obj/effect/spawner/random/salvage/container/military
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/military,
	)

/obj/effect/spawner/random/salvage/container/salvage
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/salvage,
	)

// Random crates and shipping containers

/obj/effect/spawner/random/salvage/container_or_crate
	name = "random crate or shipping container"
	icon_state = "container"
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot,
		/obj/structure/closet/crate/shuttle/secured/random_loot,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot,
	)

/obj/effect/spawner/random/salvage/container_or_crate/medical_or_research
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/medical_or_research,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/medical_or_research,
		/obj/structure/closet/crate/shuttle/secured/random_loot/medical_or_research,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/medical_or_research,
	)

/obj/effect/spawner/random/salvage/container_or_crate/construction
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/construction,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/construction,
		/obj/structure/closet/crate/shuttle/secured/random_loot/construction,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/construction,
	)

/obj/effect/spawner/random/salvage/container_or_crate/civilian_supply
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/civilian_supply,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/civilian_supply,
		/obj/structure/closet/crate/shuttle/secured/random_loot/civilian_supply,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/civilian_supply,
	)

/obj/effect/spawner/random/salvage/container_or_crate/military
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/military,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/military,
		/obj/structure/closet/crate/shuttle/secured/random_loot/military,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/military,
	)

/obj/effect/spawner/random/salvage/container_or_crate/salvage
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/salvage,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/salvage,
		/obj/structure/closet/crate/shuttle/secured/random_loot/salvage,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/salvage,
	)

// Only random crates without shipping containers

/obj/effect/spawner/random/salvage/crate_only
	name = "random crate"
	icon_state = "crate"
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot,
		/obj/structure/closet/crate/shuttle/secured/random_loot,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot,
	)

/obj/effect/spawner/random/salvage/crate_only/medical_or_research
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/medical_or_research,
		/obj/structure/closet/crate/shuttle/secured/random_loot/medical_or_research,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/medical_or_research,
	)

/obj/effect/spawner/random/salvage/crate_only/construction
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/construction,
		/obj/structure/closet/crate/shuttle/secured/random_loot/construction,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/construction,
	)

/obj/effect/spawner/random/salvage/crate_only/civilian_supply
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/civilian_supply,
		/obj/structure/closet/crate/shuttle/secured/random_loot/civilian_supply,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/civilian_supply,
	)

/obj/effect/spawner/random/salvage/crate_only/military
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/military,
		/obj/structure/closet/crate/shuttle/secured/random_loot/military,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/military,
	)

/obj/effect/spawner/random/salvage/crate_only/salvage
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/salvage,
		/obj/structure/closet/crate/shuttle/secured/random_loot/salvage,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/salvage,
	)

// Random crates and shipping containers and misc. cargo

/obj/effect/spawner/random/salvage/container_or_crate_or_cargo
	name = "random crate or shipping container or cargo"
	icon_state = "container"
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot,
		/obj/structure/closet/crate/shuttle/secured/random_loot,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot,
		/obj/effect/spawner/random/salvage/cargo_machine,
	)

/obj/effect/spawner/random/salvage/container_or_crate_or_cargo/medical_or_research
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/medical_or_research,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/medical_or_research,
		/obj/structure/closet/crate/shuttle/secured/random_loot/medical_or_research,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/medical_or_research,
		/obj/effect/spawner/random/salvage/cargo_machine/medical_or_research,
	)

/obj/effect/spawner/random/salvage/container_or_crate_or_cargo/construction
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/construction,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/construction,
		/obj/structure/closet/crate/shuttle/secured/random_loot/construction,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/construction,
		/obj/effect/spawner/random/salvage/cargo_machine/construction,
	)

/obj/effect/spawner/random/salvage/container_or_crate_or_cargo/civilian_supply
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/civilian_supply,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/civilian_supply,
		/obj/structure/closet/crate/shuttle/secured/random_loot/civilian_supply,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/civilian_supply,
		/obj/effect/spawner/random/salvage/civilian_supply,
	)

/obj/effect/spawner/random/salvage/container_or_crate_or_cargo/military
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/military,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/military,
		/obj/structure/closet/crate/shuttle/secured/random_loot/military,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/military,
		/obj/effect/spawner/random/salvage/cargo_machine/military,
	)

/obj/effect/spawner/random/salvage/container_or_crate_or_cargo/salvage
	loot = list(
		/obj/structure/closet/shipping_container/secured/random_loot/salvage,
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/salvage,
		/obj/structure/closet/crate/shuttle/secured/random_loot/salvage,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/salvage,
		/obj/effect/spawner/random/salvage/cargo_machine/scrap,
	)

// Random crates and misc. cargo, no shipping containers

/obj/effect/spawner/random/salvage/crate_or_cargo
	name = "random crate or cargo"
	icon_state = "crate"
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot,
		/obj/structure/closet/crate/shuttle/secured/random_loot,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot,
		/obj/effect/spawner/random/salvage/cargo_machine,
	)

/obj/effect/spawner/random/salvage/crate_or_cargo/medical_or_research
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/medical_or_research,
		/obj/structure/closet/crate/shuttle/secured/random_loot/medical_or_research,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/medical_or_research,
		/obj/effect/spawner/random/salvage/cargo_machine/medical_or_research,
	)

/obj/effect/spawner/random/salvage/crate_or_cargo/construction
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/construction,
		/obj/structure/closet/crate/shuttle/secured/random_loot/construction,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/construction,
		/obj/effect/spawner/random/salvage/cargo_machine/construction,
	)

/obj/effect/spawner/random/salvage/crate_or_cargo/civilian_supply
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/civilian_supply,
		/obj/structure/closet/crate/shuttle/secured/random_loot/civilian_supply,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/civilian_supply,
		/obj/effect/spawner/random/salvage/civilian_supply,
	)

/obj/effect/spawner/random/salvage/crate_or_cargo/military
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/military,
		/obj/structure/closet/crate/shuttle/secured/random_loot/military,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/military,
		/obj/effect/spawner/random/salvage/cargo_machine/military,
	)

/obj/effect/spawner/random/salvage/crate_or_cargo/salvage
	loot = list(
		/obj/structure/closet/crate/shuttle_hard/secured/random_loot/salvage,
		/obj/structure/closet/crate/shuttle/secured/random_loot/salvage,
		/obj/structure/closet/crate/shuttle/small/secured/random_loot/salvage,
		/obj/effect/spawner/random/salvage/cargo_machine/scrap,
	)
