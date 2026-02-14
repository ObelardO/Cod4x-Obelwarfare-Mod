//******************************************************************************
//  _____                  _    _             __
// |  _  |                | |  | |           / _|
// | | | |_ __   ___ _ __ | |  | | __ _ _ __| |_ __ _ _ __ ___
// | | | | '_ \ / _ \ '_ \| |/\| |/ _` | '__|  _/ _` | '__/ _ \
// \ \_/ / |_) |  __/ | | \  /\  / (_| | |  | || (_| | | |  __/
//  \___/| .__/ \___|_| |_|\/  \/ \__,_|_|  |_| \__,_|_|  \___|
//       | |               We don't make the game you play.
//       |_|                 We make the game you play BETTER.
//
//            Website: http://openwarfaremod.com/
//******************************************************************************

/*
###########################################
## Quick Health System's Function Finder ##
###########################################

Description: 
This is the health system module. It combines
the old _bleeding.gsc, _healthbar.gsc, 
_healthoverlay.gsc, and _healthpacks.gsc scripts.
As well there is a new medic script which allows
players to bandage and/or heal their teammates.

Copy one of the following 6 character codes 
and type ctrl-f then paste it into the text box 
and hit find.

-Codes-
1QHSFF - Health Bar Functions
2QHSFF - Health Overlay Functions
3QHSFF - Health Pack Functions
4QHSFF - Bleeding/Bandaging/Medic Functions 
5QHSFF - Helper Functions

##########################################
*/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{  
  //=======
  //Health System Enabling Dvars
  //=======
  level.scr_healthsystem_bleeding_enable = getdvarx( "scr_healthsystem_bleeding_enable", "float", 0, 0, 15 );
  level.scr_healthsystem_medic_enable = getdvarx( "scr_healthsystem_medic_enable", "int", 0, 0, 1 );
  level.scr_healthsystem_healthpacks_enable = getdvarx( "scr_healthsystem_healthpacks_enable", "int", 0, 0, 2 );
  
  //=======
  //Bandage Specific Dvars
  //=======
  level.scr_healthsystem_bandage_self = getdvarx( "scr_healthsystem_bandage_self", "int", 1, 0, 1 );
  level.scr_healthsystem_bandage_start = getdvarx( "scr_healthsystem_bandage_start", "int", 3, 1, 5 );
  level.scr_healthsystem_bandage_max = getdvarx( "scr_healthsystem_bandage_max", "int", 5, 1, 5 );
  level.scr_healthsystem_bandage_time = getdvarx( "scr_healthsystem_bandage_time", "int", 3, 2, 10 );
  level.scr_healthsystem_bleeding_start_percentage = getdvarx( "scr_healthsystem_bleeding_start_percentage", "int", 0, 0, 99 );

  //=======
  //Medic Specific Dvars
  //=======      
  level.scr_healthsystem_medic_healing = getdvarx( "scr_healthsystem_medic_healing", "int", 1, 0, 1 );
  level.scr_healthsystem_medic_bandaging = getdvarx( "scr_healthsystem_medic_bandaging", "int", 1, 0, 1 );
  level.scr_healthsystem_medic_healing_self = getdvarx( "scr_healthsystem_medic_healing_self", "int", 1, 0, 1 );
  level.scr_healthsystem_medic_healing_time = getdvarx( "scr_healthsystem_medic_healing_time", "int", 3, 2, 10 );
  level.scr_healthsystem_medic_healing_health = getdvarx( "scr_healthsystem_medic_healing_health", "int", 25, 1, getDvarInt( "scr_player_maxhealth" ) );
  level.scr_healthsystem_medic_clear_damage_effects = getdvarx( "scr_healthsystem_medic_clear_damage_effects", "int", 0, 0, 1 );
  level.scr_healthsystem_medic_take_bandage = getdvarx( "scr_healthsystem_medic_take_bandage", "int", 0, 0, 1 );
    
  //=======
  // Health Pack Specific Dvars
  //=======
  level.scr_healthsystem_healthpacks_health = getdvarx( "scr_healthsystem_healthpacks_health", "int", 25, 1, getDvarInt( "scr_player_maxhealth" ) );
  level.scr_healthsystem_healthpacks_random_health = getdvarx( "scr_healthsystem_healthpacks_random_health", "int", 0, 0, 1 );
  level.scr_healthsystem_healthpacks_timeout = getdvarx( "scr_healthsystem_healthpacks_timeout", "float", 60, 30, 300 );
    
  //=======
  // Health System Icons
  //=======
  level.scr_healthsystem_bleeding_icon = getdvarx( "scr_healthsystem_bleeding_icon", "int", 1, 0, 1 );
  level.scr_healthsystem_healing_icon = getdvarx( "scr_healthsystem_healing_icon", "int", 1, 0, 1 );
    
  //=======
  // Health System Misc.
  //=======  
  //Health bar
  level.scr_healthsystem_show_healthbar = getdvarx( "scr_healthsystem_show_healthbar", "int", 0, 0, 1 );
  
  //=======
  // PreCache Items
  //=======
  precacheShader("overlay_low_health");
  precacheShader( "bandaging" );
  precacheShader( "bleeding" );
  
  precacheModel( "weapon_bf3_medicbag" );
  //precacheModel( "weapon_bf3_medicbag" );

  preCacheString( &"OW_STATUS_BLEEDING" );
  preCacheString( &"OW_STATUS_HEALING" );
  preCacheString( &"OW_STATUS_BANDAGE" );
  preCacheString( &"OW_MEDIC_HINT_HEAL" );
  preCacheString( &"OW_MEDIC_HINT_BANDAGE" );

  level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

//Have to do this if we want one health system module.
//The check for which health regen system comes before 
//the globalinit call and this is the easiest way
//without changing around the code too much
init_healthOverlay()
{
  precacheShader("overlay_low_health");
  
  //Health Overlay
  level.healthOverlayCutoff = 0.55; // getting the dvar value directly doesn't work right because it's a client dvar getdvarfloat("hud_healthoverlay_pulseStart");
  level.playerHealthRegenDelay = level.scr_player_healthregentime;
  level.healthRegenCycle = 0.1;
  level.healthRegenDisabled = ( level.scr_healthregen_method == 0 );
}
  
onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );
	self thread addNewEvent( "onJoinedSpectators", ::onJoinedSpectators );   
}

