#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;


init()
{
    level.finalKillcamInProgress = false;
    level.finalKillcamInfo = [];
}


onPlayerKilled( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, killcamentity, iAttackerNum )
{
    switch( sMeansOfDeath )
    {
        //Don't record explosions witn none weapons
        case "MOD_EXPLOSIVE":
            if( sWeapon == "none" )
                return;

            break;

        //Override killcam entity (like a burrel)
        /*case "MOD_CRUSH":
            if( isDefined( eInflictor ) )
                killcamentity = eInflictor getEntityNumber();

            break;*/

        //Override attacker for suicides
        case "MOD_SUICIDE":
        case "MOD_FALLING":
        case "MOD_TRIGGER_HURT":
            eAttacker = self;

            break;
    }

    if( ! isDefined( eAttacker ) )
    {
        return;
    }

    attackerNum = eAttacker getEntityNumber();

    if( ! isPlayer( eAttacker ) && iAttackerNum > 0 )
    {
        attackerNum = iAttackerNum;
    }

    if( isDefined( eAttacker.team ) && isDefined ( level.otherTeam[eAttacker.team] ) )
    {    
        if( level.teamBased && level.gametype != "bel" )
        {
            killerId = eAttacker.team;

            //Hack to show player suicide. switch team for displaying self kill 
            if ( eAttacker == self ) killerId = level.otherTeam[eAttacker.team];
        }
        else
        {
            killerId = "player";
        }

        level.finalKillcamInfo[killerId]["attacker"] = eAttacker;
        level.finalKillcamInfo[killerId]["attackerNumber"] = attackerNum;
        level.finalKillcamInfo[killerId]["victim"] = self;
        level.finalKillcamInfo[killerId]["deathTime"] = GetTime()/1000;
        level.finalKillcamInfo[killerId]["weapon"] = sWeapon;
        level.finalKillcamInfo[killerId]["killcamentity"] = killcamentity;
    }
}


startFinalKillcam( winner, mode )
{
    level endon("end_killcam");
    
    finalKillcamInfo = undefined;

    if( level.teamBased && level.gametype != "bel" )
    {
        finalKillcamInfo = level.finalKillcamInfo[winner];
    }
    else if( isPlayer( winner ) )
    {
        finalKillcamInfo = level.finalKillcamInfo["player"];
    }

    if( ! isDefined( finalKillcamInfo ) )
    {
        return;
    }
    
    switch( finalKillcamInfo["weapon"] )
    {
        case "artillery_mp":
            viewDuratation = 3;
            viewEntityDist = 60;
            break;

        case "airstrike_mp":
            viewDuratation = 3;
            viewEntityDist = 60;
            break;

        case "claymore_mp":
            viewDuratation = 3.0;
            viewEntityDist = 20;
            break;

        case "frag_grenade_mp":
            viewDuratation = 4.0; // show long enough to see grenade thrown
            viewEntityDist = 60;
            break;

        default:
            viewDuratation = 5;
            viewEntityDist = 40;
    }

    startDelay = getTime()/1000 - finalKillcamInfo["deathTime"];
    finalDelay = 1;
    timeLength = viewDuratation + finalDelay;
    timeOffset = viewDuratation + startDelay;

    //if we're not looking back in time far enough to even see the death, cancel
    if( timeOffset <= startDelay )
    {
        return;
    }
    
    level.finalKillcamInProgress = true;
    level notify("begin_killcam");

    visionSetNaked( maps\mp\gametypes\_globallogic::GetNakedVision(), 0.5 );

    for( i = 0; i < level.players.size; i++ )
    {
        player = level.players[i];

        player setClientDvar ("cg_airstrikeKillCamDist", viewEntityDist );
        
        player thread playerFinalKillcamThread(
            finalKillcamInfo["attacker"], 
            finalKillcamInfo["attackerNumber"], 
            finalKillcamInfo["deathTime"], 
            finalKillcamInfo["victim"], 
            finalKillcamInfo["weapon"],
            finalKillcamInfo["killcamentity"],
            timeOffset,
            timeLength,
            mode);
    }

    wait timeLength;

    visionSetNaked( "mpOutro", 0.2 );
    wait 0.2;

    level.finalKillcamInProgress = false;
    level notify("end_killcam");
}


playerFinalKillcamThread( attacker, attackerNum, deathtime, victim, weapon, viewEntity, timeOffset, timeLength, mode )
{
    level endon("end_killcam");
    self endon("disconnect");

    self notify( "reset_outcome" );

    wait 0.05;
    self notify ( "begin_killcam", getTime() );
    
    self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
    
    self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.killcamEntity = viewEntity;
	self.archivetime = timeOffset;
	self.killcamlength = timeLength;
	self.psoffsettime = 0;

    self showFinalKillcamHUD( victim, attacker, mode );

    self.killcam = true;    
    
    wait timeLength;

    if ( ! isDefined( self ) )
        return;
    
    self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;

    self hideFinalKillcamHUD();

    self.killcam = undefined;

    wait 0.05;
    self notify("end_killcam");
}


showFinalKillcamHUD( victim, attacker, mode )
{
    if( ! isDefined( self.fk_title_low ) )
    {
        self.fk_title_low = createFontString( "default", 1.4 );
        self.fk_title_low setPoint( "CENTER", "BOTTOM", 0, -30 );
        self.fk_title_low.archived = false;
        self.fk_title_low.foreground = true;
    }

    self.fk_title_low.alpha = 1;

    if ( victim != attacker )
        self.fk_title_low setText( &"OW_FINALCAM_PLAYER_VS_PLAYER", attacker.name, victim.name );
    else
        self.fk_title_low setText( &"OW_FINALCAM_PLAYER_SUICIDE", victim.name );
    
    switch ( mode )
    {
        case "round":
            self setClientDvar ("ui_hud_killcam_title", "OW_FINALCAM_ROUND_WIN" );
            break;
        case "match":
            self setClientDvar ("ui_hud_killcam_title", "OW_FINALCAM_MATCH_WIN" );
            break;
    }
}


hideFinalKillcamHUD()
{
    self.fk_title_low.alpha = 0;
}