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
#include openwarfare\_utils;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  LOGIC                                                  //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


init() 
{
	level.scr_splashes_enabled = getDvarx( "scr_splashes_enabled", "int", 1, 0, 1 ) && getDvarx( "scr_enable_nightvision", "int", 1, 0, 1 );

	// If night vision system is disabled then there's nothing else to do here
	if ( level.scr_splashes_enabled == 0 )
		return;

	precacheShader("splashicon0");
	precacheShader("splashicon1");
	precacheShader("splashicon2");
	precacheShader("splashicon3");
	precacheShader("splashicon4");
	precacheShader("splashicon5");
	precacheShader("splashicon6");
	precacheShader("splashicon7");
	precacheShader("splashicon8");
	precacheShader("splashicon9");
	precacheShader("splashicon0");
	precacheShader("splashicon10");
	precacheShader("splashicon11");
	precacheShader("splashicon12");
	precacheShader("splashicon13");
	precacheShader("splashicon14");
	precacheShader("splashicon15");
	precacheShader("splashicon16");
	precacheShader("splashicon17");
	precacheShader("splashicon18");
	precacheShader("splashicon19");
	precacheShader("splashicon20");
	/*Reserved
	precacheShader("splashicon21");
	precacheShader("splashicon22");
	precacheShader("splashicon23");
	precacheShader("splashicon24");
	precacheShader("splashicon25");
	*/

	level.numKills = 0;

	level thread levelPlayerConnectionWatcher();
}


levelPlayerConnectionWatcher() 
{
	for (;;) 
	{
		level waittill( "connected", player );

		player.recentKillCount = 0;

		player.lastKilledPlayer = undefined;
		player.lastKilledBy = undefined;
		player.lastKillTime = undefined;
		
		player.pers["cur_death_streak"] = 0;
		
		player thread playerSpawningWatcher();
		player thread playerDamageWatcher();
		player thread playerKillWatcher();
	}
}


playerSpawningWatcher()
{
	self endon( "disconnect" );
	level endon( "game_ended" );

	for( ;; ) 
	{
		self waittill( "spawned" );

		self.firstDamagedTime = undefined;

		self.lastDamagedPoint = undefined;
		self.lastDamagedTime = undefined;
		self.lastDamagedBy = undefined;

		self.lastAttackedPlayer = undefined;
		self.lastAttackedTime = undefined;

		self.pers["cur_kill_streak"] = 0;
	}
}


