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
    forceClientDvar( "cg_chatHeight", 8 ); 
    forceClientDvar( "cg_drawhealth", 1 );
    forceClientDvar( "cg_hudDamageIconHeight", 64 );
    forceClientDvar( "cg_hudDamageIconWidth", 128 );
    forceClientDvar( "cg_hudProneY", -52 ); // or +10 for hide this hint
    forceClientDvar( "cg_drawSpectatorMessages", 0 );
    forceClientDvar( "cg_crossHair", ( 1 - level.hardcoreMode ) );

    // Apply other player dvars
    openwarfare\_playerdvars::completeForceClientDvarsArray();

    // Team status
    scr_hud_show_teams_status = getdvarx( "scr_hud_show_teams_status", "int", 1, 0, 2 );

    if( scr_hud_show_teams_status > 0 )
    {
        level.teamsStatus = spawnStruct();
        level.teamsStatus.teamBasedHUD = level.teamBased && level.gametype != "bel";
        level.teamsStatus.showHUD = scr_hud_show_teams_status;
    
        setDvar( "ui_hud_show_teams_status", scr_hud_show_teams_status );
        makeDvarServerInfo( "ui_hud_show_teams_status" );
        
        setDvar( "ui_hud_teams_status_teambased", int( level.teamsStatus.teamBasedHUD ) );
        makeDvarServerInfo( "ui_hud_teams_status_teambased" );
        
        setDvar( "ui_hud_teams_status_count_allies", 0 );
        makeDvarServerInfo( "ui_hud_teams_status_count_allies" );

        setDvar( "ui_hud_teams_status_count_axis", 0 );
        makeDvarServerInfo( "ui_hud_teams_status_count_axis" );

        if ( level.teamsStatus.teamBasedHUD )
        {
            level thread teamCountsWatcher( "allies" );
            level thread teamCountsWatcher( "axis" );
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

    // Move progress bars
    level.primaryProgressBarY = 90; // from center
    level.primaryProgressBarTextY = 76;
    level.secondaryProgressBarY = 184; // from center
    level.secondaryProgressBarTextY = 170;

    level.scr_hud_show_spectator_messages = 0;
}


showHintAction( hintText )
{
    self setClientDvar( "ui_hud_hint_text", hintText );

    self maps\mp\gametypes\_hud_hints::showHintAction( hintText );
}


onPlayerConnected()
{
    self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
    self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );

    self thread playerAngleWatcher();
    self thread playerSessionWatcher();
    self thread playerSpectatingWatcher();
}


onPlayerSpawned()
{
    if( isDefined( level.teamsStatus ) && !level.teamsStatus.teamBasedHUD )
    {
        self thread playerScoreWathcher() ;
    }

    self setClientDvar( "ui_hud_lives_count", getPlayerLivesCount( self ) );
}


playerAngleWatcher()
{
    self endon( "disconnect" );

    for( ;; )
    {
        yaw = 360 - int( self getPlayerAngles()[1] );

        if ( yaw < 0 ) yaw += 360;
        if ( yaw >= 360 ) yaw -= 360;

        self setClientDvar( "ui_hud_compass_angle", yaw );

        wait( 0.05 );
    }
}


playerSpectatingWatcher()
{
    self endon( "disconnect" );

    lastSessionstate = "none";

    for( ;; )
    {
        if ( lastSessionstate != self.sessionstate )
        {
            lastSessionstate = self.sessionstate;

            self setClientDvar( "ui_sessionstate", self.sessionstate );

            //debug info
            //self iPrintLn( self.name + "^2 state: " + self.sessionstate );
        }

        wait ( 0.05 );
    }
}


playerSessionWatcher()
{
    self endon( "disconnect" );

    lastSpectatorClient = -1;

    for( ;; )
    {
        wait ( 0.05 );

        if ( self.sessionstate != "spectator") continue;

        if ( lastSpectatorClient != self.spectatorclient )
        {
            lastSpectatorClient = self.spectatorclient;

            //Debug info
            //self iPrintLn( self.name + "spectating changed to: ^2 " + self.spectatorclient );

            if ( lastSpectatorClient == -1 ) continue;

            player = getPlayerByEntityNumber( lastSpectatorClient );

            if ( isDefined( player ) )
            {
                self setClientDvars(
                    "ui_hud_lives_count",       getPlayerLivesCount ( player ),
                    "ui_hud_spectating_name",   player.name
                );

                if ( isDefined( player.totalBandages ) )
                {
                    self setClientDvar( "ui_bandages_qty", player.totalBandages );
                }
            }
        }
    }
}


onPlayerDeath() {  }


prematchOverWatcher() { }
/*{
    self waittill( "prematch_over" );

    if( isDefined( level.teamsStatus ) )
    {   
        setdvar( "ui_hud_show_teams_status", level.teamsStatus.showHUD );
    }
}*/


gameOverWatcher() { }
/*{
    self waittill( "game_ended" );

    if( isDefined( level.teamsStatus ) )
    {   
        //setdvar( "ui_hud_show_teams_status", 0 );
    }
}*/


teamCountsWatcher( team )
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


playerScoreWathcher()
{
	self endon( "death" );
    self endon( "disconnect" );
    self endon( "joined_spectators" );
    level endon( "game_ended" );

    lastPlayerScoreRank = -1;

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


getPlayerByEntityNumber( entityNumber )
{
    for( i = 0; i < level.players.size; i++ )
    {
        player = level.players[i];

        if( isDefined( player ) && player getEntityNumber() == entityNumber )
        {
            return player;
        }
    }

    return undefined;
}


getPlayerLivesCount( player )
{
    return ( player.pers["lives"] + ( level.numLives != 0 ) );
}


//  12   7      1.714
//  10   5      2
//  11   5      2.2
//
//  12   8      1.5
//  10   6      1.6666
//  11   6      1.8233