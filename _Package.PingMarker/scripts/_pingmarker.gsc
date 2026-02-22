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


init()
{
	//TODO: Make configuration options

    preCacheShader("compass_ping");
	preCacheShader("waypoint_ping");

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	self thread addNewEvent( "onMenuResponse", ::onMenuResponse );
}


onMenuResponse( menu, response )
{
	if( menu == "-1" && response == "ping" ) pingRightNow();
}


pingRightNow()
{
	self endon( "disconnect" );

    if( !isDefined(self.pinged) )
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

	/* TODO: Process entities
	if ( isDefined( trace["entity"] ) )
	{
		pinghud setTargetEnt( trace.entity );

		self iPrintLn(trace["entity"].targetname);
	}
	*/

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