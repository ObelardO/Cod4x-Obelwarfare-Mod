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
        initItemInfo( 1, "primary", weaponsTableRef, "weap" );
        initItemInfo( 2, "primary_attachment", attachmentTableRef, "attach" );
        initItemInfo( 3, "secondary", weaponsTableRef, "weap" );
        initItemInfo( 4, "secondary_attachment", attachmentTableRef, "attach" );
        initItemInfo( 5, "perk1", perksTableRef, "perk1" ); // equipment
        initItemInfo( 6, "perk2", perksTableRef, "perk2" ); // weapon
        initItemInfo( 7, "perk3", perksTableRef, "perk3" ); // ability
        initItemInfo( 8, "grenade", weaponsTableRef, "weap" );
        initItemInfo( 9, "camo", camoTableRef, "" );

        level.cacIngame.allowedItems = [];
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


initItemInfo( statOffset, dataType, tableSource, tag ) //, weaponId, weaponCount )
{
    index = level.cacIngame.itemInfo.size;

    level.cacIngame.itemInfo[index] = spawnStruct();
    level.cacIngame.itemInfo[index].statOffset = statOffset;
    //level.cacIngame.itemInfo[index].dataType = dataType;
    level.cacIngame.itemInfo[index].tableSource = tableSource;
    level.cacIngame.itemInfo[index].dvarName = "loadout_" + dataType;
    level.cacIngame.itemInfo[index].tag = tag;
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

        addAllowedItem( className, weaponName, dvarName, "weap" );

        //---- NO ATTACHMENTS ----

        if ( !isDefined( attachName ) || attachName == "" )
        {
            attachName = className;
        }

        //Add allowed no attachments
        if ( attachName != "" )
        {            
            dvarName = "attach_allow_" + attachName + "_none";
            addAllowedItem( className, "none", dvarName, "attach" );
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
            addAllowedItem( attachName, attachments, dvarName, "attach" );
        }
        //Multiple attachment options
        else
        {
            for( attachIndex = 0; attachIndex < attachmentsNames.size; attachIndex++ )
            {
                dvarName = "attach_allow_" + attachName + "_" + attachmentsNames[attachIndex];
                addAllowedItem( attachName, attachmentsNames[attachIndex], dvarName, "attach" );
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

        addAllowedItem( className, perkName, dvarName, perkGroup );
    }
}


addAllowedItem( className, itemName, dvarName, tag )
{
    itemIndex = level.cacIngame.allowedItems.size;
    level.cacIngame.allowedItems[itemIndex] = spawnStruct();
    level.cacIngame.allowedItems[itemIndex].dvarName = dvarName;
    level.cacIngame.allowedItems[itemIndex].dvarValue = getdvarx( dvarName, "int", 1, 0, 2 );
    level.cacIngame.allowedItems[itemIndex].className = className;
    level.cacIngame.allowedItems[itemIndex].itemName = itemName;
    level.cacIngame.allowedItems[itemIndex].tag = tag;
}


validateAllowedItem( itemName, tag )
{
    if ( !isDefined( tag ) || tag == "" ) return itemName;

    firstAllowedItem = undefined;

    for( allowIndex = 0; allowIndex < level.cacIngame.allowedItems.size; allowIndex++ )
    {
        allowedItem = level.cacIngame.allowedItems[allowIndex];

        //TODO: Add className check

        if ( allowedItem.dvarValue > 0 && allowedItem.tag == tag )
        {
            if ( !isDefined( firstAllowedItem ) )
            {
                firstAllowedItem = allowedItem;
            }

            if ( allowedItem.itemName == itemName )
            {
                return itemName;
            }
        }
    }

    if ( isDefined ( firstAllowedItem ) ) return firstAllowedItem.itemName;

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
            saveLoadoutData();

            //self iPrintLn( "[CAC Ingame] Go!" );

            self closeMenu();
            self closeInGameMenu();

            self.selectedClass = true;
            self [[level.class]]( self.cacIngame.stockResponse );

            continue;
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
    //self iPrintLn( "[CAC Ingame] Load..." );

    self.cacIngame.classInfoIndex = classInfoIndex;
    self.cacIngame.stockResponse =  level.cacIngame.classInfo[classInfoIndex].stockResponse;

    classStatOffset = level.cacIngame.classInfo[classInfoIndex].statOffset;

    self setClientDvar( "loadout_class_name", level.cacIngame.classInfo[classInfoIndex].name );

    for( i = 0; i < level.cacIngame.itemInfo.size; i++ )
    {
        itemInfo = level.cacIngame.itemInfo[i];

        itemStatValue = self getStat ( classStatOffset + itemInfo.statOffset );
        itemValueRef = getRefByStatValue( itemInfo.tableSource, itemStatValue );

        itemValueRefRaw = itemValueRef;
        itemValueRef = validateAllowedItem ( itemValueRef, itemInfo.tag );

        self.cacIngame.loadoutDataRef[itemInfo.dvarName] = itemValueRef;
        self setClientDvar( itemInfo.dvarName, itemValueRef );
        ////self iPrintLn( "[CAC Ingame] (Loading). dvar: ^2" + itemInfo.dvarName + "^7 value: ^2" + itemStatValue + "^7 ref: ^2" + itemValueRef );
        self iPrintLn( "[CAC Ingame] I ^2" + itemInfo.dvarName + "^7 ref: ^2" + itemValueRef + "^7 (" + itemValueRefRaw + ")" + itemInfo.tag );
    }
}


setLoadoutData( dvarName, valueRef )
{
    if( isDefined( self.cacIngame.loadoutDataRef[dvarName] ) )
    {
        //itemValueRef = 

        self.cacIngame.loadoutDataRef[dvarName] = valueRef;

        //self iPrintLn( "[CAC Ingame] (Setting). dvar: ^2" + dvarName + "^7  value: ^2" + valueRef );
    }
}


saveLoadoutData()
{
    //self iPrintLn( "[CAC Ingame] Save..." );

    classStatOffset = level.cacIngame.classInfo[self.cacIngame.classInfoIndex].statOffset;

    for( i = 0; i < level.cacIngame.itemInfo.size; i++ )
    {
        itemInfo = level.cacIngame.itemInfo[i];

        itemValueRefRaw = self.cacIngame.loadoutDataRef[itemInfo.dvarName];
        itemValueRef = validateAllowedItem( itemValueRefRaw, itemInfo.tag );
        itemStatValue = getStatValueByRef( itemInfo.tableSource, itemValueRef );

        self setStat ( classStatOffset + itemInfo.statOffset, itemStatValue );
        ////self iPrintLn( "[CAC Ingame] (Saving) dvar: ^2" + itemInfo.dvarName + "^7 value: ^2" + itemStatValue + "^7 ref: ^2" + itemValueRef );
        self iPrintLn( "[CAC Ingame] S ^2" + itemInfo.dvarName + "^7 ref: ^2" + itemValueRef + "^7 (" + itemValueRefRaw + ") " + itemInfo.tag  );
    }
}