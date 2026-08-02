/particles/sulfur_spring_steam
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list(
		"steam_cloud_1" = 1,
		"steam_cloud_2" = 1,
		"steam_cloud_3" = 1,
		"steam_cloud_4" = 1,
		"steam_cloud_5" = 1,
	)
	color = "#d5da998a"
	count = 2
	spawning = 0.3
	lifespan = 3 SECONDS
	fade = 1.2 SECONDS
	fadein = 0.4 SECONDS
	position = generator(GEN_BOX, list(-17,-15,0), list(24,15,0), NORMAL_RAND)
	scale = generator(GEN_VECTOR, list(0.9,0.9), list(1.1,1.1), NORMAL_RAND)
	drift = generator(GEN_SPHERE, list(-0.01,0), list(0.01,0.01), UNIFORM_RAND)
	spin = generator(GEN_NUM, list(-2,2), NORMAL_RAND)
	gravity = list(0.05, 0.28)
	friction = 0.3
	grow = 0.037
