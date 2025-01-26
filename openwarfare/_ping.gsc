#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    //preCacheShader("headicon_dead");
    preCacheShader("compass_ping");
	preCacheShader("waypoint_ping");
    

    //if( isDefined(level.on) )
	//	[[level.on]]( "menu_response", ::processMenuResponse );
	
	//else thread onPlayerConnect();
}

/*
onPlayerConnect()
{
    level endon("restarting");
	level endon("game_ended");
	while(true)
	{
		level waittill( "connected", player );
		player thread onPlayerMenuResponse();
	}
}

onPlayerMenuResponse()
{
	level endon("restarting");
	level endon("game_ended");
	self endon( "disconnect" );
	while(1)
	{
		self waittill( "menuresponse", menu, response );
		processMenuResponse( menu, response );
	}
}

//processMenuResponse( menu, response )
//{
//    if( response == "ping" )
//        self thread pingRightNow();
//}

*/

pingRightNow()
{
	self endon("disconnect");

    if( !isDefined(self.pinged) )
        self.pinged = false;

	if(!isAlive(self)||self.pinged)
		return;

	angles=self getPlayerAngles();
	eye=self getTagOrigin("j_head");
	forward=eye + vector_scale(anglesToForward(angles),4000);
	trace=bulletTrace(eye,forward,false,self);

	if(trace["fraction"]==1)
		return;

	pingloc=trace["position"]-vector_scale(anglesToForward(angles),50);
	self.pinged=true;
	self pingPlayer();
	
	self thread minimap(pingloc);

	/*
	origin = player.origin + level.aacpIconOffset;
	objWorld.name = "pointout_" + player getEntityNumber();
	objWorld.x = origin[0];
	objWorld.y = origin[1];
	objWorld.z = origin[2];
	objWorld.baseAlpha = 1.0;
	objWorld.isFlashing = false;
	objWorld.isShown = true;
	objWorld setShader( level.aacpIconShader, level.objPointSize, level.objPointSize );
	objWorld setWayPoint( true, level.aacpIconShader );
	objWorld setTargetEnt( player );
	objWorld thread maps\mp\gametypes\_objpoints::startFlashing();
	*/

	// Check if only one team should see this
	if ( level.teamBased ) {
		pinghud = newTeamHudElem(self.pers["team"]);		

		playSoundOnPlayers( "mp_ingame_summary", self.pers["team"] );
	} else {
		pinghud = newHudElem();	

		playSoundOnPlayers( "mp_ingame_summary" );	
	}

	pinghud.name = "waypoint_ping_" + self getEntityNumber();

	//pinghud=newTeamHudElem(self.pers["team"]);
	//pinghud setShader("waypoint_kill", level.objPointSize, level.objPointSize);
	pinghud setShader("waypoint_ping", level.objPointSize, level.objPointSize);
	//pinghud setwaypoint(true, "waypoint_kill");
	pinghud setwaypoint(true, "waypoint_ping");
	//pinghud setwaypoint(true, "headicon_dead");
	pinghud.x=pingloc[0];
    pinghud.y=pingloc[1];
    pinghud.z=pingloc[2]+10;	
    pinghud.baseAlpha = 0.9;
	//pinghud.color=(1,1,0);

	/*
	if ( isDefined( trace["entity"] ) )
	{
		pinghud setTargetEnt( trace.entity );

		self iPrintLn(trace["entity"].targetname);
	}
	*/

	a=0.8;
	pinghud.alpha=a;wait 0.05;
	pinghud.alpha=0;wait 0.05;
	pinghud.alpha=a;wait 0.05;
	pinghud.alpha=0;wait 0.05;
	pinghud.alpha=a;wait 2;
	pinghud fadeovertime(0.5);
	//pinghud scaleovertime(0.5, level.objPointSize * 2, level.objPointSize * 2);
	pinghud.alpha=0;
	wait 0.5;
	pinghud destroy();
	wait 0.3;
	self.pinged=false;
}

minimap(position)
{
	objCompass = maps\mp\gametypes\_gameobjects::getNextObjID();
	if ( objCompass != -1 ) 
	{
		objective_Add( objCompass, "active", position + ( 0, 0, 25 ) );
		objective_Icon( objCompass, "compass_ping" );

		// Check if only one team should see this
		if ( level.teamBased ) {
			objective_Team( objCompass, self.team );
		} else {
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
		//level.numGametypeReservedObjectives--;
	}
	//else level.numGametypeReservedObjectives--;
}