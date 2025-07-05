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
    level.scr_enable_cac_ingame_ranked = getdvarx( "scr_enable_cac_ingame_ranked", "int", 0, 0, 1 );

    if( level.scr_enable_cac_ingame_ranked == 0 || !level.rankedMatch || level.oldschool || level.console )
        return;

    if( !isDefined( level.cacIngame ) )
    {
        level.cacIngame = spawnStruct();
    }
    
    if( !isDefined( level.cacIngame.initialized ) )
    {
        perksTableRef = "perks_table";
        weaponsTableRef = "weapons_table";
        attachmentTableRef = "attachment_table";
        camoTableRef = "camo_table";

        level.cacIngame.classInfo = [];
        initClassInfo( 200, "1" );
        initClassInfo( 210, "2" );
        initClassInfo( 220, "3" );
        initClassInfo( 230, "4" );
        initClassInfo( 240, "5" );

        level.cacIngame.itemInfo = [];
        initItemInfo( 1, "primary", weaponsTableRef, "weap_tg" );
        initItemInfo( 2, "primary_attachment", attachmentTableRef, "atch_tg" );
        initItemInfo( 3, "secondary", weaponsTableRef, "weap_tg" );
        initItemInfo( 4, "secondary_attachment", attachmentTableRef, "atch_tg" );
        initItemInfo( 5, "perk1", perksTableRef, "perk1_tg" ); // equipment
        initItemInfo( 6, "perk2", perksTableRef, "perk2_tg" ); // weapon
        initItemInfo( 7, "perk3", perksTableRef, "perk3_tg" ); // ability
        initItemInfo( 8, "grenade", weaponsTableRef, "gren_tg" );
        initItemInfo( 9, "camo", camoTableRef, "" );

        level.cacIngame.allowedItems = [];
        //                                        /         overrides         \       
        //                  Stat   Class Name     Attach    Weap tag   Attach tag
        initAllowedWeapons( 20,    "assault",     "",       "",        "" );
        initAllowedWeapons( 10,    "specops",     "",       "",        "" );
        initAllowedWeapons( 80,    "heavygunner", "",       "",        "" );
        initAllowedWeapons( 70,    "demolitions", "",       "",        "" );
        initAllowedWeapons( 60,    "sniper",      "",       "",        "" );
        initAllowedWeapons( 0,     "",            "pistol", "pist_tg", "pist_atch_tg" );
        initAllowedWeapons( 100,   "",            "",       "gren_tg", "" );

        //
        initAllowedPerks( "" );
        initAllowedPerks( "assault" );
        initAllowedPerks( "specops" );
        initAllowedPerks( "heavygunner" );
        initAllowedPerks( "demolitions" );
        initAllowedPerks( "sniper" );

        level.cacIngame.initialized = true;
        level.cacIngame.menu = "cac_ingame";

        precacheMenu( level.cacIngame.menu );
    }

    level thread onPlayerConnecting();
}


initClassInfo( classStatOffset, customClassNumber )
{
    index = level.cacIngame.classInfo.size;

    level.cacIngame.classInfo[index] = spawnStruct();
    level.cacIngame.classInfo[index].statOffset = classStatOffset;
    level.cacIngame.classInfo[index].stockResponse = "custom" + customClassNumber + ",0";
    level.cacIngame.classInfo[index].name = "customclass" + customClassNumber;
}


initItemInfo( statOffset, dataType, tableSource, tag )
{
    index = level.cacIngame.itemInfo.size;

    level.cacIngame.itemInfo[index] = spawnStruct();
    level.cacIngame.itemInfo[index].statOffset = statOffset;
    level.cacIngame.itemInfo[index].tableSource = tableSource;
    level.cacIngame.itemInfo[index].dvarName = "loadout_" + dataType;
    level.cacIngame.itemInfo[index].tag = tag;
}


