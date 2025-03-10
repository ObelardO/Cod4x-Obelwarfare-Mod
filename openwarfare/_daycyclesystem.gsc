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

#include maps\mp\_utility;

#include openwarfare\_eventmanager;
#include openwarfare\_utils;


// Function to get extended dvar values
// getdvarx( dvarName, dvarType, dvarDefault, minValue, maxValue )

init()
{
	// Get the main module's dvar
	level.scr_dcs_enabled = getdvarx( "scr_dcs_enabled", "int", 0, 0, 1 );

	// If the day cycle system is disabled there's nothing else to do here
	if ( level.scr_dcs_enabled == 0 )
		return;
		
	// Load the rest of the module's variables
	level.scr_dcs_dawn_length = getdvarx( "scr_dcs_dawn_length", "float", 0, 0, 1440 ) * 60000;
	level.scr_dcs_day_length = getdvarx( "scr_dcs_day_length", "float", 0, 0, 1440 ) * 60000;
	level.scr_dcs_dusk_length = getdvarx( "scr_dcs_dusk_length", "float", 0, 0, 1440 ) * 60000;
	level.scr_dcs_night_length = getdvarx( "scr_dcs_night_length", "float", 0, 0, 1440 ) * 60000;
	
	level.scr_dcs_first_cycle = getdvarx( "scr_dcs_first_cycle", "int", 1, -1, 3 );
	// Check if we should randomize the starting cycle
	if ( level.scr_dcs_first_cycle == -1 ) {
		level.scr_dcs_first_cycle = randomIntRange( 0, 4 );
	}

	level.scr_dcs_fog_enable = getdvarx( "scr_dcs_fog_enable", "int", 1, 0, 1 );
	
	level.scr_dcs_sounds_enable = getdvarx( "scr_dcs_sounds_enable", "int", 1, 0, 1 );
	
	level.scr_dcs_reset_cycle = getdvarx( "scr_dcs_reset_cycle", "int", 0, 0, 2 );

	// If this is the first time we run this module with this map check if we need to reset the day cycle
	if ( !isDefined( game["_dcs_daycycle"] ) && level.scr_dcs_reset_cycle != 0 ) {
		game["_dcs_daycycle"] = level.scr_dcs_first_cycle;
		game["_dcs_cyclevision"] = 0;
		game["_dcs_timeleft"] = 0;
		
	// If this is not the first time check if we need to reset it every round
	} else if ( isDefined( game["_dcs_daycycle"] ) && level.scr_dcs_reset_cycle == 2 ) {
		game["_dcs_daycycle"] = level.scr_dcs_first_cycle;
		game["_dcs_cyclevision"] = 0;
		game["_dcs_timeleft"] = 0;		
		
	// If we don't need to reset it we'll just load the previous one if there's anything there
	} else {
		game["_dcs_daycycle"] = getdvard( "_dcs_daycycle", "int", level.scr_dcs_first_cycle, 0, 3 );
		game["_dcs_cyclevision"] = getdvard( "_dcs_cyclevision", "int", 0, 0, 3 );
		game["_dcs_timeleft"] = getdvard( "_dcs_timeleft", "int", 0, 0, 86400000 );
	}	

	// Start the thread to control the day cycles
	level thread dayCycleController();	
}