onPlayerSpawned()
{
	//Show Healthbar if enabled
	if ( level.scr_healthsystem_show_healthbar )
			self setClientDvar( "cg_drawhealth", 1 );
			
	//If stock health regen is on then we are done.
	if ( level.scr_healthregen_method == 1 )
		return;
	else if ( level.scr_healthregen_method == 2 )
		self thread playerHealthRegen();
	
	if ( level.scr_healthsystem_bleeding_enable > 0 )
	{		
		self.isBleeding = false;
		self.bleedingRate = 0;
		self.bleedOut = false;
		self.bleedingParams = spawnstruct();
		self thread onPlayerDamaged();
	}
	
	if ( ( level.scr_healthsystem_bleeding_enable > 0 && level.scr_healthsystem_bandage_self  ) || level.scr_healthsystem_medic_enable )
	{
		self.isBandaging = false;
		self.totalBandages = level.scr_healthsystem_bandage_start;
	} else {
		self.totalBandages = 0;
	}
  
	if ( level.scr_healthsystem_medic_enable )
	{
		self.isUsingTeammateBandage = false;

		if ( level.scr_healthsystem_bleeding_enable > 0 )
			self.isBandagingTeammate = false;
		if ( level.scr_healthsystem_medic_healing )
			self.isHealingTeammate = false;
		if ( level.scr_healthsystem_medic_healing_self )
			self.isHealing = false;
	}   
      
	if ( ( level.scr_healthsystem_healing_icon || level.scr_healthsystem_bleeding_icon ) ) 
	{
		if( !isDefined( self.hud_healthsystem_icon ) )
		{
			self.hud_healthsystem_icon = createIcon( "bleeding", 32, 32 );
			self.hud_healthsystem_icon setPoint( "BOTTOM RIGHT", undefined, -14, -133 );
			self.hud_healthsystem_icon.alpha = 0;
			self.hud_healthsystem_icon.archived = true;
			self.hud_healthsystem_icon.hideWhenInMenu = true;
		}

		if( !isDefined( self.hud_healthsystem_text ) )
		{
			self.hud_healthsystem_text = createFontString( "default", 1.4 );
			self.hud_healthsystem_text setParent( self.hud_healthsystem_icon );
			self.hud_healthsystem_text setPoint( "RIGHT", "LEFT", -5, 0 );
			self.hud_healthsystem_text.alpha = 0;
			self.hud_healthsystem_text.archived = false;
			self.hud_healthsystem_text.foreground = true;
		}
	}
  
	if ( level.scr_healthsystem_bandage_self || level.scr_healthsystem_medic_enable || level.scr_healthsystem_healthpacks_enable )
	{
		if ( ( !level.scr_healthsystem_bleeding_enable || !level.scr_healthsystem_bandage_self ) && !level.scr_healthsystem_medic_enable )
			self setClientDvars( "ui_bandages", "0", "ui_bandages_qty", "0" );		
		else
			self setClientDvars( "ui_bandages", "1", "ui_bandages_qty", level.scr_healthsystem_bandage_start ); 
	}
	else
		self setClientDvar( "ui_bandages", "0" );     

	if ( level.scr_healthsystem_medic_enable && ( level.scr_healthsystem_medic_healing || level.scr_healthsystem_medic_bandaging ) )
		self thread medicHintThread();
}

