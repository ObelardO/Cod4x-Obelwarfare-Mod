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
	level.scr_teamassign_enable = getdvarx( "scr_teamassign_enable", "int", 0, 0, 2 );
	level.scr_teamassign_priority = getdvarx( "scr_teamassign_priority", "int", 0, 0, 2 );
	level.scr_teamassign_ignore_bots = getdvarx( "scr_teamassign_ignore_bots", "int", 0, 0, 1 );

	// scr_teamassign_enable: 0 = stock, 1+ = override autoassign
	if ( !level.scr_teamassign_enable || !level.teamBased )
		return;

	level.pickAutoAssignTeam = ::pickAutoAssignTeam;

	// scr_teamassign_enable: 2 = also override autobalance
	if ( level.scr_teamassign_enable >= 2 )
	{
		level.getTeamBalance = ::getTeamBalance;
		level.balanceTeams = ::balanceTeams;

		precacheString( &"OW_AUTOBALANCE_SKILL_NOW" );
		precacheString( &"OW_AUTOBALANCE_SKILL_SECONDS" );
		precacheString( &"OW_AUTOBALANCE_SKILL_NEXT_ROUND" );

		game["strings"]["autobalance"] = &"OW_AUTOBALANCE_SKILL_NOW";
		game["strings"]["autobalance_seconds"] = &"OW_AUTOBALANCE_SKILL_SECONDS";
		game["strings"]["autobalance_next_round"] = &"OW_AUTOBALANCE_SKILL_NEXT_ROUND";
	}
}


isIgnoredBot( player )
{
	// scr_teamassign_ignore_bots: 0 = count everyone, 1 = skip bots
	if ( !level.scr_teamassign_ignore_bots )
		return false;

	if ( !isDefined( player ) || !isPlayer( player ) )
		return false;

	return IsBot( player );
}


getPlayerKD( player )
{
	kd = player maps\mp\gametypes\_persistence::statGet( "kdratio" );
	if ( kd > 0 )
		return kd / 1000.0;

	kills = 0;
	deaths = 0;
	if ( isDefined( player.pers["kills"] ) )
		kills = player.pers["kills"];
	if ( isDefined( player.pers["deaths"] ) )
		deaths = player.pers["deaths"];

	if ( deaths <= 0 )
	{
		if ( kills <= 0 )
			return 1.0;

		return kills * 1.0;
	}

	return ( kills * 1.0 ) / deaths;
}


getTeamData( excludePlayer )
{
	data = spawnStruct();
	data.countAllies = 0;
	data.countAxis = 0;
	data.kdAllies = 0.0;
	data.kdAxis = 0.0;

	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];
		if ( !isDefined( player ) )
			continue;

		if ( isDefined( excludePlayer ) && player == excludePlayer )
			continue;

		if ( isIgnoredBot( player ) )
			continue;

		if ( !isDefined( player.pers["team"] ) )
			continue;

		if ( player.pers["team"] == "allies" )
		{
			data.countAllies++;
			data.kdAllies += getPlayerKD( player );
		}
		else if ( player.pers["team"] == "axis" )
		{
			data.countAxis++;
			data.kdAxis += getPlayerKD( player );
		}
	}

	return data;
}


pickByScoreOrRandom()
{
	if ( getTeamScore( "allies" ) < getTeamScore( "axis" ) )
		return "allies";

	if ( getTeamScore( "axis" ) < getTeamScore( "allies" ) )
		return "axis";

	teams[0] = "allies";
	teams[1] = "axis";
	return teams[randomInt(2)];
}


pickLowerKDTeam( data )
{
	if ( data.kdAllies < data.kdAxis )
		return "allies";

	if ( data.kdAxis < data.kdAllies )
		return "axis";

	return pickByScoreOrRandom();
}


pickCloserKDTeam( data, playerKD )
{
	gapAllies = abs( ( data.kdAllies + playerKD ) - data.kdAxis );
	gapAxis = abs( ( data.kdAxis + playerKD ) - data.kdAllies );

	if ( gapAllies < gapAxis )
		return "allies";

	if ( gapAxis < gapAllies )
		return "axis";

	return pickByScoreOrRandom();
}


pickAutoAssignTeam()
{
	data = getTeamData( self );
	playerKD = getPlayerKD( self );

	// scr_teamassign_priority: 0 = keep counts within 1, use K/D only when equal
	if ( level.scr_teamassign_priority == 0 )
	{
		if ( data.countAllies == data.countAxis )
			return pickLowerKDTeam( data );

		if ( data.countAllies < data.countAxis )
			return "allies";

		return "axis";
	}

	alliesLegal = true;
	axisLegal = true;
	// scr_teamassign_priority: 1 = equalize K/D sums, never create a count gap larger than 1
	if ( level.scr_teamassign_priority == 1 )
	{
		alliesLegal = ( abs( ( data.countAllies + 1 ) - data.countAxis ) <= 1 );
		axisLegal = ( abs( data.countAllies - ( data.countAxis + 1 ) ) <= 1 );
	}

	if ( alliesLegal && !axisLegal )
		return "allies";

	if ( axisLegal && !alliesLegal )
		return "axis";

	return pickCloserKDTeam( data, playerKD );
}


