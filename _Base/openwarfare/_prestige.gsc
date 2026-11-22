#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
	level.scr_prestige_enable = getdvarx( "scr_prestige_enable", "int", 1, 0, 1 );
	
	if ( !level.scr_prestige_enable )
		return;

	if ( !level.rankedMatch && level.scr_server_rank_type != 2 )
		return;

	precacheMenu( "menu_challenges" );
	precacheMenu( "popup_prestige" );
	precacheString( &"PRESTIGE_KILLFEED" );

	initPrestigeLevelData();
	
	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

initPrestigeLevelData()
{
	prestigeId = 1;

	for ( ;; )
	{
		prestigeTitle = tableLookupIString( "mp/prestigeNameTable.csv", 0, prestigeId, 1 );
		if ( !isDefined( prestigeTitle ) || prestigeTitle == "" )
			break;

		precacheString( prestigeTitle );
		prestigeId++;
	}

	assertex( prestigeId > 1, "mp/prestigeNameTable.csv has no rows" );

	level.prestige = spawnStruct();
	level.prestige.statSetsTotal = processPrestigeResetData( false );
}

onPlayerConnected()
{
	self initPrestigePlayerData();
	self setClientDvar( "ui_prestige_enable", 1 );
	self thread addNewEvent( "onMenuResponse", ::onPrestigeMenuResponse );
}

initPrestigePlayerData()
{
	self.prestige = spawnStruct();
	self.prestige.isUnlockingInProgress = false;
	self.prestige.statSetsChunks = 0;
	self.prestige.statSetsCurrent = 0;
	self.prestige.statSetsPercent = 0;
}

openPrestigeMenuForced()
{
	self endon( "disconnect" );
	self setClientDvar( "ui_prestige_lock", "0" );
	self setClientDvar( "ui_prestige_nav", "1" );
	self closeMenu();
	self closeInGameMenu();
	wait 0.05;
	self openMenu( "menu_challenges" );
}

onPrestigeMenuResponse( menu, response )
{
	if ( response == "challenges" )
	{
		self closeMenu();
		self closeInGameMenu();
		self setClientDvar( "ui_prestige_nav", "1" );
		self openMenu( "menu_challenges" );
		return;
	}

	if ( response == "challenges_back" )
	{
		self closeMenu();
		self closeInGameMenu();

		if ( isDefined( self.pers["team"] ) && self.pers["team"] == "allies" )
			self openMenu( game["menu_class_allies"] );
		else if ( isDefined( self.pers["team"] ) && self.pers["team"] == "axis" )
			self openMenu( game["menu_class_axis"] );
		return;
	}

	if ( menu != "popup_prestige" && menu != "menu_challenges" )
		return;

	if ( response != "enter" )
		return;

	if ( !self unlockPrestige() )
		self thread openPrestigeMenuForced();
}

pacePrestigeResetData()
{
	self.prestige.statSetsChunks++;

	// setStat and setClientDvar each send a reliable command when the value
	// changes. More than 128 unacknowledged commands drops the client.
	if ( self.prestige.statSetsChunks < 8 )
		return;

	self.prestige.statSetsChunks = 0;
	wait 0.05;
}

informPrestigeResetProgress()
{
	progress = 0;

	progress = int( ( self.prestige.statSetsCurrent * 100 ) / level.prestige.statSetsTotal );
	if ( progress > 100 )
		progress = 100;
	if ( progress == self.prestige.statSetsPercent )
		return;

	self.prestige.statSetsPercent = progress;
	self setClientDvar( "ui_prestige_pct", progress );
	self pacePrestigeResetData();
}