onPlayerDeath()
{
	if ( level.scr_healthsystem_healthpacks_enable )
		self thread dropHealthPack();
		
	if ( level.scr_healthsystem_bleeding_enable > 0 )
		self.bleedingParams = undefined;
	
	if ( isDefined( self.hud_healthsystem_icon ) )
		self.hud_healthsystem_icon destroy();

	if ( isDefined( self.hud_healthsystem_text ) )
		self.hud_healthsystem_text destroy();
	
	//if (level.scr_healthsystem_show_healthbar )
		//self setClientdvar( "cg_drawhealth", 0 );

	//self setClientDvar( "ui_bandages", "0" );
	
	self maps\mp\gametypes\_hud_hints::hideHint( "HS_MED" );     
}

onJoinedSpectators()
{
	self notify("end_healthregen");
	
	//if ( level.scr_healthsystem_show_healthbar )
		//self setClientdvar( "cg_drawhealth", 0 );

	//self setClientDvar( "ui_bandages", "0" );     

	self maps\mp\gametypes\_hud_hints::hideHint( "HS_MED" );
}

/*
#######################################
## 2QHSFF - Health Overlay Functions ##
#######################################
*/

//OW's health regen - scr_player_healthregen "2"
playerHealthRegen()
{
	self endon("disconnect");
	self endon("death");
	self endon("end_healthregen");
	level endon( "game_ended" );

	if ( self.health <= 0 )
	{
		assert( !isalive( self ) );
		return;
	}

	oldHealth = self.maxhealth;
	player = self;

	// Initialize some internal variables
	veryHurt = false;
	newHealth = 0;
	healthRegenUnitPerCycle = 0;

	for (;;)
	{
		// Wait for the cycle time
		wait ( level.healthRegenCycle );

		// Check if this player is frozen
		if ( level.gametype == "ftag" && self.freezeTag["frozen"] )
			continue;
			
		// Check if the player has full health
		if ( self.health == self.maxhealth ) {
			oldHealth = self.maxhealth;
			continue;
		}

		// Make sure the player is not bleeding
		if ( isDefined( self.isBleeding ) && self.isBleeding )
			continue;
		
		// If the player is dead or if health regen is disabled we have nothing else to do
		if ( player.health <= 0 || level.healthRegenDisabled )
			return;

		// If player took damage calculate the regen unit for each cycle based on maxhealth, damage taken and regen time
		while ( player.health < oldHealth ) 
		{
			healthRatio = player getnormalhealth();
			oldHealth = player.health;

			healthLost = ( 1 - healthRatio );
			healthTimeRatio = level.playerHealthRegenDelay * healthLost;
			healthRegenUnitPerCycle = healthLost / ( healthTimeRatio / level.healthRegenCycle );

			// Check if this was a very serious injury for the invincible challenge
			if ( healthRatio <= level.healthOverlayCutoff ) 
			{
				veryHurt = true;
				self.atBrinkOfDeath = true; // This variable is set to false by _missions::healthRegenerated()
			}

			newHealth = healthRatio;
			wait (2);
		}

		// If we got to this point it is because we still need to regen health so add one more regen unit
		newHealth += healthRegenUnitPerCycle;

		// Make sure that the new health is not more than 100% and process the invincible challenge when we got to 100%
		if ( newHealth >= 1.0 ) 
		{
			newHealth = 1.0;
			if ( veryHurt ) 
			{
				player maps\mp\gametypes\_missions::healthRegenerated();
				veryHurt = false;
			}
		}

		// Set the new health for the player
		player setnormalhealth( newHealth );
		oldHealth = player.health;
	}
}

/*
####################################
## 3QHSFF - Health Pack Functions ##
####################################
*/

dropHealthPack()
{
  //If Health Regen (Non-Openwarfare) is on then this script is useless.
	if ( level.scr_healthregen_method == 1 )
		return; 
       
	// Get the victim's origin
	playerOrigin = self.origin;

	// Calculate the position and angles to spawn this healthpack
	trace = playerPhysicsTrace( playerOrigin + (0,0,20), playerOrigin - (0,0,2000), false, self.body );
	angleTrace = bulletTrace( playerOrigin + (0,0,20), playerOrigin - (0,0,2000), false, self.body );
	tempAngle = randomfloat( 360 );
	dropOrigin = trace;
	if ( angleTrace["fraction"] < 1 && distance( angleTrace["position"], trace ) < 10.0 )
	{
		forward = (cos( tempAngle ), sin( tempAngle ), 0);
		forward = vectornormalize( forward - vector_scale( angleTrace["normal"], vectordot( forward, angleTrace["normal"] ) ) );
		dropAngles = vectortoangles( forward );
	}
	else
	{
		dropAngles = ( 0, tempAngle, 0);
	}

	// Create a new health pack
	healthPackTrigger = spawn( "trigger_radius", dropOrigin, 0, 10, 2 );
	healthPackModel = spawn( "script_model", dropOrigin );
	healthPackModel.angles = dropAngles;
	healthPackModel setModel( "weapon_bf3_medicbag" );
	
	// TODO return glowing health pack model
	/*
	if ( level.scr_healthsystem_healthpacks_enable == 2 ) 
	{
		healthPackGlow = spawn( "script_model", dropOrigin );
		healthPackGlow.angles = dropAngles;
		healthPackGlow setModel( "weapon_bf3_medicbag" );	
	} 
	else 
	{
		healthPackGlow = undefined;
	}
	*/
	healthPackGlow = undefined;

	// Function to control the pickup
	healthPackTrigger thread pickupHealthPackThink( healthPackModel, healthPackGlow );

	// Function to remove the healthpack from the game if it's not picked up in certain amount of time
	healthPackTrigger thread pickupHealthPackTimeout( healthPackModel, healthPackGlow );
}

