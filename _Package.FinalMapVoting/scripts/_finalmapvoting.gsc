//**************************************************************//
//  _____ _          _    _    _             __                 //
// |  _  | |        | |  | |  | |           / _|                //
// | | | | |__   ___| |  | |  | | __ _ _ __| |_ __ _ _ __ ___   //
// | | | | '_ \ / _ \ |  | |/\| |/ _` | '__|  _/ _` | '__/ _ \  //
// \ \_/ / |_) |  __/ |__\  /\  / (_| | |  | || (_| | | |  __/  //
//  \___/|_.__/ \___|____/\/  \/ \__,_|_|  |_| \__,_|_|  \___|  //
//                                                              //
//            Website: http://cod4.obelardo.ru                  //
//**************************************************************//

#include openwarfare\_utils;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                         FINAL MAP VOTING SYSTEM                                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

init()
{
	level.scr_fmv_enabled = getdvarx( "scr_fmv_enabled", "int", 0, 0, 1 );

	if( !level.scr_fmv_enabled )
	{
		logPrint(" Package FMV disabled \n");
		return;
	}
	

	level.onEndGameMapVote = ::onEngGameMapVote;

	game["menu_fmv"] = "finalmapvoting";
	precacheMenu( game["menu_fmv"] );

	logPrint(" Package FMV started \n");
}

onEngGameMapVote()
{
	//level thread 
	map();

	wait 35;
}

map()
{
	if( !isDefined( level.scr_fmv_enabled ) || !level.scr_fmv_enabled )
		return;

	level.votetime = 30;

	tmpmaps=strTok(getDvar("sv_mapRotation"), " ");
	maps = [];
	for(i=0;i<tmpmaps.size;i++)
	{
		if(tmpmaps[i] != "map")
			maps[maps.size] = tmpmaps[i];
	}
	if(maps.size <9)
	{
		iprintlnbold("^1Not enough maps in sv_mapRotation to start vote!");
	}
	else if(maps.size >= 9)
	{
		level.map["map1"] = "";
		level.map["map2"] = "";
		level.map["map3"] = "";
		level.map["map4"] = "";
		level.map["map5"] = "";
		level.map["map6"] = "";
		level.map["map7"] = "";
		level.map["map8"] = "";
		level.map["map9"] = "";
		level.map["map1_realname"] = "";
		level.map["map2_realname"] = "";
		level.map["map3_realname"] = "";
		level.map["map4_realname"] = "";
		level.map["map5_realname"] = "";
		level.map["map6_realname"] = "";
		level.map["map7_realname"] = "";
		level.map["map8_realname"] = "";
		level.map["map9_realname"] = "";

		usedmaps = "";
		for(i=1;i<10;i++)
		{
			selected_map = "";
			uniqueMap = false;
			while(!uniqueMap)
			{
				selected_map = maps[randomintrange(0,maps.size)];
				if(!isSubStr(usedmaps, selected_map))
				{
					usedmaps += selected_map;
					uniqueMap = true;
				}
			}
			level.map["map" + i] = getSubStr(selected_map, 3);
			if(!isCustomMap(selected_map))
			{
				level.map["map" + i + "_realname"] = getRealMapName(selected_map);
				level.map["map" + i + "_material"] = getSubStr(selected_map, 3);
			}
			if(isCustomMap(selected_map))
			{
				level.map["map" + i + "_realname"] = getGoodName(selected_map);
				level.map["map" + i + "_material"] = "placeholder";
			}
			wait 0.05;
		}
		level.map["map0_votes"] = 0;
		level.map["map1_votes"] = 0;
		level.map["map2_votes"] = 0;
		level.map["map3_votes"] = 0;
		level.map["map4_votes"] = 0;
		level.map["map5_votes"] = 0;
		level.map["map6_votes"] = 0;
		level.map["map7_votes"] = 0;
		level.map["map8_votes"] = 0;
		level.map["map9_votes"] = 0;
		level.voting = true;
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];

			player iPrintLn( "START VOTING" );


			allClientDvar("map1_realname", level.map["map" + 1 + "_realname"]);
			allClientDvar("map2_realname", level.map["map" + 2 + "_realname"]);
			allClientDvar("map3_realname", level.map["map" + 3 + "_realname"]);
			allClientDvar("map4_realname", level.map["map" + 4 + "_realname"]);
			allClientDvar("map5_realname", level.map["map" + 5 + "_realname"]);
			allClientDvar("map6_realname", level.map["map" + 6 + "_realname"]);
			allClientDvar("map7_realname", level.map["map" + 7 + "_realname"]);
			allClientDvar("map8_realname", level.map["map" + 8 + "_realname"]);
			allClientDvar("map9_realname", level.map["map" + 9 + "_realname"]);
			allClientDvar("map1", level.map["map" + 1 + "_material"]);
			allClientDvar("map2", level.map["map" + 2 + "_material"]);
			allClientDvar("map3", level.map["map" + 3 + "_material"]);
			allClientDvar("map4", level.map["map" + 4 + "_material"]);
			allClientDvar("map5", level.map["map" + 5 + "_material"]);
			allClientDvar("map6", level.map["map" + 6 + "_material"]);
			allClientDvar("map7", level.map["map" + 7 + "_material"]);
			allClientDvar("map8", level.map["map" + 8 + "_material"]);
			allClientDvar("map9", level.map["map" + 9 + "_material"]);
			level.roundStarted = undefined;
			for(i=0;i<level.players.size;i++)
			{
				player = level.players[i];
				player setClientDvar("selected_map", 1337);
				player thread updateVotes();
				player thread animVoteMap();
				player thread voteMenuResponse();
				player closeMenu();
				player closeInGameMenu();
				player.lastvoted = 0;
				player.specate = undefined;
				if(player.sessionstate != "playing")
					player notify("menuresponse", game["menu_team"], "autoassign");
				wait 0.05;
				player openMenu( game["menu_fmv"] );
			}
		}
		time = level.votetime;
		for(i=0;i<time;i++)
		{
			wait 1;
			level.votetime -= 1;
		}
		level.voting = undefined;
		result = level getMostVotedForMap();
		name = getRealMapName(result);
		allClientDvar("votetime", "Next map:^1 " + name);
		allClientDvar("cl_bypassmouseinput", 0);
		freezeall();
		changelevel(result, 3, false);
	}
	maps=strTok(getDvar("sv_mapRotation"), " ");
	currentmap=getDvar("mapname");
	nextMap="Unknown/Same map";
	for(i=1; i < maps.size && maps[i] !=currentmap; i+=2)
	{
		wait 0.05;
	}
	if(isDefined(maps[i+2]))
		nextmap=maps[i+2];
	announcement("^2Nextmap:^3 " + nextMap);
	wait 5;
	exitLevel( false );
}

