/*	
	 ███▄ ▄███▓ ██▓ ▄████▄   ██░ ██  ▄▄▄      ▓█████  ██▓        ███▄ ▄███▓▓██   ██▓▓█████  ██▀███    ██████ 
	▓██▒▀█▀ ██▒▓██▒▒██▀ ▀█  ▓██░ ██▒▒████▄    ▓█   ▀ ▓██▒       ▓██▒▀█▀ ██▒ ▒██  ██▒▓█   ▀ ▓██ ▒ ██▒▒██    ▒ 
	▓██    ▓██░▒██▒▒▓█    ▄ ▒██▀▀██░▒██  ▀█▄  ▒███   ▒██░       ▓██    ▓██░  ▒██ ██░▒███   ▓██ ░▄█ ▒░ ▓██▄   
	▒██    ▒██ ░██░▒▓▓▄ ▄██▒░▓█ ░██ ░██▄▄▄▄██ ▒▓█  ▄ ▒██░       ▒██    ▒██   ░ ▐██▓░▒▓█  ▄ ▒██▀▀█▄    ▒   ██▒
	▒██▒   ░██▒░██░▒ ▓███▀ ░░▓█▒░██▓ ▓█   ▓██▒░▒████▒░██████▒   ▒██▒   ░██▒  ░ ██▒▓░░▒████▒░██▓ ▒██▒▒██████▒▒
	░ ▒░   ░  ░░▓  ░ ░▒ ▒  ░ ▒ ░░▒░▒ ▒▒   ▓▒█░░░ ▒░ ░░ ▒░▓  ░   ░ ▒░   ░  ░   ██▒▒▒ ░░ ▒░ ░░ ▒▓ ░▒▓░▒ ▒▓▒ ▒ ░
	░  ░      ░ ▒ ░  ░  ▒    ▒ ░▒░ ░  ▒   ▒▒ ░ ░ ░  ░░ ░ ▒  ░   ░  ░      ░ ▓██ ░▒░  ░ ░  ░  ░▒ ░ ▒░░ ░▒  ░ ░
	░      ░    ▒ ░░         ░  ░░ ░  ░   ▒      ░     ░ ░      ░      ░    ▒ ▒ ░░     ░     ░░   ░ ░  ░  ░  
	       ░    ░  ░ ░       ░  ░  ░      ░  ░   ░  ░    ░  ░          ░    ░ ░        ░  ░   ░           ░  
	               ░                                                        ░ ░                              

	Michael Myers (CoD4) created by Blade
	Vistic Clan ©

	Discord: 	Blade #6504
				discord.gg/JKwXV3h
*/

init()
{
	//level.fx["weather_snow"] = loadfx("weather/snow_light_mp_bloc");
	level.fx_snow = loadfx("weather/snow_light_mp_bloc");

	thread snow();

	/*
	if(getdvar("mapname") != "mp_farm" || getdvar("mapname") != "mp_crash_snow")
	{
		if(level.dvar["xmasMode"])
		{
			iprintln("Snow");
			thread snow();
		}
		else 
		{
			weather = randomint(5);
			if(weather == 1 || weather == 3)
			{
				iprintln("Rain");
				thread rain();
			}
		}
		return;
	}
	*/
}

snow()
{
	snow = spawnfx(level.fx_snow, getWeatherOrigin()+(0,0,200));
	triggerfx(snow,-15);
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
}