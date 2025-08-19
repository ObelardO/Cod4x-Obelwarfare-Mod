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

getDayCycleData()
{
	dayCycle = [];
	dayCycle[0] = initDayCycleData( level.scr_dcs_dawn_length, "ow_sunrise1;ow_sunrise2;ow_sunrise3;ow_sunrise4", "dcsdawn", true, false, level.scr_dcs_dawn_length, (1/255, 1/255, 1/255) ); 
	dayCycle[1] = initDayCycleData( level.scr_dcs_day_length, level.script, "dcsday", false, false, 0, (1/255, 1/255, 1/255) );
	dayCycle[2] = initDayCycleData( level.scr_dcs_dusk_length, "ow_sunset1;ow_sunset2;ow_sunset3;ow_sunset4", "dcsdusk", false, true, level.scr_dcs_dusk_length, (1/255, 1/255, 1/255) );
	dayCycle[3] = initDayCycleData( level.scr_dcs_night_length, "ow_night1;ow_night2;ow_night3;ow_night4", "dcsnight", true, true, 0, (1/255, 1/255, 1/255) );
	
	return dayCycle;
}

initDayCycleData( cycleLength, visionFiles, soundAlias, isFogOnStart, isFogOnEnd, fogTime, fogClr)
{
	dayCycle = [];
	dayCycle["visions"] = strtok( visionFiles, ";" );
	dayCycle["length"] = int( cycleLength / dayCycle["visions"].size );
	dayCycle["sound"] = soundAlias;

	dayCycle["fog_start"] = isFogOnStart;
	dayCycle["fog_end"] = isFogOnEnd;
	dayCycle["fog_time"] = fogTime;
	dayCycle["fog_clr"] = fogClr;

	return dayCycle;	
}