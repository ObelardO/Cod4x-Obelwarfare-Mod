//**************************************************************//
//  _____ _          _    _    _             __                 //
// |  _  | |        | |  | |  | |           / _|                //
// | | | | |__   ___| |  | |  | | __ _ _ __| |_ __ _ _ __ ___   //
// | | | | '_ \ / _ \ |  | |/\| |/ _` | '__|  _/ _` | '__/ _ \  //
// \ \_/ / |_) |  __/ |__\  /\  / (_| | |  | || (_| | | |  __/  //
//  \___/|_.__/ \___|____/\/  \/ \__,_|_|  |_| \__,_|_|  \___|  //
//                                                              //
//            Website: http://cod4.obelardo.ru                  //
//**************************************************************//

#include openwarfare\_utils;
#include openwarfare\_eventmanager;


init()
{
	if ( !isDefined( game["skip_final_map_voting"] ) )
		game["skip_final_map_voting"] = false;	
	
	level.scr_fmv_enabled = getdvarx( "scr_fmv_enabled", "int", 0, 0, 1 );

	if( !level.scr_fmv_enabled ) return;

	level.scr_fmv_map_time = getdvard( "scr_fmv_map_time", "int", 15, 5, 45 );
	level.scr_fmv_winner_time = getdvard( "scr_fmv_winner_time", "int", 5, 5, 15 );

	if( !isDefined( level.fmvMod ) )
    {
		level.fmvMod = spawnStruct();

		level.fmvMod.menu = "finalmapvoting";

		initVoteOptions();
		resetVoteOptions();

		precacheMenu( level.fmvMod.menu );
	}

	level.onEndGameMapVote = ::onEngGameMapVote;
}


initVoteOptions()
{
	for( i = 1; i < 10; i++ )
	{
		level.fmvMod.voteOptions[i] = spawnStruct();
	}
}


resetVoteOptions()
{
	for( i = 1; i <= level.fmvMod.voteOptions.size; i++ )
	{
		level.fmvMod.voteOptions[i].mapName = "";
		level.fmvMod.voteOptions[i].gameType = "";
		level.fmvMod.voteOptions[i].votes = 0;
		level.fmvMod.voteOptions[i].index = i;
	}
}


setupPlayerVotingMenu()
{
	for( i = 1; i <= level.fmvMod.voteOptions.size; i++ )
	{
		voteOption = level.fmvMod.voteOptions[i];
		dvarPrefix = "ui_fmv_option_" + i + "_";

		self setClientDvars(
			dvarPrefix + "map", voteOption.mapName,
			dvarPrefix + "gametype", voteOption.gameType,
			dvarPrefix + "votes", voteOption.votes
		);
	}

	self setClientDvar( "ui_fmv_vote_done", 0 );
	self setClientDvar( "ui_fmv_selected_index", 1337 );

	self closeMenu();
	self closeInGameMenu();

	self.sessionstate = "spectator";

	self freezecontrols( true );

	wait 0.05;

	self openMenu( level.fmvMod.menu );

	if( !isDefined( self.fmvMod ) )
		self.fmvMod = spawnStruct();

	self.fmvMod.lastVotedIndex = 0;

	self thread addNewEvent( "onMenuResponse", ::onMenuResponse );
}


onEngGameMapVote()
{
	if( level.scr_fmv_enabled == 0 || game["skip_final_map_voting"] )
		return;

	thread maps\mp\gametypes\_globallogic::timeLimitClock_Intermission( level.scr_fmv_map_time, true );

	mgCombos = openwarfare\_maprotationcs::getMapGametypeCombinations();

	if( mgCombos.size < level.fmvMod.voteOptions.size )
	{
		iprintlnbold("^1Not enough maps in sv_mapRotation to start vote!");

		return;
	}

	logPrint("FMV;S\n");

	/* Select maps for votes options */
	
	resetVoteOptions();

	mgComboUsedIndexes = [];

	for( i = 1; i <= level.fmvMod.voteOptions.size; i++ )
	{
		isComboUnique = false;

		while( !isComboUnique )
		{
			mgComboIndex = randomIntRange( 0, mgCombos.size );
				
			if ( !isDefined( mgComboUsedIndexes[mgComboIndex] ) )
			{
				mgComboUsedIndexes[mgComboIndex] = i;

				mgCombo = mgCombos[mgComboIndex];

				level.fmvMod.voteOptions[i].mapName = mgCombo["mapname"];
				level.fmvMod.voteOptions[i].gameType = mgCombo["gametype"];
				//level.fmvMod.voteOptions[i].mapTitle = getMapTitle( mgCombo["mapname"] );
				//level.fmvMod.voteOptions[i].gameTypeTitle = getGameTypeTitle( mgCombo["gametype"] );
				level.fmvMod.voteOptions[i].votes = 0;

				isComboUnique = true;
			}
		}
	}

	/* Setup players */
	for( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];

		if( isDefined( player ) ) 
			player thread setupPlayerVotingMenu();
	}

	/* Voting (wait) */
	wait level.scr_fmv_map_time;

	/* Resulting */
	resultOption = level getVotingResult();

	setAllClientsDvar( "ui_fmv_winner", resultOption.index );
	setAllClientsDvar( "ui_fmv_vote_done", 1 );

	logPrint("FMV;R;" + resultOption.mapName + ";" + resultOption.gameType + "\n");

	changelevel( resultOption.mapName, resultOption.gameType, level.scr_fmv_winner_time );
}


onMenuResponse( menu, response )
{
	if( menu == level.fmvMod.menu ) self makeVote( response );
}


getVotingResult()
{
	resultOptionIndex = 1;

	for( i = 2; i <= level.fmvMod.voteOptions.size; i++ )
	{
		voteOption = level.fmvMod.voteOptions[i];

		if( voteOption.votes > level.fmvMod.voteOptions[resultOptionIndex].votes )
		{
			resultOptionIndex = i;
		}
	}

	return level.fmvMod.voteOptions[resultOptionIndex];
}


makeVote( response )
{
	for( i = 1; i <= level.fmvMod.voteOptions.size; i++ )
	{
		voteOption = level.fmvMod.voteOptions[i];

		if( response == "vote" + i && ( self.fmvMod.lastVotedIndex != i ) )
		{
			voteOption.votes++;

			setAllClientsDvar( "ui_fmv_option_" + i + "_votes", voteOption.votes );

			if( self.fmvMod.lastVotedIndex > 0 )
			{
				lastVoteOption = level.fmvMod.voteOptions[self.fmvMod.lastVotedIndex];
				lastVoteOption.votes--;

				setAllClientsDvar( "ui_fmv_option_" + self.fmvMod.lastVotedIndex + "_votes", lastVoteOption.votes );
			}

			self.fmvMod.lastVotedIndex = i;
			self setClientDvar( "ui_fmv_selected_index", i );
		}
	}
}


changelevel( map, gameType, delay )
{
	if( isDefined( level.nextMapInfo ) )
	{
		nextMap = level.nextMapInfo["mapname"];
		nextGametype = level.nextMapInfo["gametype"];

		if( nextMap == map && gameType == nextGametype )
		{
			wait delay;
			exitlevel( false );
		}
	}
	
	currentRotation = getDvar( "sv_mapRotationCurrent" );
	setDvar( "sv_mapRotationCurrent", "gametype " + gameType + " map " + map + " " + currentRotation );		

	wait delay;
	exitlevel( false );
}


setAllClientsDvar( dvar, value )
{
	for( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];

		if( isDefined( player ) ) 
			player setClientDvar( dvar, value );
	}
}