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

#include maps\mp\_utility;

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

//#include openwarfare\_playerdvars;

init()
{
    // Weapon info HUD
    scr_hud_show_offhand_info = getdvarx( "scr_hud_show_offhand_info", "int", 1, 0, 2 );
    setDvar( "ui_hud_show_offhand_info", scr_hud_show_offhand_info );
    makeDvarServerInfo( "ui_hud_show_offhand_info" );

    //ammodisplay
    scr_hud_show_weapon_info = getdvarx( "scr_hud_show_weapon_info", "int", 1, 0, 2 );
    setDvar( "ui_hud_show_weapon_info", scr_hud_show_weapon_info );
    makeDvarServerInfo( "ui_hud_show_weapon_info" );

    //
    scr_hud_show_player_info = getdvarx( "scr_hud_show_player_info", "int", 1, 0, 2 );
    setDvar( "ui_hud_show_player_info", scr_hud_show_player_info );
    makeDvarServerInfo( "ui_hud_show_player_info" );

    //
    scr_hud_show_abilities_info = getdvarx( "scr_hud_show_abilities_info", "int", 1, 0, 2 );
    setDvar( "ui_hud_show_abilities_info", scr_hud_show_abilities_info );
    makeDvarServerInfo( "ui_hud_show_abilities_info" );

    //
    scr_hud_show_breath_hint = getdvarx( "scr_hud_show_breath_hint", "int", 1, 0, 2 );
    setDvar( "ui_hud_show_breath_hint", scr_hud_show_breath_hint );
    makeDvarServerInfo( "ui_hud_show_breath_hint" );

    //TODO: Rename. Make it based on player and game state
    setDvar( "ui_hud_show_inventory", 0 );
    makeDvarServerInfo( "ui_hud_show_inventory" );

    // Fade options
    scr_hud_fade_enabled = getdvarx( "scr_hud_fade_enabled", "int", 1, 0, 1 );
    scr_hud_fade_time = getdvarx( "scr_hud_fade_time", "float", 1.7, 0, 10 );
    
	if( scr_hud_fade_enabled ) 
    {
        hudFadeTime = scr_hud_fade_time;

        forceClientDvar( "hud_fade_stance", hudFadeTime );
        forceClientDvar( "hud_fade_ammodisplay", hudFadeTime );
        forceClientDvar( "hud_fade_offhand", hudFadeTime );
        forceClientDvar( "hud_fade_healthbar", hudFadeTime );
    }

    // Waypoint size
    scr_hud_waypoint_size = getdvarx( "scr_hud_waypoint_size", "int", 20, 10, 50 );
	forceClientDvar( "waypointiconwidth", scr_hud_waypoint_size );
	forceClientDvar( "waypointiconheight", scr_hud_waypoint_size );

    // Waypoints area
	forceClientDvar( "waypointOffscreenPadLeft", 100 );
	forceClientDvar( "waypointOffscreenPadRight", 100 );
	forceClientDvar( "waypointOffscreenPadTop", 30 );
	forceClientDvar( "waypointOffscreenPadBottom", 60 );

    // Other
	forceClientDvar( "cg_youinkillcamsize", 1 );
    forceClientDvar( "cg_cursorHints", 4 );
    forceClientDvar( "cg_chatHeight", 6 );
    forceClientDvar( "cg_drawHealth", 1 );
    forceClientDvar( "cg_hudDamageIconHeight", 64 );
    forceClientDvar( "cg_hudDamageIconWidth", 128 );

    // Apply other player dvars
    openwarfare\_playerdvars::completeForceClientDvarsArray();

    // Team status
    scr_hud_show_teams_status = getdvarx( "scr_hud_show_teams_status", "int", 1, 0, 2 );

    if( scr_hud_show_teams_status > 0 )
    {
        level.teamsStatus = spawnStruct();
        level.teamsStatus.teamBasedHUD = level.teamBased && level.gametype != "bel";
        level.teamsStatus.showHUD = scr_hud_show_teams_status;
    
        setDvar( "ui_hud_show_teams_status", 0 );
        makeDvarServerInfo( "ui_hud_show_teams_status" );
        
        setDvar( "ui_hud_teams_status_teambased", int( level.teamsStatus.teamBasedHUD ) );
        makeDvarServerInfo( "ui_hud_teams_status_teambased" );
        
        setDvar( "ui_hud_teams_status_count_allies", 0 );
        makeDvarServerInfo( "ui_hud_teams_status_count_allies" );

        setDvar( "ui_hud_teams_status_count_axis", 0 );
        makeDvarServerInfo( "ui_hud_teams_status_count_axis" );

        if ( level.teamsStatus.teamBasedHUD )
        {
            level thread updateTeamCountsHUD( "allies" );
            level thread updateTeamCountsHUD( "axis" );
        }
    }
    else
    {
        setDvar( "ui_hud_show_teams_status", 0 );
        makeDvarServerInfo( "ui_hud_show_teams_status" );
    }


    level thread prematchOverWatcher();
    level thread gameOverWatcher();

    level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );

    // Better hints
    level.showHintAction = ::showHintAction;
}


