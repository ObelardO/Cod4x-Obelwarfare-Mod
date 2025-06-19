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

#include openwarfare\_utils;

init()
{
    level.ow_cac_allow_ingame_ranked = getdvarx( "ow_cac_allow_ingame_ranked", "int", 1, 0, 1 );

    if( !level.ow_cac_allow_ingame_ranked || level.oldschool || level.console )
        return;

    if( !isDefined( level.cacIngameInitialized ) )
    {
        perksTableRef = "perks_table";
        weaponsTableRef = "weapons_table";
        attachmentTableRef = "attachment_table";
        camoTableRef = "camo_table";

        level.cacIngameClassInfo = [];
        initClassInfo( 200, "custom1,0" );
        initClassInfo( 210, "custom2,0" );
        initClassInfo( 220, "custom3,0" );
        initClassInfo( 230, "custom4,0" );
        initClassInfo( 240, "custom5,0" );

        level.cacIngameItemInfo = [];
        initItemInfo( 1, "primary", weaponsTableRef );
        initItemInfo( 2, "primary_attachment", attachmentTableRef );
        initItemInfo( 3, "secondary", weaponsTableRef );
        initItemInfo( 4, "secondary_attachment", attachmentTableRef );
        initItemInfo( 5, "perk1", perksTableRef ); // equipment
        initItemInfo( 6, "perk2", perksTableRef ); // weapon
        initItemInfo( 7, "perk3", perksTableRef ); // ability
        initItemInfo( 8, "grenade", weaponsTableRef );
        initItemInfo( 9, "camo", camoTableRef );

        level.cacIngameAllowedWeaps = [];
        initAllowedWeapons( 20, "assault", "" );
        initAllowedWeapons( 10, "specops", "" );
        initAllowedWeapons( 80, "heavygunner", "" );
        initAllowedWeapons( 70, "demolitions", "" );
        initAllowedWeapons( 60, "sniper", "" );
        initAllowedWeapons( 0, "", "pistol" );
        initAllowedWeapons( 100, "", "" );

        //
        initAllowedPerks( "" );
        initAllowedPerks( "assault" );
        initAllowedPerks( "specops" );
        initAllowedPerks( "heavygunner" );
        initAllowedPerks( "demolitions" );
        initAllowedPerks( "sniper" );

        level.cacIngameInitialized = true;

        precacheMenu( "cac_ingame" );
    }




    level thread onPlayerConnecting();


}


initClassInfo( classStatOffset, stockResponse )
{
    index = level.cacIngameClassInfo.size;

    level.cacIngameClassInfo[index] = spawnStruct();
    level.cacIngameClassInfo[index].statOffset = classStatOffset;
    level.cacIngameClassInfo[index].stockResponse = stockResponse;
    //level.cacIngameClassInfo[index].className = className;
    //level.cacIngameClassInfo[index].menuName = "cac_" + className + "_ingame";
    //level.cacIngameClassInfo[index].weaponsStatOffset = weaponsStatOffset;

    //precacheMenu( level.cacIngameClassInfo[index].menuName );
}


initItemInfo( statOffset, dataType, tableSource, dvarName ) //, weaponId, weaponCount )
{
    index = level.cacIngameItemInfo.size;

    level.cacIngameItemInfo[index] = spawnStruct();
    level.cacIngameItemInfo[index].statOffset = statOffset;
    level.cacIngameItemInfo[index].dataType = dataType;
    level.cacIngameItemInfo[index].tableSource = tableSource;
    level.cacIngameItemInfo[index].dvarName = "loadout_" + dataType;
}

initAllowedWeapons( statOffset, className, attachName )
{
    for( weapIndex = statOffset; weapIndex < statOffset + 10; weapIndex++ )
    {
        //---- WEAPONS ----

        //Add allowed weapons
        weaponName = tableLookup( "mp/statsTable.csv", 0, weapIndex, 4 );
        if ( !isDefined( weaponName ) || weaponName == "" )
            continue;

        if ( className == "" )
            dvarName = "weap_allow_" + weaponName;
        else
            dvarName = "weap_allow_" + className + "_" + weaponName;

        addAllowedWeapon( dvarName );

        //---- NO ATTACHMENTS ----

        if ( !isDefined( attachName ) || attachName == "" )
        {
            attachName = className;
        }

        //Add allowed no attachments
        if ( attachName != "" )
        {            
            dvarName = "attach_allow_" + attachName + "_none";
            addAllowedWeapon( dvarName );
        }

        //---- ATTACHMENTS ----

        //Add allowed attachments for weapon
        attachments = tableLookup( "mp/statsTable.csv", 0, weapIndex, 8 );
        if( !isdefined( attachments ) || attachments == "" )
            continue;

        //Get attachment names
        attachmentsNames = strTok( attachments, " " );
        if( !isDefined( attachmentsNames ) )
            continue;

        //Only 1 attachment for this weapon
        if ( attachmentsNames.size == 0 )
        {
            dvarName = "attach_allow_" + attachName + "_" + attachments;
            addAllowedWeapon( dvarName );
        }
        //Multiple attachment options
        else
        {
            for( attachIndex = 0; attachIndex < attachmentsNames.size; attachIndex++ )
            {
                dvarName = "attach_allow_" + attachName + "_" + attachmentsNames[attachIndex];
                addAllowedWeapon( dvarName );
            }
        }
    }
}