dayCycleController()
{
	level endon( "game_ended" );
	
	// Initialize visions and sounds for each day cycle
	dayCycle = openwarfare\_daycycleutils::getDayCycleData();

	// Wait until the game starts
	level waittill("prematch_over");
	
	firstCycle = true;

	// Check if we need to play the sounds for each day cycle
	if ( level.scr_dcs_sounds_enable == 1 ) {
		level thread dayCycleSounds( dayCycle );
	}
		
	for (;;)
	{
		wait (0.05);
		
		// Set current vision file if enabled
		if ( dayCycle[ game["_dcs_daycycle"] ]["length"] > 0 ) {
			//iprintln( "Switching to vision file: " + dayCycle[ game["_dcs_daycycle"] ]["visions"][ game["_dcs_cyclevision"] ] );
			
			if ( firstCycle ) {
				transitionTime = 0;
			} else {
				transitionTime = dayCycle[ game["_dcs_daycycle"] ]["length"] / 1000;
			}
			visionSetNaked( dayCycle[ game["_dcs_daycycle"] ]["visions"][ game["_dcs_cyclevision"] ], transitionTime );
			
			if (level.scr_dcs_fog_enable) {
				visionIndex = game["_dcs_cyclevision"];
				visionCount = dayCycle[ game["_dcs_daycycle"] ]["visions"].size;
				fogStart = dayCycle[ game["_dcs_daycycle"] ]["fog_start"];
				fogEnd = dayCycle[ game["_dcs_daycycle"] ]["fog_end"];
				fogTime = dayCycle[ game["_dcs_daycycle"] ]["fog_time"] / visionCount / 1000;
				fogClr = dayCycle[ game["_dcs_daycycle"] ]["fog_clr"];

				if ( firstCycle ) {
					setFog(visionIndex, visionCount, fogStart, fogEnd, 0, fogClr);
					wait (0.05);
				} 

				setFog(visionIndex + 1, visionCount, fogStart, fogEnd, fogTime, fogClr);
			}

			if ( firstCycle ) firstCycle = false;

			// Determine the next day cycle / vision file change
			if ( game["_dcs_timeleft"] == 0 ) {
				level.dcsNextCycle = openwarfare\_timer::getTimePassed() + dayCycle[ game["_dcs_daycycle"] ]["length"];
			} else {
				level.dcsNextCycle = openwarfare\_timer::getTimePassed() + game["_dcs_timeleft"];
				game["_dcs_timeleft"] = 0;
			}
			
			// Keep them just in case the admin forces the rotation of the map
			if ( level.scr_dcs_reset_cycle == 0 ) {
				setDvar( "_dcs_daycycle", game["_dcs_daycycle"] );
				setDvar( "_dcs_cyclevision", game["_dcs_cyclevision"] );
			}
			
			// Wait for the this cycle to finish
			while ( openwarfare\_timer::getTimePassed() < level.dcsNextCycle ) {
				setDvar( "_dcs_daycycle", game["_dcs_daycycle"] );
				setDvar( "_dcs_cyclevision", game["_dcs_cyclevision"] );
				setDvar( "_dcs_timeleft", level.dcsNextCycle - openwarfare\_timer::getTimePassed() );				
				wait (5);
			}
		}
			
		// Move to the next vision or to the next cycle if that was the last one
		game["_dcs_cyclevision"]++;
		if ( game["_dcs_cyclevision"] == dayCycle[ game["_dcs_daycycle"] ]["visions"].size ) {
			game["_dcs_cyclevision"] = 0;
			game["_dcs_daycycle"]++;
			if ( game["_dcs_daycycle"] == dayCycle.size ) {
				game["_dcs_daycycle"] = 0;
			}
		}
	}
}


dayCycleSounds( dayCycle )
{
	level endon( "game_ended" );
	
	for (;;)
	{
		wait ( randomFloatRange( 5.0, 15.0 ) );
		
		// Check if we have a sound for the current day cycle
		if ( dayCycle[ game["_dcs_daycycle"] ]["sound"] != "" ) {
			playSoundOnPlayers( dayCycle[ game["_dcs_daycycle"] ]["sound"] );
		}
	}	
}


setFog(index, count, isFogOnStart, isFogOnEnd, fogTime, fogClr)
{
	FOG_MIN_DIST_ON = 0;
	FOG_MIN_DIST_OFF = 500;

	FOG_MAX_DIST_ON = 200;
	FOG_MAX_DIST_OFF = 5000;

	if (isFogOnStart) {
		fogStartDistMin = FOG_MIN_DIST_ON;
		fogStartDistMax = FOG_MAX_DIST_ON;
	} else {
		fogStartDistMin = FOG_MIN_DIST_OFF;
		fogStartDistMax = FOG_MAX_DIST_OFF;
	}

	if (isFogOnEnd) {
		fogEndDistMin = FOG_MIN_DIST_ON;
		fogEndDistMax = FOG_MAX_DIST_ON;
	} else {
		fogEndDistMin = FOG_MIN_DIST_OFF;
		fogEndDistMax = FOG_MAX_DIST_OFF;
	}

	targetFogMinDist = fogStartDistMin + (fogEndDistMin - fogStartDistMin) / count * index;
	targetFogMaxDist = fogStartDistMax + (fogEndDistMax - fogStartDistMax) / count * index;

	setExpFog( targetFogMinDist, targetFogMaxDist, fogClr[0], fogClr[1], fogClr[2], fogTime);

	//iprintln( "Switching FOG: index: " + index + " of " + count + "   start: " + targetFogMinDist + "   end: " + targetFogMaxDist + "   time: " + fogTime );
}