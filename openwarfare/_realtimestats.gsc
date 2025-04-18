//******************************************************************************
//  _____                  _    _             __
// |  _  |                | |  | |           / _|
// | | | |_ __   ___ _ __ | |  | | __ _ _ __| |_ __ _ _ __ ___
// | | | | '_ \ / _ \ '_ \| |/\| |/ _` | '__|  _/ _` | '__/ _ \
// \ \_/ / |_) |  __/ | | \  /\  / (_| | |  | || (_| | | |  __/
//  \___/| .__/ \___|_| |_|\/  \/ \__,_|_|  |_| \__,_|_|  \___|
//       | |               We don't make the game you play.
//       |_|                 We make the game you play BETTER.
//
//            Website: http://openwarfaremod.com/
//******************************************************************************

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
	// Get the main module's dvar
	level.scr_realtime_stats_enable = getdvarx( "scr_realtime_stats_enable", "int", 0, 0, 1 );
	level.scr_endofgame_stats_enable = getdvarx( "scr_endofgame_stats_enable", "int", 0, 0, 1 );

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );

	level.scr_realtime_stats_skipbots = getdvarx( "scr_realtime_stats_skipbots", "int", 0, 0, 1 );
	level.scr_endofgame_stats_log = getdvarx( "scr_endofgame_stats_log", "int", 0, 0, 1 );
	level.scr_endofgame_stats_log_external = getdvarx( "scr_endofgame_stats_log_external", "int", 0, 0, 1 );

	// If real time stats are not enabled then there's nothing else to do here
	if ( level.scr_realtime_stats_enable == 0 && level.scr_endofgame_stats_enable == 0 )
		return;

	level.scr_realtime_stats_default_on = getdvarx( "scr_realtime_stats_default_on", "int", 1, 0, 1 );
	
	level.scr_realtime_stats_unit = getdvarx( "scr_realtime_stats_unit", "string", "meters" );
	if ( level.scr_realtime_stats_unit != "meters" && level.scr_realtime_stats_unit != "yards" ) {
		level.scr_realtime_stats_unit = "meters";
	}
	
	// Check if we should show the end of game statistics
	if ( level.scr_endofgame_stats_enable == 1 ) {
		game["menu_eog_stats"] = "eog_statistics";
		precacheMenu( game["menu_eog_stats"] );
		level thread onGameEnded();
	}
}

