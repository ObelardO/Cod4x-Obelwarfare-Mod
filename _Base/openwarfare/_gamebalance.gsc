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
	level.gameBalance = spawnStruct();
	level.gameBalance.active = false;
	level.gameBalance.ready = false;
	level.gameBalance.imbalanced = false;
	level.gameBalance.timingsValid = false;
	level.gameBalance.largerTeam = "";
	level.gameBalance.smallerTeam = "";

	level.gameBalance.count = [];
	level.gameBalance.count["allies"] = 0;
	level.gameBalance.count["axis"] = 0;
	level.gameBalance.lives = [];
	level.gameBalance.lives["allies"] = 0;
	level.gameBalance.lives["axis"] = 0;
	level.gameBalance.respawnDelay = [];
	level.gameBalance.respawnDelay["allies"] = 0;
	level.gameBalance.respawnDelay["axis"] = 0;
	level.gameBalance.timeScale = [];
	level.gameBalance.timeScale["allies"] = 1.0;
	level.gameBalance.timeScale["axis"] = 1.0;
	level.gameBalance.rosterCount = [];
	level.gameBalance.rosterCount["allies"] = 0;
	level.gameBalance.rosterCount["axis"] = 0;

	level.scr_gamebalance_enable = getdvarx( "scr_gamebalance_enable", "int", 0, 0, 1 );

	if ( !level.scr_gamebalance_enable || !level.teamBased )
		return;

	level.scr_gamebalance_lives_enable = getdvarx( "scr_gamebalance_lives_enable", "int", 1, 0, 1 );
	level.scr_gamebalance_lives_max = getdvarx( "scr_gamebalance_lives_max", "int", 0, 0, 100 );
	level.scr_gamebalance_respawn_enable = getdvarx( "scr_gamebalance_respawn_enable", "int", 1, 0, 1 );
	level.scr_gamebalance_respawn_min = getdvarx( "scr_gamebalance_respawn_min", "float", 1, 0, 30 );

	level.gameBalance.active = true;
}


isActive()
{
	return ( isDefined( level.gameBalance ) && level.gameBalance.active );
}


isImbalanced()
{
	return ( isActive() && level.gameBalance.imbalanced );
}


onRoundStart()
{
	if ( !isActive() )
		return;

	snapshotLives();
	refreshTimings();
	level.gameBalance.ready = true;
}


onRosterChanged()
{
	if ( !isActive() )
		return;

	refreshTimings();
}


getTeamCount( team )
{
	if ( !isActive() || !isDefined( level.gameBalance.count[team] ) )
		return 0;

	return level.gameBalance.count[team];
}


getLargerTeam()
{
	if ( !isActive() )
		return "";

	return level.gameBalance.largerTeam;
}


getSmallerTeam()
{
	if ( !isActive() )
		return "";

	return level.gameBalance.smallerTeam;
}


getLives( team )
{
	if ( !isActive() || !isDefined( level.gameBalance.lives[team] ) )
		return level.numLives;

	return level.gameBalance.lives[team];
}


getRespawnDelay( team )
{
	if ( !isActive() || !level.scr_gamebalance_respawn_enable )
		return undefined;

	if ( !isDefined( team ) || ( team != "allies" && team != "axis" ) )
		return undefined;

	if ( !level.gameBalance.timingsValid )
		return undefined;

	return level.gameBalance.respawnDelay[team];
}


getTimeScale( team )
{
	if ( !isActive() || !isDefined( team ) || !isDefined( level.gameBalance.timeScale[team] ) )
		return 1.0;

	return level.gameBalance.timeScale[team];
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

	level.gameBalance.count["allies"] = countAllies;
	level.gameBalance.count["axis"] = countAxis;
	level.gameBalance.lives["allies"] = level.numLives;
	level.gameBalance.lives["axis"] = level.numLives;
	level.gameBalance.imbalanced = false;
	level.gameBalance.largerTeam = "";
	level.gameBalance.smallerTeam = "";

	if ( !level.scr_gamebalance_lives_enable || level.numLives <= 1 )
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

	level.gameBalance.imbalanced = true;
	level.gameBalance.largerTeam = largerTeam;
	level.gameBalance.smallerTeam = smallerTeam;

	totalPool = largerCount * level.numLives;
	baseLives = int( totalPool / smallerCount );
	remainder = totalPool - ( baseLives * smallerCount );
	maxLives = getMaxLives();

	smallerLives = baseLives;
	if ( remainder > 0 )
		smallerLives++;
	if ( smallerLives > maxLives )
		smallerLives = maxLives;

	level.gameBalance.lives[largerTeam] = level.numLives;
	level.gameBalance.lives[smallerTeam] = smallerLives;

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

	level.gameBalance.rosterCount["allies"] = countAllies;
	level.gameBalance.rosterCount["axis"] = countAxis;
	level.gameBalance.timeScale["allies"] = 1.0;
	level.gameBalance.timeScale["axis"] = 1.0;
	level.gameBalance.timingsValid = false;

	if ( countAllies == 0 || countAxis == 0 )
		return;

	if ( countAllies >= countAxis )
		largerCount = countAllies;
	else
		largerCount = countAxis;

	level.gameBalance.timeScale["allies"] = ( countAllies * 1.0 ) / largerCount;
	level.gameBalance.timeScale["axis"] = ( countAxis * 1.0 ) / largerCount;
	level.gameBalance.timingsValid = true;

	if ( !level.scr_gamebalance_respawn_enable )
		return;

	baseDelay = getBaseRespawnDelay();
	level.gameBalance.respawnDelay["allies"] = scaleRespawnDelay( baseDelay, level.gameBalance.timeScale["allies"] );
	level.gameBalance.respawnDelay["axis"] = scaleRespawnDelay( baseDelay, level.gameBalance.timeScale["axis"] );
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
	if ( level.scr_gamebalance_lives_max > 0 )
		return level.scr_gamebalance_lives_max;

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

	if ( respawnDelay < level.scr_gamebalance_respawn_min )
		respawnDelay = level.scr_gamebalance_respawn_min;

	return respawnDelay;
}
