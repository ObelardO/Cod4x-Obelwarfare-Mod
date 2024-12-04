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
	level.sv_greetings_enable = getdvarx( "sv_greetings_enable", "int", 0, 0, 1 );
	level.sv_greetings_start_once = getdvarx( "sv_greetings_start_once", "int", 0, 0, 1 );
	level.sv_greetings_start_delay = getdvarx( "sv_greetings_start_delay", "int", 0, 0, 10 );
	level.sv_greetings_messages_delay = getdvarx( "sv_greetings_messages_delay", "int", 2, 2, 10 );
	level.sv_greetings_messages_sound = getdvarx( "sv_greetings_messages_sound", "string", "" );

	// Fetch the greetings messages and store them in a list.
	level.sv_greetings_messages_text = getDvarListx( "sv_greetings_messages_text_", "string", "" );

	if ( level.sv_greetings_enable == 0 || level.sv_greetings_messages_text.size == 0)
		return;

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::displayGreetingsMessages );
}

displayGreetingsMessages()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	if (level.sv_greetings_start_once == 1 && isDefined ( level.isGreetingsDone ) && level.isGreetingsDone == true)
	{
		return;
	}

	while ( level.inReadyUpPeriod || level.inStrategyPeriod || level.inStrategyPeriod )
	{
		xwait (0.05);
	}

	if (sv_greetings_start_delay > 0)
	{
		wait (level.sv_greetings_start_delay);
	}
	
	notifyData = spawnStruct();
	if ( isDefined ( level.sv_greetings_messages_sound ) )
	{
		notifyData.sound = level.sv_greetings_messages_sound;
	}
	
	for ( msgIndex = 0; msgIndex < level.sv_greetings_messages_text.size; msgIndex++ )
	{
		notifyData.titleText = level.sv_greetings_messages_text[msgIndex];

		self maps\mp\gametypes\_hud_message::notifyMessage(notifyData);

		wait (level.sv_greetings_start_delay);
	}			


	if (level.sv_greetings_start_once == 1)
	{
		level.isGreetingsDone = true;
	}

	//wait (2);

	//delete (notifyData);
}