#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
	precacheMenu( "menu_challenges" );
	precacheMenu( "popup_prestige" );
	precacheString( &"PRESTIGE_KILLFEED" );
	precacheString( &"PRESTIGE_NAME1" );
	precacheString( &"PRESTIGE_NAME2" );
	precacheString( &"PRESTIGE_NAME3" );
	precacheString( &"PRESTIGE_NAME4" );
	precacheString( &"PRESTIGE_NAME5" );
	precacheString( &"PRESTIGE_NAME6" );
	precacheString( &"PRESTIGE_NAME7" );
	precacheString( &"PRESTIGE_NAME8" );
	precacheString( &"PRESTIGE_NAME9" );
	precacheString( &"PRESTIGE_NAME10" );
	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

onPlayerConnected()
{
	if ( level.rankedMatch || level.scr_server_rank_type == 2 )
		self repairWipedClasses();

	self thread prestigeResponseHandler();
}

prestigeUnlockMenu()
{
	self endon( "disconnect" );
	self setClientDvar( "ui_prestige_lock", "0" );
	self setClientDvar( "ui_prestige_nav", "1" );
	self closeMenu();
	self closeInGameMenu();
	wait 0.05;
	self openMenu( "menu_challenges" );
}

prestigeResponseHandler()
{
	self endon( "disconnect" );

	for (;;)
	{
		self waittill( "menuresponse", menu, response );

		if ( response == "challenges" )
		{
			self closeMenu();
			self closeInGameMenu();
			self setClientDvar( "ui_prestige_nav", "1" );
			self openMenu( "menu_challenges" );
			continue;
		}

		if ( response == "challenges_back" )
		{
			self closeMenu();
			self closeInGameMenu();

			if ( isDefined( self.pers["team"] ) && self.pers["team"] == "allies" )
				self openMenu( game["menu_class_allies"] );
			else if ( isDefined( self.pers["team"] ) && self.pers["team"] == "axis" )
				self openMenu( game["menu_class_axis"] );
			continue;
		}

		if ( menu != "popup_prestige" && menu != "menu_challenges" )
			continue;

		if ( response == "enter" )
		{
			if ( !self prestigeReset() )
				self thread prestigeUnlockMenu();
		}
	}
}

prestigePace()
{
	self.prestigeStatWrites++;

	// setStat and setClientDvar each send a reliable command when the value
	// changes. More than 128 unacknowledged commands drops the client.
	if ( self.prestigeStatWrites < 8 )
		return;

	self.prestigeStatWrites = 0;
	wait 0.05;
}

prestigePctString( pct )
{
	digit = [];

	if ( !isDefined( pct ) || pct <= 0 )
		return "0";
	if ( pct >= 100 )
		return "100";

	digit[0] = "0";
	digit[1] = "1";
	digit[2] = "2";
	digit[3] = "3";
	digit[4] = "4";
	digit[5] = "5";
	digit[6] = "6";
	digit[7] = "7";
	digit[8] = "8";
	digit[9] = "9";

	if ( pct < 10 )
		return digit[pct];

	return digit[ int( pct / 10 ) ] + digit[ pct - ( int( pct / 10 ) * 10 ) ];
}

prestigePublish()
{
	pct = 0;

	pct = int( ( self.prestigeDone * 100 ) / self.prestigeTotal );
	if ( pct > 100 )
		pct = 100;
	if ( pct == self.prestigePct )
		return;

	self.prestigePct = pct;
	self setClientDvar( "ui_prestige_pct", self prestigePctString( pct ) );
	self prestigePace();
}

defaultClassStat( slot )
{
	// statsTable row ids. Slot 0 is the M9, not an empty perk.
	if ( slot == 1 )
		return 25;
	if ( slot == 5 || slot == 6 || slot == 7 )
		return 190;
	if ( slot == 8 )
		return 101;

	return 0;
}