playerKillWatcher()
{
	self endon( "disconnect" );
	level endon( "game_ended" );

	for( ;; ) 
	{
		self waittill( "player_killed", eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, fDistance );

		if( isDefined( attacker ) && isPlayer( attacker ) )
		{   
			attacker thread onPlayerKilled( self, sWeapon, sMeansOfDeath, iDamage, sHitLoc );   
		}
		
		if( sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_FALLING" || sMeansOfDeath == "MOD_TRIGGER_HURT" )
		{
			self thread onPlayerSuicide();
		}
	}
}


playerDamageWatcher()
{
	self endon( "disconnect" );
	level endon( "game_ended" );

	for( ;; )
	{
		self waittill( "damage_taken", eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );

		if ( isDefined( eAttacker ) && isplayer( eAttacker ) && eAttacker != self ) 
		{
			if ( !isDefined( self.firstDamagedTime ) ) 
			{
				self.firstDamagedTime = getTime();
			}

			self.lastDamagedTime = getTime();
			self.lastDamagedPoint = vPoint;
			self.lastDamagedBy = eAttacker;

			eAttacker.lastAttackedPlayer = self;
			eAttacker.lastAttackedTime = getTime();
		}
	}
}


onPlayerKilled( victim, weapon, meansOfDeath, damage, hitloc ) 
{
	curTime = getTime();
	attacker = self;

	if( attacker == victim )
		return;

	victim.lastKilledBy = attacker;
	
	attacker.lastKillTime = curTime;
	attacker.lastKilledPlayer = victim;

	level.numKills++;


	if( !isAlive( attacker ) )
		return;


	attacker thread playerMultikillWatcher();
	
	
	if( isDefined( attacker.pers["cur_death_streak"] ) && attacker.pers["cur_death_streak"] >= 3 )
	{
		attacker thread splashNotifyDelayed( "comeback" );
	}

	attacker.pers["cur_death_streak"] = 0;
	attacker.pers["cur_kill_streak"] ++;


	if( isDefined( victim.pers["cur_kill_streak"] ) && victim.pers["cur_kill_streak"] >= 3 )
	{
		attacker thread splashNotifyDelayed( "buzzkill" );
	}

	victim.pers["cur_death_streak"] ++;
	victim.pers["cur_kill_streak"] = 0;


	if( isDefined( victim.firstDamagedTime ) && victim.firstDamagedTime == curTime && ( meansOfDeath == "MOD_RIFLE_BULLET" || meansOfDeath == "MOD_PISTOL_BULLET" ) )
	{
		attacker thread splashNotifyDelayed( "oneshot" );
	}


	if( isDefined( victim.lastDamagedTime ) && victim.lastDamagedTime == curTime && ( meansOfDeath == "MOD_RIFLE_BULLET" || meansOfDeath == "MOD_PISTOL_BULLET" || meansOfDeath == "MOD_HEAD_SHOT" ) &&
		isWallBang ( attacker, victim, victim.lastDamagedPoint ) )
	{	
		attacker thread splashNotifyDelayed( "puncture" );
	}


	if( meansOfDeath == "MOD_HEAD_SHOT" )
	{
		attacker thread splashNotifyDelayed( "headshot" );
	}


	if( level.numKills == 1 )
	{
		attacker thread splashNotifyDelayed( "firstblood" );
	}


	/*
	if (isAlive(self) && self.deathtime + 800 < getTime())
		self postDeathKill();
	*/
	

	if( attacker.health < 10 )
	{
		attacker thread splashNotifyDelayed( "neardeath" );
	}


	if( level.teamBased && isDefined( victim.lastKilledPlayer ) && victim.lastKilledPlayer != attacker && ( curTime - victim.lastKillTime ) < 10000 )
	{
		attacker thread splashNotifyDelayed( "avenger" );
	}


	if( level.teamBased && isDefined( victim.lastAttackedPlayer ) && isAlive( victim.lastAttackedPlayer ) && victim.lastAttackedPlayer != attacker && ( curTime - victim.lastAttackedTime ) < 5000 )
	{ 
		attacker thread splashNotifyDelayed( "defender" );
	}


	if( isdefined( attacker.lastKilledBy ) && attacker.lastKilledBy == victim )// && level.players.size > 2)
	{
		attacker.lastKilledBy = undefined;
		attacker thread splashNotifyDelayed( "revenge" );
	}


	if( isDefined( victim.attackerPosition ) )
		attackerPosition = victim.attackerPosition;
	else
		attackerPosition = attacker.origin;

	killDistance = distance( attackerPosition, victim.origin ) * 0.0254; // inches to meters

	if( meansOfDeath == "MOD_RIFLE_BULLET" || meansOfDeath == "MOD_PISTOL_BULLET" || meansOfDeath == "MOD_HEAD_SHOT" )
	{
		if( killDistance > 80 )
			attacker thread splashNotifyDelayed( "longshot" );

		if( killDistance < 2 )
			attacker thread splashNotifyDelayed( "pointblank" );
	}


	if( isDefined( attacker.pers["cur_kill_streak"] ) )
	{
		switch ( attacker.pers["cur_kill_streak"] )
		{
			case 3:
				attacker thread splashNotifyDelayed( "slayer" );
				break;
			case 5:
				attacker thread splashNotifyDelayed( "bloodthirsty" );
				break;
			case 10:
				attacker thread splashNotifyDelayed( "merciless" );
				break;
			default:
				//nothing
				break;
		}
	}
}


onPlayerSuicide() 
{
	if( isDefined( self.lastDamagedTime ) && isPlayer( self.lastDamagedBy ) && isAlive( self.lastDamagedBy ) && ( getTime() - self.lastDamagedTime ) < 10000 )
	{
		self.lastDamagedBy thread splashNotifyDelayed("assistedsuicide");
	}
}


playerMultikillWatcher()
{
	self endon( "disconnect" );
	level endon( "game_ended" );

	self notify( "updateRecentKills" );
	self endon( "updateRecentKills" );

	self.recentKillCount ++;

	wait( 1.5 );

	if( self.recentKillCount > 1 )
	{
		self onPlayerMultikill( self.recentKillCount );
	}
		
	self.recentKillCount = 0;
}


onPlayerMultikill( killCount ) 
{
	assert( killCount > 1 );

	switch( killCount ) 
	{
		case 2:
			self thread splashNotifyDelayed("doublekill");
			break;
		case 3:
			self thread splashNotifyDelayed("triplekill");
			break;
		case 4:
			self thread splashNotifyDelayed("quadrokill");
			break;
		/*
		case 5:
			self thread splashNotifyDelayed("megakill");
			break;
		case 6:
			self thread splashNotifyDelayed("ultrakill");
			break;
		case 7:
			self thread splashNotifyDelayed("monsterkill");
			break;
		*/
		default:
			self thread splashNotifyDelayed("multikill");
			break;
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                UTILITIES                                                //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


isWallBang( attacker, victim, hitPoint )
{
    return !SightTracePassed( attacker getEye(), hitPoint, false, attacker );
    //return !bulletTracePassed( attacker getEye(), hitPoint, false, attacker );
}


splashNotifyDelayed( splash )
{
	actionData = spawnStruct();

	actionData.name = splash;
	actionData.sound = getSplashSound( splash );
	actionData.duration = 2.0;

	//self thread underScorePopup( getSplashTitle( splash ), ( 1,1,.2 ) ); // OPTIONAL
	self thread splashNotify( actionData );
}


getSplashTitle( splash )
{
	return tableLookupIString( "mp/splashtable.csv", 1, splash, 2 );
}


getSplashDescription( splash )
{
	return tableLookupIString( "mp/splashtable.csv", 1, splash, 3 );
}


getSplashMaterial( splash )
{
	return tableLookup( "mp/splashtable.csv", 1, splash, 4 );
}


getSplashSound( splash )
{
	return tableLookup( "mp/splashtable.csv", 1, splash, 10 );
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                   HUD                                                   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


splashNotify( splash )
{
	self endon( "disconnect" );

	wait 0.05;

	if( level.gameEnded )
		return;

	if( tableLookup( "mp/splashtable.csv", 1, splash.name, 0 ) != "")
	{
		if( isDefined( self.splashinprogress ) && self.splashinprogress )
		{
			if ( !isdefined( self.splashwaitcount ) )
			{
				self.splashwaitcount = .4;
			}
			else
			{
				self.splashwaitcount += .4;
			}
			wait self.splashwaitcount;
			
			self notify( "splashwaitting" );
			self.splashwaitcount -= .4;
		}

		self.splashinprogress = true;

		if ( isDefined( splash.sound ) )
		{
			self playlocalsound( splash.sound );
		}

		splashNotify[0] = addTextHud( self, 0, -120, 0, "center", "middle", 1.4 );
		splashNotify[0].font = "default";
		splashNotify[0].horzAlign = "center";
		splashNotify[0].vertAlign = "middle";
		splashNotify[0] setText( getSplashTitle( splash.name ) );
		splashNotify[0].glowcolor = ( 0.15, 1.0, 0.15 );
		splashNotify[0].glowalpha = 0.5;//getSplashColorRGBA(splash.name,8);
		splashNotify[0].sort = 1001;
		//splashNotify[0] maps\mp\gametypes\_hud::fontPulseInit();
		splashNotify[0].hideWhenInMenu = true;
		splashNotify[0].archived = false;

		splashNotify[1] = addTextHud( self, 0, -160, 0, "center", "middle", 1.4 );
		splashNotify[1].horzAlign = "center";
		splashNotify[1].vertAlign = "middle";
		splashNotify[1] setshader( getSplashMaterial( splash.name ), 120, 120 );//getSplashDescription(splash.name)
		splashNotify[1].sort = 1002;
		//splashNotify[1] maps\mp\gametypes\_hud::fontPulseInit();
		splashNotify[1].hideWhenInMenu = true;
		splashNotify[1].archived = false;

		splashNotify[0] thread moveAsideSplash( self );
		splashNotify[1] thread moveAsideSplash( self, true );

		for ( i = 0; i < splashNotify.size; i++)
		{
			splashNotify[i] fadeOverTime(0.15);
			splashNotify[i].alpha = 1.0;
		}

		//	splashNotify[0] thread maps\mp\gametypes\_hud::fontPulse( self );
		//	splashNotify[1] thread maps\mp\gametypes\_hud::fontPulse( self );
		splashNotify[1] scaleovertime(.1, 70, 70);


		wait(splash.duration - 0.05);

		for ( i = 0; i < splashNotify.size ; i++)
		{
			splashNotify[i] fadeOverTime(0.15);
			splashNotify[i].alpha = 0;
		}

		splashNotify[0] scaleOverTime(0.15, 480, 480);


		wait 0.1;
		self destroySplash( splashNotify );
		wait 0.05;
		self.splashinprogress = false;
	}
}


destroySplash( splashNotify )
{
	if( !isDefined( splashNotify ) || !splashNotify.size )
		return;

	for( i = 0; i < splashNotify.size; i++ )
	{
		splashNotify[i] destroy();
	}

	splashNotify = [];
}


fontPulse( player )
{
	self notify( "fontPulse" );
	self endon( "fontPulse" );

	player endon( "disconnect" );
	player endon( "joined_team" );
	player endon( "joined_spectators" );
	
	scaleRange = self.maxFontScale - self.baseFontScale;
	while( self.fontScale < self.maxFontScale )
	{
		self.fontScale = min( self.maxFontScale, self.fontScale + ( scaleRange / self.inFrames ) );
		wait 0.05;
	}

	while( self.fontScale > self.baseFontScale )
	{
		self.fontScale = max( self.baseFontScale, self.fontScale - ( scaleRange / self.outFrames ) );
		wait 0.05;
	}
}


addTextHud( owner, x, y, alpha, alignX, alignY, fontScale)
{
	if( isPlayer(owner) )
		hud = newClientHudElem( owner );
	else
		hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.alignX = alignX;
	hud.alignY = alignY;
	hud.fontScale = fontScale;

	return hud;
}


moveAsideSplash( player, doScale )
{
	player endon( "disconnect" );

	while( isdefined( self ) )
	{
		if ( !isdefined(player) )
			return;

		player waittill( "splashwaitting" );

		if ( isdefined( self ) ) 
		{
			self moveovertime( 0.2 );
			self.x = self.x + 100;

			if ( isDefined ( doScale ) && doScale )
			{
				self scaleovertime( 0.2, 50, 50 );
			}

			if ( self.x > 300 )
			{
				self fadeovertime( 0.2 );
				self.alpha = 0;
			}
		}
	}
}


underScorePopup( string, hudColor, glowAlpha )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	while( isDefined( self.underScoreInProgress ) && self.underScoreInProgress )
		wait 0.05;

	self.underScoreInProgress = true;

	if( !isDefined( hudColor ) )
		hudColor = (1, 1, 1);

	if( !isDefined( glowAlpha ) )
		glowAlpha = 0;

	if( !isDefined( self._scorePopup ) )
	{
		self._scorePopup = newClientHudElem( self );
		self._scorePopup.horzAlign = "center";
		self._scorePopup.vertAlign = "middle";
		self._scorePopup.alignX = "left";
		self._scorePopup.alignY = "middle";
		self._scorePopup.y = -30;
		self._scorePopup.font = "objective";
		self._scorePopup.fontscale = 1.4;
		self._scorePopup.archived = false;
		self._scorePopup.hideWhenInMenu = true;
		self._scorePopup.sort = 9999;
	}

	self._scorePopup.x = -50;
	self._scorePopup.alpha = 0;
	self._scorePopup.color = hudColor;
	self._scorePopup.glowColor = hudColor;
	self._scorePopup.glowAlpha = glowAlpha;
	self._scorePopup setText(string);
	self._scorePopup fadeOverTime( 0.5 );
	self._scorePopup.alpha = 1;
	self._scorePopup moveOverTime( 0.75 );
	self._scorePopup.x = 35;

	wait 1.5;
	self._scorePopup fadeOverTime( 0.75 );
	self._scorePopup.alpha = 0;

	wait 0.2;
	self.underScoreInProgress = false;
}