voteMenuResponse()
{
	for(;;)
	{
		self waittill("menuresponse",menu,response);

		
		if(menu == game["menu_fmv"])
		{
			self iprintLn( "MAP RESP: " + response);

			votemap(response);
		}
	}
}

allClientDvar(dvar, value)
{
	for(i=0;i<level.players.size;i++)
	{
		level.players[i] setClientDvar(dvar, value);
	}
}

getRealMapName(map)
{
	mapname = "";
	switch(map)
	{
		case "mp_backlot": 		mapname = "Backlot";		break;
		case "mp_bloc": 		mapname = "Bloc"; 			break;
		case "mp_bog": 			mapname = "Bog"; 			break;
		case "mp_broadcast": 	mapname = "Broadcast";		break;
		case "mp_cargoship": 	mapname = "Wetwork"; 		break;
		case "mp_citystreets": 	mapname = "District"; 		break;
		case "mp_convoy":		mapname = "Ambush"; 		break;
		case "mp_countdown": 	mapname = "Countdown"; 		break;
		case "mp_crash": 		mapname = "Crash"; 			break;
		case "mp_crossfire": 	mapname = "Crossfire"; 		break;
		case "mp_farm": 		mapname = "Downpour"; 		break;
		case "mp_overgrown": 	mapname = "Overgrown"; 		break;
		case "mp_pipeline": 	mapname = "Pipeline"; 		break;
		case "mp_shipment": 	mapname = "Shipment"; 		break;
		case "mp_showdown": 	mapname = "Showdown"; 		break;
		case "mp_strike": 		mapname = "Strike"; 		break;
		case "mp_vacant": 		mapname = "Vacant"; 		break;
		case "mp_crash_snow": 	mapname = "Winter Crash"; 	break;
		case "mp_creek": 		mapname = "Creek"; 			break;
		case "mp_carentan": 	mapname = "Chinatown"; 		break;
		case "mp_killhouse":	mapname = "Killhouse"; 		break;
		case "mp_marketcenter":	mapname = "Marketcenter"; 	break;
		case "mp_nuketown":		mapname = "Nuketown"; 		break;

	}
	if(mapname == "")
		mapname = getGoodName(map);
	return mapname;
}