repairWipedClasses()
{
	base = 0;
	slot = 0;
	classBases = [];

	classBases[0] = 200;
	classBases[1] = 210;
	classBases[2] = 220;
	classBases[3] = 230;
	classBases[4] = 240;

	for ( base = 0; base < classBases.size; base++ )
	{
		slot = classBases[base];
		if ( self getStat( slot + 1 ) != 0 || self getStat( slot + 5 ) != 0 || self getStat( slot + 6 ) != 0 || self getStat( slot + 7 ) != 0 )
			continue;

		self setStat( slot, 1 );
		self setStat( slot + 1, defaultClassStat( 1 ) );
		self setStat( slot + 2, defaultClassStat( 2 ) );
		self setStat( slot + 3, defaultClassStat( 3 ) );
		self setStat( slot + 4, defaultClassStat( 4 ) );
		self setStat( slot + 5, defaultClassStat( 5 ) );
		self setStat( slot + 6, defaultClassStat( 6 ) );
		self setStat( slot + 7, defaultClassStat( 7 ) );
		self setStat( slot + 8, defaultClassStat( 8 ) );
		self setStat( slot + 9, defaultClassStat( 9 ) );
	}
}

prestigeSetStat( statId, value )
{
	self setStat( statId, value );
	self.prestigeDone++;
	self prestigePace();
	self prestigePublish();
}

prestigeReset()
{
	self endon( "disconnect" );

	statId = 0;
	slot = 0;
	base = 0;
	i = 0;
	clanTag = 0;
	newPrestige = 0;
	classBases = [];
	clearBases = [];
	starterPerks = [];

	if ( !level.rankedMatch && level.scr_server_rank_type != 2 )
		return false;

	if ( isDefined( self.prestigeResetting ) && self.prestigeResetting )
		return true;

	if ( !isDefined( self.pers["prestige"] ) || self.pers["prestige"] >= level.maxPrestige )
		return false;

	if ( !isDefined( self.pers["rank"] ) || self.pers["rank"] != level.maxRank )
		return false;

	self.prestigeResetting = true;
	self.prestigeStatWrites = 0;
	self.prestigeDone = 0;
	self.prestigePct = 0;
	// One prestigeSetStat call is one step: 200 + clan tag + 150 weapons +
	// 10 rank/feature + 10 tiers + 7 bookmarks + 50 class slots + 11 class
	// bases + 8 starter weapons + 13 perks + plevel + rank icons.
	self.prestigeTotal = 463;
	self setClientDvar( "ui_prestige_pct", "0" );
	newPrestige = self.pers["prestige"] + 1;
	clanTag = self getStat( 261 );

	for ( statId = 0; statId < 200; statId++ )
		self prestigeSetStat( statId, 0 );
	self prestigeSetStat( 261, clanTag );

	for ( statId = 3000; statId <= 3149; statId++ )
		self prestigeSetStat( statId, 0 );

	self prestigeSetStat( 251, 0 );
	self prestigeSetStat( 252, 0 );
	self prestigeSetStat( 253, 0 );
	self prestigeSetStat( 254, 0 );
	self prestigeSetStat( 255, 0 );
	self prestigeSetStat( 256, 0 );
	self prestigeSetStat( 257, 0 );
	self prestigeSetStat( 258, 0 );
	self prestigeSetStat( 260, 0 );
	self prestigeSetStat( 263, 0 );
	for ( statId = 270; statId <= 279; statId++ )
		self prestigeSetStat( statId, 0 );

	self prestigeSetStat( 2301, 0 );
	self prestigeSetStat( 2350, 0 );
	self prestigeSetStat( 2351, 0 );
	self prestigeSetStat( 2352, 0 );
	self prestigeSetStat( 2353, 0 );
	self prestigeSetStat( 3150, 0 );
	self prestigeSetStat( 3151, 0 );

	classBases[0] = 200;
	classBases[1] = 210;
	classBases[2] = 220;
	classBases[3] = 230;
	classBases[4] = 240;
	for ( i = 0; i < classBases.size; i++ )
	{
		base = classBases[i];
		self prestigeSetStat( base, 1 );
		for ( slot = 1; slot <= 9; slot++ )
			self prestigeSetStat( base + slot, defaultClassStat( slot ) );
	}

	clearBases[0] = 300;
	clearBases[1] = 310;
	clearBases[2] = 320;
	clearBases[3] = 330;
	clearBases[4] = 340;
	clearBases[5] = 350;
	clearBases[6] = 1300;
	clearBases[7] = 1310;
	clearBases[8] = 1320;
	clearBases[9] = 1330;
	clearBases[10] = 1340;
	for ( i = 0; i < clearBases.size; i++ )
		self prestigeSetStat( clearBases[i], 0 );

	self prestigeSetStat( 3000, 9 );
	self prestigeSetStat( 3002, 9 );
	self prestigeSetStat( 3010, 1 );
	self prestigeSetStat( 3025, 1 );
	self prestigeSetStat( 3061, 1 );
	self prestigeSetStat( 3071, 1 );
	self prestigeSetStat( 3081, 1 );
	self prestigeSetStat( 3100, 1 );

	starterPerks[0] = 154;
	starterPerks[1] = 156;
	starterPerks[2] = 160;
	starterPerks[3] = 161;
	starterPerks[4] = 162;
	starterPerks[5] = 167;
	starterPerks[6] = 168;
	starterPerks[7] = 169;
	starterPerks[8] = 184;
	starterPerks[9] = 186;
	starterPerks[10] = 187;
	starterPerks[11] = 188;
	starterPerks[12] = 190;
	for ( i = 0; i < starterPerks.size; i++ )
		self prestigeSetStat( starterPerks[i], 1 );

	self prestigeSetStat( 2326, newPrestige );
	self maps\mp\gametypes\_persistence::statSet( "plevel", newPrestige );
	self maps\mp\gametypes\_persistence::statSet( "rankxp", 0 );
	self maps\mp\gametypes\_persistence::statSet( "rank", 0 );
	self maps\mp\gametypes\_persistence::statSet( "minxp", maps\mp\gametypes\_rank::getRankInfoMinXp( 0 ) );
	self maps\mp\gametypes\_persistence::statSet( "maxxp", maps\mp\gametypes\_rank::getRankInfoMaxXp( 0 ) );
	self maps\mp\gametypes\_persistence::statSet( "lastxp", 0 );

	self.pers["prestige"] = newPrestige;
	self.pers["rankxp"] = 0;
	self.pers["rank"] = 0;
	self.cur_rankNum = 0;
	self prestigeSetStat( 251, 0 );
	self prestigeSetStat( 252, 0 );

	if ( level.gametype != "gg" )
		self setRank( 0, newPrestige );

	self announcePrestige( newPrestige );

	self.prestigePct = 100;
	self setClientDvar( "ui_prestige_pct", "100" );
	wait 0.75;

	self setClientDvar( "ui_prestige_lock", "0" );
	self closeMenu();
	self closeInGameMenu();
	self.prestigeResetting = false;

	// The promotion banner hides while a menu is open.
	wait 0.2;
	self announcePrestigeLevelUp( newPrestige );
	return true;
}