processPrestigeResetData( writeStats )
{
	row = 0;
	total = 1;
	statId = 0;
	
	statRangeMinRaw = "";
	statRangeMaxRaw = "";

	statRangeMin = 0;
	statRangeMax = 0;
	statValue = 0;

	for ( ;; )
	{
		statRangeMinRaw = tableLookup( "mp/prestigeResetTable.csv", 0, row, 1 );
		if ( !isDefined( statRangeMinRaw ) || statRangeMinRaw == "" )
			break;

		statRangeMaxRaw = tableLookup( "mp/prestigeResetTable.csv", 0, row, 2 );
		statRangeMin = int( statRangeMinRaw );
		statValue = int( tableLookup( "mp/prestigeResetTable.csv", 0, row, 3 ) );
		
		if ( !isDefined( statRangeMaxRaw ) || statRangeMaxRaw == "" )
			statRangeMax = statRangeMin;
		else
			statRangeMax = int( statRangeMaxRaw );

		if ( writeStats )
		{
			for ( statId = statRangeMin; statId <= statRangeMax; statId++ )
				self setPrestigeResetData( statId, statValue );
		}

		total += statRangeMax - statRangeMin + 1;
		row++;
	}

	assertex( row > 0, "mp/prestigeResetTable.csv has no rows" );
	return total;
}

setPrestigeResetData( statId, value )
{
	self setStat( statId, value );
	self.prestige.statSetsCurrent++;
	
	self pacePrestigeResetData();
	self informPrestigeResetProgress();
}

unlockPrestige()
{
	self endon( "disconnect" );

	if ( self.prestige.isUnlockingInProgress )
		return true;

	if ( !isDefined( self.pers["prestige"] ) || self.pers["prestige"] >= level.maxPrestige )
		return false;

	if ( !isDefined( self.pers["rank"] ) || self.pers["rank"] != level.maxRank )
		return false;

	self.prestige.isUnlockingInProgress = true;
	self.prestige.statSetsChunks = 0;
	self.prestige.statSetsCurrent = 0;
	self.prestige.statSetsPercent = 0;
	self setClientDvar( "ui_prestige_pct", "0" );
	
	prestigeId = self.pers["prestige"] + 1;

	self processPrestigeResetData( true );
	self setPrestigeResetData( 2326, prestigeId );
	
	self maps\mp\gametypes\_persistence::statSet( "minxp", maps\mp\gametypes\_rank::getRankInfoMinXp( 0 ) );
	self maps\mp\gametypes\_persistence::statSet( "maxxp", maps\mp\gametypes\_rank::getRankInfoMaxXp( 0 ) );

	self.pers["prestige"] = prestigeId;
	self.pers["rankxp"] = 0;
	self.pers["rank"] = 0;
	self.cur_rankNum = 0;

	if ( level.gametype != "gg" )
		self setRank( 0, prestigeId );

	self notifyPrestigeUnlockedToPlayers( prestigeId );

	self.prestige.statSetsPercent = 100;
	self setClientDvar( "ui_prestige_pct", "100" );
	wait 0.75;

	self setClientDvar( "ui_prestige_lock", "0" );
	self closeMenu();
	self closeInGameMenu();
	self.prestige.isUnlockingInProgress = false;

	// The promotion banner hides while a menu is open.
	wait 0.2;
	self notifyPrestigeUnlockedToPlayer( prestigeId );
	return true;
}

notifyPrestigeUnlockedToPlayer( prestigeId )
{
	notifyData = spawnStruct();
	notifyData.titleText = &"RANK_PROMOTED";
	notifyData.notifyText = getPrestigeTitle( prestigeId );
	notifyData.iconName = maps\mp\gametypes\_rank::getRankInfoIcon( 0, prestigeId );
	notifyData.sound = "mp_level_up";
	notifyData.duration = 4.0;

	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

notifyPrestigeUnlockedToPlayers( prestigeId )
{
	iprintln( &"PRESTIGE_KILLFEED", self, getPrestigeTitle( prestigeId ) );
}

getPrestigeTitle( prestigeId )
{
	return tableLookupIString( "mp/prestigeNameTable.csv", 0, prestigeId, 1 );
}