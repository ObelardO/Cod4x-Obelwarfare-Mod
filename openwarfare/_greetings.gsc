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
	level.sv_greetings_start_sound = getdvarx( "sv_greetings_start_sound", "int", 0, 0, 1 );
	level.sv_greetings_messages_delay = getdvarx( "sv_greetings_messages_delay", "int", 2, 2, 10 );
	level.sv_greetings_messages_sound = getdvarx( "sv_greetings_messages_sound", "string", "" );

	// Fetch the greetings messages and store them in a list.
	level.sv_greetings_messages_text = getDvarListx( "sv_greetings_messages_text_", "string", "" );

	if ( level.sv_greetings_enable == 0 || level.sv_greetings_messages_text.size == 0)
		return;

	if ( level.sv_greetings_start_once && game["roundsplayed"] > 0 )
	{
		setDefaultSpawnMusic();

		return;
	}
	
	if (level.sv_greetings_start_sound == 1)
	{
		setGreetingsSpawnMusic();
	}

	level thread runGreetingsMessages();
}


runGreetingsMessages()
{
	level endon("intermission");
	level endon("game_ended");

	level waittill("prematch_start");

	if (level.sv_greetings_start_delay > 0)
	{
		wait (level.sv_greetings_start_delay);
	}

	for ( msgIndex = 0; msgIndex < level.sv_greetings_messages_text.size; msgIndex++ )
	{
		sendNotifyToPlayers ( level.sv_greetings_messages_text[msgIndex], level.sv_greetings_messages_sound );

		wait (level.sv_greetings_messages_delay);
	}
}


sendNotifyToPlayers( message, sound )
{
	notifyData = spawnStruct();
	notifyData.titleText = message;
	if ( sound != "" )
	{
		notifyData.sound = sound;
	}

	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];

		if (player.hasSpawned && player.sessionteam != "spectator" && isAlive ( player ) )
		{
			player maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
	}
}



setGreetingsSpawnMusic()
{
	game["music"]["spawn_axis"] = "welcome";
	game["music"]["spawn_allies"] = "welcome";
}


setDefaultSpawnMusic()
{
	switch ( game["allies"] )
	{
		case "sas":
			game["music"]["spawn_allies"] = "mp_spawn_sas";
			game["music"]["victory_allies"] = "mp_victory_sas";
			break;
		case "marines":
		default:
			game["music"]["spawn_allies"] = "mp_spawn_usa";
			game["music"]["victory_allies"] = "mp_victory_usa";
			break;
	}

	switch ( game["axis"] )
	{
		case "russian":
			game["music"]["spawn_axis"] = "mp_spawn_soviet";
			game["music"]["victory_axis"] = "mp_victory_soviet";
			break;
		case "arab":
		case "opfor":
		default:
			game["music"]["spawn_axis"] = "mp_spawn_opfor";
			game["music"]["victory_axis"] = "mp_victory_opfor";
			break;
	}
}