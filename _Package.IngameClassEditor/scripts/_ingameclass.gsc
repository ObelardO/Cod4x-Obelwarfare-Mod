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

//Entry point, initialize variables and register events
init()
{
    //Master enable/disable for ingame class editor, if disabled then everything related to it will be skipped and default game behavior will be used
    level.scr_ice_enabled = getdvarx( "scr_ice_enabled", "int", 0, 0, 1 );

    //Disable in non ranked matches, console and oldschool mode (because of custom class stat overrides that can cause issues with those modes)
    if( level.scr_ice_enabled == 0 || !level.rankedMatch || level.oldschool || level.console )
        return;

    //Initialize ingame class editor data once
    if( !isDefined( level.cacIngame ) )
    {
        //Base module struct
        level.cacIngame = spawnStruct();

        //References to stock tables
        perksTableRef = "perks_table";
        weaponsTableRef = "weapons_table";
        attachmentTableRef = "attachment_table";
        camoTableRef = "camo_table";

        //Initialize custom class info with corresponding stat offsets and stock response for each custom class
        //Used to determine which custom class is being edited based on menu response and to save the loadout data to correct stat offsets when selecting a custom class
        level.cacIngame.classInfo = [];
        initClassInfo( 200, "1" );
        initClassInfo( 210, "2" );
        initClassInfo( 220, "3" );
        initClassInfo( 230, "4" );
        initClassInfo( 240, "5" );

        //Initialize item info with corresponding stat offsets and data types for each item in the loadout (primary, secondary, attachments, perks, etc)
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

        //Initialize allowed items list that will be used for validating loadout selections and updating allowed items in UI based on selected weapons and perks
        initAllowedItems();

        //Precache menu used for editing custom classes loadout
        level.cacIngame.menu = "ice_main";
        precacheMenu( level.cacIngame.menu );
    }

    //Register event for player connection to initialize ingame class editor data for each player
    level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

//Fill class info struct with stat offset and stock response
initClassInfo( classStatOffset, customClassNumber )
{
    index = level.cacIngame.classInfo.size;

    level.cacIngame.classInfo[index] = spawnStruct();
    level.cacIngame.classInfo[index].statOffset = classStatOffset;
    level.cacIngame.classInfo[index].stockResponse = "custom" + customClassNumber + ",0";
    level.cacIngame.classInfo[index].name = "customclass" + customClassNumber;
}

//Fill item info struct with stat offset, data type and reference to correct stock table for each editable item in the loadout
initItemInfo( statOffset, dataType, tableSource )
{
    index = level.cacIngame.itemInfo.size;

    level.cacIngame.itemInfo[index] = spawnStruct();
    level.cacIngame.itemInfo[index].statOffset = statOffset;
    level.cacIngame.itemInfo[index].tableSource = tableSource;
    level.cacIngame.itemInfo[index].dvarName = "loadout_" + dataType;
}

//Initialize player specific data and register menu response event for handling menu interactions
onPlayerConnected()
{
    //Base module struct for player specific data
    self.cacIngame = spawnStruct();
    self.cacIngame.loadoutDataRef = [];
    self.cacIngame.classInfoIndex = 0;
    self.cacIngame.stockResponse = "";

    //Open all classes for player so they can be edited and selected without having to exit game and edit them in create a class menu
    self openAllClasses();

    //Start listening to menu responses
    self thread addNewEvent( "onMenuResponse", ::onMenuResponse );
}

//Handle menu responses for opening class selection menu, saving loadout and selecting class
onMenuResponse( menu, response )
{
    //Debug
    //self iprintLn( "RAW RES: " + response + " from " + menu );

    //Hook into class selection menu response to open create a class menu when selecting class
    if( menu == game["menu_changeclass"] && response != "back" )
    {
        self closeMenu();
        self closeInGameMenu();

        classInfoIndex = undefined;

        //Determine if selected class is one of the custom classes
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
            //Read loadout data from stats
            initLoadoutData( classInfoIndex );

            //First pre-validation because player can set not allowed weapons or perks in main menu
            validateLoadoutData();

            //Open custom create a class menu
            self openMenu( level.cacIngame.menu );
        }
        //Othervise stock logic (default class selected)
        else
        {
            self.selectedClass = true;
            self [[level.class]]( response );
        }

        return;
    } 

    //Ignore all other responses that are not from create a class menu
    if ( isStrStart( response, "ice_" ) )
    {
        response = getSubStr( response, 4, response.size ); //Remove "ice_" prefix from response to separate it from stock responses and identify it as coming from ingame class editor menu
    }
    else
    {
        return;
    }

    //Create a class menu responses: editing done, start game with selected class and loadout
    if( response == "go" )
    {
        //Final vaildation (client can cheat with dvars so validate everything)
        validateLoadoutData();

        //Save loadout data to stats (directly to player profile)
        saveLoadoutData();

        //Close cteate a class menu
        self closeMenu();
        self closeInGameMenu();

        //Stock logic. Class edited and saved so we can emulate selecting a custom class by sending stock response for it
        self.selectedClass = true;
        self [[level.class]]( self.cacIngame.stockResponse );

        return;
    }

    //Update which weapon classes may be picked as the overkill second primary
    if ( response == "allow:secondary" )
    {
        self pushOverkillMask();

        return;
    }

    //Split response into tokens to determine action, data type and value reference
    responseTok = strTok( response, ":" );

    //Some menu callbacks for updating elements
    if( isdefined( responseTok ) && responseTok.size == 3 )
    {
        switch( responseTok[0] )
        {
            //Set loadout item (without validation)
            case "set":

                dataType = responseTok[1];
                valueRef = responseTok[2];

                setLoadoutDataRef( dataType, valueRef );

                break;

            //Validate special cases (specialty_twoprimaries perk... is ****ing up the logic a bit so need to validate when primary or secondary weapon is changed)
            case "validate":

                weaponSlot = responseTok[1]; //primary or secondary
                className = responseTok[2];

                validateLoadoutWeaponSpecialCases( className, weaponSlot );

                break;

            //Update allowed items in UI based on weapon class and item type (perk, weapon or attachment)
            case "allow":

                className = responseTok[1];
                itemType = responseTok[2];

                updateAllowedItemsInMenu( className, itemType );

                break;
        }
    }
}