pickupHealthPackThink( healthPackModel, healthPackGlow )
{
	self endon("death");

	for (;;)
	{
		self waittill ( "trigger", player );

		// Check if this player is frozen		
		if ( level.gametype == "ftag" && player.freezeTag["frozen"] )
			continue;
			
		healthPackPicked = false;
		newRandomHealthAmount = 0;

		// If bleeding is enabled and player doesn't have the maximum amount of bandages give a bandage
		if ( ( level.scr_healthsystem_bleeding_enable > 0 || level.scr_healthsystem_medic_enable ) && player.totalBandages < level.scr_healthsystem_bandage_max && player.health >= player getMaxHealth() ) 
		{
			if ( !( !level.scr_healthsystem_medic_enable  && !level.scr_healthsystem_bandage_self ) )
			{
				player.totalBandages += 1;
				player setClientDvar( "ui_bandages_qty", player.totalBandages );
				healthPackPicked = true;
			}
		}
		
		// Only give health if health regen is disabled and the player needs health and the player is not bleeding
		if ( player.health < player.maxhealth ) 
		{
			if ( level.scr_healthsystem_healthpacks_random_health && level.scr_healthsystem_healthpacks_health > 1 )
			{
				newRandomHealthAmount = randomIntRange( 1, level.scr_healthsystem_healthpacks_health + 1 );
        
				if ( player.health + newRandomHealthAmount > player.maxhealth )
					player.health = player.maxhealth;
				else
					player.health += newRandomHealthAmount;     
			}
			else if ( player.health + level.scr_healthsystem_healthpacks_health > player.maxhealth ) 
			{
				player.health = player.maxhealth;
			} 
			else 
			{
				player.health += level.scr_healthsystem_healthpacks_health;
			}
			healthPackPicked = true;
      
		}
    
		// If the health packs was picked up play the pick up sound and remove the health pack from the game
		if ( healthPackPicked ) 
		{
			player playLocalSound( "health_pickup_medium" );
			thread destroyHealthPack( self, healthPackModel, healthPackGlow );
			return;
		}
	}
}

pickupHealthPackTimeout( healthPackModel, healthPackGlow )
{
	self endon("death");

	healthPackTimeout = openwarfare\_timer::getTimePassed() + level.scr_healthsystem_healthpacks_timeout * 1000;
	while ( healthPackTimeout > openwarfare\_timer::getTimePassed() )
		wait (0.05);

	// Remove the health pack from the game
	thread destroyHealthPack( self, healthPackModel, healthPackGlow );
}

destroyHealthPack( healthPackTrigger, healthPackModel, healthPackGlow )
{
	// Destroy the trigger first
	healthPackTrigger delete();

	// Destroy the script model entity
	healthPackModel delete();
	
	if ( isDefined( healthPackGlow ) )
		healthPackGlow delete();
}

/*
##################################################
## 4QHSFF - Bleeding/Bandaging/Medic Functions  ##
##################################################
*/

onPlayerDamaged()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	for (;;)
	{
		self waittill("damage_taken", eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );

		// Make sure the player was damaged but it was not from falling
		if ( iDamage > 0 && sMeansOfDeath != "MOD_FALLING" && sMeansOfDeath != "MOD_GRENADE_SPLASH" && sMeansOfDeath != "MOD_TRIGGER_HURT" ) 
		{
			// Quickly start a new thread so we can monitor for more damage taken
			if ( level.scr_healthsystem_bleeding_start_percentage > 0 )
			{
				value = level.scr_healthsystem_bleeding_start_percentage;
				currentHealth = self.health;
				percentage = getMaxHealth() - int( getMaxHealth() * ( value / 100 ) );

				if ( currentHealth <= percentage )
					self thread bleedPlayer( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
				else
					continue;
			}
			else
				self thread bleedPlayer( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );  
		}
	}
}

