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

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

//#include openwarfare\_playerdvars;

init()
{
    // Weapon info HUD
    scr_hud_show_offhand_items = getdvarx( "scr_hud_show_offhand_items", "int", 1, 0, 2 );
    setDvar( "ui_hud_show_offhand_items", scr_hud_show_offhand_items );
    makeDvarServerInfo( "ui_hud_show_offhand_items" );

    //ammodisplay
    scr_hud_show_ammodisplay = getdvarx( "scr_hud_show_ammodisplay", "int", 1, 0, 2 );
    setDvar( "ui_hud_show_ammodisplay", scr_hud_show_ammodisplay );
    makeDvarServerInfo( "ui_hud_show_ammodisplay" );

    setDvar( "ui_hud_show_weaponinfo", 0 );
    makeDvarServerInfo( "ui_hud_show_weaponinfo" );

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

    // Other
	forceClientDvar( "cg_youinkillcamsize", 1 );
    forceClientDvar( "cg_cursorHints", 4 );
    forceClientDvar( "cg_chatHeight", 6 );

    // Apply other player dvars
    openwarfare\_playerdvars::completeForceClientDvarsArray();

    // Team status
    scr_hud_show_teamstat = getdvarx( "scr_hud_show_teamstat", "int", 1, 0, 2 );

    if( scr_hud_show_teamstat > 0 )
    {
        level.teamStats = spawnStruct();
        level.teamStats.teamBasedHUD = level.teamBased && level.gametype != "bel";
        level.teamStats.showHUD = scr_hud_show_teamstat;
    
        setDvar( "ui_hud_show_teamstat", 0 );
        makeDvarServerInfo( "ui_hud_show_teamstat" );
        
        setDvar( "ui_hud_teamstat_teambased", int( level.teamStats.teamBasedHUD ) );
        makeDvarServerInfo( "ui_hud_teamstat_teambased" );
        
        setDvar( "ui_hud_teamstat_count_allies", 0 );
        makeDvarServerInfo( "ui_hud_teamstat_count_allies" );

        setDvar( "ui_hud_teamstat_count_axis", 0 );
        makeDvarServerInfo( "ui_hud_teamstat_count_axis" );

        if ( level.teamStats.teamBasedHUD )
        {
            level thread updateTeamCountsHUD( "allies" );
            level thread updateTeamCountsHUD( "axis" );
        }
    }
    else
    {
        setDvar( "ui_hud_show_teamstat", 0 );
        makeDvarServerInfo( "ui_hud_show_teamstat" );
    }


    level thread prematchOverWatcher();
    level thread gameOverWatcher();

    level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );

    // Better hints
    level.showHintAction = ::showHintAction;
}


onPlayerConnected()
{
    if( isDefined( level.teamStats ) && !level.teamStats.teamBasedHUD )
    {
        self thread addNewEvent( "onPlayerSpawned", ::updatePlayerScoreHUD );
    }

    self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );
}

onPlayerDeath()
{
    if (self maps\mp\gametypes\_globallogic::maySpawn())
    {
        self setClientDvar( "ui_hud_has_frags", "0" );
	    self setClientDvar( "ui_hud_has_spec_gren", "0" );
        self setClientDvar( "ui_hud_show_weapon", "0" );
    }

    //self setClientDvar( "ui_hud_has_frags", "0" );
	//self setClientDvar( "ui_hud_has_spec_gren", "0" );
    //self setClientDvar( "ui_hud_show_weapon", "0" );
}


showHintAction( hintText )
{
    self setClientDvar( "ui_hud_hint_text", hintText );

    self maps\mp\gametypes\_hud_hints::showHintAction( hintText );
}


prematchOverWatcher()
{
    self waittill( "prematch_over" );

    if( isDefined( level.teamStats ) )
    {   
        setdvar( "ui_hud_show_teamstat", level.teamStats.showHUD );
    }

    setdvar( "ui_hud_show_weaponinfo", 1 );
}


gameOverWatcher()
{
    self waittill( "game_ended" );

    if( isDefined( level.teamStats ) )
    {   
        setdvar( "ui_hud_show_teamstat", 0 );
    }

    setdvar( "ui_hud_show_weaponinfo", 0 );
}


updateTeamCountsHUD( team )
{
    self endon( "game_ended" );

    previousCount = -1;

    for( ;; )
	{
		wait( 0.1 );

        currentCount = 0;

        for( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];

            if( player.team == team && isAlive( player ) && ( level.gametype != "ftag" || !player.freezeTag["frozen"] ))
            {
                currentCount++;
            }
        }

        if( currentCount != previousCount )
        {
            setdvar( "ui_hud_teamstat_count_" + team, currentCount );
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

    //TODO: update eventialy 
    //while( isPlayer( self ) && isAlive( self ) )
    while( 1 )
    {
        playerScoreRank = 0; 

        for( i = 0; i < level.players.size; i++ )
        {
            otherPlayer = level.players[i];

            if( self != otherPlayer && isDefined ( otherPlayer ) && isAlive( otherPlayer ) && getBestPlayerOf( self, otherPlayer ) == otherPlayer )
            {
                playerScoreRank--;
            }
        }

        self setClientDvar( "ui_hud_teamstat_player_rank", int( playerScoreRank * -1 + 1 ) );

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