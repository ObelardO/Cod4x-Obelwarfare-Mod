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

getPlayerHardpointStreak()
{
	return getCycledHardpointStreak( self getHardpointStreakCount() );
}


getHardpointStreakCount()
{
	streak = 0;

	if ( !isDefined( level.scr_game_hardpoints_mode ) || level.scr_game_hardpoints_mode == 0 )
	{
		if ( isDefined( self.cur_kill_streak ) )
			streak = self.cur_kill_streak;
	}
	else if ( isDefined( self.kills ) )
	{
		streak = self.kills;
	}

	return streak;
}


getNextHardpointInfo()
{
	info = spawnStruct();
	info.visible = 0;
	info.kills = 0;
	info.killsDone = 0;
	info.killsNeed = 1;
	info.icon = "white";

	if ( !isDefined( level.scr_game_hardpoints ) || level.scr_game_hardpoints != 1 )
		return info;

	streak = self getPlayerHardpointStreak();
	hardpoint = getNextHardpoint( streak );

	if ( !isDefined( hardpoint ) )
		return info;

	owned = undefined;

	if ( isDefined( self.pers["hardPointItem"] ) )
		owned = getHardpointByType( self.pers["hardPointItem"] );

	if ( isDefined( owned ) && hardpoint.streak <= owned.streak )
		return info;

	info.visible = 1;
	info.kills = hardpoint.streak - streak;
	info.killsNeed = hardpoint.streak;
	info.killsDone = streak;
	info.icon = hardpoint.hudIcon;

	if ( info.kills < 1 )
		info.kills = 1;

	if ( info.killsNeed < 1 )
		info.killsNeed = 1;

	if ( !isDefined( info.icon ) || info.icon == "" )
		info.icon = "white";

	return info;
}


getCycledHardpointStreak( actualstreak )
{
	streak = actualstreak;

	if ( !actualstreak || !isDefined( level.scr_game_hardpoints_cycle ) || level.scr_game_hardpoints_cycle != 1 )
		return streak;

	cyclestreak = getHardpointCycleStreak();

	if ( cyclestreak && actualstreak > cyclestreak )
	{
		streak = actualstreak % cyclestreak;

		if ( streak == 0 )
			streak = cyclestreak;
	}

	return streak;
}


getHardpointCycleStreak()
{
	cyclestreak = 0;
	hardpoints = getEnabledHardpoints();

	for ( i = 0; i < hardpoints.size; i++ )
	{
		if ( hardpoints[i].streak > cyclestreak )
			cyclestreak = hardpoints[i].streak;
	}

	return cyclestreak;
}


getNextHardpoint( streak )
{
	hardpoints = getEnabledHardpoints();

	for ( i = 0; i < hardpoints.size; i++ )
	{
		if ( hardpoints[i].streak > streak )
			return hardpoints[i];
	}

	return undefined;
}


getHardpointAtStreak( streak )
{
	hardpoints = getEnabledHardpoints();

	for ( i = 0; i < hardpoints.size; i++ )
	{
		if ( hardpoints[i].streak == streak )
			return hardpoints[i];
	}

	return undefined;
}


getHardpointByType( hardpointType )
{
	if ( !isDefined( hardpointType ) || !isDefined( level.hardpoints ) )
		return undefined;

	for ( i = 0; i < level.hardpoints.size; i++ )
	{
		hardpoint = level.hardpoints[i];

		if ( isDefined( hardpoint ) && isDefined( hardpoint.type ) && hardpoint.type == hardpointType )
			return hardpoint;
	}

	return undefined;
}


getEnabledHardpoints()
{
	enabledHardpoints = [];

	if ( !isDefined( level.hardpoints ) )
		return enabledHardpoints;

	for ( i = 0; i < level.hardpoints.size; i++ )
	{
		hardpoint = level.hardpoints[i];

		if ( isDefined( hardpoint ) && isDefined( hardpoint.enabled ) && hardpoint.enabled )
			enabledHardpoints[enabledHardpoints.size] = hardpoint;
	}

	return enabledHardpoints;
}
