#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
    level.killcam_style = 0;
    level.fk = false;
    level.showFinalKillcam = false;

    level.doFK["axis"] = false;
    level.doFK["allies"] = false;
    
    level.slowmotstart = undefined;

    /////////////////////////////////////////////////////////////////////////////////
    //                                     HUD                                     //
    /////////////////////////////////////////////////////////////////////////////////

    game["strings"]["finalcam_pvp"] = &"OW_FINALCAM_PLAYER_VS_PLAYER";
    game["strings"]["finalcam_round"] = &"OW_FINALCAM_ROUND_WIN";
    game["strings"]["finalcam_match"] = &"OW_FINALCAM_MATCH_WIN";

    preCacheString( game["strings"]["finalcam_pvp"] );
    preCacheString( game["strings"]["finalcam_round"] );
    preCacheString( game["strings"]["finalcam_match"] );

    /////////////////////////////////////////////////////////////////////////////////

    for(;;)
    {
        level waittill("connected", player);

        player thread beginFK();
    }

    //self SetClientDvar( "ui_ShowMenuOnly", "" );    
}

SetKillcamStyle( style )
{
    level.killcam_style = style;
}
        
beginFK()
{
    self endon("disconnect");
    
    for(;;)
    {
        self waittill("beginFK", winner);
        
        self notify ( "reset_outcome" );
        
        if(level.TeamBased)
        {
            self finalkillcam(
                level.KillInfo[winner]["attacker"], 
                level.KillInfo[winner]["attackerNumber"], 
                level.KillInfo[winner]["deathTime"], 
                level.KillInfo[winner]["victim"], 
                level.KillInfo[winner]["weapon"],
                level.KillInfo[winner]["killcamentity"]);
        }
        else
        {
            self finalkillcam(
                winner.KillInfo["attacker"], 
                winner.KillInfo["attackerNumber"], 
                winner.KillInfo["deathTime"], 
                winner.KillInfo["victim"], 
                winner.KillInfo["weapon"], 
                winner.KillInfo["killcamentity"]);
        }
    }
}

finalkillcam( attacker, attackerNum, deathtime, victim, weapon, killcamentity)
{
    self endon("disconnect");
    level endon("end_killcam");
    
    //self SetClientDvar("ui_ShowMenuOnly", "none");

    camdist = 40;
    camtime = 5;

    if (weapon == "artillery_mp")
    {
        camtime = 1.3;
        camdist = 60;
    }

    else if (weapon == "airstrike_mp")
    {
        camtime = 1.3;
        camdist = 128;
    }

    else if (weapon == "claymore_mp")
    {
        camtime = 3.0;
        camdist = 100;
    }

    else if (weapon == "frag_grenade_mp")
    {
        camtime = 4.0; // show long enough to see grenade thrown
        camdist = 160;
    }

    predelay = getTime()/1000 - deathTime;
    postdelay = 3;
    killcamlength = camtime + postdelay;
    killcamoffset = camtime + predelay;
    

    visionSetNaked( getdvar("mapname") );
    
    self notify ( "begin_killcam", getTime() );
    
    self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
    
    self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.killcamentity = killcamentity;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = 0;
    
    if(!isDefined(level.slowmostart))
        level.slowmostart = killcamlength - 4;

    wait 0.05;

    if ( self.archivetime <= predelay ) // if we're not looking back in time far enough to even see the death, cancel
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;

    	self thread EndFK();

		return;
	}
    
    self.killcam = true;

    self setClientDvar ("cg_airstrikeKillCamDist", camdist );
    
    if( !isDefined( self.fk_title ) )
    {
        self CreateFKHUD( victim, attacker );
    }
    else
    {
        self.fk_title.alpha = 1;
        self.fk_title_low.alpha = 1;
    }
    
    self thread WaitEnd( killcamlength );
    
    wait 0.05;
    
    self waittill( "end_killcam" );

    self thread CleanFK();
    self thread EndFK();
}

EndFK()
{
    self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
    
    wait 0.05;
    
    self.sessionstate = "spectator";
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	assert( spawnpoints.size );
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	self spawn(spawnpoint.origin, spawnpoint.angles);

    wait 0.05;
    
    self.killcam = undefined;
    self thread maps\mp\gametypes\_spectating::setSpectatePermissions();

    level notify("end_killcam");

    level.fk = false;  
}

