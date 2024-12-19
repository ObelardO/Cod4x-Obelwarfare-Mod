init()
{
	level._effect["snow_light"] = loadfx("weather/snow_light_mp_bloc");

	thread snow();

	ambientPlay("ambient_day");
}

snow()
{
	while ( !isDefined(level.mapCenter) )
	{
		wait 0.05;
	}

	snow1 = spawnfx(level._effect["snow_light"], getWeatherOrigin()+(0,0,170));
	snow2 = spawnfx(level._effect["snow_light"], getWeatherOrigin()+(0,0,140));
	snow3 = spawnfx(level._effect["snow_light"], getWeatherOrigin()+(0,0,110));
	
	triggerfx(snow1,-15);
	triggerfx(snow2,-15);
	triggerfx(snow3,-15);
}
/*
rain()
{
	rain = spawnfx(level.fx["weather_rain"], getWeatherOrigin()+(0,0,200));
	triggerfx(rain,-15);

	if(game["rounds"] > level.dvar["roundLimit"])
	{
		thunder = spawnfx(level.fx["weather_lightning"], getWeatherOrigin()+(0,0,200));
		triggerfx(thunder,-15);
	}
}
*/
getWeatherOrigin()
{
	//Defined in root gametype script;
	return level.mapCenter;
/*
	pos = (0,0,0);

	switch(getdvar("mapname"))
	{
		case "mp_crossfire":
			pos = (5000, -3000, 0);
			break;

		case "mp_cluster":
			pos = (-2000, 3500, 0);
			break;

		case "mp_overgrown":
			pos = (200, -2500, 0);
			break;

		case "mp_crash":
			pos = (538.545,-2.91238,854.74);
			break;

		default:
			break;
	}
	return pos;
	*/
}