onGameEnded()
{
	level waittill("intermission");	

	// Wait some time to let all the events be processed
	wait (1.5);

	// Initialize array for best/worst values
	level.eogBest = [];
	level.eogBest["score"]["name"] = "";
	level.eogBest["score"]["value"] = 0;
	level.eogBest["score"]["guid"] = 0;

	level.eogBest["accuracy"]["name"] = "";
	level.eogBest["accuracy"]["value"] = 0;
	level.eogBest["accuracy"]["guid"] = 0;

	level.eogBest["kills"]["name"] = "";
	level.eogBest["kills"]["value"] = 0;
	level.eogBest["kills"]["guid"] = 0;
	
	level.eogBest["teamkills"]["name"] = "";
	level.eogBest["teamkills"]["value"] = 0;
	level.eogBest["teamkills"]["guid"] = 0;	
	
	level.eogBest["killstreak"]["name"] = "";
	level.eogBest["killstreak"]["value"] = 0;	
	level.eogBest["killstreak"]["guid"] = 0;	
	
	level.eogBest["longest"]["name"] = "";
	level.eogBest["longest"]["value"] = 0;	
	level.eogBest["longest"]["guid"] = 0;	

	level.eogBest["melee"]["name"] = "";
	level.eogBest["melee"]["value"] = 0;
	level.eogBest["melee"]["guid"] = 0;

	level.eogBest["claymore"]["name"] = "";
	level.eogBest["claymore"]["value"] = 0;
	level.eogBest["claymore"]["guid"] = 0;

	level.eogBest["headshots"]["name"] = "";
	level.eogBest["headshots"]["value"] = 0;
	level.eogBest["headshots"]["guid"] = 0;

	level.eogBest["longesths"]["name"] = "";
	level.eogBest["longesths"]["value"] = 0;
	level.eogBest["longesths"]["guid"] = 0;

	level.eogBest["deaths"]["name"] = "";
	level.eogBest["deaths"]["value"] = 0;
	level.eogBest["deaths"]["guid"] = 0;

	level.eogBest["suicides"]["name"] = "";
	level.eogBest["suicides"]["value"] = 0;
	level.eogBest["suicides"]["guid"] = 0;

	level.eogBest["deathstreak"]["name"] = "";
	level.eogBest["deathstreak"]["value"] = 0;	
	level.eogBest["deathstreak"]["guid"] = 0;

	level.eogBest["uav"]["name"] = "";
	level.eogBest["uav"]["value"] = 0;
	level.eogBest["uav"]["guid"] = 0;

	level.eogBest["airstrikes"]["name"] = "";
	level.eogBest["airstrikes"]["value"] = 0;
	level.eogBest["airstrikes"]["guid"] = 0;

	level.eogBest["airstrike_kills"]["name"] = "";
	level.eogBest["airstrike_kills"]["value"] = 0;
	level.eogBest["airstrike_kills"]["guid"] = 0;

	level.eogBest["helicopters"]["name"] = "";
	level.eogBest["helicopters"]["value"] = 0;
	level.eogBest["helicopters"]["guid"] = 0;
	
	level.eogBest["helicopter_kills"]["name"] = "";
	level.eogBest["helicopter_kills"]["value"] = 0;
	level.eogBest["helicopter_kills"]["guid"] = 0;
	
	level.eogBest["distance"]["name"] = "";
	level.eogBest["distance"]["value"] = 0;	
	level.eogBest["distance"]["guid"] = 0;	
	
	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];	

		player.pers["stats"]["score"] = player.score;
	}

	// Get all the best/worst players for each stat item we monitor and display at the end of the game
	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];	
		
		if (isDefined( player ) && isPlayer ( player ) && isBot( player ))
			continue;

		guid = player getGUID();

		if ( isDefined( player ) && isDefined( player.pers["stats"] ) ) {	

			player checkStatItem( player.pers["stats"]["score"], "score", guid);

			if ( player.pers["stats"]["accuracy"]["total_shots"] != 0 ) {
				player checkStatItem( int( player.pers["stats"]["accuracy"]["hits"] / player.pers["stats"]["accuracy"]["total_shots"] * 100 ), "accuracy", guid);
			} else {
				player checkStatItem( 0, "accuracy", guid);
			}
			
			player checkStatItem( player.pers["stats"]["kills"]["total"], "kills", guid);
			player checkStatItem( player.pers["stats"]["kills"]["teamkills"], "teamkills", guid);
			player checkStatItem( player.pers["stats"]["kills"]["killstreak"], "killstreak", guid);
			player checkStatItem( player.pers["stats"]["kills"]["longest"], "longest", guid);
			player checkStatItem( player.pers["stats"]["kills"]["knife"], "melee", guid);
			player checkStatItem( player.pers["stats"]["kills"]["claymore"], "claymore", guid);
			player checkStatItem( player.pers["stats"]["kills"]["headshots"], "headshots", guid);
			player checkStatItem( player.pers["stats"]["kills"]["longesths"], "longesths", guid);
			
			player checkStatItem( player.pers["stats"]["deaths"]["total"], "deaths", guid);
			player checkStatItem( player.pers["stats"]["deaths"]["suicides"], "suicides", guid);
			player checkStatItem( player.pers["stats"]["deaths"]["deathstreak"], "deathstreak", guid);
			
			player checkStatItem( player.pers["stats"]["hardpoints"]["uav"], "uav", guid);
			player checkStatItem( player.pers["stats"]["hardpoints"]["airstrikes"], "airstrikes", guid);
			player checkStatItem( player.pers["stats"]["hardpoints"]["airstrike_kills"], "airstrike_kills", guid);
			player checkStatItem( player.pers["stats"]["hardpoints"]["helicopters"], "helicopters", guid);
			player checkStatItem( player.pers["stats"]["hardpoints"]["helicopter_kills"], "helicopter_kills", guid);
			
			player checkStatItem( player.pers["stats"]["misc"]["distance"], "distance", guid);
		}
	}
	
	if ( level.scr_realtime_stats_unit == "meters" ) {
		level.eogBest["distance"]["value"] = int( level.eogBest["distance"]["value"] * 0.0254 * 10 ) / 10;
		longestUnit = " m";
	} else {
		level.eogBest["distance"]["value"] = int( level.eogBest["distance"]["value"] * 0.0278 * 10 ) / 10;
		longestUnit = " yd";
	}
	
	// Send the data to each player
	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];	

		if (isDefined( player ) && isPlayer ( player ) && isBot( player ))
			continue;

		if ( isDefined( player ) ) {
			player setClientDvars(
				"ps_n", player.name,
				"gs_pg", 1,
				"gs_an", level.eogBest["accuracy"]["name"],
				"gs_a", level.eogBest["accuracy"]["value"],
				"gs_kn", level.eogBest["kills"]["name"],
				"gs_k", level.eogBest["kills"]["value"],
				"gs_tn", level.eogBest["teamkills"]["name"],
				"gs_t", level.eogBest["teamkills"]["value"],
				"gs_ksn", level.eogBest["killstreak"]["name"],
				"gs_ks", level.eogBest["killstreak"]["value"],
				"gs_ln", level.eogBest["longest"]["name"],
				"gs_l", level.eogBest["longest"]["value"] + longestUnit,
				"gs_mn", level.eogBest["melee"]["name"],
				"gs_m", level.eogBest["melee"]["value"],
				"gs_hn", level.eogBest["headshots"]["name"],
				"gs_h", level.eogBest["headshots"]["value"],
				"gs_lhn", level.eogBest["longesths"]["name"]				
			);
			player setClientDvars(
				"gs_lh", level.eogBest["longesths"]["value"] + longestUnit,
				"gs_dn", level.eogBest["deaths"]["name"],
				"gs_d", level.eogBest["deaths"]["value"],
				"gs_sn", level.eogBest["suicides"]["name"],
				"gs_s", level.eogBest["suicides"]["value"],
				"gs_dsn", level.eogBest["deathstreak"]["name"],
				"gs_ds", level.eogBest["deathstreak"]["value"],
				"gs_h1n", level.eogBest["uav"]["name"],
				"gs_h1", level.eogBest["uav"]["value"],
				"gs_h2n", level.eogBest["airstrikes"]["name"],
				"gs_h2", level.eogBest["airstrikes"]["value"],
				"gs_h2kn", level.eogBest["airstrike_kills"]["name"],
				"gs_h2k", level.eogBest["airstrike_kills"]["value"],
				"gs_h3n", level.eogBest["helicopters"]["name"],
				"gs_h3", level.eogBest["helicopters"]["value"],
				"gs_h3kn", level.eogBest["helicopter_kills"]["name"],
				"gs_h3k", level.eogBest["helicopter_kills"]["value"]
			);
			player setClientDvars(
				"gs_dtn", level.eogBest["distance"]["name"],
				"gs_dt", level.eogBest["distance"]["value"] + longestUnit
			);			
		}
	}	

	if (level.scr_endofgame_stats_log == 1)
	{
		logResults();
	}
}


