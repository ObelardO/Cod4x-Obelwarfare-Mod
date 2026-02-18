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

#include openwarfare\_utils;
#include openwarfare\_eventmanager;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                           INGAME CLASS EDITOR                                           //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

init()
{
    level.scr_ice_enabled = getdvarx( "scr_ice_enabled", "int", 0, 0, 1 );

    if( level.scr_ice_enabled == 0 || !level.rankedMatch || level.oldschool || level.console )
        return;

    if( !isDefined( level.cacIngame ) )
    {
        level.cacIngame = spawnStruct();

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
        initItemInfo( 1, "primary", weaponsTableRef );
        initItemInfo( 2, "primary_attachment", attachmentTableRef );
        initItemInfo( 3, "secondary", weaponsTableRef );
        initItemInfo( 4, "secondary_attachment", attachmentTableRef );
        initItemInfo( 5, "perk1", perksTableRef ); // equipment
        initItemInfo( 6, "perk2", perksTableRef ); // weapon
        initItemInfo( 7, "perk3", perksTableRef ); // ability
        initItemInfo( 8, "grenade", weaponsTableRef );
        initItemInfo( 9, "camo", camoTableRef );

        level.cacIngame.allowedItems = [];
        initAllowedItems();

        level.cacIngame.menu = "cac_ingame";
        precacheMenu( level.cacIngame.menu );
    }

    //level thread onPlayerConnecting();
    level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


initClassInfo( classStatOffset, customClassNumber )
{
    index = level.cacIngame.classInfo.size;

    level.cacIngame.classInfo[index] = spawnStruct();
    level.cacIngame.classInfo[index].statOffset = classStatOffset;
    level.cacIngame.classInfo[index].stockResponse = "custom" + customClassNumber + ",0";
    level.cacIngame.classInfo[index].name = "customclass" + customClassNumber;
}


initItemInfo( statOffset, dataType, tableSource )
{
    index = level.cacIngame.itemInfo.size;

    level.cacIngame.itemInfo[index] = spawnStruct();
    level.cacIngame.itemInfo[index].statOffset = statOffset;
    level.cacIngame.itemInfo[index].tableSource = tableSource;
    level.cacIngame.itemInfo[index].dvarName = "loadout_" + dataType;
}


onPlayerConnected()
{
	//for(;;)
	//{
	//	level waittill( "connecting", player );

        self.cacIngame = spawnStruct();
        self.cacIngame.loadoutDataRef = [];
        self.cacIngame.classInfoIndex = 0;
        self.cacIngame.stockResponse = "";

        self openAllClasses();

        //player thread onMenuResponseThread();

        self thread addNewEvent( "onMenuResponse", ::onMenuResponse );

        //self thread prepareAndOpenMenuThread();
	//}
}


prepareAndOpenMenuThread()
{
    self endon("disconnect");

    for( allowIndex = 0; allowIndex < level.cacIngame.allowedItems.size; allowIndex++ )
    {
        self setClientDvar( level.cacIngame.allowedItems[allowIndex].dvarName, level.cacIngame.allowedItems[allowIndex].dvarValue  );
    
        if( allowIndex % 3 == 0 && allowIndex > 0 ) 
        {
            wait 0.05;
        }
    }

    self iPrintLn( "[CAC Ingame] Processed " + level.cacIngame.allowedItems.size + " allowed items" );
}


onMenuResponse( menu, response )
{
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

            //self thread prepareAndOpenMenuThread();
                            
            self openMenu( "cac_ingame" );
        }
        else //Othervise stock logic
        {
            self.selectedClass = true;
            self [[level.class]]( response );
        }

        return;
    } 

    if( response == "go" && menu == level.cacIngame.menu )
    {
        validateLoadoutData();

        saveLoadoutData();

        self closeMenu();
        self closeInGameMenu();

        self.selectedClass = true;
        self [[level.class]]( self.cacIngame.stockResponse );

        return;
    }

    if( response == "validate" )
    {
        validateLoadoutData();
    }

    responseTok = strTok( response, ":" );

    if( isdefined( responseTok ) && responseTok.size == 3 )
    {
        if( responseTok[0] == "set" )
        {
            setLoadoutDataRef( responseTok[1], responseTok[2] );
        }

        if( responseTok[0] == "allow" )
        {
            className = responseTok[1];
            tag = responseTok[2];

            if( isSubStr( tag, "perk" ) )
            {
                if( isSubStr( className, "current" ) )
                {
                    primaryClassName = getPlayerClassName( getLoadoutDataRef( "primary" ) );

                    updateAllowedItems( primaryClassName, tag );

                    if( getLoadoutDataRef("perk2") == "specialty_twoprimaries" )
                    {
                        secondaryClassName = getPlayerClassName( getLoadoutDataRef( "secondary" ) );

                        updateAllowedItems( secondaryClassName, tag, true );
                    }
                }

                if( isSubStr( className, "all" ) )
                {
                    updateAllowedItems( "*all*", tag );
                }
            }
            // if weapon or attachment, only update for current class as they are not used by other classes
            else 
            {
                updateAllowedItems( className, tag );
            }
        }
    }
}

