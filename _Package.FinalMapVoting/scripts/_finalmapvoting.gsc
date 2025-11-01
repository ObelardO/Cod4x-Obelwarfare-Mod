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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                         FINAL MAP VOTING SYSTEM                                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
		//level.fmvMod.voteOptions[i].mapTitle = "";
		level.fmvMod.voteOptions[i].gameType = "";
		//level.fmvMod.voteOptions[i].gameTypeTitle = "";
		level.fmvMod.voteOptions[i].votes = 0;
	}
}


initPlayer()
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

	self openMenu( level.fmvMod.menu );

	if( !isDefined( self.fmvMod ) )
		self.fmvMod = spawnStruct();

	self.fmvMod.lastVotedIndex = 0;

	//player thread updateVotes();
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
	else
	{
		resetVoteOptions();

		/* Select maps for votes options */

		logPrint("FMV;S\n");

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
					//level.fmvMod.voteOptions[i].mapTitle = getMapTitle( mgCombo["mapname"] );
					level.fmvMod.voteOptions[i].gameType = mgCombo["gametype"];
					//level.fmvMod.voteOptions[i].gameTypeTitle = mgCombo["gametype"];
					level.fmvMod.voteOptions[i].votes = 0;

					isComboUnique = true;
				}
			}
		}

		/* */
	
		/* Setup players */

		for( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];

			if( isDefined( player ) ) 
				player thread initPlayer();
		}

		//wait 0.05;

		/* */

		/* Voting (wait) */

		time = level.scr_fmv_map_time;
		updateDisplayTimer( time );

		while( time > 0 )
		{
			wait 1;
			time--;
			updateDisplayTimer( time );
		}

		/* */

		/* Resulting */

		resultOption = level getVotingResult();

		setAllClientsDvar( "ui_fmv_time", "Next map:^3 " + resultOption.mapName );
		setAllClientsDvar( "ui_fmv_vote_done", 1 );

		logPrint("FMV;R;" + resultOption.mapName + ";" + resultOption.gameType + "\n");

		changelevel( resultOption.mapName, resultOption.gameType, level.scr_fmv_winner_time );
	}
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


updateDisplayTimer( time )
{
	if( time < 4 )
		self setAllClientsDvar( "ui_fmv_time", "Vote Map - Time left:^1 " + time);
	else
		self setAllClientsDvar( "ui_fmv_time", "Vote Map - Time left: " + time);
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                         FINAL MAP VOTING UTILS                                          //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*

getMapTitle( mapName )
{
	if( isDefined( level.stockMapNames ) && isDefined ( level.stockMapNames[mapName] ) )
	{
		return level.stockMapNames[mapName];
	}

	return getCustomMapTitle( mapName );
}


isDefaultMap( mapName )
{
	if( isDefined( level.defaultMapList ) )
	{
		return isSubStr( level.defaultMapList, mapName );
	}
	
	return false;
}


getCustomMapTitle( mapName )
{
	mapName = getSubStr(mapName, 3);
	mapName += " ";

	mapTitle = "";

	switch( mapName[0] )
	{
		case"a": mapTitle += "A"; break;
		case"b": mapTitle += "B"; break;
		case"c": mapTitle += "C"; break;
		case"d": mapTitle += "D"; break;
		case"e": mapTitle += "E"; break;
		case"f": mapTitle += "F"; break;
		case"g": mapTitle += "G"; break;
		case"h": mapTitle += "H"; break;
		case"i": mapTitle += "I"; break;
		case"j": mapTitle += "J"; break;
		case"k": mapTitle += "K"; break;
		case"l": mapTitle += "L"; break;
		case"m": mapTitle += "M"; break;
		case"n": mapTitle += "N"; break;
		case"o": mapTitle += "O"; break;
		case"p": mapTitle += "P"; break;
		case"q": mapTitle += "Q"; break;
		case"r": mapTitle += "R"; break;
		case"s": mapTitle += "S"; break;
		case"t": mapTitle += "T"; break;
		case"u": mapTitle += "U"; break;
		case"v": mapTitle += "V"; break;
		case"w": mapTitle += "W"; break;
		case"x": mapTitle += "X"; break;
		case"y": mapTitle += "Y"; break;
		case"z": mapTitle += "Z"; break;
		default: mapTitle += mapName[0];
	}

	for( i = 1; i < mapName.size; i++ )
	{
		if( mapName[i] == "_" )
		{
			mapTitle += " ";
			if( isDefined( mapName[i + 1] ) )
			{
				switch( mapName[i + 1] )
				{
					case"a": mapTitle += "A"; break;
					case"b": mapTitle += "B"; break;
					case"c": mapTitle += "C"; break;
					case"d": mapTitle += "D"; break;
					case"e": mapTitle += "E"; break;
					case"f": mapTitle += "F"; break;
					case"g": mapTitle += "G"; break;
					case"h": mapTitle += "H"; break;
					case"i": mapTitle += "I"; break;
					case"j": mapTitle += "J"; break;
					case"k": mapTitle += "K"; break;
					case"l": mapTitle += "L"; break;
					case"m": mapTitle += "M"; break;
					case"n": mapTitle += "N"; break;
					case"o": mapTitle += "O"; break;
					case"p": mapTitle += "P"; break;
					case"q": mapTitle += "Q"; break;
					case"r": mapTitle += "R"; break;
					case"s": mapTitle += "S"; break;
					case"t": mapTitle += "T"; break;
					case"u": mapTitle += "U"; break;
					case"v": mapTitle += "V"; break;
					case"w": mapTitle += "W"; break;
					case"x": mapTitle += "X"; break;
					case"y": mapTitle += "Y"; break;
					case"z": mapTitle += "Z"; break;
					default: mapTitle += mapName[i + 1];
				}
				i++;
			}
		}
		else if( mapName[i] != "_" )
		{
			mapTitle += mapName[i];
		}
	}

	return mapTitle;
}

*/

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

	//setDvar( "sv_maprotationcurrent", "");
	//setDvar( "sv_maprotation", nextRotation );
	//setAllClientsDvar( "cl_bypassmouseinput", 0 );

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