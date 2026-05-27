// ====================================================================================================
// primary and second primary attachment selection ====================================================
// ====================================================================================================
#define LOCAL_ATTACHMENT_INFO_WINDOW\
    /* attachment information side frame*/ \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString( "ui_inside_popup" ) != "camo" ); ) \
    LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString( "ui_inside_popup" ) != "camo" );, 0, 0 ) \
    /* attachment image*/ \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString( "ui_inside_popup" ) != "camo" ); ) \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+182) 6 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/attachmentTable.csv",4,dvarString( "ui_attachment_highlighted" ),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString( "ui_inside_popup" ) != "camo" ); ) \
    /* attachment title*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmentTable.csv",4,dvarString( "ui_attachment_highlighted" ),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( dvarString( "ui_inside_popup" ) != "camo" ); ) \
    /* attachment desc unlocked*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmentTable.csv",4,dvarString( "ui_attachment_highlighted" ),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( dvarBool( "ui_attachment_hl_unlocked" ) ); )\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@OW_ICE_LOCK_SERVER", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( !dvarBool( "ui_attachment_hl_unlocked" ) ); )\
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( !dvarBool( "ui_attachment_hl_unlocked" ) && dvarString( "ui_inside_popup" ) != "camo" ); ) \
    PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarBool( ui_inside_popup_nested ) ); )\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/statstable.csv",4,dvarString( dvarString( "ui_attachment_weap_slot" ) ),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR visible when( dvarBool( "ui_inside_popup_nested" ) ); )\
    /* pointer icon */ \
    PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarBool( "ui_inside_popup_nested" ) ); )

#define LOCAL_ATTACHMENT_ACTION( attachmentName, wClass ) \
    setdvar loadout_primary_attachment attachmentName; \
    scriptMenuResponse "ice_set:primary_attachment:"attachmentName;\
    ICE_UPDATE_PERK1_LOCKSTATE \
    close self;\
    uiScript openMenuOnDvar ui_inside_popup_nested 1 "ice_attachment_popup_"wClass;\
    execOnDvarStringValue ui_inside_popup_nested 1 "set loadout_camo camo_none";\
    uiScript openMenuOnDvar ui_inside_popup_nested 1 "ice_camo_popup";
    
#define LOCAL_ATTACHMENT_ACTION_OVERKILL( attachmentName, wClass ) \
    setdvar loadout_secondary_attachment attachmentName; \
    scriptMenuResponse "ice_set:secondary_attachment:"attachmentName;\
    ICE_UPDATE_PERK1_LOCKSTATE \
    ICE_CLOSE_ALL_POPUPS_ACTION

#define LOCAL_PISTOL_ATTACHMENT_ACTION( attachmentName, wClass ) \
    setdvar loadout_secondary_attachment attachmentName; \
    scriptMenuResponse "ice_set:secondary_attachment:"attachmentName;\
    ICE_CLOSE_ALL_POPUPS_ACTION

#define LOCAL_ATTACHMENT_ONFOCUS( wClass, wRef ) \
    execOnDvarStringValue "attach_allow_"wClass"_"wRef 0 "set ui_attachment_hl_unlocked 0";\
    execOnDvarStringValue "attach_allow_"wClass"_"wRef 1 "set ui_attachment_hl_unlocked 1";\
    exec "set ui_attachment_highlighted "wRef;

#define LOCAL_ATTACHMENT_ITEM( itemNum, wClass ,p_numref, wRef )\
    /*Primary attachment*/\
    CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,wRef,3), LOCAL_ATTACHMENT_ACTION( wRef, wClass );, \
        LOCAL_ATTACHMENT_ONFOCUS( wClass, wRef ), ;, when( dvarString( "ui_primary_selected" ) == "primary" && dvarBool( "attach_allow_"wClass"_"wRef ) ), dvarString( "ui_primary_selected" ) == "primary" && dvarBool( "attach_allow_"wClass"_"wRef ) ) \
    /*Secondary attachment (overkill perk)*/\
    CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,wRef,3), LOCAL_ATTACHMENT_ACTION_OVERKILL( wRef, wClass );, \
        LOCAL_ATTACHMENT_ONFOCUS( wClass, wRef ), ;, when( dvarString( "ui_primary_selected" ) == "secondary" && dvarBool( "attach_allow_"wClass"_"wRef ) ), dvarString( "ui_primary_selected" ) == "secondary" && dvarBool( "attach_allow_"wClass"_"wRef ) ) \
    /*Disabled*/\
    CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, LOCAL_ATTACHMENT_ONFOCUS(wClass,wRef), ;, when( !dvarBool( "attach_allow_"wClass"_"wRef ) ); ) \
    CHOICE_DBUTTON_VIS( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,wRef,3), when( !dvarBool( "attach_allow_"wClass"_"wRef ) ); ) \
    
#define LOCAL_PISTOL_ATTACHMENT_ITEM( itemNum, wClass ,p_numref, wRef )\
    /*Pistol attachment*/\
    CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,wRef,3), LOCAL_PISTOL_ATTACHMENT_ACTION( wRef, wClass ), \
        LOCAL_ATTACHMENT_ONFOCUS(wClass,wRef), ;, when( dvarBool( "attach_allow_"wClass"_"wRef ) ), dvarBool( "attach_allow_"wClass"_"wRef ) ) \
    /*Disabled*/\
    CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, LOCAL_ATTACHMENT_ONFOCUS(wClass,wRef), ;, when( !dvarBool( "attach_allow_"wClass"_"wRef ) ); ) \
    CHOICE_DBUTTON_VIS( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,wRef,3), when( !dvarBool( "attach_allow_"wClass"_"wRef ) ); ) \
    