initAllowedWeapons( statOffset, className, overrideClassName, overrideWeapTag, overrideAttachTag )
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

        if ( !isDefined( overrideWeapTag ) || overrideWeapTag == "" ) overrideWeapTag = "weap_tg";
        

        addAllowedItem( className, weaponName, dvarName, overrideWeapTag );

        //initAllowedAttachments( className )

        //---- NO ATTACHMENTS ----

        if ( !isDefined( overrideClassName ) || overrideClassName == "" ) overrideClassName = className;

        if ( !isDefined( overrideAttachTag ) || overrideAttachTag == "" ) overrideAttachTag = "atch_tg";

        //Add allowed no attachments
        if ( overrideClassName != "" )
        {            
            dvarName = "attach_allow_" + overrideClassName + "_none";
            addAllowedItem( overrideClassName, "none", dvarName, overrideAttachTag );
        }

        //---- ATTACHMENTS ----

        attachments = tableLookup( "mp/statsTable.csv", 0, weapIndex, 8 );
        //Skip if no attachments data in table
        if( !isdefined( attachments ) || attachments == "" ) continue;
            
        attachmentsNames = strTok( attachments, " " );
        //Skip if something wrong with attachments data
        if( !isDefined( attachmentsNames ) ) continue;
            
        //Only 1 attachment for this weapon
        if ( attachmentsNames.size == 0 )
        {
            dvarName = "attach_allow_" + overrideClassName + "_" + attachments;
            addAllowedItem( overrideClassName, attachments, dvarName, overrideAttachTag );
        }
        //Multiple attachment options
        else
        {
            for( attachIndex = 0; attachIndex < attachmentsNames.size; attachIndex++ )
            {
                dvarName = "attach_allow_" + overrideClassName + "_" + attachmentsNames[attachIndex];
                addAllowedItem( overrideClassName, attachmentsNames[attachIndex], dvarName, overrideAttachTag );
            }
        }
    }
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

        dvarName = undefined;

        //Master Option
        if ( className == "")
        {
            dvarName = "perk_allow_" + perkName;
        }
        else //Class depends perks
        {
            dvarName = "perk_" + className + "_allow_" + perkName;
        }

        addAllowedItem( className, perkName, dvarName, perkGroup + "_tg" );
    }
}


addAllowedItem( className, itemName, dvarName, tag )
{
    //If not class name defined, use value for all classes (master option)
    if ( !isDefined( className ) || className == "" ) className = "*all*";

    itemIndex = level.cacIngame.allowedItems.size;
    level.cacIngame.allowedItems[itemIndex] = spawnStruct();
    level.cacIngame.allowedItems[itemIndex].dvarName = dvarName;
    level.cacIngame.allowedItems[itemIndex].dvarValue = getdvarx( dvarName, "int", 1, 0, 2 );
    level.cacIngame.allowedItems[itemIndex].className = className;
    level.cacIngame.allowedItems[itemIndex].itemName = itemName;
    level.cacIngame.allowedItems[itemIndex].tag = tag;
}


validateAllowedItem( itemName, tag, className )
{
    if ( !isDefined( tag ) || tag == "" ) return itemName;

    firstAllowedItem = undefined;

    for( allowIndex = 0; allowIndex < level.cacIngame.allowedItems.size; allowIndex++ )
    {
        allowedItem = level.cacIngame.allowedItems[allowIndex];

        if ( allowedItem.dvarValue > 0 && allowedItem.className == className && allowedItem.tag == tag )
        {
            if ( !isDefined( firstAllowedItem ) )
            {
                firstAllowedItem = allowedItem;
            }

            if ( allowedItem.itemName == itemName )
            {
                //self iPrintLn( "[CAC Ingame] Allowed item: ref ^2" + itemName + "^7 dvar ^2" + allowedItem.dvarName + "^7 in class ^2" + className + "^7 with tag" + tag );
                return itemName;
            }
        }
    }

    if ( isDefined ( firstAllowedItem ) ) 
    {
        //self iPrintLn( "[CAC Ingame]^1 Not allowed:^7 ref ^2" + itemName + "^7 in class ^2" + className + "^7 with tag ^2" + tag + "^7 changed to ^2" + firstAllowedItem.itemName );
        return firstAllowedItem.itemName;
    }

    //self iPrintLn( "[CAC Ingame] Not stored: ^2" + itemName + "^7 in class ^2" + className + "^7 with tag ^2" + tag );
    return itemName;
}


onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

        player.cacIngame = spawnStruct();
        player.cacIngame.loadoutDataRef = [];
        player.cacIngame.classInfoIndex = 0;
        player.cacIngame.stockResponse = "";

        player thread onMenuResponseThread();
	}
}


prepareAndOpenMenuThread()
{
    for( allowIndex = 0; allowIndex < level.cacIngame.allowedItems.size; allowIndex++ )
    {
        self setClientDvar( level.cacIngame.allowedItems[allowIndex].dvarName, level.cacIngame.allowedItems[allowIndex].dvarValue  );
    
        if ( allowIndex % 10 == 0 && allowIndex > 0 ) 
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

            classInfoIndex = undefined;

            for( i = 0; i < level.cacIngame.classInfo.size; i++ )
            {
                if( level.cacIngame.classInfo[i].stockResponse == response )
                {
                    classInfoIndex = i;
                    break;
                }
            }

            //Override open CAC menu for selected custom class
            if( isDefined( classInfoIndex ) )
            {
                initLoadoutData( classInfoIndex );

                validateLoadoutData();

                self thread prepareAndOpenMenuThread();
                                
                self openMenu( "cac_ingame" );
            }
            else //Othervise stock logic
            {
				self.selectedClass = true;
				self [[level.class]]( response );
            }

            continue;
        } 

        if ( response == "go" && menu == level.cacIngame.menu )
        {
            validateLoadoutData();

            saveLoadoutData();

            self closeMenu();
            self closeInGameMenu();

            self.selectedClass = true;
            self [[level.class]]( self.cacIngame.stockResponse );

            continue;
        }

        if ( response == "validate" && menu == level.cacIngame.menu )
        {
            validateLoadoutData();
        }

        responseTok = strTok( response, ":" );

    	if( isdefined( responseTok ) && responseTok.size == 3 )
		{
            if( responseTok[0] == "set" )
            {
                setLoadoutData( responseTok[1], responseTok[2] );
            }
        }
    }
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
            return int( tableLookup( "mp/statsTable.csv", 4, valueRef, 1 ) ) - 3000;

        case "attachment_table":
            return int( tableLookup( "mp/attachmentTable.csv", 4, valueRef, 9 ) );

        case "camo_table":
            return int( tableLookup( "mp/attachmentTable.csv", 4, valueRef, 11 ) );
    }

    return -1;
}


initLoadoutData( classInfoIndex )
{
    self.cacIngame.classInfoIndex = classInfoIndex;
    self.cacIngame.stockResponse =  level.cacIngame.classInfo[classInfoIndex].stockResponse;

    classStatOffset = level.cacIngame.classInfo[classInfoIndex].statOffset;

    for( i = 0; i < level.cacIngame.itemInfo.size; i++ )
    {
        itemInfo = level.cacIngame.itemInfo[i];

        itemStatValue = self getStat ( classStatOffset + itemInfo.statOffset );
        itemValueRef = getRefByStatValue( itemInfo.tableSource, itemStatValue );

        self.cacIngame.loadoutDataRef[itemInfo.dvarName] = itemValueRef;
        self setClientDvar( itemInfo.dvarName, itemValueRef );
        //self iPrintLn( "[CAC Ingame] Loading: dvar ^2" + itemInfo.dvarName + "^7 value ^2" + itemStatValue + "^7 ref ^2" + itemValueRef );
    }

    self setClientDvars
    (
         "loadout_class_name", level.cacIngame.classInfo[classInfoIndex].name,
         "loadout_class", getPlayerClassName( self.cacIngame.loadoutDataRef["loadout_primary"] )
    );
}