getStatItem( statItem, sepChar )
{
	return statItem +sepChar+ level.eogBest[statItem]["value"] +sepChar+ level.eogBest[statItem]["guid"] +sepChar+ level.eogBest[statItem]["name"];
}


checkStatItem( value, statItem, guid )
{
	// Check if this stat item is blank or if the value is higher than the current one
	if ( level.eogBest[statItem]["name"] == "" || value > level.eogBest[statItem]["value"] ) {
		level.eogBest[statItem]["name"] = self.name;
		level.eogBest[statItem]["value"] = value;		
		level.eogBest[statItem]["guid"] = guid;		
	}	
}


onPlayerConnected()
{
	// Check if real time stats are disabled
	if ( level.scr_realtime_stats_enable == 0 ) {
		self setClientDvar( "ui_hud_showstats", 0 );
		// If End Of Game statistics are also disabled will just leave at this point
		if ( level.scr_endofgame_stats_enable == 0 ) {
			return;		
		}
	}
	
	self thread onPlayerKilled();
	self thread onRefreshAccuracy();
	self thread onHardpointCalled();
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	
	// Make sure the initialization happens only at the beginning of the map
	if ( !isDefined( self.pers["stats"] ) ) {
	
		if ( level.scr_realtime_stats_unit == "meters" ) {
			longestDefault = "0 m";
		} else {
			longestDefault = "0 yd";
		}
			
		// Initialize the values
		self setClientDvars(
			"ui_hud_showstats", ( level.scr_realtime_stats_default_on && level.scr_realtime_stats_enable ),
			"ps_a", "",												// Accuracy
			"ps_r", 0,												// Kill/Deaths ratio
			"ps_k", 0,												// Kills
			"ps_t", 0,												// Teamkills
			"ps_cks", 0, 											// Current Killstreak
			"ps_ks", 0, 											// Highest Killstreak
			"ps_l", longestDefault,						// Longest Kill
			"ps_mk", 0,												// Melee Kills
			"ps_dt", longestDefault						// Distance Travelled
		);
		self setClientDvars(
			"ps_h", 0,												// Headshots
			"ps_lh", longestDefault,					// Longest Headshot
			"ps_d", 0, 												// Deaths
			"ps_s", 0,												// Suicides
			"ps_cds", 0,											// Current Deathstreak
			"ps_ds", 0,												// Highest Deathstreak
			"ps_h1", 0,												// UAVs
			"ps_h2", 0,												// Airstrikes
			"ps_h2k", 0,											// Airstrike Kills
			"ps_h3", 0,												// Helicopters
			"ps_h3k", 0												// Helicopter Kills
		);
		
		// Initialize variables to keep stats
		self.pers["stats"] = [];
		self.pers["stats"]["show"] = level.scr_realtime_stats_default_on;
		self.pers["stats"]["score"] = 0;

		// Accuracy
		self.pers["stats"]["accuracy"] = [];
		self.pers["stats"]["accuracy"]["total_shots"] = 0;
		self.pers["stats"]["accuracy"]["hits"] = 0;
		
		// Kills
		self.pers["stats"]["kills"] = [];
		self.pers["stats"]["kills"]["total"] = 0;
		self.pers["stats"]["kills"]["teamkills"] = 0;
		self.pers["stats"]["kills"]["consecutive"] = 0;
		self.pers["stats"]["kills"]["killstreak"] = 0;
		self.pers["stats"]["kills"]["longest"] = 0;
		self.pers["stats"]["kills"]["knife"] = 0;
		self.pers["stats"]["kills"]["claymore"] = 0;
		self.pers["stats"]["kills"]["headshots"] = 0;
		self.pers["stats"]["kills"]["longesths"] = 0;
		
		// Deaths
		self.pers["stats"]["deaths"] = [];
		self.pers["stats"]["deaths"]["total"] = 0;
		self.pers["stats"]["deaths"]["suicides"] = 0;
		self.pers["stats"]["deaths"]["consecutive"] = 0;
		self.pers["stats"]["deaths"]["deathstreak"] = 0;
		
		// Hardpoints
		self.pers["stats"]["hardpoints"] = [];
		self.pers["stats"]["hardpoints"]["uav"] = 0;
		self.pers["stats"]["hardpoints"]["airstrikes"] = 0;
		self.pers["stats"]["hardpoints"]["airstrike_kills"] = 0;
		self.pers["stats"]["hardpoints"]["helicopters"] = 0;
		self.pers["stats"]["hardpoints"]["helicopter_kills"] = 0;

		// Misc
		self.pers["stats"]["misc"] = [];
		self.pers["stats"]["misc"]["distance"] = 0;		
	}	
}