// Multiple instances of this function can be running in the case the player is damaged multiple times
bleedPlayer( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	// Increase bleeding rate
	self.bleedingRate += 1;

	// Save some of the values from the last attacker
	self.bleedingParams.eInflictor = eInflictor;
	self.bleedingParams.attacker = eAttacker;
	self.bleedingParams.iDamage = iDamage;
	self.bleedingParams.sMeansOfDeath = sMeansOfDeath;
	self.bleedingParams.sWeapon = sWeapon;
	self.bleedingParams.vDir = vDir;
	self.bleedingParams.sHitLoc = sHitLoc;
	self.bleedingParams.psOffsetTime = psOffsetTime;
	
	if ( isDefined( eAttacker ) ) 
	{
		self.bleedingParams.fDistance = distance( self.origin, eAttacker.origin );
	} 
	else 
	{
		self.bleedingParams.fDistance = 0;
	}

	// Check if the player is already bleeding
	if ( self.isBleeding )
		return;

	// Show the bleeding shader to the player
	self.isBleeding = true;
	
	if ( level.scr_healthsystem_bleeding_icon ) 
	{
		self setHealingStatus( "bleeding" );
		self showHealingStatus( true );
	}

	// Wait before start bleeding
	xWait(1);

	// Start the bleeding process until the player bandages himself or dies
	while ( self.health > 0 && self.isBleeding && ( !isDefined( self.lastStand ) || !self.lastStand ) ) 
	{
		self.health -= self.bleedingRate;

		nextBleeding = openwarfare\_timer::getTimePassed() + level.scr_healthsystem_bleeding_enable * 1000;
		while ( self.health > 0 && self.isBleeding && nextBleeding > openwarfare\_timer::getTimePassed() )
			wait (0.05);
	}

	// Hide the bleeding shader
	if ( level.scr_healthsystem_bleeding_icon ) 
		self showHealingStatus( false );

	// Check if the player has bleed out
	if ( self.health <= 0 ) 
	{
		self.useLastStandParams = true;
		self.bleedOut = true;
		self.lastStandParams = spawnstruct();
		self.lastStandParams.eInflictor = self.bleedingParams.eInflictor;
		self.lastStandParams.attacker = self.bleedingParams.attacker;
		self.lastStandParams.iDamage = self.bleedingParams.iDamage;
		self.lastStandParams.sMeansOfDeath = self.bleedingParams.sMeansOfDeath;
		self.lastStandParams.sWeapon = self.bleedingParams.sWeapon;
		self.lastStandParams.vDir = self.bleedingParams.vDir;
		self.lastStandParams.sHitLoc = self.bleedingParams.sHitLoc;
		self.lastStandParams.lastStandStartTime = self.bleedingParams.psOffsetTime;
		self.lastStandParams.fDistance = self.bleedingParams.fDistance;
		self maps\mp\gametypes\_globallogic::ensureLastStandParamsValidity();
		self suicidePlayer();
	} 
	else 
	{
		self.isBleeding = false;
		self.bleedingRate = 0;
	}
}

medicHintThread()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	maxHealth = getMaxHealth();

	lastTeammate = undefined;
	isHintShown = false;
	teamMateNeedHelp = false;

	for(;;)
	{
		if ( isHintShown )
		{
			isMedicActionInProgress = ( 
				 ( isDefined( self.isBandagingTeammate ) && self.isBandagingTeammate ) ||
			 	 ( isDefined( self.isHealingTeammate ) && self.isHealingTeammate ) ||
				 ( isDefined( self.isHealing ) && self.isHealing ) ||
				 ( isDefined( self.isBandaging ) && self.isBandaging ) );

			if ( !teamMateNeedHelp || isMedicActionInProgress )
			{
				lastTeammate = undefined;
				isHintShown = false;

				self maps\mp\gametypes\_hud_hints::hideHint( "HS_MED" );
			}
		}	

		wait (1);

		teamMate = self findClosestTeammate();
		teamMateNeedHelp = isDefined( teamMate ) && teamMate.health < maxHealth && ( level.gametype != "ftag" || !teamMate.freezeTag["frozen"] );

		if ( teamMateNeedHelp && ( !isDefined( lastTeammate ) || lastTeammate != teamMate ) )
		{
			lastTeammate = teamMate;
			isHintShown = true;

			switch ( getMedicActionType( teamMate ) )
			{
				case "bandage":
					self maps\mp\gametypes\_hud_hints::showHint( &"OW_MEDIC_HINT_BANDAGE", "HS_MED", teamMate, false );
					break;
		
				case "heal":
					self maps\mp\gametypes\_hud_hints::showHint( &"OW_MEDIC_HINT_HEAL", "HS_MED", teamMate, false );
					break;
			}
		}
	}
}

medic()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );
	
	if ( !level.scr_healthsystem_medic_enable )
		return;
    
	if ( !isDefined( self.tookBandage ) )
		self.tookBandage = false; 
    
	teammate = self findClosestTeammate();  
  
	//If no teammate check if we are healing our self
	if ( !isDefined( teammate ) )
	{
	 	// Check if the player is frozen
		if ( level.gametype == "ftag" && self.freezeTag["frozen"] )
			return;

		if ( self playerHasBandages() )
		{
		if ( level.scr_healthsystem_medic_healing_self && ( self.health < getMaxHealth() ) )
			self thread healSelf();
		else
			return;
		}
		return;
	}
  
	if ( teammate.health >= getMaxHealth() )
		return;

	// Check if the player is frozen
	if ( level.gametype == "ftag" && teammate.freezeTag["frozen"] )
		return;
		  
	//Check to make sure at least one bandage is available
	if ( !self playerHasBandages() )
	{
		if ( level.scr_healthsystem_medic_take_bandage )
		{
			if ( teammate playerHasBandages() )
				self.isUsingTeammateBandage = true;
			else
			{  
				self iprintln( &"OW_BLEEDING_NOBANDAGES" );    
				return;
			}
		}
	}
  
	if ( isDefined( teammate.isBandaging ) && teammate.isBandaging )
	{
		self iprintln( &"OW_TEAMMATE_BANDAGE" );
		return;
	}
	else if ( isDefined( teammate.isHealing ) && teammate.isHealing )
	{
		self iprintln( &"OW_TEAMMATE_HEAL" );
		return;
	}
  
	switch ( getMedicActionType( teammate ) )
	{
		case "bandage":
			self thread bandageTeammate( teammate );
			break;
	
		case "heal":
			
			self thread healTeammate( teammate );
			break;
	}
  
	return;
}  
      