getPlayerClassName( weaponRef )
{
    for( allowIndex = 0; allowIndex < level.cacIngame.allowedItems.size; allowIndex++ )
    {
        allowedItem = level.cacIngame.allowedItems[allowIndex];

        if ( allowedItem.itemName == weaponRef )
        {
            return allowedItem.className;
        }
    }

    return "none";
}


setLoadoutData( dvarName, valueRef )
{
    if( isDefined( self.cacIngame.loadoutDataRef[dvarName] ) )
    {
        self.cacIngame.loadoutDataRef[dvarName] = valueRef;
        //self iPrintLn( "[CAC Ingame] Setting: dvar ^2" + dvarName + "^7  value ^2" + valueRef );
    }
}


saveLoadoutData()
{
    //self iPrintLn( "[CAC Ingame] Save..." );

    classStatOffset = level.cacIngame.classInfo[self.cacIngame.classInfoIndex].statOffset;

    for( i = 0; i < level.cacIngame.itemInfo.size; i++ )
    {
        itemInfo = level.cacIngame.itemInfo[i];
        
        itemValueRef = self.cacIngame.loadoutDataRef[itemInfo.dvarName];
        itemStatValue = getStatValueByRef( itemInfo.tableSource, itemValueRef );

        self setStat ( classStatOffset + itemInfo.statOffset, itemStatValue );
        //self iPrintLn( "[CAC Ingame] (Saving) dvar ^2" + itemInfo.dvarName + "^7 value ^2" + itemStatValue + "^7 ref ^2" + itemValueRef );
    }
}


validateLoadoutData()
{
    className = getPlayerClassName( self.cacIngame.loadoutDataRef["loadout_primary"] );
    //self iPrintLn( "[CAC Ingame] Validating: primary class ^2" + className);

    validateLoadoutItem( className, "primary", "weap_tg" );
    validateLoadoutItem( className, "primary_attachment", "atch_tg" );

    validateLoadoutItem( className, "perk1", "perk1_tg" );
    validateLoadoutItem( className, "perk2", "perk2_tg" );
    validateLoadoutItem( className, "perk3", "perk3_tg" );

    className2 = getPlayerClassName( self.cacIngame.loadoutDataRef["loadout_secondary"] );
    //self iPrintLn( "[CAC Ingame] Validating: secondary class ^2" + className2);

    if ( self.cacIngame.loadoutDataRef["loadout_perk2"] == "specialty_twoprimaries" )
    {
        validateLoadoutItem( className2, "secondary", "weap_tg" );
        validateLoadoutItem( className2, "secondary_attachment", "atch_tg" );
    }
    else
    {
        validateLoadoutItem( "*all*", "secondary", "pist_tg" );
        validateLoadoutItem( "*all*", "secondary_attachment", "pist_atch_tg" );
    }

    validateLoadoutItem( "*all*", "grenade", "gren_tg" );
}

validateLoadoutItem( className, dataType, tag )
{   
    dvarName = "loadout_" + dataType;

    itemValueRef = self.cacIngame.loadoutDataRef[dvarName];
    itemValueRefRaw = itemValueRef;

    itemValueRef = validateAllowedItem( itemValueRef, tag, className );
    itemValueRef = validateAllowedItem( itemValueRef, tag, "*all*" );

    self.cacIngame.loadoutDataRef[dvarName] = itemValueRef;

    self setClientDvar( dvarName, itemValueRef );

    //self iPrintLn( "[CAC Ingame] Validated: ^2" + dvarName + "^7 ref ^2" + itemValueRef + "^7 (from ^2" + itemValueRefRaw + "^7) in class ^2" + className + "^7 with tag ^2" + tag );
}