onPlayerSpawned()
{
	self endon("disconnect");

	if ( level.scr_realtime_stats_unit == "meters" ) {
		mUnit = " m";
	} else {
		mUnit = " yd";
	}
	
	oldPosition = self.origin;
	oldValue = self.pers["stats"]["misc"]["distance"];
	updateLoop = 0;
	
	// Monitor this player until he/she dies or the round ends
	while ( isAlive( self ) && game["state"] != "postgame" ) {
		wait (0.1);
		
		// Make sure the player is not jumping
		if ( self isOnGround() || self isOnLadder() ) {
			// Calculate the distance between the last knows position and the current one
			travelledDistance = distance( oldPosition, self.origin );
			
			// If we have a positive travelled distance add it up 
			if ( travelledDistance > 0 ) {
				oldPosition = self.origin;
				self.pers["stats"]["misc"]["distance"] += travelledDistance;
			}			
		}
		
		// We update every second
		updateLoop++;
		if ( updateLoop == 10 ) {
			updateLoop = 0;
			if ( oldValue != self.pers["stats"]["misc"]["distance"] ) {
				oldValue = self.pers["stats"]["misc"]["distance"];
				travelledDistance = getPlayerDistance( self );
				self setClientDvar( "ps_dt", travelledDistance + mUnit );
			}
		}		
	}
	
	// Update one more time once the player dies
	if ( oldValue != self.pers["stats"]["misc"]["distance"] ) {
		oldValue = self.pers["stats"]["misc"]["distance"];
		travelledDistance = getPlayerDistance( self );
		self setClientDvar( "ps_dt", travelledDistance + mUnit );
	}	
}


