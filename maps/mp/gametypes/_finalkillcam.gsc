#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
    level.killcam_style = 0;
    level.fk = false;
    level.showFinalKillcam = false;
    level.waypoint = false;
    
    level.doFK["axis"] = false;
    level.doFK["allies"] = false;
    
    level.slowmotstart = undefined;
    
    OnPlayerConnect();

    self SetClientDvar( "ui_ShowMenuOnly", "" );
}

SetKillcamStyle( style )
{
    level.killcam_style = style;
}

OnPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread beginFK();
    }
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
            self finalkillcam(level.KillInfo[winner]["attacker"], level.KillInfo[winner]["attackerNumber"], level.KillInfo[winner]["deathTime"], level.KillInfo[winner]["victim"]);
        }
        else
        {
            self finalkillcam(winner.KillInfo["attacker"], winner.KillInfo["attackerNumber"], winner.KillInfo["deathTime"], winner.KillInfo["victim"]);
        }
    }
}

finalkillcam( attacker, attackerNum, deathtime, victim)
{
    self endon("disconnect");
    level endon("end_killcam");
    
    self SetClientDvar("ui_ShowMenuOnly", "none");

    camtime = 5;
    predelay = getTime()/1000 - deathTime;
    postdelay = 2;
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
	self.killcamentity = -1;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = 0;
    
    if(!isDefined(level.slowmostart))
        level.slowmostart = killcamlength - 3;


    wait 0.05;

    if ( self.archivetime <= predelay ) // if we're not looking back in time far enough to even see the death, cancel
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self SetClientDvar( "ui_ShowMenuOnly", "" );
		
		return;
	}
    
    self.killcam = true;

    
    if(!isDefined(self.top_fk_shader))
    {
        self CreateFKMenu(victim , attacker);
    }
    else
    {
        self.fk_title.alpha = 1;
        self.fk_title_low.alpha = 1;
        self.top_fk_shader.alpha = 0.5;
        self.bottom_fk_shader.alpha = 0.5;
        self.credits.alpha = 0;
    }
    
    self thread WaitEnd(killcamlength);
    
    wait 0.05;
    
    self waittill("end_killcam");
    
    self thread CleanFK();
    
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
    self.top_fk_shader.alpha = 0;
    self.bottom_fk_shader.alpha = 0;
    self.credits.alpha = 0;
    
    self SetClientDvar("ui_ShowMenuOnly", "");
    
    visionSetNaked( "mpOutro", 1.0 );
}

WaitEnd( killcamlength )
{
    self endon("disconnect");
	self endon("end_killcam");
    
    wait killcamlength;
    
    self notify("end_killcam");
}

CreateFKMenu( victim , attacker)
{
    self.top_fk_shader = newClientHudElem(self);
    self.top_fk_shader.elemType = "shader";
    self.top_fk_shader.archived = false;
    self.top_fk_shader.horzAlign = "fullscreen";
    self.top_fk_shader.vertAlign = "fullscreen";
    self.top_fk_shader.sort = 0;
    self.top_fk_shader.foreground = true;
    self.top_fk_shader.color	= (.15, .0, .0);
    self.top_fk_shader setShader("white",640,112);
    
    self.bottom_fk_shader = newClientHudElem(self);
    self.bottom_fk_shader.elemType = "shader";
    self.bottom_fk_shader.y = 368;
    self.bottom_fk_shader.archived = false;
    self.bottom_fk_shader.horzAlign = "fullscreen";
    self.bottom_fk_shader.vertAlign = "fullscreen";
    self.bottom_fk_shader.sort = 0; 
    self.bottom_fk_shader.foreground = true;
    self.bottom_fk_shader.color	= (.15, .0, .0);
    self.bottom_fk_shader setShader("white",640,112);
    
    self.fk_title = newClientHudElem(self);
    self.fk_title.archived = false;
    self.fk_title.y = 45;
    self.fk_title.alignX = "center";
    self.fk_title.alignY = "middle";
    self.fk_title.horzAlign = "center";
    self.fk_title.vertAlign = "top";
    self.fk_title.sort = 1; // force to draw after the bars
    self.fk_title.font = "objective";
    self.fk_title.fontscale = 3.5;
    self.fk_title.foreground = true;
    self.fk_title.shadown = 1;
    
    self.fk_title_low = newClientHudElem(self);
    self.fk_title_low.archived = false;
    self.fk_title_low.x = 0;
    self.fk_title_low.y = -85;
    self.fk_title_low.alignX = "center";
    self.fk_title_low.alignY = "bottom";
    self.fk_title_low.horzAlign = "center_safearea";
    self.fk_title_low.vertAlign = "bottom";
    self.fk_title_low.sort = 1; // force to draw after the bars
    self.fk_title_low.font = "objective";
    self.fk_title_low.fontscale = 1.4;
    self.fk_title_low.foreground = true;
    
    self.credits = newClientHudElem(self);
    self.credits.archived = false;
    self.credits.x = 0;
    self.credits.y = 0;
    self.credits.alignX = "left";
    self.credits.alignY = "bottom";
    self.credits.horzAlign = "left";
    self.credits.vertAlign = "bottom";
    self.credits.sort = 1; // force to draw after the bars
    self.credits.font = "default";
    self.credits.fontscale = 1.4;
    self.credits.foreground = true;
        
    self.fk_title.alpha = 1;
    self.fk_title_low.alpha = 1;
    self.top_fk_shader.alpha = 0.5;
    self.bottom_fk_shader.alpha = 0.5;
    self.credits.alpha = 0;
    
    self.credits setText("^1Created by: ^2FzBr.^3d4rk");
    self.fk_title_low setText(attacker.name + " kills " + victim.name);
    
    if( !level.killcam_style )
        self.fk_title setText("GAME WINNER KILL");
    else
        self.fk_title setText("ROUND WINNER KILL");
}

onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
    if(attacker != self && isDefined(attacker) && isDefined(attacker.team))
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
        }
        else
        {
            attacker.KillInfo["attacker"] = attacker;
            attacker.KillInfo["attackerNumber"] = attacker getEntityNumber();
            attacker.KillInfo["victim"] = self;
            attacker.KillInfo["deathTime"] = GetTime()/1000;
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
    
    SetDvar("timescale", ".2");
    for(i=0;i<level.players.size;i++)
        level.players[i] setclientdvar("timescale", ".3");
    
    wait 1.7;
    
    SetDvar("timescale", "1");
    for(i=0;i<level.players.size;i++)
        level.players[i] setclientdvar("timescale", "1");
}
