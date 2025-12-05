init()
{
	// Override the daytime vision for autumn server event
	if ( isDefined ( game["_dcs_data"] ) )
	{
		game["_dcs_data"][1]["visions"] = [];
		game["_dcs_data"][1]["visions"][0] = "default_day";
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