addAllowedWeapon( dvarName )
{
    allowIndex = level.cacIngameAllowedWeaps.size;
    level.cacIngameAllowedWeaps[allowIndex] = spawnStruct();
    level.cacIngameAllowedWeaps[allowIndex].dvarName = dvarName;
    level.cacIngameAllowedWeaps[allowIndex].dvarValue = getdvarx( dvarName, "int", 1, 0, 2 );
}


initAllowedPerks( className )
{
    for( perkIndex = 150; perkIndex < 190; perkIndex++ )
    {
        perkName = tableLookup( "mp/statsTable.csv", 0, perkIndex, 4 );
        if ( !isDefined( perkName ) || perkName == "" )
            continue;

        perkGroup = tableLookup( "mp/statsTable.csv", 0, perkIndex, 8 );
        if ( !isDefined( perkGroup ) || perkGroup == "" )
            continue;

        //Master Option
        if ( className == "")
        {
            dvarName = "perk_allow_" + perkName;
            addAllowedWeapon( dvarName );
        }
        //Class depends perks
        {
            dvarName = "perk_" + className + "_allow_" + perkName;
            addAllowedWeapon( dvarName );
        }
    }
}


onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

        player.cacBackStatData = [];
        player.cacTempStatData = [];

        player flushTempStatData();
        
        player thread onMenuResponseThread();
	}
}


sendAllowedLoadoutThread()
{
    for( allowIndex = 0; allowIndex < level.cacIngameAllowedWeaps.size; allowIndex++ )
    {
        self setClientDvar( level.cacIngameAllowedWeaps[allowIndex].dvarName, level.cacIngameAllowedWeaps[allowIndex].dvarValue  );
    
        if ( allowIndex % 10 == 0 ) 
        {
            wait 0.05;
        }
    }
}


onMenuResponseThread()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("menuresponse", menu, response);

        self iPrintLn( "RAW RES: " + response );

        if( menu == game["menu_changeclass"] && response != "back" )
        {
            self closeMenu();
			self closeInGameMenu();

            //cacMenu = undefined;
            classOffset = undefined;

            for( i = 0; i < level.cacIngameClassInfo.size; i++ )
            {
                if( level.cacIngameClassInfo[i].stockResponse == response )
                {
                    //cacMenu = level.cacIngameClassInfo[i].menuName;
                    classOffset =  level.cacIngameClassInfo[i].statOffset;
                    break;
                }
            }

            //Override open CAC menu for selected custom class
            //if( isDefined( cacMenu ) && isDefined( classOffset ) )
            if( isDefined( classOffset ) )
            {
                flushTempStatData();
                loadBackupStatData( classOffset );

                self thread sendAllowedLoadoutThread();

                //self openMenu( cacMenu );
                self openMenu( "cac_ingame" );
            }
            //Othervise stock logic
            else
            {
				self.selectedClass = true;
				self [[level.class]]( response );
            }

            continue;
        } 

        if ( response == "cac_esc" )
        {
            self closeMenu();
			self closeInGameMenu();

            self iPrintLn( "CAC ESC! menu: ^7" + menu );

            for( i = 0; i < level.cacIngameClassInfo.size; i++ )
            {
                if( level.cacIngameClassInfo[i].menuName == menu )
                {
                    self iPrintLn( "CAC ESC! menu match: ^2" + menu ); 

                    saveBackStatData( level.cacIngameClassInfo[i].statOffset );
                }
            }

            //self setClientDvar( "ui_primary_weapon", 85 );


            //hack to reload loadout display (not worked)
            wait 0.05;
            self openMenu( game["menu_changeclass"] );

            continue;
        }

        if ( response == "cac_go" )
        {
            self iPrintLn( "CAC GO! menu: ^7" + menu );

            for( i = 0; i < level.cacIngameClassInfo.size; i++ )
            {
                if( level.cacIngameClassInfo[i].menuName == menu )
                {
                    self iPrintLn( "CAC GO! menu match: ^2" + menu ); 

                    saveTempStatData( level.cacIngameClassInfo[i].statOffset );

                    self closeMenu();
                    self closeInGameMenu();

                    self.selectedClass = true;
                    self [[level.class]]( level.cacIngameClassInfo[i].stockResponse );
                }
            }

            continue;
        }

        responseTok = strTok( response, "," );

    	if( isdefined( responseTok ) && responseTok.size > 1 )
		{
			responseType = responseTok[0];

            if( responseType == "cac_set" )
            {
                // primary weapon selection
                assertex( responseTok.size != 3, "Item selection in create-a-class-ingame is sending bad response:" + response );

                dataType = responseTok[1];
                valueRef = responseTok[2]; // int( tableLookup( "mp/statsTable.csv", 4, responseTok[2], 1 ) );
                
                statValue = getStatValueByType( dataType, valueRef );

                setTempStatData( dataType, statValue );

                self iPrintLn( "CAC SET: type: ^2" + dataType + "^7  value: ^2" + statValue + "^7 ref: ^2" + valueRef +  "^7 menu: " + menu );
            }
        }
    }
}


