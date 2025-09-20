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

    // Apply other player dvars
    openwarfare\_playerdvars::completeForceClientDvarsArray();

    // Team status
    scr_hud_teamstat_enabled = getdvarx( "scr_hud_teamstat_enabled", "int", 1, 0, 1 );

    if( scr_hud_teamstat_enabled )
    {
        setDvar( "ui_hud_teamstat_count_allies", 0 );
        makeDvarServerInfo( "ui_hud_teamstat_count_allies" );

        setDvar( "ui_hud_teamstat_count_axis", 0 );
        makeDvarServerInfo( "ui_hud_teamstat_count_axis" );
        
        setDvar( "ui_hud_teamstat_visible", 0 );
        makeDvarServerInfo( "ui_hud_teamstat_visible" );
        
        setDvar( "ui_hud_teamstat_teambased", int( level.teamBased ) );
        makeDvarServerInfo( "ui_hud_teamstat_teambased" );
        
        level thread prematchOverWatcher();
        level thread gameOverWatcher();

        level thread teamCountsWatcher( "allies" );
        level thread teamCountsWatcher( "axis" );
    }
    else
    {
        setDvar( "ui_hud_teamstat_visible", 0 );
        makeDvarServerInfo( "ui_hud_teamstat_visible" );
    
    }
}


prematchOverWatcher()
{
    self waittill( "prematch_over" );

    //wait( 1.0 );

    setdvar( "ui_hud_teamstat_visible", 1 );

    //setdvar( "ui_hud_teamstat_teambased", int( level.teamBased ) );

    iPrintLnBold( "TEAMSTAT " +  (int ( level.teamBased )) );
}


gameOverWatcher()
{
    self waittill( "game_ended" );

    //wait( 1.0 );

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