updateAllowedItems( className, tag, updateOnlyNotAllowedItems )
{
    //self endon("disconnect");

    updateOnlyNotAllowedItems = isDefined( updateOnlyNotAllowedItems ) && updateOnlyNotAllowedItems;

    for( allowIndex = 0; allowIndex < level.cacIngame.allowedItems.size; allowIndex++ )
    {
        allowedItem = level.cacIngame.allowedItems[allowIndex];

        if ( updateOnlyNotAllowedItems && allowedItem.dvarValue > 0 ) continue;

        if( allowedItem.className == className && allowedItem.tag == tag )
        {
            self setClientDvar( allowedItem.dvarName, allowedItem.dvarValue );

            debugLog = "[CAC Ingame] Item ^3" + allowedItem.itemName + "^7 in group ^3" + allowedItem.tag + "^7 for class ^3" + className + "^7 is";

            if( allowedItem.dvarValue == 1 )
            {
                debugLog += "^2 allowed";
            }
            else
            {
                debugLog += "^1 NOT allowed";
            }

            self iPrintLn( debugLog );
        }
    }

    //self iPrintLn( "[CAC Ingame] Processed " + level.cacIngame.allowedItems.size + " allowed items" );
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
         "loadout_class", getPlayerClassName( getLoadoutDataRef("primary") )
    );
}


getPlayerClassName( weaponRef )
{
    for( allowIndex = 0; allowIndex < level.cacIngame.allowedItems.size; allowIndex++ )
    {
        allowedItem = level.cacIngame.allowedItems[allowIndex];

        if( allowedItem.itemName == weaponRef )
        {
            return allowedItem.className;
        }
    }

    return "none";
}


setLoadoutDataRef( dataType, valueRef )
{
    dvarName = "loadout_" + dataType;

    if( isDefined( self.cacIngame.loadoutDataRef[dvarName] ) )
    {
        self.cacIngame.loadoutDataRef[dvarName] = valueRef;
        //self iPrintLn( "[CAC Ingame] Setting: dvar ^2" + dvarName + "^7  value ^2" + valueRef );
    }
}