getMedicActionType( player )
{
	if ( isDefined( player.isBleeding ) && player.isBleeding )
	{
		if ( !level.scr_healthsystem_medic_bandaging )
		{
			return "heal";
		}
		else
		{
			return "bandage";
		}
	}

	return "heal";
}
   

/*
*********************
The healSelf(), healTeammate(), and bandageTeammate() functions 
are all based on the bandageSelf() (originally bleedingApplication).
This will keep the functions similar and easier to understand as well
to keep the health system running smoothly.
*********************
*/

bandageSelf()
{     
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );
	
	if ( !level.scr_healthsystem_bleeding_enable || !level.scr_healthsystem_bandage_self )
		return;

	if ( self.health >= getMaxHealth() )
		return;

	// Make sure the player is bleeding
	if ( isDefined( self.isBleeding ) && self.isBleeding ) 
	{
		// If the player is already bandaging then we need to cancel the process
		if ( self.isBandaging ) 
		{
			self.isBandaging = false;
		} 
		else 
		{
			// Make sure the player has bandages left
			if ( self playerHasBandages() ) 
			{
				// Start bandaging process. We'll stop in case the player decides to stop.
				self.isBandaging = true;

				// Reduce speed, prevent sprinting, and disable weapons
				self stopPlayer( true, 75 );

				if ( level.scr_healthsystem_healing_icon && isDefined( self.hud_healthsystem_icon ) ) 
					self setHealingStatus( "bandaging" );

				// Play some bandaging sound
				self playLocalSound( "scramble" );

				bandageEnds = openwarfare\_timer::getTimePassed() + level.scr_healthsystem_bandage_time * 1000;
				while ( self.isBandaging && bandageEnds > openwarfare\_timer::getTimePassed() )
					wait (0.05);

				// Make sure the bandaging process was complete and the player didn't cancel it
				if ( self.isBandaging ) 
				{
					// The necessary time for bandaging has been completed
					self.isBleeding = false;
					self.isBandaging = false;
					self.totalBandages -= 1;
					self setClientDvar( "ui_bandages_qty", self.totalBandages );
				} 
			} 
			else 
			{
				self iprintln( &"OW_BLEEDING_NOBANDAGES" );
			}
		}
		if ( level.scr_healthsystem_bleeding_icon && isDefined( self.hud_healthsystem_icon ) ) 
      self setHealingStatus( "bleeding" );
      
    // Restore speed, allow sprinting, and enable weapons
    self stopPlayer( false, 0 );
	}
	return;
}

healSelf()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );
	
	if ( !level.scr_healthsystem_medic_healing_self )
    return;
	
	if ( self.health >= getMaxHealth() )
    return;
  
	//If player is healing then we need to stop this process
	if ( isDefined( self.isHealing ) && self.isHealing )
	{
		self.isHealing = false;
	}
	else
	{    
		self.isHealing = true;  
  
		self stopPlayer( true, 75 );
    
		self playLocalSound( "scramble" );
  
		if ( level.scr_healthsystem_healing_icon && isDefined( self.hud_healthsystem_icon ) )
		{
		self setHealingStatus( "healing" );
		self showHealingStatus( true );
		}                
    
		addingHealth = 0.0;
		remainingHealthPoints = 0.0;
		healEnds = openwarfare\_timer::getTimePassed() + level.scr_healthsystem_medic_healing_time * 1000; 
		while ( self.isHealing && healEnds > openwarfare\_timer::getTimePassed() )
		{
			if ( isDefined( self.lastStand ) && self.lastStand )
			{
				remainingHealthPoints = 0;
				break; 
			}	 
			addingHealth += ( level.scr_healthsystem_medic_healing_health / level.scr_healthsystem_medic_healing_time ) * 0.05;
   
			if ( int( addingHealth ) >= 1 )
			{
				remainingHealthPoints += addingHealth - 1.0; 
				self.health += 1;
				addingHealth = 0.0;
      
				if (self.health >= getMaxHealth() )
				{
					self.health = getMaxHealth();
					break;
				}
			}
			wait (0.05);
		}
    
		if ( (self.health + int( remainingHealthPoints ) ) >= getMaxHealth() )
			self.health = getMaxHealth();
		else
			self.health += int( remainingHealthPoints );
    
		if ( self.isHealing )
		{
		self.isHealing = false;        
		self removeBandage();   
		}
		else
		{
			self removeBandage(); 
		}  
	}
  
	if ( level.scr_healthsystem_healing_icon && isDefined( self.hud_healthsystem_icon ) )
		self showHealingStatus( false );  
    
	self stopPlayer( false, 0 );
  
	return;
}    