isCustomMap(mapname)
{
	isCustom = true;
	switch(mapname)
	{
		case"mp_backlot": 		isCustom = false;break;
		case"mp_bloc": 			isCustom = false;break;
		case"mp_bog": 			isCustom = false;break;
		case"mp_broadcast": 	isCustom = false;break;
		case"mp_cargoship": 	isCustom = false;break;
		case"mp_citystreets": 	isCustom = false;break;
		case"mp_convoy":		isCustom = false;break;
		case"mp_countdown": 	isCustom = false;break;
		case"mp_crash": 		isCustom = false;break;
		case"mp_crossfire": 	isCustom = false;break;
		case"mp_farm": 			isCustom = false;break;
		case"mp_overgrown": 	isCustom = false;break;
		case"mp_pipeline": 		isCustom = false;break;
		case"mp_shipment": 		isCustom = false;break;
		case"mp_showdown": 		isCustom = false;break;
		case"mp_strike": 		isCustom = false;break;
		case"mp_vacant": 		isCustom = false;break;
		case"mp_crash_snow": 	isCustom = false;break;
		case"mp_creek": 		isCustom = false;break;
		case"mp_carentan": 		isCustom = false;break;
		case"mp_killhouse":		isCustom = false;break;
		case"mp_marketcenter":	isCustom = false;break;
		case"mp_nuketown":		isCustom = false;break;

	}
	return isCustom;
}

getGoodName(mapname)
{
	mapname = getSubStr(mapname, 3);
	mapname += " ";
	newname = "";
	switch(mapname[0])
	{
		case"a": newname += "A"; break;
		case"b": newname += "B"; break;
		case"c": newname += "C"; break;
		case"d": newname += "D"; break;
		case"e": newname += "E"; break;
		case"f": newname += "F"; break;
		case"g": newname += "G"; break;
		case"h": newname += "H"; break;
		case"i": newname += "I"; break;
		case"j": newname += "J"; break;
		case"k": newname += "K"; break;
		case"l": newname += "L"; break;
		case"m": newname += "M"; break;
		case"n": newname += "N"; break;
		case"o": newname += "O"; break;
		case"p": newname += "P"; break;
		case"q": newname += "Q"; break;
		case"r": newname += "R"; break;
		case"s": newname += "S"; break;
		case"t": newname += "T"; break;
		case"u": newname += "U"; break;
		case"v": newname += "V"; break;
		case"w": newname += "W"; break;
		case"x": newname += "X"; break;
		case"y": newname += "Y"; break;
		case"z": newname += "Z"; break;
	}
	for(i=1;i<mapname.size;i++)
	{
		if(mapname[i] == "_")
		{
			newname += " ";
			if(isDefined(mapname[i+1]))
			{
				switch(mapname[i+1])
				{
					case"a": newname += "A"; break;
					case"b": newname += "B"; break;
					case"c": newname += "C"; break;
					case"d": newname += "D"; break;
					case"e": newname += "E"; break;
					case"f": newname += "F"; break;
					case"g": newname += "G"; break;
					case"h": newname += "H"; break;
					case"i": newname += "I"; break;
					case"j": newname += "J"; break;
					case"k": newname += "K"; break;
					case"l": newname += "L"; break;
					case"m": newname += "M"; break;
					case"n": newname += "N"; break;
					case"o": newname += "O"; break;
					case"p": newname += "P"; break;
					case"q": newname += "Q"; break;
					case"r": newname += "R"; break;
					case"s": newname += "S"; break;
					case"t": newname += "T"; break;
					case"u": newname += "U"; break;
					case"v": newname += "V"; break;
					case"w": newname += "W"; break;
					case"x": newname += "X"; break;
					case"y": newname += "Y"; break;
					case"z": newname += "Z"; break;
				}
				i++;
			}
		}
		else if(mapname[i] != "_")
		{
			newname += mapname[i];
		}
	}
	return newname;
}

getMostVotedForMap()
{
	mapvotes_array = [];
	mapname_array = [];

	for(i = 1; i < 11; i++)
	{
		mapvotes_array[mapvotes_array.size] = level.map["map" + i + "_votes"];
		mapname_array[mapname_array.size] = level.map["map" + i];
	}

	n = mapvotes_array.size;

	for(i = 0; i < n; i++)
	{
		for(j = i + 1; j < n; j++)
		{
			if (mapvotes_array[i] > mapvotes_array[j])
			{
				a =  mapvotes_array[i];
				b = mapname_array[i];

				mapvotes_array[i] = mapvotes_array[j];
				mapname_array[i] = mapname_array[j];

				mapvotes_array[j] = a;
				mapname_array[j] = b;
			}
		}
	}
    return "mp_" + mapname_array[mapname_array.size - 1];
}