announcePrestigeLevelUp( newPrestige )
{
	notifyData = spawnStruct();
	notifyData.titleText = &"RANK_PROMOTED";
	notifyData.notifyText = self prestigeFullName( newPrestige );
	notifyData.iconName = maps\mp\gametypes\_rank::getRankInfoIcon( 0, newPrestige );
	notifyData.sound = "mp_level_up";
	notifyData.duration = 4.0;

	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

announcePrestige( newPrestige )
{
	prestigeName = self prestigeFullName( newPrestige );
	players = level.players;

	for ( i = 0; i < players.size; i++ )
	{
		if ( isDefined( players[i] ) )
			players[i] iprintln( &"PRESTIGE_KILLFEED", self, prestigeName );
	}
}

prestigeFullName( prestigeId )
{
	if ( prestigeId == 2 )
		return &"PRESTIGE_NAME2";
	if ( prestigeId == 3 )
		return &"PRESTIGE_NAME3";
	if ( prestigeId == 4 )
		return &"PRESTIGE_NAME4";
	if ( prestigeId == 5 )
		return &"PRESTIGE_NAME5";
	if ( prestigeId == 6 )
		return &"PRESTIGE_NAME6";
	if ( prestigeId == 7 )
		return &"PRESTIGE_NAME7";
	if ( prestigeId == 8 )
		return &"PRESTIGE_NAME8";
	if ( prestigeId == 9 )
		return &"PRESTIGE_NAME9";
	if ( prestigeId == 10 )
		return &"PRESTIGE_NAME10";

	return &"PRESTIGE_NAME1";
}