bandageTeammate( teammate )
{
	if ( !level.scr_healthsystem_medic_bandaging )
		return; 
  
	//If we are already bandaging the teammate then we need to stop    
	if ( isDefined( self.isBandagingTeammate ) && self.isBandagingTeammate )
	{
		self.isBandagingTeammate = false;
	}
	else
	{ 
		self.isBandagingTeammate = true;
    
		self iprintln( &"OW_MEDIC_SELF_BANDAGE", teammate );
		teammate iprintln( &"OW_MEDIC_TEAMMATE_BANDAGE", self );
		
		self stopPlayer( true, 100 );
		teammate stopPlayer( true, 100 );
    
		self playLocalSound( "scramble" );  
    
		if ( level.scr_healthsystem_healing_icon && isDefined( self.hud_healthsystem_icon ) )
		{
			self setHealingStatus( "bandaging" );
			self showHealingStatus( true );  
			teammate setHealingStatus( "bandaging" );
			teammate showHealingStatus( true );          
		}     
      
		bandageEnds = openwarfare\_timer::getTimePassed() + level.scr_healthsystem_bandage_time * 1000;
		while ( isAlive( teammate ) && self.isBandagingTeammate && bandageEnds > openwarfare\_timer::getTimePassed() )
		{
			if ( ( isDefined( self.lastStand ) && self.lastStand ) || ( isDefined( teammate.lastStand ) && teammate.lastStand ) ) 
				break; 
			wait (0.05);
		}
      
		if ( self.isBandagingTeammate ) 
		{    
			teammate.isBleeding = false;  
			self.isBandagingTeammate = false;
          
			if ( isDefined( self.isUsingTeammateBandage ) && self.isUsingTeammateBandage )
				teammate removeBandage();
			else
				self removeBandage();
			
			self iprintln( &"OW_MEDIC_BANDAGE_SUCCESS" );  
			teammate iprintln( &"OW_MEDIC_BANDAGE_SUCCESS" );  
		}
		else
		{
			self iprintln( &"OW_MEDIC_BANDAGE_UNSUCCESSFUL" );
			teammate iprintln( &"OW_MEDIC_BANDAGE_UNSUCCESSFUL" );
		}
	}
    
	if ( level.scr_healthsystem_healing_icon && isDefined( self.hud_healthsystem_icon ) )
		self showHealingStatus( false );
    
	if ( level.scr_healthsystem_bleeding_icon && isDefined( self.hud_healthsystem_icon ) && !teammate.isBleeding )
		teammate showHealingStatus( false );
  
	self stopPlayer( false, 0 );
	teammate stopPlayer( false, 0 ); 
  
	return;    
}

healTeammate( teammate )
{ 

	if ( !level.scr_healthsystem_medic_healing )
		return; 

	//If we are already healing the teammate then lets stop
	if ( isDefined( self.isHealingTeammate ) && self.isHealingTeammate )
	{
		self.isHealingTeammate = false;
	}
	else
	{    
		self.isHealingTeammate = true;
    
		self iprintln( &"OW_MEDIC_SELF_HEAL", teammate );
		teammate iprintln( &"OW_MEDIC_TEAMMATE_HEAL", self );

		self stopPlayer( true, 100 );
		teammate stopPlayer( true, 100 );
    
		if ( level.scr_healthsystem_healing_icon && isDefined( self.hud_healthsystem_icon) )
		{
			self setHealingStatus( "healing" );
			self showHealingStatus( true );  
			teammate setHealingStatus( "healing" );
			teammate showHealingStatus( true );          
		}
    
		self playLocalSound( "scramble" );
    
		addingHealth = 0.0;
		remainingHealthPoints = 0.0;
		healEnds = openwarfare\_timer::getTimePassed() + level.scr_healthsystem_medic_healing_time * 1000;
		while ( isAlive( teammate ) && self.isHealingTeammate && healEnds > openwarfare\_timer::getTimePassed() )
		{
			if ( ( isDefined( self.lastStand ) && self.lastStand ) || ( isDefined( teammate.lastStand ) && teammate.lastStand ) ) 
			{
				remainingHealthPoints = 0;
				break;
			}  

			addingHealth += ( level.scr_healthsystem_medic_healing_health / level.scr_healthsystem_medic_healing_time ) * 0.05;
      
			if ( int( addingHealth ) >= 1 )
			{
				remainingHealthPoints += addingHealth - 1.0;
				teammate.health += 1;
				addingHealth = 0.0;
				
				if (teammate.health >= getMaxHealth() )
				{
					teammate.health = getMaxHealth();
					break;
				}
			}
			wait (0.05);
		}
    
		if ( (teammate.health + int( remainingHealthPoints ) ) >= getMaxHealth() )
			teammate.health = getMaxHealth();
		else
			teammate.health += int( remainingHealthPoints ); 
    
		if ( self.isHealingTeammate )
		{  
			self.isHealingTeammate = false;
      
			self iprintln( &"OW_MEDIC_HEALING_FULL" );
			teammate iprintln( &"OW_MEDIC_HEALING_FULL" );

			if ( level.scr_healthsystem_medic_clear_damage_effects > 0 )
			{
				teammate openwarfare\_damageeffect::clearAllDamageEffects();
			}
      
			if ( isDefined( self.isUsingTeammateBandage ) && self.isUsingTeammateBandage )
				teammate removeBandage();
			else
				self removeBandage();
		}
		else
		{	
			self iprintln( &"OW_MEDIC_HEALING_PARTIAL" );
			teammate iprintln( &"OW_MEDIC_HEALING_PARTIAL" );    
    
			if ( isDefined( self.isUsingTeammateBandage ) && self.isUsingTeammateBandage )
				teammate removeBandage();
			else
				self removeBandage(); 
		}  
	}
  
	if ( level.scr_healthsystem_healing_icon && isDefined( self.hud_healthsystem_icon ) )
	{
		self showHealingStatus( false );
		teammate showHealingStatus( false );
	}
      
	self stopPlayer( false, 0 );
	teammate stopPlayer( false, 0 ); 
  
	return;
}