freezeall()
{
	for(i=0;i<level.players.size;i++)
		level.players[i] freezecontrols(true);
}

updateVotes()
{
	while(isDefined(level.voting))
	{
		self setClientDvar("votes_map1", level.map["map1_votes"]);
		self setClientDvar("votes_map2", level.map["map2_votes"]);
		self setClientDvar("votes_map3", level.map["map3_votes"]);
		self setClientDvar("votes_map4", level.map["map4_votes"]);
		self setClientDvar("votes_map5", level.map["map5_votes"]);
		self setClientDvar("votes_map6", level.map["map6_votes"]);
		self setClientDvar("votes_map7", level.map["map7_votes"]);
		self setClientDvar("votes_map8", level.map["map8_votes"]);
		self setClientDvar("votes_map9", level.map["map9_votes"]);
		if(level.votetime < 4)
			self setClientDvar("votetime", "Vote Map - Time left:^1 " + level.votetime);
		else
			self setClientDvar("votetime", "Vote Map - Time left: " + level.votetime);
		wait 0.05;
	}
}

animVoteMap()
{
	for(i=0;i<417;i+=41.6)
	{
		iprintln(i);

		self setClientDvar("map3_x", int(i));
		self setClientDvar("map6_x", int(i));
		self setClientDvar("map9_x", int(i));

		self setClientDvar("map2_x", int(i - 180));
		self setClientDvar("map5_x", int(i - 180));
		self setClientDvar("map8_x", int(i - 180));

		self setClientDvar("map1_x", int(i - 360));
		self setClientDvar("map4_x", int(i - 360));
		self setClientDvar("map7_x", int(i - 360));
		wait 0.05;
	}
}

changelevel(map, delay, persistence)
{
	if(!isDefined(persistence))
		persistence = false;
	old_rotation = strTok(getDvar("sv_mapRotation"), " ");
	new_rotation = "";
	new_rotation += "map " + map + " ";
	for(i=0;i<old_rotation.size;i++)
	{
		if(old_rotation[i] == map)
		{
			i+=2;
		}
		else
			new_rotation += old_rotation[i] + " ";
	}
	setDvar("sv_maprotationcurrent", "");
	setDvar("sv_maprotation", new_rotation);
	allClientDvar("cl_bypassmouseinput", 0);
	wait delay;
	exitlevel(persistence);
}

votemap(response)
{
	if(isDefined(level.voting))
	{
		switch(response)
		{
			case"map1": if(self.lastvoted != 1){level.map["map" + self.lastvoted + "_votes"] -= 1;
						level.map["map1_votes"] += 1; self.lastvoted = 1; self setClientDvar("selected_map", 1);} break;
			case"map2": if(self.lastvoted != 2){level.map["map" + self.lastvoted + "_votes"] -= 1;
						level.map["map2_votes"] += 1; self.lastvoted = 2; self setClientDvar("selected_map", 2);} break;
			case"map3": if(self.lastvoted != 3){level.map["map" + self.lastvoted + "_votes"] -= 1;
						level.map["map3_votes"] += 1; self.lastvoted = 3; self setClientDvar("selected_map", 3);} break;
			case"map4": if(self.lastvoted != 4){level.map["map" + self.lastvoted + "_votes"] -= 1;
						level.map["map4_votes"] += 1; self.lastvoted = 4; self setClientDvar("selected_map", 4);} break;
			case"map5": if(self.lastvoted != 5){level.map["map" + self.lastvoted + "_votes"] -= 1;
						level.map["map5_votes"] += 1; self.lastvoted = 5; self setClientDvar("selected_map", 5);} break;
			case"map6": if(self.lastvoted != 6){level.map["map" + self.lastvoted + "_votes"] -= 1;
						level.map["map6_votes"] += 1; self.lastvoted = 6; self setClientDvar("selected_map", 6);} break;
			case"map7": if(self.lastvoted != 7){level.map["map" + self.lastvoted + "_votes"] -= 1;
						level.map["map7_votes"] += 1; self.lastvoted = 7; self setClientDvar("selected_map", 7);} break;
			case"map8": if(self.lastvoted != 8){level.map["map" + self.lastvoted + "_votes"] -= 1;
						level.map["map8_votes"] += 1; self.lastvoted = 8; self setClientDvar("selected_map", 8);} break;
			case"map9": if(self.lastvoted != 9){level.map["map" + self.lastvoted + "_votes"] -= 1;
						level.map["map9_votes"] += 1; self.lastvoted = 9; self setClientDvar("selected_map", 9);} break;
		}
	}
}