onRefreshAccuracy()
{
	self endon("disconnect");
	
	for (;;) {
		self waittill( "refresh_accuracy", shotsFired, hits );

		self.pers["stats"]["accuracy"]["total_shots"] += shotsFired;
		self.pers["stats"]["accuracy"]["hits"] += hits;
		
		// Calculate new accuracy
		newAccuracy = int( self.pers["stats"]["accuracy"]["hits"] / self.pers["stats"]["accuracy"]["total_shots"] * 100 );
		newAccuracy = newAccuracy;
		self setClientDvar( "ps_a", newAccuracy );
	}	
}


onPlayerKilled()
{
	self endon("disconnect");
	
	for (;;) {
		self waittill( "player_killed", eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, fDistance );

		if (isPlayer( self ) && isBot( self ))
			continue;

		// Make sure the player is not switching teams or being team balanced (our suicides count only when the player kills himself)
		if ( sMeansOfDeath == "MOD_SUICIDE" )
			continue;
			
		// Check if it was a suicide
		if ( sMeansOfDeath == "MOD_FALLING" || ( isPlayer( attacker ) && attacker == self ) ) {
			self.pers["stats"]["deaths"]["suicides"] += 1;
		}

		if ( isPlayer( attacker ) && isBot( attacker ) )
			continue;

		// Handle the stats for the victim 
		self.pers["stats"]["kills"]["consecutive"] = 0;
		self.pers["stats"]["deaths"]["total"] += 1;
		self.pers["stats"]["deaths"]["consecutive"] += 1;
		if ( self.pers["stats"]["deaths"]["consecutive"] > self.pers["stats"]["deaths"]["deathstreak"] )
			self.pers["stats"]["deaths"]["deathstreak"] = self.pers["stats"]["deaths"]["consecutive"];
		
		// Update stats for the victim
		kdRatio = int( self.pers["stats"]["kills"]["total"] / self.pers["stats"]["deaths"]["total"] * 100 ) / 100;
		self setClientDvars(
			"ps_r", kdRatio,
			"ps_cks", 0,
			"ps_d", self.pers["stats"]["deaths"]["total"], 
			"ps_s", self.pers["stats"]["deaths"]["suicides"], 
			"ps_cds", self.pers["stats"]["deaths"]["consecutive"],
			"ps_ds", self.pers["stats"]["deaths"]["deathstreak"]
		);

		// Handle the stats for the attacker
		if ( isPlayer( attacker ) && attacker != self ) {
			// Check if it was a team kill (team kills don't count towards K/D ratio or total kills, headshots, distances, etc)
			if ( level.teambased && isPlayer( attacker ) && attacker.pers["team"] == self.pers["team"] ) {
				attacker.pers["stats"]["kills"]["teamkills"] += 1;
				// Update the stats for the attacker
				attacker setClientDvars(
					"ps_t", attacker.pers["stats"]["kills"]["teamkills"]
				);				
			} else {
				attacker.pers["stats"]["deaths"]["consecutive"] = 0;
				attacker.pers["stats"]["kills"]["consecutive"] += 1;

				// Check if consecutive kills is higher than the killstreak
				if ( attacker.pers["stats"]["kills"]["consecutive"] > attacker.pers["stats"]["kills"]["killstreak"] ) {
					attacker.pers["stats"]["kills"]["killstreak"] = attacker.pers["stats"]["kills"]["consecutive"];
				}
	
				// Check if this was a headshot
				if ( sMeansOfDeath == "MOD_HEAD_SHOT" ) {
					attacker.pers["stats"]["kills"]["headshots"] += 1;
					
				// Check if this was a melee
				} else if ( sMeansOfDeath == "MOD_MELEE" || sMeansOfDeath == "MOD_BAYONET" ) {
					attacker.pers["stats"]["kills"]["knife"] += 1;			

				// Check if this was a claymore
				} else if ( sMeansOfDeath == "MOD_GRENADE_SPLASH" && sWeapon == "claymore_mp" ) {
					attacker.pers["stats"]["kills"]["claymore"] += 1;
				}				

				// Check if a hardpoint was used
				switch( sWeapon ) {
					case "artillery_mp":
						attacker.pers["stats"]["hardpoints"]["airstrike_kills"]++;
						break;

					case "cobra_20mm_mp":
					case "cobra_FFAR_mp":
					case "hind_FFAR_mp":
						attacker.pers["stats"]["hardpoints"]["helicopter_kills"]++;
						break;
						
					default:
						// Should we check the distance
						switch ( weaponClass( sWeapon ) )	{
							case "rifle":
							case "pistol":
							case "mg":
							case "smg":
							case "spread":
								// Check in which unit are we measuring
								if ( level.scr_realtime_stats_unit == "meters" ) {
									shotDistance = int( fDistance * 0.0254 * 10 ) / 10;
								} else {
									shotDistance = int( fDistance * 0.0278 * 10 ) / 10;
								}
								if ( shotDistance > attacker.pers["stats"]["kills"]["longest"] ) {
									attacker.pers["stats"]["kills"]["longest"] = shotDistance;
								}
								if ( sMeansOfDeath == "MOD_HEAD_SHOT" && shotDistance > attacker.pers["stats"]["kills"]["longesths"] ) {
									attacker.pers["stats"]["kills"]["longesths"] = shotDistance;
								}
								break;
						}
						break;
				}	
						
				attacker.pers["stats"]["kills"]["total"] += 1;
				
				// Calculate some intermediary variables
				if ( attacker.pers["stats"]["deaths"]["total"] > 0 ) {
					kdRatio = int( attacker.pers["stats"]["kills"]["total"] / attacker.pers["stats"]["deaths"]["total"] * 100 ) / 100;
				} else {
					kdRatio = attacker.pers["stats"]["kills"]["total"];
				}
				
				if ( level.scr_realtime_stats_unit == "meters" ) {
					longestKill = attacker.pers["stats"]["kills"]["longest"] + " m";
					longestHS = attacker.pers["stats"]["kills"]["longesths"] + " m";
				} else {
					longestKill = attacker.pers["stats"]["kills"]["longest"] + " yd";
					longestHS = attacker.pers["stats"]["kills"]["longesths"] + " yd";
				}
				
				// Update the stats for the attacker
				attacker setClientDvars(
					"ps_r", kdRatio,
					"ps_k", attacker.pers["stats"]["kills"]["total"],
					"ps_cks", attacker.pers["stats"]["kills"]["consecutive"], 
					"ps_ks", attacker.pers["stats"]["kills"]["killstreak"], 
					"ps_l", longestKill,
					"ps_mk", attacker.pers["stats"]["kills"]["knife"],
					"ps_h", attacker.pers["stats"]["kills"]["headshots"],
					"ps_lh", longestHS,
					"ps_cds", attacker.pers["stats"]["deaths"]["consecutive"],
					"ps_h2k", attacker.pers["stats"]["hardpoints"]["airstrike_kills"],
					"ps_h3k", attacker.pers["stats"]["hardpoints"]["helicopter_kills"]
				);			
			}
		}		
	}
}