getLoadoutDataRef( dataType )
{
    return self.cacIngame.loadoutDataRef["loadout_" + dataType];
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


openAllClasses()
{
	//If the first custom class is unlocked then in order
	//to display all of the classes in the class selection
	//menu without having to exit game and edit them
	//then we need to unlock them on initialization of the menu
	//so players can edit and then select from any custom class.
	if( self getStat( 210 ) < 1 )
		self setStat( 210, 1 );
	if( self getStat( 220 ) < 1 )
		self setStat( 220, 1 );
	if( self getStat( 230 ) < 1 )
		self setStat( 230, 1 );	
	if( self getStat( 240 ) < 1 )
		self setStat( 240, 1 );		
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                             CLASS VALIDATION                                            //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

initAllowedItems()
{
    initAllowedWeapons( 20,  "assault",     "" );
    initAllowedWeapons( 10,  "specops",     "" );
    initAllowedWeapons( 80,  "heavygunner", "" );
    initAllowedWeapons( 70,  "demolitions", "" );
    initAllowedWeapons( 60,  "sniper",      "" );
    initAllowedWeapons( 0,   "",    "pistol" );
    initAllowedWeapons( 101, "",    "grenade" );

    //
    initAllowedPerks( "" );
    initAllowedPerks( "assault" );
    initAllowedPerks( "specops" );
    initAllowedPerks( "heavygunner" );
    initAllowedPerks( "demolitions" );
    initAllowedPerks( "sniper" );
}


initAllowedWeapons( statOffset, className, overrideClassName )
{
    weaponTag = "weap";
    
    for( weapIndex = statOffset; weapIndex < statOffset + 10; weapIndex++ )
    {
        //Add allowed weapons
        weaponName = tableLookup( "mp/statsTable.csv", 0, weapIndex, 4 );
        if( !isDefined( weaponName ) || weaponName == "" )
            continue;

        if( className == "" )
            dvarName = "weap_allow_" + weaponName;
        else
            dvarName = "weap_allow_" + className + "_" + weaponName;

        addAllowedItem( className + overrideClassName, weaponName, dvarName, weaponTag );
    }

    initAllowedAttachments( statOffset, className + overrideClassName );
}


initAllowedAttachments( statOffset, weaponClass )
{
    attachTag = "atch";

    attachments = tableLookup( "mp/statsTable.csv", 0, statOffset, 8 );
    //Skip if no attachments data in table
    if( !isdefined( attachments ) || attachments == "" ) return;
        
    attachmentsNames = strTok( attachments, " " );
    //Skip if something wrong with attachments data
    if( !isDefined( attachmentsNames ) ) return;

    //Add allowed none attachments
    if( weaponClass != "" )
    {            
        dvarName = "attach_allow_" + weaponClass + "_none";
        addAllowedItem( weaponClass, "none", dvarName, attachTag );
    }
        
    //Only 1 attachment for this weapon
    if( attachmentsNames.size == 0 )
    {
        dvarName = "attach_allow_" + weaponClass + "_" + attachments;
        addAllowedItem( weaponClass, attachments, dvarName, attachTag );
    }

    //Multiple attachment options
    else
    {
        for( attachIndex = 0; attachIndex < attachmentsNames.size; attachIndex++ )
        {
            dvarName = "attach_allow_" + weaponClass + "_" + attachmentsNames[attachIndex];
            addAllowedItem( weaponClass, attachmentsNames[attachIndex], dvarName, attachTag );
        }
    }
}


initAllowedPerks( className )
{
    for( perkIndex = 150; perkIndex < 190; perkIndex++ )
    {
        perkName = tableLookup( "mp/statsTable.csv", 0, perkIndex, 4 );
        if( !isDefined( perkName ) || perkName == "" )
            continue;

        perkGroup = tableLookup( "mp/statsTable.csv", 0, perkIndex, 8 );
        if( !isDefined( perkGroup ) || perkGroup == "" )
            continue;

        dvarName = undefined;

        //Master Option
        if( className == "")
        {
            dvarName = "perk_allow_" + perkName;
        }
        else //Class depends perks
        {
            dvarName = "perk_" + className + "_allow_" + perkName;
        }

        addAllowedItem( className, perkName, dvarName, perkGroup );
    }
}


addAllowedItem( className, itemName, dvarName, tag )
{
    //If not class name defined, use value for all classes (master option)
    if( !isDefined( className ) || className == "" ) className = "*all*";

    itemIndex = level.cacIngame.allowedItems.size;
    level.cacIngame.allowedItems[itemIndex] = spawnStruct();
    level.cacIngame.allowedItems[itemIndex].dvarName = dvarName;
    level.cacIngame.allowedItems[itemIndex].dvarValue = getdvarx( dvarName, "int", 1, 0, 2 );
    level.cacIngame.allowedItems[itemIndex].className = className;
    level.cacIngame.allowedItems[itemIndex].itemName = itemName;
    level.cacIngame.allowedItems[itemIndex].tag = tag;

    //logPrint("[CAC Ingame] Init: class " + className + ", item " + itemName + ", tag " + tag + ", dvar " + dvarName + ", val " + level.cacIngame.allowedItems[itemIndex].dvarValue + "\n");
}


validateAllowedItem( itemName, tag, className )
{
    if( !isDefined( tag ) || tag == "" ) return itemName;

    firstAllowedItem = undefined;

    for( allowIndex = 0; allowIndex < level.cacIngame.allowedItems.size; allowIndex++ )
    {
        allowedItem = level.cacIngame.allowedItems[allowIndex];

        if( allowedItem.dvarValue > 0 && allowedItem.className == className && allowedItem.tag == tag )
        {
            if( !isDefined( firstAllowedItem ) )
            {
                firstAllowedItem = allowedItem;
            }

            if( allowedItem.itemName == itemName )
            {
                //self iPrintLn( "[CAC Ingame] Allowed item: ref ^2" + itemName + "^7 dvar ^2" + allowedItem.dvarName + "^7 in class ^2" + className + "^7 with tag " + tag );
                return itemName;
            }
        }
    }

    if( isDefined ( firstAllowedItem ) ) 
    {
        //self iPrintLn( "[CAC Ingame]^1 Not allowed:^7 ref ^2" + itemName + "^7 in class ^2" + className + "^7 with tag ^2" + tag + "^7 changed to ^2" + firstAllowedItem.itemName );
        return firstAllowedItem.itemName;
    }

    //self iPrintLn( "[CAC Ingame] Not stored: ^2" + itemName + "^7 in class ^2" + className + "^7 with tag ^2" + tag );
    return itemName;
}


validateLoadoutData()
{
    validateLoadoutPrimaryWeapon();

    validateLoadoutSecondaryWeapon();

    validateLoadoutItem( "grenade", "grenade", "weap" );
}


validateLoadoutPrimaryWeapon()
{
    className = getPlayerClassName( getLoadoutDataRef("primary") );
    //self iPrintLn( "[CAC Ingame] Validating: primary class ^2" + className);

    validateLoadoutItem( className, "primary", "weap" );
    validateLoadoutItem( className, "primary_attachment", "atch" );

    validatePerks( className );
}


validateLoadoutSecondaryWeapon()
{
    className = getPlayerClassName( getLoadoutDataRef("secondary") );
    //self iPrintLn( "[CAC Ingame] Validating: secondary class ^2" + className);

    self iPrintLn( "PERK2 IS " + getLoadoutDataRef("perk2"));

    if( getLoadoutDataRef("perk2") == "specialty_twoprimaries" )
    {
        validateLoadoutItem( className, "secondary", "weap" );
        validateLoadoutItem( className, "secondary_attachment", "atch" );

        validatePerks( className );
    }
    else
    {
        validateLoadoutItem( "pistol", "secondary", "weap" );
        validateLoadoutItem( "pistol", "secondary_attachment", "atch" );
    }
}


validatePerks( className )
{
    validateLoadoutItem( className, "perk1", "perk1" );
    validateLoadoutItem( className, "perk2", "perk2" );
    validateLoadoutItem( className, "perk3", "perk3" );
}


validateLoadoutItem( className, dataType, tag )
{   
    dvarName = "loadout_" + dataType;

    itemValueRef = self.cacIngame.loadoutDataRef[dvarName];
    itemValueRefValidated = itemValueRef;

    itemValueRefValidated = validateAllowedItem( itemValueRefValidated, tag, className );
    itemValueRefValidated = validateAllowedItem( itemValueRefValidated, tag, "*all*" );

    self.cacIngame.loadoutDataRef[dvarName] = itemValueRefValidated;

    if( itemValueRef != itemValueRefValidated )
    {
        self setClientDvar( dvarName, itemValueRefValidated );

        debugLog = "[CAC Ingame] Validated: ^2" + dataType + "^7 ref ^2" + itemValueRefValidated + "^7 (from ^1" + itemValueRef + "^7) in class ^2" + className + "^7 with tag ^2" + tag;
    }
    else
    {
        debugLog = "[CAC Ingame] Validated: ^2" + dataType + "^7 ref ^2" + itemValueRefValidated + "^7 (from ^2" + itemValueRef + "^7) in class ^2" + className + "^7 with tag ^2" + tag;
    }

    self iPrintLn( debugLog );
}


validateLoadoutPerk1Special( dataType )
{
    dvarName = "loadout_" + dataType;

    switch ( self.cacIngame.loadoutDataRef[dvarName] )
    {
        case "gl": case "grip":
            self.cacIngame.loadoutDataRef["loadout_perk1"] = "specialty_null"; break;
    }
}