getEligiblePlayers( team, ignoreProtect )
{
	list = [];
	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];
		if ( !isDefined( player ) || !isDefined( player.pers["team"] ) )
			continue;

		if ( player.pers["team"] != team )
			continue;

		if ( isIgnoredBot( player ) )
			continue;

		if ( !maps\mp\gametypes\_teams::canAutobalance( player ) )
			continue;

		if ( !ignoreProtect && isDefined( player.dont_auto_balance ) )
			continue;

		list[list.size] = player;
	}

	return list;
}


getCountGap( data )
{
	return abs( data.countAllies - data.countAxis );
}


getKDGap( data )
{
	return abs( data.kdAllies - data.kdAxis );
}


getLargerTeam( data )
{
	if ( data.countAllies > data.countAxis )
		return "allies";

	return "axis";
}


getStrongerKDTeam( data )
{
	if ( data.kdAllies > data.kdAxis )
		return "allies";

	return "axis";
}


wouldKeepCountGap( data, fromTeam, maxGap )
{
	if ( fromTeam == "allies" )
		return ( abs( ( data.countAllies - 1 ) - ( data.countAxis + 1 ) ) <= maxGap );

	return ( abs( ( data.countAllies + 1 ) - ( data.countAxis - 1 ) ) <= maxGap );
}


getMoveKDGap( data, fromTeam, playerKD )
{
	if ( fromTeam == "allies" )
		return abs( ( data.kdAllies - playerKD ) - ( data.kdAxis + playerKD ) );

	return abs( ( data.kdAllies + playerKD ) - ( data.kdAxis - playerKD ) );
}


canImproveKDByMove( data, maxCountGap )
{
	currentGap = getKDGap( data );
	if ( currentGap <= 0.001 )
		return false;

	fromTeam = getStrongerKDTeam( data );
	if ( isDefined( maxCountGap ) && !wouldKeepCountGap( data, fromTeam, maxCountGap ) )
		return false;

	players = getEligiblePlayers( fromTeam, false );
	// scr_teambalance: 2 = also move clan-protected players if nobody else is eligible
	if ( !players.size && isDefined( level.teamBalance ) && level.teamBalance == 2 )
		players = getEligiblePlayers( fromTeam, true );

	for ( i = 0; i < players.size; i++ )
	{
		if ( getMoveKDGap( data, fromTeam, getPlayerKD( players[i] ) ) < currentGap )
			return true;
	}

	return false;
}


pickBestMovePlayer( fromTeam, data, maxCountGap )
{
	if ( isDefined( maxCountGap ) && !wouldKeepCountGap( data, fromTeam, maxCountGap ) )
		return undefined;

	players = getEligiblePlayers( fromTeam, false );
	// scr_teambalance: 2 = also move clan-protected players if nobody else is eligible
	if ( !players.size && isDefined( level.teamBalance ) && level.teamBalance == 2 )
		players = getEligiblePlayers( fromTeam, true );

	bestPlayer = undefined;
	bestGap = undefined;

	for ( i = 0; i < players.size; i++ )
	{
		resetTimeout();
		playerKD = getPlayerKD( players[i] );
		newGap = getMoveKDGap( data, fromTeam, playerKD );
		if ( !isDefined( bestPlayer ) || newGap < bestGap )
		{
			bestPlayer = players[i];
			bestGap = newGap;
		}
	}

	return bestPlayer;
}


movePlayerToTeam( player, team )
{
	if ( !isDefined( player ) )
		return false;

	player maps\mp\gametypes\_teams::changeTeam( team );
	return true;
}


getTeamBalance()
{
	data = getTeamData( undefined );

	if ( getCountGap( data ) > 1 )
		return false;

	// scr_teamassign_priority: 0 = only count imbalance triggers autobalance
	if ( level.scr_teamassign_priority == 0 )
		return true;

	maxCountGap = undefined;
	// scr_teamassign_priority: 1 = also rebalance K/D if the move keeps count gap <= 1
	if ( level.scr_teamassign_priority == 1 )
		maxCountGap = 1;

	if ( canImproveKDByMove( data, maxCountGap ) )
		return false;

	return true;
}


balanceTeams()
{
	moved = true;
	safety = 0;

	while ( moved && safety < 16 )
	{
		moved = false;
		safety++;
		data = getTeamData( undefined );

		if ( getCountGap( data ) > 1 )
		{
			fromTeam = getLargerTeam( data );
			player = pickBestMovePlayer( fromTeam, data, undefined );
			if ( movePlayerToTeam( player, level.otherTeam[fromTeam] ) )
				moved = true;

			continue;
		}

		// scr_teamassign_priority: 0 = stop after count gap is within 1
		if ( level.scr_teamassign_priority == 0 )
			break;

		maxCountGap = undefined;
		// scr_teamassign_priority: 1 = skill move must keep count gap <= 1 (2 = K/D only)
		if ( level.scr_teamassign_priority == 1 )
			maxCountGap = 1;

		currentGap = getKDGap( data );
		fromTeam = getStrongerKDTeam( data );
		player = pickBestMovePlayer( fromTeam, data, maxCountGap );
		if ( !isDefined( player ) )
			break;

		newGap = getMoveKDGap( data, fromTeam, getPlayerKD( player ) );
		if ( newGap >= currentGap )
			break;

		if ( movePlayerToTeam( player, level.otherTeam[fromTeam] ) )
			moved = true;
	}
}