onHardpointCalled()
{
	self endon("disconnect");
	
	for (;;)
	{
		self waittill( "hardpoint_called", hardpointName );
		
		clientVariable = undefined;
		newValue = undefined;
		
		// Check which hardpoint was used
		switch ( hardpointName )
		{
			case "radar_mp":
				self.pers["stats"]["hardpoints"]["uav"]++;
				clientVariable = "ps_h1";
				newValue = self.pers["stats"]["hardpoints"]["uav"];
				break;
				
			case "airstrike_mp":
				self.pers["stats"]["hardpoints"]["airstrikes"]++;
				clientVariable = "ps_h2";
				newValue = self.pers["stats"]["hardpoints"]["airstrikes"];
				break;
				
			case "helicopter_mp":
				self.pers["stats"]["hardpoints"]["helicopters"]++;
				clientVariable = "ps_h3";
				newValue = self.pers["stats"]["hardpoints"]["helicopters"];
				break;
		}
		
		// Check if we had a valid hardpoint
		if ( isDefined( clientVariable ) ) {
			self setClientDvar( clientVariable, newValue );
		}		
	}	
}


isBot( player )
{

	return level.scr_realtime_stats_skipbots == 1 && isPlayer ( player ) && ( player getGUID() ) == "0";
	//TODO: try isDefined( self.pers["isBot"] flag for checking 
}