onPlayerConnected()
{
    if( isDefined( level.teamsStatus ) && !level.teamsStatus.teamBasedHUD )
    {
        self thread addNewEvent( "onPlayerSpawned", ::updatePlayerScoreHUD );
    }

    self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );
    self thread updatePlayerAngleThread();
}


updatePlayerAngleThread()
{
    //self endon( "death" );
    self endon( "disconnect" );

    for( ;; )
    {
        angles = self getPlayerAngles();

        yaw = 360 - int( angles[1] );

        if ( yaw < 0 ) yaw += 360;
        if ( yaw >= 360 ) yaw -= 360;
            
        self setClientDvar( "ui_hud_compass_angle", yaw );

        wait( 0.05 );
    }
}


onPlayerDeath()
{
    //TODO Work with player session state
    if (self maps\mp\gametypes\_globallogic::maySpawn())
    {
        self setClientDvar( "ui_hud_has_frags", "0" );
	    self setClientDvar( "ui_hud_has_spec_gren", "0" );
        self setClientDvar( "ui_hud_has_weapon", "0" );
    }

    //self setClientDvar( "ui_hud_has_frags", "0" );
	//self setClientDvar( "ui_hud_has_spec_gren", "0" );
    //self setClientDvar( "ui_hud_has_weapon", "0" );
}


showHintAction( hintText )
{
    self setClientDvar( "ui_hud_hint_text", hintText );

    self maps\mp\gametypes\_hud_hints::showHintAction( hintText );
}


prematchOverWatcher()
{
    self waittill( "prematch_over" );

    if( isDefined( level.teamsStatus ) )
    {   
        setdvar( "ui_hud_show_teams_status", level.teamsStatus.showHUD );
    }

    setdvar( "ui_hud_show_inventory", 1 );
}


gameOverWatcher()
{
    self waittill( "game_ended" );

    if( isDefined( level.teamsStatus ) )
    {   
        setdvar( "ui_hud_show_teams_status", 0 );
    }

    setdvar( "ui_hud_show_inventory", 0 );
}


updateTeamCountsHUD( team )
{
    self endon( "game_ended" );

    previousCount = -1;

    for( ;; )
	{
		wait( 0.5 );

        currentCount = 0;

        for( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];

            if( player.team == team && isPlaying( player ) && ( level.gametype != "ftag" || !player.freezeTag["frozen"] ) )
            {
                currentCount++;
            }
        }

        if( currentCount != previousCount )
        {
            setdvar( "ui_hud_teams_status_count_" + team, currentCount );
            previousCount = currentCount;
        }
    }
}


updatePlayerScoreHUD()
{
	self endon( "death" );
    self endon( "disconnect" );
    self endon( "joined_spectators" );
    level endon( "game_ended" );

    lastPlayerScoreRank = 0;

    //TODO: update eventialy 
    //while( isPlayer( self ) && isAlive( self ) )
    while( 1 )
    {
        playerScoreRank = 0; 

        for( i = 0; i < level.players.size; i++ )
        {
            otherPlayer = level.players[i];

            if( self != otherPlayer && isDefined ( otherPlayer ) && otherPlayer.sessionteam != "spectator" && getBestPlayerOf( self, otherPlayer ) == otherPlayer )
            {
                playerScoreRank--;
            }
        }

        if ( playerScoreRank != lastPlayerScoreRank )
        {
            lastPlayerScoreRank = playerScoreRank;
            self setClientDvar( "ui_hud_teams_status_player_rank", int( playerScoreRank * -1 + 1 ) );
        }

        wait( 1 );
    }
}




getBestPlayerOf( playerA, playerB )
{
    if( !isDefined( playerA.pers ) ) return playerB;
    if( !isDefined( playerB.pers ) ) return playerA;

    if( playerA.pers["score"] > playerB.pers["score"] ) return playerA;
    if( playerA.pers["score"] < playerB.pers["score"] ) return playerB;

    playerAkdr = playerA.pers["kills"];
    if( playerA.pers["deaths"] > 0 ) playerAkdr = float( playerA.pers["kills"] / playerA.pers["deaths"] );
    
    playerBkdr = playerB.pers["kills"];
    if( playerB.pers["deaths"] > 0 ) playerBkdr = float( playerB.pers["kills"] / playerB.pers["deaths"] );
    
    if( playerAkdr > playerBkdr ) return playerA;
    if( playerAkdr < playerBkdr ) return playerB;

    return playerA;
}

//  12   7      1.714
//  10   5      2
//  11   5      2.2
//
//  12   8      1.5
//  10   6      1.6666
//  11   6      1.8233