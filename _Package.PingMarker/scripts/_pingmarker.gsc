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
// Based on Kesara Weerasooriya's Splashes code                 //
// https://github.com/kesaraweerasooriya/Splash-Icons-Cod4      //
//**************************************************************//


#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#include openwarfare\_eventmanager;
#include openwarfare\_utils;


init()
{
	preCacheShader( "compass_ping" );
	preCacheShader( "waypoint_ping" );
	precacheHeadIcon( "talkingicon" );

	precacheString( &"MARKER_DIR_NORTH" );
	precacheString( &"MARKER_DIR_NORTHEAST" );
	precacheString( &"MARKER_DIR_EAST" );
	precacheString( &"MARKER_DIR_SOUTHEAST" );
	precacheString( &"MARKER_DIR_SOUTH" );
	precacheString( &"MARKER_DIR_SOUTHWEST" );
	precacheString( &"MARKER_DIR_WEST" );
	precacheString( &"MARKER_DIR_NORTHWEST" );

	level.scr_pingmarker_enable = getdvarx( "scr_pingmarker_enable", "int", 1, 0, 1 );
	level.scr_pingmarker_direction_voice = getdvarx( "scr_pingmarker_direction_voice", "int", 1, 0, 1 );
	level.scr_pingmarker_direction_chat = getdvarx( "scr_pingmarker_direction_chat", "int", 1, 0, 1 );
	level.scr_pingmarker_direction_mindist = getdvarx( "scr_pingmarker_direction_mindist", "float", 0, 0, 4000 );
	level.scr_pingmarker_landmark_voice = getdvarx( "scr_pingmarker_landmark_voice", "int", 1, 0, 1 );
	level.scr_pingmarker_landmark_chat = getdvarx( "scr_pingmarker_landmark_chat", "int", 1, 0, 1 );

	initPingLandmarks();

	if ( !level.scr_pingmarker_enable )
		return;

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	self thread addNewEvent( "onMenuResponse", ::onMenuResponse );
	self thread addNewEvent( "onJoinedTeam", ::cachePingVoicePrefix );
	self thread addNewEvent( "onPlayerSpawned", ::cachePingVoicePrefix );
	self cachePingVoicePrefix();
}


initPingLandmarks()
{
	level.pingLandmarks = [];

	names = strTok( "apc armoredvehicle barrels barricade boxes bradley bulldozer bus car carblue carbrown cargocontainer cargreen carred carwhite carwrecked cinderblocks concretepipe couch crate crater desk dumpster extdoorway fence fountain fridge garage gate hatchback humvee intdoorway marketstand outhouse palmtrees pilelumber sandbags semi shed statue steps table tank tires trailer trashcans trees truck truckblue truckbrown truckdestroyed truckgreen truckpickup truckred truckwhite van vanblue vanbrown vandestroyed vangreen vanred vanwhite wall wallbroken wallcinderblock walllow wallstone washingmachine window", " " );

	for ( i = 0; i < names.size; i++ )
		level.pingLandmarks[ names[i] ] = true;
}


cachePingVoicePrefix()
{
	team = self.pers["team"];

	if ( !isDefined( team ) || !isDefined( game["voice"][team] ) )
	{
		self.pingVoicePrefix = undefined;
		return;
	}

	// Marines and SAS use US_6, Spetsnaz RU_1, OpFor AB_1. The alias prefix is the faction.
	switch ( game["voice"][team] )
	{
		case "US_1mc_":
			self.pingVoicePrefix = "us";
			break;
		case "UK_1mc_":
			self.pingVoicePrefix = "sas";
			break;
		case "RU_1mc_":
			self.pingVoicePrefix = "ru";
			break;
		case "AB_1mc_":
			self.pingVoicePrefix = "ab";
			break;
		default:
			self.pingVoicePrefix = undefined;
			break;
	}
}


pingVoicePrefix()
{
	if ( !isDefined( self.pingVoicePrefix ) )
		self cachePingVoicePrefix();

	return self.pingVoicePrefix;
}


onMenuResponse( menu, response )
{
	if( menu == "-1" && response == "ping" ) pingRightNow();
}


pingRightNow()
{
	self endon( "disconnect" );

	if ( !isDefined( self.pinged ) )
		self.pinged = false;

	if( !isAlive( self ) || self.pinged )
		return;

	angles = self getPlayerAngles();
	eye = self getTagOrigin("j_head");
	forward = eye + vector_scale(anglesToForward(angles),4000);
	trace = bulletTrace(eye,forward,false,self);

	if( trace["fraction"] == 1 )
		return;

	pingloc = trace["position"] - vector_scale( anglesToForward( angles ), 50 );
	
	self.pinged = true;
	self pingPlayer();

	self thread minimap( pingloc );
	self thread announcePing( pingloc );

	// TODO: Cache hud element on player connection
	// Check if only one team should see this
	if ( level.teamBased )
	{
		pinghud = newTeamHudElem( self.pers["team"] );		

		playSoundOnPlayers( "mp_ingame_summary", self.pers["team"] );
	}
	else
	{
		pinghud = newHudElem();	

		playSoundOnPlayers( "mp_ingame_summary" );	
	}

	pinghud.name = "waypoint_ping_" + self getEntityNumber();
	pinghud setShader("waypoint_ping", level.objPointSize, level.objPointSize);
	pinghud setwaypoint(true, "waypoint_ping");

	pinghud.x=pingloc[0];
    pinghud.y=pingloc[1];
    pinghud.z=pingloc[2]+10;	
	pinghud.baseAlpha = 0.9;

	a = 0.8;
	pinghud.alpha = a; wait 0.05;
	pinghud.alpha = 0; wait 0.05;
	pinghud.alpha = a; wait 0.05;
	pinghud.alpha = 0; wait 0.05;
	pinghud.alpha = a; wait 2;
	pinghud.alpha = 0;

	wait 0.5;
	pinghud destroy();
	wait 0.3;
	self.pinged = false;
}