logResults()
{
	s = ";";
	timeStamp = getTimeStampStr();
	eogStatFS = 0;

	if (level.scr_endofgame_stats_log_external)
	{
		eogStatFS = FS_FOpen( "stats_mp.log", "append" );

		if (eogStatFS == 0) return;
	}

	logResultLine( eogStatFS, timeStamp, "------------------------------------------------------------" );
	logResultLine( eogStatFS, timeStamp, "EG_S" +s+ getDvar( "mapname" ) +s+ level.gametype +s+ getWinnerString(s) );

	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];	
		
		if (isDefined( player ) && isPlayer ( player ) && isBot( player ))
			continue;

		if ( isDefined( player ) && isDefined( player.pers["stats"] ) ) {	

			playerId = player getGUID() +s+ player.name; 

			logResultLine( eogStatFS, timeStamp, "EG_P" +s+
				"guid:"  + player getGUID() +s+
				"name:"  + player.name +s+
				"team:"  + player.pers["team"] +s+
				"score:" + player.score +s+

				"hits:"        + player.pers["stats"]["accuracy"]["hits"] +s+
				"total_shots:" + player.pers["stats"]["accuracy"]["total_shots"] +s+

				"kills:"       + player.pers["stats"]["kills"]["total"] +s+
				"teamkills:"   + player.pers["stats"]["kills"]["teamkills"] +s+
				"killstreak:"  + player.pers["stats"]["kills"]["killstreak"] +s+
				"longest:"     + player.pers["stats"]["kills"]["longest"] +s+
				"melee:"       + player.pers["stats"]["kills"]["knife"] +s+
				"claymore:"    + player.pers["stats"]["kills"]["claymore"] +s+
				"headshots:"   + player.pers["stats"]["kills"]["headshots"] +s+
				"longesths:"   + player.pers["stats"]["kills"]["longesths"] +s+

				"deaths:"      + player.pers["stats"]["deaths"]["total"] +s+
				"suicides:"    + player.pers["stats"]["deaths"]["suicides"] +s+
				"deathstreak:" + player.pers["stats"]["deaths"]["deathstreak"] +s+

				"uav:"              + player.pers["stats"]["hardpoints"]["uav"] +s+
				"airstrikes:"       + player.pers["stats"]["hardpoints"]["airstrikes"] +s+
				"airstrike_kills:"  + player.pers["stats"]["hardpoints"]["airstrike_kills"] +s+
				"helicopters:"      + player.pers["stats"]["hardpoints"]["helicopters"] +s+
				"helicopter_kills:" + player.pers["stats"]["hardpoints"]["helicopter_kills"] +s+

				"distance:"         + getPlayerDistance( player )
			);
		}		
	}

	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "score", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "accuracy", s ) );

	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "kills", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "teamkills", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "killstreak", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "longest", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "melee", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "claymore", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "headshots", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "longesths", s ) );

	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "deaths", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "suicides", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "deathstreak", s ) );

	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "uav", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "airstrikes", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "airstrike_kills", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "helicopters", s ) );
	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "helicopter_kills", s ) );

	logResultLine( eogStatFS, timeStamp, "EG_B" +s+ getStatItem( "distance", s ) );

	if (level.scr_endofgame_stats_log_external && eogStatFS != 0)
		FS_FClose(eogStatFS);
}