//Get string reference of item based on table source and stats value (index in table). Columnes are hardcoded
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

//Get stats value (index in table) based on table source and string reference of item. Columnes are hardcoded
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

//Load loadout data from player's profile custom class and initialize dvars for menu based on that data
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
         "loadout_class", getPlayerClassName( getLoadoutDataRef("primary") ),
         "loadout_class_secondary", getPlayerClassName( getLoadoutDataRef("secondary") )
    );

    self pushOverkillMask();
}

//Get weapon class name (assault, specops, heavygunner, demolitions or sniper) based on weapon reference and allowed items list
getPlayerClassName( weaponRef )
{
    //Direct lookup by weapon name using helper array - O(1) instead of O(n)
    if( isDefined( level.cacIngame.weaponClassByWeaponRef[weaponRef] ) )
    {
        return level.cacIngame.weaponClassByWeaponRef[weaponRef];
    }

    return "none";
}

//Set loadout value (string reference) for data type (primary, secondary, perk1, perk2, perk3, etc)
setLoadoutDataRef( dataType, valueRef )
{
    dvarName = "loadout_" + dataType;

    if( isDefined( self.cacIngame.loadoutDataRef[dvarName] ) )
    {
        self.cacIngame.loadoutDataRef[dvarName] = valueRef;
        //self iPrintLn( "[CAC Ingame] Setting: dvar ^2" + dvarName + "^7  value ^2" + valueRef );
    }
}

//Get loadout value (string reference) for data type (primary, secondary, perk1, perk2, perk3, etc)
getLoadoutDataRef( dataType )
{
    return self.cacIngame.loadoutDataRef["loadout_" + dataType];
}

//Save loadout data from dvars to player profile custom class
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

