init()
{
	// Same asset names as the map props, so mod.ff supplies the scarecrow mesh.
	// me_phonebooth is the booth (~1.8 m). The handset model is shrunk away.
	// Small grey oaks are the same mesh scaled to 2.5 m.
	precacheModel( "fox_scarecrow" );
	precacheModel( "me_phonebooth" );
	precacheModel( "me_phonebooth_phone" );
	precacheModel( "foliage_tree_grey_oak_sm_a" );
	precacheModel( "foliage_tree_grey_oak_sm_ts" );

	// Override the daytime vision for autumn server event
	if ( isDefined ( game["_dcs_data"] ) )
	{
		game["_dcs_data"][1] = openwarfare\_daycyclesystem::initDayCycleData( level.scr_dcs_day_length, "default_day", "dcsday", false, false, 5000, (170/255, 189/255, 224/255) );
	}


    //level thread rain();
}

/*
rain()
{
	while ( !isDefined(level.mapCenter) )
	{
		wait 0.05;
	}

	rain = spawnfx(level.fx["weather_rain"], getMapCenter()+(0,0,200));
	triggerfx(rain,-15);

	if(game["rounds"] > level.dvar["roundLimit"])
	{
		thunder = spawnfx(level.fx["weather_lightning"], getMapCenter()+(0,0,200));
		triggerfx(thunder,-15);
	}
}

getMapCenter()
{
	return level.mapCenter;
}
*/