#define LOCAL_ATTACHMENT_POPUP_ONOPEN( wClass )\
    execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";\
    scriptMenuResponse "ice_allow:"wClass":atch";

#undef  UI_FOCUSFIRST
#define UI_FOCUSFIRST "ui_attachment_highlighted"

// primary and second primary attachment items
#define LOCAL_ATTACHMENT_POPUPS_GROUP( suffix, pos, y_offset )\
menuDef { /* assault attachments*/\
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_attachment_popup_assault"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, LOCAL_ATTACHMENT_POPUP_ONOPEN( "assault" ) , !dvarBool( "ui_inside_popup_nested" ) )\
    onClose{execnow "set ui_inside_popup 0";}\
    LOCAL_ATTACHMENT_INFO_WINDOW\
    LOCAL_ATTACHMENT_ITEM( 1, "assault", NUM_NONE, "none" )\
    LOCAL_ATTACHMENT_ITEM( 2, "assault", NUM_GL, "gl" )\
    LOCAL_ATTACHMENT_ITEM( 3, "assault", NUM_SUPPRESSOR, "silencer" )\
    LOCAL_ATTACHMENT_ITEM( 4, "assault", NUM_REFLEX, "reflex" )\
    LOCAL_ATTACHMENT_ITEM( 5, "assault", NUM_ACOG, "acog" )\
}\
menuDef { /* LMG attachments*/\
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_attachment_popup_heavygunner"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, LOCAL_ATTACHMENT_POPUP_ONOPEN( "heavygunner" ) , !dvarBool( "ui_inside_popup_nested" ) )\
    onClose{execnow "set ui_inside_popup 0";}\
    LOCAL_ATTACHMENT_INFO_WINDOW\
    LOCAL_ATTACHMENT_ITEM( 1, "heavygunner", NUM_NONE, "none" )\
    LOCAL_ATTACHMENT_ITEM( 2, "heavygunner", NUM_REFLEX, "reflex" )\
    LOCAL_ATTACHMENT_ITEM( 3, "heavygunner", NUM_GRIP, "grip" )\
    LOCAL_ATTACHMENT_ITEM( 4, "heavygunner", NUM_ACOG, "acog" )\
}\
menuDef	{ /* SMG attachments*/\
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_attachment_popup_specops"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, LOCAL_ATTACHMENT_POPUP_ONOPEN( "specops" ) , !dvarBool( "ui_inside_popup_nested" ) )\
    onClose{execnow "set ui_inside_popup 0";}\
    LOCAL_ATTACHMENT_INFO_WINDOW\
    LOCAL_ATTACHMENT_ITEM( 1, "specops", NUM_NONE, "none" )\
    LOCAL_ATTACHMENT_ITEM( 2, "specops", NUM_SUPPRESSOR, "silencer" )\
    LOCAL_ATTACHMENT_ITEM( 3, "specops", NUM_REFLEX, "reflex" )\
    LOCAL_ATTACHMENT_ITEM( 4, "specops", NUM_ACOG, "acog" )\
}\
menuDef { /* demolitions attachments*/\
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_attachment_popup_demolitions"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, LOCAL_ATTACHMENT_POPUP_ONOPEN( "demolitions" ) , !dvarBool( "ui_inside_popup_nested" ) )\
    onClose{execnow "set ui_inside_popup 0";}\
    LOCAL_ATTACHMENT_INFO_WINDOW\
    LOCAL_ATTACHMENT_ITEM( 1, "demolitions", NUM_NONE, "none" )\
    LOCAL_ATTACHMENT_ITEM( 2, "demolitions", NUM_REFLEX, "reflex" )\
    LOCAL_ATTACHMENT_ITEM( 3, "demolitions", NUM_GRIP, "grip" )\
}\
menuDef	{ /* sniper attachments*/\
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_attachment_popup_sniper"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, LOCAL_ATTACHMENT_POPUP_ONOPEN( "sniper" ) , !dvarBool( "ui_inside_popup_nested" ) )\
    onClose{execnow "set ui_inside_popup 0";}\		
    LOCAL_ATTACHMENT_INFO_WINDOW\
    LOCAL_ATTACHMENT_ITEM( 1, "sniper", NUM_NONE, "none" )\
    LOCAL_ATTACHMENT_ITEM( 2, "sniper", NUM_ACOG, "acog" )\
}

menuDef	{ /* fake attachment heading for weapons without attachments to be displayed on top of camo popup */
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_attachment_popup_no_attach", 7, (CHOICE_X( 1 )-2), (CHOICE_Y( 1 ) + 44), ;, execnow "set ui_inside_popup attachment";, 0 )
    LOCAL_ATTACHMENT_INFO_WINDOW
    PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )
    PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/statstable.csv",4,dvarString( "loadout_primary" ),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR )
    /* pointer icon */
    PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR )
}

// side arm attachment selection ======================================================================
menuDef	{ /* pistol attachments*/
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_attachment_popup_pistol", 7, (CHOICE_X( 2 )-2), (CHOICE_Y( 2 )+24), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )
    onClose{execnow "set ui_inside_popup 0";}
    LOCAL_ATTACHMENT_INFO_WINDOW
    LOCAL_PISTOL_ATTACHMENT_ITEM( 1, "pistol", NUM_NONE, "none" )
    LOCAL_PISTOL_ATTACHMENT_ITEM( 2, "pistol", NUM_SUPPRESSOR, "silencer" )
}

// primary and second primary attachment popup menus
LOCAL_ATTACHMENT_POPUPS_GROUP( "", 1, 0 )
LOCAL_ATTACHMENT_POPUPS_GROUP( "_not_nested", 1, -48)