CleanFK()
{
    self.fk_title.alpha = 0;
    self.fk_title_low.alpha = 0;

    //if( isDefined( self.fk_title ) ) self.fk_title destroy(); 
    //if( isDefined( self.fk_title_low ) ) self.fk_title_low destroy(); 
    
    visionSetNaked( "mpOutro", 1.0 );
}

WaitEnd( killcamlength )
{
    self endon("disconnect");
	self endon("end_killcam");
    
    wait killcamlength;
    
    self notify("end_killcam");
}

CreateFKHUD( victim, attacker )
{
    self.fk_title = newClientHudElem(self);
    self.fk_title.archived = false;
    self.fk_title.y = 60;
    self.fk_title.alignX = "center";
    self.fk_title.alignY = "middle";
    self.fk_title.horzAlign = "center";
    self.fk_title.vertAlign = "top";
    self.fk_title.sort = 1; // force to draw after the bars
    self.fk_title.font = "objective";
    self.fk_title.fontscale = 1.75;
    self.fk_title.foreground = true;
    self.fk_title.shadown = 1;
    
    self.fk_title_low = newClientHudElem(self);
    self.fk_title_low.archived = false;
    self.fk_title_low.x = 0;
    self.fk_title_low.y = 80;
    self.fk_title_low.alignX = "center";
    self.fk_title_low.alignY = "top";
    self.fk_title_low.horzAlign = "center_safearea";
    self.fk_title_low.vertAlign = "top";
    self.fk_title_low.sort = 1; // force to draw after the bars
    self.fk_title_low.font = "objective";
    self.fk_title_low.fontscale = 1.4;
    self.fk_title_low.foreground = true;
    
    self.fk_title.alpha = 1;
    self.fk_title_low.alpha = 1;

    self.fk_title_low setText( game["strings"]["finalcam_pvp"], attacker.name, victim.name );
    
    if( !level.killcam_style )
        self.fk_title setText( game["strings"]["finalcam_match"] );
    else
        self.fk_title setText( game["strings"]["finalcam_round"] );
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, killcamentity )
{
    if( attacker != self && isDefined( attacker ) && isDefined( attacker.team ) )
    {    
        level.showFinalKillcam = true;
        
        team = attacker.team;
        
        level.doFK[team] = true;
        
        if(level.teamBased)
        {
            level.KillInfo[team]["attacker"] = attacker;
            level.KillInfo[team]["attackerNumber"] = attacker getEntityNumber();
            level.KillInfo[team]["victim"] = self;
            level.KillInfo[team]["deathTime"] = GetTime()/1000;
            level.KillInfo[team]["weapon"] = sWeapon;
            level.KillInfo[team]["killcamentity"] = killcamentity;
        }
        else
        {
            attacker.KillInfo["attacker"] = attacker;
            attacker.KillInfo["attackerNumber"] = attacker getEntityNumber();
            attacker.KillInfo["victim"] = self;
            attacker.KillInfo["deathTime"] = GetTime()/1000;
            attacker.KillInfo["weapon"] = sWeapon;
            attacker.KillInfo["killcamentity"] = killcamentity;
        }
    }
}


startFK( winner )
{
    level endon("end_killcam");
    
    if(!level.showFinalKillcam)
        return;
    
    if(!isPlayer(Winner) && !level.doFK[winner])
        return;
    
    level.fk = true;
    
    for( i = 0; i < level.players.size; i ++)
    {
        player = level.players[i];
        
        player notify("beginFK", winner);
    }
    
    slowMotion();
}

slowMotion()
{
    while(!isDefined(level.slowmostart))
        wait 0.05;
    
    wait level.slowmostart;
    
    SetDvar("timescale", ".25");
    for(i=0;i<level.players.size;i++)
        level.players[i] setclientdvar("timescale", ".25");
    
    wait 2;
    
    SetDvar("timescale", "1");
    for(i=0;i<level.players.size;i++)
        level.players[i] setclientdvar("timescale", "1");
}