getStatValueByType( dataType, valueRef )
{
    for( i = 0; i < level.cacIngameItemInfo.size; i++ )
    {
        if( level.cacIngameItemInfo[i].dataType == dataType )
        {   
            return getStatValueByRef( level.cacIngameItemInfo[i].tableSource, valueRef );
        }
    }

    return -1;
}

getRefByStatValue( tableSource, statValue )
{
    switch( tableSource )
    {
        case "perks_table":
            return tableLookup( "mp/statsTable.csv", 1, statValue, 4 );

        case "weapons_table":
            return tableLookup( "mp/statsTable.csv", 1, statValue + 3000, 4 );

        case "attachment_table":
            return tableLookup( "mp/attachmentTable.csv", 9, statValue, 4 );

        case "camo_table":
            return tableLookup( "mp/attachmentTable.csv", 11, statValue, 4 );
    }
}

getStatValueByRef( tableSource, valueRef )
{
    switch( tableSource )
    {
        case "perks_table":
            return int( tableLookup( "mp/statsTable.csv", 4, valueRef, 1 ) );

        case "weapons_table":
            return int( tableLookup( "mp/statsTable.csv", 4, valueRef, 1 ) ) + 3000;

        case "attachment_table":
            return int( tableLookup( "mp/attachmentTable.csv", 4, valueRef, 9 ) );

        case "camo_table":
            return int( tableLookup( "mp/attachmentTable.csv", 4, valueRef, 11 ) );
    }

    return -1;
}


flushTempStatData()
{
    for( i = 0; i < level.cacIngameItemInfo.size; i++ )
    {
        self.cacTempStatData[level.cacIngameItemInfo[i].dataType] = -1;
    }
}


setTempStatData( dataType, value )
{
    if( isDefined( self.cacTempStatData[dataType] ) )
    {
        self.cacTempStatData[dataType] = value;

        //TODO: move to function
        for( i = 0; i < level.cacIngameItemInfo.size; i++ )
        {
            if( level.cacIngameItemInfo[i].dataType == dataType )
            {   
                self setClientDvar( level.cacIngameItemInfo[i].dvarName, value );
            }
        }
        //
    }
}


saveTempStatData( classStatOffset )
{
    for( i = 0; i < level.cacIngameItemInfo.size; i++ )
    {
        dataType = level.cacIngameItemInfo[i].dataType;

        if( self.cacTempStatData[dataType] < 0 )
        {
            continue;
        }

        itemStatOffset = level.cacIngameItemInfo[i].statOffset;

        self setStat ( classStatOffset + itemStatOffset, self.cacTempStatData[dataType] );
    }

    flushTempStatData();
}


saveBackStatData( classStatOffset )
{
    for( i = 0; i < level.cacIngameItemInfo.size; i++ )
    {
        dataType = level.cacIngameItemInfo[i].dataType;
        itemStatOffset = level.cacIngameItemInfo[i].statOffset;

        tempOffset = 0;

        if( level.cacIngameItemInfo[i].tableSource == "stats_table" )
        {
            tempOffset = 3000;
        }

        value = self.cacBackStatData[dataType];

        //TODO Restore UI dvars
        self iPrintLn( "[CAC] Restore backup: type: ^2" + dataType + "^7  value: ^2" + value );
        self iPrintLn( "[CAC] Set stat: ^2" + (classStatOffset + itemStatOffset) + "^7  value: ^2" + value );

        self setStat ( classStatOffset + itemStatOffset, value );
        //self setStat ( classStatOffset + itemStatOffset + tempOffset, value );
    }
}


loadBackupStatData( classStatOffset )
{
    for( i = 0; i < level.cacIngameItemInfo.size; i++ )
    {
        itemStatOffset = level.cacIngameItemInfo[i].statOffset;

        dataType = level.cacIngameItemInfo[i].dataType;

        statValue = self getStat ( classStatOffset + itemStatOffset );

        self.cacBackStatData[dataType] = statValue;

        valueRef = getRefByStatValue( level.cacIngameItemInfo[i].tableSource, statValue );

        self setClientDvar( level.cacIngameItemInfo[i].dvarName, valueRef );

        self iPrintLn( "[CAC] Store backup: type: ^2" + dataType + "^7  value: ^2" + statValue + "^7  ref: ^2" + valueRef );
    }
}
