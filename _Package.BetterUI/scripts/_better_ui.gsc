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
    
	if ( scr_hud_fade_enabled ) 
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
}