/*
#######################################
## 5QHSFF - Helper Functions ##
#######################################
*/

findClosestTeammate()
{
	// Tried using isLookingAt( player ) to get injured teammate, however, that has problems. 
	// Since isTouching( player ) does not work, then calculating the distance to find the closest player
	// will have to do.
	
	theChosenOne = undefined;
	team = self.sessionteam;
	currentShortestDistance = undefined;

	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];
    
		if ( isDefined( self.lastStand ) && self.lastStand )
			break;

		if ( isDefined( player.lastStand ) && player.lastStand ) 
			continue;
    
		if ( player.pers["team"] == team && self != player && isPlaying( player ) )
		{       
			//distance = distance( self.origin, player.origin );

			originDelta = self.origin - player.origin;

			distSq = originDelta[0]*originDelta[0] + 
					 originDelta[1]*originDelta[1] + 
					 originDelta[2]*originDelta[2];

			//if ( distance < 60 ) 
			if ( distSq < 6400 ) 
			{
				if ( !isDefined( currentShortestDistance ) )
				{
					theChosenOne = player;
					currentShortestDistance = distSq;
				}
				else
				{
					if ( distSq < currentShortestDistance )
					{
						currentShortestDistance = distSq;
						theChosenOne = player;
					}
				}     
			} 
		}
	}
	return theChosenOne;
}

getMaxHealth()
{
	max = getDvarInt( "scr_player_maxhealth" );
	return max;
}

showHealingStatus( condition )
{
	if ( !isDefined( self.hud_healthsystem_icon ) || !isDefined( self.hud_healthsystem_text ) )
		return;

	if ( condition )
	{
		self.hud_healthsystem_icon.alpha = 1;
		self.hud_healthsystem_text.alpha = 0.715;
	}
	else
	{
		self.hud_healthsystem_icon.alpha = 0;
		self.hud_healthsystem_text.alpha = 0;
	}
		
}  

setHealingStatus( status )
{
	if ( status == "bandaging" )
	{
		self.hud_healthsystem_icon setShader( "bandaging", 32, 32);
		self.hud_healthsystem_text setText( &"OW_STATUS_BANDAGE" );
	}
	else if ( status == "healing" )
	{
		self.hud_healthsystem_icon setShader( "bandaging", 32, 32);
		self.hud_healthsystem_text setText( &"OW_STATUS_HEALING" );
	}
	else
	{
		self.hud_healthsystem_icon setShader( "bleeding", 32, 32);
		self.hud_healthsystem_text setText( &"OW_STATUS_BLEEDING" );
	}
}  

removeBandage()
{
	self.totalBandages -= 1;
	self setClientDvar( "ui_bandages_qty", self.totalBandages );
}

playerHasBandages()
{
	if ( self.totalBandages > 0 )
		return true;
	else
		return false;
}

stopPlayer( condition, speedModifierPercent )
{
	if ( condition )
	{
		self thread openwarfare\_speedcontrol::setModifierSpeed( "_healthsystem", speedModifierPercent );
		self thread maps\mp\gametypes\_gameobjects::_disableWeapon();
		self thread maps\mp\gametypes\_gameobjects::_disableJump();
		self thread maps\mp\gametypes\_gameobjects::_disableSprint();
	}
	else
	{
		self thread openwarfare\_speedcontrol::setModifierSpeed( "_healthsystem", 0 );
		self thread maps\mp\gametypes\_gameobjects::_enableWeapon();
		self thread maps\mp\gametypes\_gameobjects::_enableJump();
		self thread maps\mp\gametypes\_gameobjects::_enableSprint();
	}
}