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

#include openwarfare\_utils;

init()
{
	level.teamImbalance = spawnStruct();
	level.teamImbalance.active = false;
	level.teamImbalance.ready = false;
	level.teamImbalance.imbalanced = false;
	level.teamImbalance.timingsValid = false;
	level.teamImbalance.largerTeam = "";
	level.teamImbalance.smallerTeam = "";

	level.teamImbalance.count = [];
	level.teamImbalance.count["allies"] = 0;
	level.teamImbalance.count["axis"] = 0;
	level.teamImbalance.lives = [];
	level.teamImbalance.lives["allies"] = 0;
	level.teamImbalance.lives["axis"] = 0;
	level.teamImbalance.respawnDelay = [];
	level.teamImbalance.respawnDelay["allies"] = 0;
	level.teamImbalance.respawnDelay["axis"] = 0;
	level.teamImbalance.timeScale = [];
	level.teamImbalance.timeScale["allies"] = 1.0;
	level.teamImbalance.timeScale["axis"] = 1.0;
	level.teamImbalance.rosterCount = [];
	level.teamImbalance.rosterCount["allies"] = 0;
	level.teamImbalance.rosterCount["axis"] = 0;

	level.scr_teamimbalance_enable = getdvarx( "scr_teamimbalance_enable", "int", 0, 0, 1 );

	if ( !level.scr_teamimbalance_enable || !level.teamBased )
		return;

	level.scr_teamimbalance_lives_enable = getdvarx( "scr_teamimbalance_lives_enable", "int", 1, 0, 1 );
	level.scr_teamimbalance_lives_max = getdvarx( "scr_teamimbalance_lives_max", "int", 0, 0, 100 );
	level.scr_teamimbalance_respawn_enable = getdvarx( "scr_teamimbalance_respawn_enable", "int", 1, 0, 1 );
	level.scr_teamimbalance_respawn_min = getdvarx( "scr_teamimbalance_respawn_min", "float", 1, 0, 30 );

	level.teamImbalance.active = true;
}


isActive()
{
	return ( isDefined( level.teamImbalance ) && level.teamImbalance.active );
}


isImbalanced()
{
	return ( isActive() && level.teamImbalance.imbalanced );
}


onRoundStart()
{
	if ( !isActive() )
		return;

	snapshotLives();
	refreshTimings();
	level.teamImbalance.ready = true;
}


onRosterChanged()
{
	if ( !isActive() )
		return;

	refreshTimings();
}


getTeamCount( team )
{
	if ( !isActive() || !isDefined( level.teamImbalance.count[team] ) )
		return 0;

	return level.teamImbalance.count[team];
}


getLargerTeam()
{
	if ( !isActive() )
		return "";

	return level.teamImbalance.largerTeam;
}


getSmallerTeam()
{
	if ( !isActive() )
		return "";

	return level.teamImbalance.smallerTeam;
}


getLives( team )
{
	if ( !isActive() || !isDefined( level.teamImbalance.lives[team] ) )
		return level.numLives;

	return level.teamImbalance.lives[team];
}


getRespawnDelay( team )
{
	if ( !isActive() || !level.scr_teamimbalance_respawn_enable )
		return undefined;

	if ( !isDefined( team ) || ( team != "allies" && team != "axis" ) )
		return undefined;

	if ( !level.teamImbalance.timingsValid )
		return undefined;

	return level.teamImbalance.respawnDelay[team];
}


getTimeScale( team )
{
	if ( !isActive() || !isDefined( team ) || !isDefined( level.teamImbalance.timeScale[team] ) )
		return 1.0;

	return level.teamImbalance.timeScale[team];
}


scaleTime( team, baseTime )
{
	return baseTime * getTimeScale( team );
}


scaleTimeForPlayer( player, baseTime )
{
	if ( !isDefined( player ) || !isDefined( player.pers["team"] ) )
		return baseTime;

	return scaleTime( player.pers["team"], baseTime );
}