//Unlock all custom classes if not unlocked to allow players to edit and select them without
openAllClasses()
{
	//If the first custom class is unlocked then in order
	//to display all of the classes in the class selection
	//menu without having to exit game and edit them
	//then we need to unlock them on initialization of the menu
	//so players can edit and then select from any custom class.
	if( self getStat( 210 ) < 1 ) self setStat( 210, 1 );
	if( self getStat( 220 ) < 1 ) self setStat( 220, 1 );
	if( self getStat( 230 ) < 1 ) self setStat( 230, 1 );	
	if( self getStat( 240 ) < 1 ) self setStat( 240, 1 );		
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                             CLASS VALIDATION                                            //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Initialize allowed items list based on dvars values
initAllowedItems()
{
    level.cacIngame.allowedItems = [];
    level.cacIngame.allowedItemsIndexesLookup = [];    //Helper index arrays: [className][itemType] = [indexes]
    level.cacIngame.weaponClassByWeaponRef = [];         //Helper direct lookup for weapons only: [weaponName] = className

    //Initialize allowed weapons (primary weapons and attachments for each weapon class and pistols and grenades))
    initAllowedWeapons( 20,  "assault",     "" );
    initAllowedWeapons( 10,  "specops",     "" );
    initAllowedWeapons( 80,  "heavygunner", "" );
    initAllowedWeapons( 70,  "demolitions", "" );
    initAllowedWeapons( 60,  "sniper",      "" );
    initAllowedWeapons( 0,   "",    "pistol" );
    initAllowedWeapons( 101, "",    "grenade" );

    //Initialize allowed perks for each weapon class (and master option for all classes)
    initAllowedPerks( "" );
    initAllowedPerks( "assault" );
    initAllowedPerks( "specops" );
    initAllowedPerks( "heavygunner" );
    initAllowedPerks( "demolitions" );
    initAllowedPerks( "sniper" );
}

//Initialize allowed weapons in weapon class
initAllowedWeapons( statOffset, className, overrideClassName )
{
    //Item type for global allowed items list
    weaponItemType = "weap";
    
    //Read all weapon names from stock table
    for( weapIndex = statOffset; weapIndex < statOffset + 10; weapIndex++ )
    {
        //Add allowed weapons
        weaponName = tableLookup( "mp/statsTable.csv", 0, weapIndex, 4 );
        if( !isDefined( weaponName ) || weaponName == "" )
            continue;

        //If class name is not defined then it's master option for all classes (also pistols and grenades for all classes)
        if( className == "" )
            dvarName = "weap_allow_" + weaponName;
        else
            dvarName = "weap_allow_" + className + "_" + weaponName;

        //Bit is the stats row inside this class block. The menu shifts by the same index.
        storedClass = className + overrideClassName;
        addAllowedItem( storedClass, weaponName, dvarName, weaponItemType, "ui_ice_allow_" + storedClass, weapIndex - statOffset );
    }

    //Initialize allowed attachments for each weapon in weapon class
    initAllowedAttachments( statOffset, className + overrideClassName );
}

//Initialize allowed attachments for weapon class (each weapon class has unified attachments list for all weapons in that class)
initAllowedAttachments( statOffset, weaponClass )
{
    //Item type for global allowed items list
    attachItemType = "atch";

    //Add allowed none attachments (weapon without attachments)
    if( weaponClass != "" )
    {            
        dvarName = "attach_allow_" + weaponClass + "_none";
        addAllowedItem( weaponClass, "none", dvarName, attachItemType, "ui_ice_allow_" + weaponClass + "_atch", attachmentMaskBit( "none" ) );
    }

    //Get attachment names from stock table for weapon class
    attachments = tableLookup( "mp/statsTable.csv", 0, statOffset, 8 );
    //Skip if no attachments data in table
    if( !isdefined( attachments ) || attachments == "" ) return;
    
    //Split attachment names into array
    attachmentsNames = strTok( attachments, " " );
    //Skip if something wrong with attachments data
    if( !isDefined( attachmentsNames ) ) return;
        
    //Weapon has only one attachment option
    if( attachmentsNames.size == 0 )
    {
        dvarName = "attach_allow_" + weaponClass + "_" + attachments;
        addAllowedItem( weaponClass, attachments, dvarName, attachItemType, "ui_ice_allow_" + weaponClass + "_atch", attachmentMaskBit( attachments ) );
    }
    //Weapon has multiple attachment options
    else
    {
        for( attachIndex = 0; attachIndex < attachmentsNames.size; attachIndex++ )
        {
            dvarName = "attach_allow_" + weaponClass + "_" + attachmentsNames[attachIndex];
            addAllowedItem( weaponClass, attachmentsNames[attachIndex], dvarName, attachItemType, "ui_ice_allow_" + weaponClass + "_atch", attachmentMaskBit( attachmentsNames[attachIndex] ) );
        }
    }
}

//Initialize allowed perks for weapon class and master option for all classes
initAllowedPerks( className )
{
    //Bit 0 is the first perk of each group in statsTable order. A group holds at most 15.
    perkBits = [];
    perkBits["perk1"] = 0;
    perkBits["perk2"] = 0;
    perkBits["perk3"] = 0;

    //Read all perk names and groups from stock table
    for( perkIndex = 150; perkIndex < 190; perkIndex++ )
    {
        //Skip if empty perk name line
        perkName = tableLookup( "mp/statsTable.csv", 0, perkIndex, 4 );
        if( !isDefined( perkName ) || perkName == "" )
            continue;

        //Skip if empty perk group (perk1, perk2 or perk3)
        perkGroup = tableLookup( "mp/statsTable.csv", 0, perkIndex, 8 );
        if( !isDefined( perkGroup ) || perkGroup == "" )
            continue;

        maskBit = perkBits[perkGroup];
        if ( maskBit < 15 )
            perkBits[perkGroup] = maskBit + 1;
        else
            maskBit = -1;

        dvarName = undefined;
        maskDvar = undefined;

        //Perk with no class dependency, use master option for all classes
        if( className == "")
        {
            dvarName = "perk_allow_" + perkName;
            maskDvar = "ui_ice_allow_" + perkGroup;
        }
        //Perk with class dependency, use class specific dvar
        else 
        {
            dvarName = "perk_" + className + "_allow_" + perkName;
            maskDvar = "ui_ice_class_" + perkGroup;
        }

        //Add allowed perk to the global allowed items list
        addAllowedItem( className, perkName, dvarName, perkGroup, maskDvar, maskBit );
    }
}

//Add item to the global allowed items list
addAllowedItem( className, itemName, dvarName, itemType, maskDvar, maskBit )
{
    //If not class name defined, use value for all classes (master option)
    if( !isDefined( className ) || className == "" ) className = "*all*";

    //Store allowed item info
    itemIndex = level.cacIngame.allowedItems.size;
    level.cacIngame.allowedItems[itemIndex] = spawnStruct();
    level.cacIngame.allowedItems[itemIndex].dvarName = dvarName;
    level.cacIngame.allowedItems[itemIndex].dvarValue = getdvarx( dvarName, "int", 1, 0, 2 );
    level.cacIngame.allowedItems[itemIndex].className = className;
    level.cacIngame.allowedItems[itemIndex].itemName = itemName;
    level.cacIngame.allowedItems[itemIndex].itemType = itemType;
    level.cacIngame.allowedItems[itemIndex].maskDvar = maskDvar;
    level.cacIngame.allowedItems[itemIndex].maskBit = maskBit;

    //Add index to helper lookup arrays for fast searching without loops
    if( !isDefined( level.cacIngame.allowedItemsIndexesLookup[className] ) )
        level.cacIngame.allowedItemsIndexesLookup[className] = [];

    if( !isDefined( level.cacIngame.allowedItemsIndexesLookup[className][itemType] ) )
        level.cacIngame.allowedItemsIndexesLookup[className][itemType] = [];

    lookupIndex = level.cacIngame.allowedItemsIndexesLookup[className][itemType].size;
    level.cacIngame.allowedItemsIndexesLookup[className][itemType][lookupIndex] = itemIndex;

    //Direct weapon lookup by name for O(1) class search
    if( itemType == "weap" )
        level.cacIngame.weaponClassByWeaponRef[itemName] = className;

    //logPrint("[CAC Ingame] Init: class " + className + ", item " + itemName + ", itemType " + itemType + ", dvar " + dvarName + ", val " + level.cacIngame.allowedItems[itemIndex].dvarValue + "\n");
}

//Get allowed items indexes in global allowed items list for weapon class and item type from helper lookup array
getAllowedItemsIndexes( className, itemType )
{
    classLookup = level.cacIngame.allowedItemsIndexesLookup[className];
    if( !isDefined( classLookup ) ) return undefined;

    return classLookup[itemType];
}

//Update allowed items in UI based on weapon class and item type (perk, weapon or attachment) 
//className can be specific weapon class (assault, specops, etc), "current" for current primary weapon class or "all" for all classes (master option)
updateAllowedItemsInMenu( className, itemType )
{
    //Update allowed perks in UI based on weapon class and perk group (perk1, perk2 or perk3)
    if( isSubStr( itemType, "perk" ) )
    {
        isCurrentClass = isSubStr( className, "current" );
        isAllClasses = isSubStr( className, "all" );

        //Class mask for the open perk group. Overkill folds the second weapon class into the same bits.
        if( isCurrentClass )
        {
            self pushPerkClassMask( getPlayerClassName( getLoadoutDataRef( "primary" ) ), itemType );
        }

        //Global server rule for this perk group
        if( isAllClasses )
        {
            self pushAllowMask( "*all*", itemType );
        }

        //Update perks allowed state for specific weapon class (not used because isCurrentClass is used instead)
        if( !isCurrentClass && !isAllClasses )
        {
            self pushPerkClassMask( className, itemType );
        }
    }
    //Update allowed weapons or attachments in UI based on weapon class
    else 
    {
        self pushAllowMask( className, itemType );
    }
}

//Value of one bit. Script has no shift operator, so bit 0 is 1 and each next bit doubles.
maskBitValue( bit )
{
    value = 1;

    for ( i = 0; i < bit; i++ )
        value = value * 2;

    return value;
}

//attachmentTable column 9. none is 0, matching NUM_NONE in the menu.
attachmentMaskBit( attachmentName )
{
    return int( tableLookup( "mp/attachmentTable.csv", 4, attachmentName, 9 ) );
}

//Find one allowed item by class, type and reference
getAllowedItemByName( className, itemType, itemName )
{
    allowedItemsIndexes = getAllowedItemsIndexes( className, itemType );
    if ( !isDefined( allowedItemsIndexes ) )
        return undefined;

    for ( i = 0; i < allowedItemsIndexes.size; i++ )
    {
        allowedItem = level.cacIngame.allowedItems[ allowedItemsIndexes[i] ];

        if ( allowedItem.itemName == itemName )
            return allowedItem;
    }

    return undefined;
}

//Pack every item in this class and type into its mask dvar. Bit 1 means the server allows it.
pushAllowMask( className, itemType )
{
    allowedItemsIndexes = getAllowedItemsIndexes( className, itemType );
    if ( !isDefined( allowedItemsIndexes ) )
        return;

    mask = 0;
    maskDvar = undefined;

    for ( i = 0; i < allowedItemsIndexes.size; i++ )
    {
        allowedItem = level.cacIngame.allowedItems[ allowedItemsIndexes[i] ];

        if ( !isDefined( maskDvar ) )
            maskDvar = allowedItem.maskDvar;

        if ( !isDefined( allowedItem.maskBit ) || allowedItem.maskBit < 0 )
            continue;

        if ( allowedItem.dvarValue > 0 )
            mask = mask + maskBitValue( allowedItem.maskBit );
    }

    if ( isDefined( maskDvar ) )
        self setClientDvar( maskDvar, mask );
}

//Class perk mask for the primary weapon. With overkill, a perk bit stays set only when the second weapon class allows it too.
pushPerkClassMask( primaryClass, perkGroup )
{
    allowedItemsIndexes = getAllowedItemsIndexes( primaryClass, perkGroup );
    if ( !isDefined( allowedItemsIndexes ) )
        return;

    secondaryClass = undefined;
    if ( getLoadoutDataRef( "perk2" ) == "specialty_twoprimaries" )
        secondaryClass = getPlayerClassName( getLoadoutDataRef( "secondary" ) );

    mask = 0;
    maskDvar = undefined;

    for ( i = 0; i < allowedItemsIndexes.size; i++ )
    {
        allowedItem = level.cacIngame.allowedItems[ allowedItemsIndexes[i] ];

        if ( !isDefined( maskDvar ) )
            maskDvar = allowedItem.maskDvar;

        if ( !isDefined( allowedItem.maskBit ) || allowedItem.maskBit < 0 )
            continue;

        allowed = allowedItem.dvarValue > 0;

        if ( allowed && isDefined( secondaryClass ) && secondaryClass != "" && secondaryClass != "none" )
        {
            secondaryItem = getAllowedItemByName( secondaryClass, perkGroup, allowedItem.itemName );

            if ( isDefined( secondaryItem ) && secondaryItem.dvarValue <= 0 )
                allowed = false;
        }

        if ( allowed )
            mask = mask + maskBitValue( allowedItem.maskBit );
    }

    if ( isDefined( maskDvar ) )
        self setClientDvar( maskDvar, mask );
}

//One bit per weapon class, in class-popup order: assault, specops, heavygunner, demolitions, sniper.
pushOverkillMask()
{
    classNames = [];
    classNames[0] = "assault";
    classNames[1] = "specops";
    classNames[2] = "heavygunner";
    classNames[3] = "demolitions";
    classNames[4] = "sniper";

    mask = 0;

    for ( i = 0; i < classNames.size; i++ )
    {
        allowedItem = getAllowedItemByName( classNames[i], "perk2", "specialty_twoprimaries" );

        if ( isDefined( allowedItem ) && allowedItem.dvarValue > 0 )
            mask = mask + maskBitValue( i );
    }

    self setClientDvar( "ui_ice_overkill", mask );
}

//Validate all loadout data (primary and secondary weapon, attachments, perks and grenade)
//Used for first validation when opening create a class menu and final validation when saving loadout and starting game to prevent cheating with dvars
validateLoadoutData()
{
    validateLoadoutPrimaryWeapon();

    validateLoadoutSecondaryWeapon();

    validateLoadoutItem( "grenade", "grenade", "weap" );

    validateLoadoutPerk1SpecialCases( "primary_attachment" );
}

//Validate primary weapon and attachments based on weapon class 
//and update perks if some perks are not allowed with selected primary weapon class
validateLoadoutPrimaryWeapon()
{
    className = getPlayerClassName( getLoadoutDataRef("primary") );
    //self iPrintLn( "[CAC Ingame] Validating: primary class ^2" + className);

    validateLoadoutItem( className, "primary", "weap" );
    validateLoadoutItem( className, "primary_attachment", "atch" );

    validateLoadoutClassPerks( className );
}

//Validate secondary weapon and attachments based on weapon class and specialty_twoprimaries perk 
//and update perks if some perks are not allowed with selected secondary weapon class 
validateLoadoutSecondaryWeapon()
{
    className = getPlayerClassName( getLoadoutDataRef("secondary") );
    //self iPrintLn( "[CAC Ingame] Validating: secondary class ^2" + className);

    if( getLoadoutDataRef("perk2") == "specialty_twoprimaries" )
    {
        validateLoadoutItem( className, "secondary", "weap" );
        validateLoadoutItem( className, "secondary_attachment", "atch" );

        validateLoadoutClassPerks( className );
    }
    else
    {
        validateLoadoutItem( "pistol", "secondary", "weap" );
        validateLoadoutItem( "pistol", "secondary_attachment", "atch" );
    }
}

//Validate weapons cases based on specialty_twoprimaries perk

validateLoadoutWeaponSpecialCases( className, weaponSlot )
{
    //We can easily update all class and it will be work correctly
    //but for some optimization we will update only one weapon slot for specialty_twoprimaries perk special case
    //validateLoadoutData(); DISABLED

    //Reset secondary weapon to first allowed pistol if perk specialty_twoprimaries is not allowed with this primary weapon or not selected
    //and secondary weapon is not a pistol. Also reset secondary weapon attachments because they may be not valid for pistols
    if ( weaponSlot == "primary" )
    {
        validateLoadoutItem( className, "perk2", "perk2" );

        if( getLoadoutDataRef("perk2") != "specialty_twoprimaries" )
        {
            validateLoadoutItem( "pistol", "secondary", "weap" );
            validateLoadoutItem( "pistol", "secondary_attachment", "atch" );
        }
    }
    //Validate secondary weapon to first allowed in weapon class
    //Update perks if secondary weapon not a pistol and perk specialty_twoprimaries is selected
    else if ( weaponSlot == "secondary" )
    {
        validateLoadoutItem( className, "secondary", "weap" );
        validateLoadoutItem( className, "secondary_attachment", "atch" );

        if( getLoadoutDataRef("perk2") == "specialty_twoprimaries" )
        {
            validateLoadoutClassPerks( className );
        }
    }
}

//Validate perks based on primary weapon class (and secondary weapon class if specialty_twoprimaries perk is selected)
validateLoadoutPerks()
{
    primaryClassName = getPlayerClassName( getLoadoutDataRef("primary") );
    validateLoadoutClassPerks( primaryClassName );

    if( getLoadoutDataRef("perk2") == "specialty_twoprimaries" )
    {
        secondaryClassName = getPlayerClassName( getLoadoutDataRef("secondary") );
        validateLoadoutClassPerks( secondaryClassName );
    }
}

//Validate all perks based on weapon class
validateLoadoutClassPerks( className )
{
    validateLoadoutItem( className, "perk1", "perk1" );
    validateLoadoutItem( className, "perk2", "perk2" );
    validateLoadoutItem( className, "perk3", "perk3" );
}

//Validate item in loadout based on weapon class
validateLoadoutItem( className, dataType, itemType )
{   
    dvarName = "loadout_" + dataType;

    itemValueRef = self.cacIngame.loadoutDataRef[dvarName];
    itemValueRefValidated = itemValueRef;

    //First iteraton: validate based on weapon class 
    itemValueRefValidated = validateAllowedItem( itemValueRefValidated, itemType, className );
    //Second iteration: validate based on master option for all classes to override class specific options
    itemValueRefValidated = validateAllowedItem( itemValueRefValidated, itemType, "*all*" );

    self.cacIngame.loadoutDataRef[dvarName] = itemValueRefValidated;

    //Update client dvar if value was changed after validation
    if( itemValueRef != itemValueRefValidated )
    {
        self setClientDvar( dvarName, itemValueRefValidated );

        debugLog = "[CAC Ingame] Validated: ^2" + dataType + "^7 ref ^2" + itemValueRefValidated + "^7 (from ^1" + itemValueRef + "^7) in class ^2" + className + "^7 with itemType ^2" + itemType;
    }
    else
    {
        debugLog = "[CAC Ingame] Validated: ^2" + dataType + "^7 ref ^2" + itemValueRefValidated + "^7 (from ^2" + itemValueRef + "^7) in class ^2" + className + "^7 with itemType ^2" + itemType;
    }

    //self iprintLn( debugLog );
}

//Get validted item reference based on allowed items list, weapon class and item type (perk, weapon or attachment)
//If item is not allowed then it will be replaced with first allowed item in weapon class
validateAllowedItem( itemName, itemType, className )
{
    if( !isDefined( itemType ) || itemType == "" ) return itemName;

    //Use helper index array - O(m) where m is items in class+itemType, not O(n)
    allowedItemsIndexes = getAllowedItemsIndexes( className, itemType );
    if( !isDefined( allowedItemsIndexes ) ) return itemName;

    firstAllowedItem = undefined;

    for( i = 0; i < allowedItemsIndexes.size; i++ )
    {
        allowedItemIndex = allowedItemsIndexes[i];
        allowedItem = level.cacIngame.allowedItems[allowedItemIndex];

        if( allowedItem.dvarValue > 0 )
        {
            if( !isDefined( firstAllowedItem ) )
            {
                firstAllowedItem = allowedItem;
            }

            if( allowedItem.itemName == itemName )
            {
                //self iPrintLn( "[CAC Ingame] Allowed item: ref ^2" + itemName + "^7 dvar ^2" + allowedItem.dvarName + "^7 in class ^2" + className + "^7 with itemType " + itemType );
                return itemName;
            }
        }
    }

    if( isDefined( firstAllowedItem ) ) 
    {
        //self iPrintLn( "[CAC Ingame]^1 Not allowed:^7 ref ^2" + itemName + "^7 in class ^2" + className + "^7 with itemType ^2" + itemType + "^7 changed to ^2" + firstAllowedItem.itemName );
        return firstAllowedItem.itemName;
    }

    //self iPrintLn( "[CAC Ingame] Not stored: ^2" + itemName + "^7 in class ^2" + className + "^7 with itemType ^2" + itemType );
    return itemName;
}

//Validate special cases for weapons with grip and grenade launcher attachments (perk1 have to be disabled)
validateLoadoutPerk1SpecialCases( dataType )
{
    dvarName = "loadout_" + dataType;

    switch ( self.cacIngame.loadoutDataRef[dvarName] )
    {
        case "gl": case "grip":
            self.cacIngame.loadoutDataRef["loadout_perk1"] = "specialty_null"; break;
    }
}