minimap( position )
{
	objCompass = maps\mp\gametypes\_gameobjects::getNextObjID();

	if ( objCompass != -1 ) 
	{
		objective_Add( objCompass, "active", position + ( 0, 0, 25 ) );
		objective_Icon( objCompass, "compass_ping" );

		// Check if only one team should see this
		if ( level.teamBased )
		{
			objective_Team( objCompass, self.team );
		} 
		else
		{
			objective_Team( objCompass, "none" );
		}
		
		while( self.pinged )
		{
			wait 0.1;
			objective_State( objCompass, "invisible" );
			wait 0.1;
			objective_State( objCompass, "active" );
		}

		objective_delete( objCompass );
		level.objectiveIDs[objCompass] = false;	
	}
}


announcePing( pingloc )
{
	self endon( "disconnect" );

	if ( !level.scr_pingmarker_direction_voice && !level.scr_pingmarker_direction_chat && !level.scr_pingmarker_landmark_voice && !level.scr_pingmarker_landmark_chat )
		return;

	info = undefined;

#if isSyscallDefined getCallout
	info = self getCallout( pingloc, "ping" );
#endif

	alias = "";
	text = undefined;
	namedSector = isDefined( info ) && isDefined( info["index"] ) && info["index"] > 0 && isDefined( info["ref"] ) && info["ref"] != "";

	if ( namedSector )
	{
		ref = toLower( info["ref"] );

		prefix = self pingVoicePrefix();

		if ( level.scr_pingmarker_landmark_voice && isDefined( prefix ) && isDefined( level.pingLandmarks[ref] ) )
			alias = "pm_" + prefix + "_lm_" + ref;

		if ( level.scr_pingmarker_landmark_chat && isDefined( info["localized"] ) && info["localized"] != "" )
			text = info["localized"];
	}
	else if ( level.scr_pingmarker_direction_mindist <= 0 || distance( self.origin, pingloc ) >= level.scr_pingmarker_direction_mindist )
	{
		direction = getPingCompassDirection( self.origin, pingloc );

		prefix = self pingVoicePrefix();

		if ( level.scr_pingmarker_direction_voice && isDefined( prefix ) )
			alias = "pm_" + prefix + "_dir_" + direction;

		if ( level.scr_pingmarker_direction_chat )
			text = getPingDirectionText( direction );
	}

	if ( alias != "" && soundExists( alias ) )
	{
		self savePingHeadIcon();

		if ( level.teamBased )
		{
			if ( self.sessionteam == "allies" )
				self.headiconteam = "allies";
			else if ( self.sessionteam == "axis" )
				self.headiconteam = "axis";
		}
		else
		{
			self.headiconteam = "none";
		}

		self.headicon = "talkingicon";
		self playSound( alias );
		self thread restorePingHeadIconDelayed();
	}

	if ( isDefined( text ) )
	{
		if ( level.teamBased )
			self sayTeam( text );
		else
			self sayAll( text );
	}
}


getPingCompassDirection( vOrigin, vPoint )
{
	angles = vectorToAngles( vPoint - vOrigin );
	angle = angles[1] - getNorthYaw();

	if ( angle < 0 )
		angle += 360;
	else if ( angle >= 360 )
		angle -= 360;

	if ( angle < 22.5 || angle > 337.5 )
		return "north";
	else if ( angle < 67.5 )
		return "northwest";
	else if ( angle < 112.5 )
		return "west";
	else if ( angle < 157.5 )
		return "southwest";
	else if ( angle < 202.5 )
		return "south";
	else if ( angle < 247.5 )
		return "southeast";
	else if ( angle < 292.5 )
		return "east";

	return "northeast";
}


getPingDirectionText( direction )
{
	switch ( direction )
	{
		case "northeast":
			return &"MARKER_DIR_NORTHEAST";
		case "east":
			return &"MARKER_DIR_EAST";
		case "southeast":
			return &"MARKER_DIR_SOUTHEAST";
		case "south":
			return &"MARKER_DIR_SOUTH";
		case "southwest":
			return &"MARKER_DIR_SOUTHWEST";
		case "west":
			return &"MARKER_DIR_WEST";
		case "northwest":
			return &"MARKER_DIR_NORTHWEST";
		default:
			return &"MARKER_DIR_NORTH";
	}
}


savePingHeadIcon()
{
	self.pingOldHeadIcon = undefined;
	self.pingOldHeadIconTeam = undefined;

	if ( isDefined( self.headicon ) )
		self.pingOldHeadIcon = self.headicon;

	if ( isDefined( self.headiconteam ) )
		self.pingOldHeadIconTeam = self.headiconteam;
}


restorePingHeadIconDelayed()
{
	self endon( "disconnect" );

	while ( isDefined( self.pinged ) && self.pinged )
		wait 0.05;

	self restorePingHeadIcon();
}


restorePingHeadIcon()
{
	if ( isDefined( self.pingOldHeadIcon ) )
		self.headicon = self.pingOldHeadIcon;

	if ( isDefined( self.pingOldHeadIconTeam ) )
		self.headiconteam = self.pingOldHeadIconTeam;

	self.pingOldHeadIcon = undefined;
	self.pingOldHeadIconTeam = undefined;
}