snapshotLives()
{
	countAllies = countAlivePlayers( "allies" );
	countAxis = countAlivePlayers( "axis" );

	level.teamImbalance.count["allies"] = countAllies;
	level.teamImbalance.count["axis"] = countAxis;
	level.teamImbalance.lives["allies"] = level.numLives;
	level.teamImbalance.lives["axis"] = level.numLives;
	level.teamImbalance.imbalanced = false;
	level.teamImbalance.largerTeam = "";
	level.teamImbalance.smallerTeam = "";

	if ( !level.scr_teamimbalance_lives_enable || level.numLives <= 1 )
		return;

	if ( countAllies == 0 || countAxis == 0 || countAllies == countAxis )
		return;

	if ( countAllies > countAxis )
	{
		largerTeam = "allies";
		smallerTeam = "axis";
		largerCount = countAllies;
		smallerCount = countAxis;
	}
	else
	{
		largerTeam = "axis";
		smallerTeam = "allies";
		largerCount = countAxis;
		smallerCount = countAllies;
	}

	level.teamImbalance.imbalanced = true;
	level.teamImbalance.largerTeam = largerTeam;
	level.teamImbalance.smallerTeam = smallerTeam;

	totalPool = largerCount * level.numLives;
	baseLives = int( totalPool / smallerCount );
	remainder = totalPool - ( baseLives * smallerCount );
	maxLives = getMaxLives();

	smallerLives = baseLives;
	if ( remainder > 0 )
		smallerLives++;
	if ( smallerLives > maxLives )
		smallerLives = maxLives;

	level.teamImbalance.lives[largerTeam] = level.numLives;
	level.teamImbalance.lives[smallerTeam] = smallerLives;

	applyTeamLives( largerTeam, level.numLives, 0 );
	applyTeamLives( smallerTeam, baseLives, remainder );
}


refreshTimings()
{
	countAllies = 0;
	countAxis = 0;

	if ( isDefined( level.playerCount ) && isDefined( level.playerCount["allies"] ) )
		countAllies = level.playerCount["allies"];
	if ( isDefined( level.playerCount ) && isDefined( level.playerCount["axis"] ) )
		countAxis = level.playerCount["axis"];

	level.teamImbalance.rosterCount["allies"] = countAllies;
	level.teamImbalance.rosterCount["axis"] = countAxis;
	level.teamImbalance.timeScale["allies"] = 1.0;
	level.teamImbalance.timeScale["axis"] = 1.0;
	level.teamImbalance.timingsValid = false;

	if ( countAllies == 0 || countAxis == 0 )
		return;

	if ( countAllies >= countAxis )
		largerCount = countAllies;
	else
		largerCount = countAxis;

	level.teamImbalance.timeScale["allies"] = ( countAllies * 1.0 ) / largerCount;
	level.teamImbalance.timeScale["axis"] = ( countAxis * 1.0 ) / largerCount;
	level.teamImbalance.timingsValid = true;

	if ( !level.scr_teamimbalance_respawn_enable )
		return;

	baseDelay = getBaseRespawnDelay();
	level.teamImbalance.respawnDelay["allies"] = scaleRespawnDelay( baseDelay, level.teamImbalance.timeScale["allies"] );
	level.teamImbalance.respawnDelay["axis"] = scaleRespawnDelay( baseDelay, level.teamImbalance.timeScale["axis"] );
}


countAlivePlayers( team )
{
	count = 0;
	players = level.players;

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( !isDefined( player ) || !isDefined( player.pers["team"] ) )
			continue;

		if ( player.pers["team"] != team )
			continue;

		if ( !isAlive( player ) || player.sessionstate != "playing" )
			continue;

		count++;
	}

	return count;
}


applyTeamLives( team, baseLives, remainder )
{
	maxLives = getMaxLives();
	appliedRemainder = 0;
	players = level.players;

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( !isDefined( player ) || !isDefined( player.pers["team"] ) )
			continue;

		if ( player.pers["team"] != team )
			continue;

		if ( !isAlive( player ) || player.sessionstate != "playing" )
			continue;

		targetLives = baseLives;
		if ( appliedRemainder < remainder )
		{
			targetLives++;
			appliedRemainder++;
		}

		if ( targetLives > maxLives )
			targetLives = maxLives;

		if ( isDefined( player.hasSpawned ) && player.hasSpawned )
			player.pers["lives"] = targetLives - 1;
		else
			player.pers["lives"] = targetLives;
	}
}


getMaxLives()
{
	if ( level.scr_teamimbalance_lives_max > 0 )
		return level.scr_teamimbalance_lives_max;

	return level.numLives * 2;
}


getBaseRespawnDelay()
{
	respawnDelay = getdvarx( "scr_" + level.gameType + "_playerrespawndelay", "float", 10, -1, 300 );

	if ( level.hardcoreMode && !respawnDelay )
		respawnDelay = 10.0;

	return respawnDelay;
}


scaleRespawnDelay( baseDelay, timeScale )
{
	if ( baseDelay < 0 )
		return baseDelay;

	respawnDelay = baseDelay * timeScale;

	if ( respawnDelay < level.scr_teamimbalance_respawn_min )
		respawnDelay = level.scr_teamimbalance_respawn_min;

	return respawnDelay;
}
