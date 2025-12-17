init()
{
	// Override the daytime vision for winter server event
	if ( isDefined ( game["_dcs_data"] ) )
	{
		game["_dcs_data"][1] = openwarfare\_daycyclesystem::initDayCycleData( level.scr_dcs_day_length, "default_day", "dcsday", false, false, 5000, (170/255, 189/255, 224/255) );
	}

	level._effect["snow_light"] = loadfx("weather/snow_light_mp_bloc");

	ambientPlay("ambient_day");

	level thread snow();
}


snow()
{
	while ( !isDefined(level.mapCenter) )
	{
		wait 0.05;
	}

	snow1 = spawnfx( level._effect["snow_light"], getMapCenter() + ( 0, 0, 170 ) );
	snow2 = spawnfx( level._effect["snow_light"], getMapCenter() + ( 0, 0, 140 ) );
	//snow3 = spawnfx(level._effect["snow_light"], getMapCenter()+(0,0,110));
	
	triggerfx( snow1, -15 );
	triggerfx( snow2, -15 );
	//triggerfx(snow3,-15);
}
/*
rain()
{
	rain = spawnfx(level.fx["weather_rain"], getMapCenter()+(0,0,200));
	triggerfx(rain,-15);

	if(game["rounds"] > level.dvar["roundLimit"])
	{
		thunder = spawnfx(level.fx["weather_lightning"], getMapCenter()+(0,0,200));
		triggerfx(thunder,-15);
	}
}
*/
getMapCenter()
{
	return level.mapCenter;
}