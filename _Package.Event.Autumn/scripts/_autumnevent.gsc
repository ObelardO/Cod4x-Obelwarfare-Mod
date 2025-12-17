init()
{
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