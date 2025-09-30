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

    forceClientDvar( "cg_cursorHints", 4 );

    // Apply other player dvars
    openwarfare\_playerdvars::completeForceClientDvarsArray();

    // Team status
    scr_hud_teamstat_enabled = getdvarx( "scr_hud_teamstat_enabled", "int", 1, 0, 1 );

    if( scr_hud_teamstat_enabled )
    {
        teamBased = level.teamBased && level.gametype != "bel";

        setDvar( "ui_hud_teamstat_visible", 0 );
        makeDvarServerInfo( "ui_hud_teamstat_visible" );
        
        setDvar( "ui_hud_teamstat_teambased", int( teamBased ) );
        makeDvarServerInfo( "ui_hud_teamstat_teambased" );
        
        setDvar( "ui_hud_teamstat_count_allies", 0 );
        makeDvarServerInfo( "ui_hud_teamstat_count_allies" );

        setDvar( "ui_hud_teamstat_count_axis", 0 );
        makeDvarServerInfo( "ui_hud_teamstat_count_axis" );

        level thread prematchOverWatcher();
        level thread gameOverWatcher();

        if ( teamBased )
        {
            level thread teamCountsWatcher( "allies" );
            level thread teamCountsWatcher( "axis" );
        }
        else
        {
            level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
        }
    }
    else
    {
        setDvar( "ui_hud_teamstat_visible", 0 );
        makeDvarServerInfo( "ui_hud_teamstat_visible" );
    }

    // Better hints
    level.showHintAction = ::showHintAction;
}


showHintAction( hintText )
{
    self setClientDvar( "ui_hud_hint_text", hintText );

    self maps\mp\gametypes\_hud_hints::showHintAction( hintText );
}


prematchOverWatcher()
{
    self waittill( "prematch_over" );

    setdvar( "ui_hud_teamstat_visible", 1 );
}


gameOverWatcher()
{
    self waittill( "game_ended" );

    setdvar( "ui_hud_teamstat_visible", 0 );
}


teamCountsWatcher( team )
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


onPlayerConnected()
{
    self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
    self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );
}

onPlayerSpawned()
{
	self endon( "death" );
    self endon( "disconnect" );
    self endon( "joined_spectators" );
    level endon( "game_ended" );

    //while( isPlayer( self ) && isAlive( self ) )
    while( 1 )
    {
        playerScoreRank = 0; 

        for( i = 0; i < level.players.size; i++ )
        {
            otherPlayer = level.players[i];

            if( self != otherPlayer && isDefined ( otherPlayer ) && isAlive( otherPlayer ) && getBestPlayer( self, otherPlayer ) == otherPlayer )
            {
                playerScoreRank--;
            }
        }

        self setClientDvar( "ui_hud_teamstat_player_rank", int( playerScoreRank * -1 + 1 ) );
        //self iPrintLn( "Your score rank is: " + ( playerScoreRank * -1 + 1 ) );

        wait( 1 );
    }
}

onPlayerDeath()
{
    self setClientDvar( "ui_hud_has_frags", "0" );
	self setClientDvar( "ui_hud_has_spec_gren", "0" );
}


getBestPlayer( playerA, playerB )
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