logResultLine( statsFileStream, timeStamp, logLine )
{
	if (level.scr_endofgame_stats_log_external)
	{
		FS_WriteLine ( statsFileStream, timeStamp + logLine );
	}
	else
	{
		logPrint ( logLine + "\n" );
	}
}

getTimeStampStr()
{
	return TimeToString( int( gettime() / 1000 ), 1, " %M:%S " );
}

getPlayerDistance( player )
{
	if ( !isDefined( player ) )
		return 0;

	if ( level.scr_realtime_stats_unit == "meters" ) {
		return int( player.pers["stats"]["misc"]["distance"] * 0.0254 * 10 ) / 10;
	} else {
		return int( player.pers["stats"]["misc"]["distance"] * 0.0278 * 10 ) / 10;
	}
}

getWinnerString( sepChar )
{
	winPlayer = getHighestScoringPlayer();
	winPlayerGuid = 0;
	winPlayerName = "";
	winTeam = "tie";

	if ( isDefined( winPlayer ) )
	{
		winPlayerGuid = winPlayer getGUID();
		winPlayerName = winPlayer.name;
	}

	if ( level.teamBased && level.gametype != "bel" )
 	{
 		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
			winTeam = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			winTeam = "axis";
		else
			winTeam = "allies";
	}
	else
	{
		winTeam = "player";

	}

	return winTeam +sepChar+ winPlayerGuid +sepChar+ winPlayerName;
}


getHighestScoringPlayer()
{
	players = level.players;
	winner = undefined;
	tie = false;

	for( i = 0; i < players.size; i++ )
	{
		if ( isBot( players[i] ) )
			continue;

		if ( !isDefined( players[i].score ) )
			continue;

		if ( players[i].score < 1 )
			continue;

		if ( !isDefined( winner ) || players[i].score > winner.score )
		{
			winner = players[i];
			tie = false;
		}
		else if ( players[i].score == winner.score )
		{
			tie = true;
		}
	}

	if ( tie || !isDefined( winner ) )
		return undefined;
	else
		return winner;
}