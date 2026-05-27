// ====================================================================================================
// primary weapon selection ===========================================================================
// ====================================================================================================
#define LOCAL_WEAPON_INFO_WINDOW( highlight_dvar ) \
    /* weapon information side frame*/ \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString( "ui_inside_popup" ) != "attachment" && dvarString( "ui_inside_popup" ) != "camo" ); ) \
    LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString( "ui_inside_popup" ) != "attachment" && dvarString( "ui_inside_popup" ) != "camo" );, 0, 0 )\ \
    /* weapon image*/ \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString( "ui_inside_popup" ) != "attachment" && dvarString( "ui_inside_popup" ) != "camo" ); ) \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+72) -6 180 90 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString( highlight_dvar ),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString( "ui_inside_popup" ) != "attachment" && dvarString( "ui_inside_popup" ) != "camo" ); ) \
    /* weapon title*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString( highlight_dvar ),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( dvarString( "ui_inside_popup" ) != "attachment" && dvarString( "ui_inside_popup" ) != "camo" ); ) \
    /* weapon desc unlocked*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString( highlight_dvar ),7), TEXTSIZE_INFO_DESC, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( dvarBool( "ui_primary_hl_unlocked" ) ); )\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@OW_ICE_LOCK_SERVER", TEXTSIZE_INFO_DESC, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( !dvarBool( "ui_primary_hl_unlocked" ) && !dvarBool( "ui_primary_equipped_overkill" ) ); )\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@OW_ICE_LOCK_EQUIPPED", TEXTSIZE_INFO_DESC, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( !dvarBool( "ui_primary_hl_unlocked" ) && dvarBool( "ui_primary_equipped_overkill" ) ); )\
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( !dvarBool( "ui_primary_hl_unlocked" ) ); ) \
    PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, dvarString( "ui_weapon_class_selected" ), TEXTSIZE_INFO_DESC, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR ) \
    /* pointer icon */ \
    PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_down", 0.9 0.9 0.95 0.4, 0, 2, CHOICE_POPUP_BORDER_COLOR )

#define LOCAL_PRIMARY_WEAPON_SET( wClass, wRef ) \
    play "mouse_click";\
    setdvar loadout_class wClass;\
    setdvar loadout_primary wRef;\
    setdvar loadout_primary_attachment REF_ATTACHMENT_NONE;\
    setdvar loadout_camo REF_CAMO_NONE;\
    scriptMenuResponse "ice_set:primary:"wRef;\
    scriptMenuResponse "ice_set:primary_attachment:"REF_ATTACHMENT_NONE;\
    scriptMenuResponse "ice_set:camo:"REF_CAMO_NONE;\
    scriptMenuResponse "ice_validate:primary:"wClass;\
    ICE_UPDATE_PERK1_LOCKSTATE;

#define LOCAL_SECONDARY_WEAPON_SET( wClass, wRef ) \
    play "mouse_click";\
    setdvar loadout_class_secondary wClass;\
    setdvar loadout_secondary wRef;\
    setdvar loadout_secondary_attachment REF_ATTACHMENT_NONE;\
    scriptMenuResponse "ice_set:secondary:"wRef;\
    scriptMenuResponse "ice_set:secondary_attachment:"REF_ATTACHMENT_NONE;\
    scriptMenuResponse "ice_validate:secondary:"wClass;\
    ICE_UPDATE_PERK1_LOCKSTATE;

#define LOCAL_PRIMARY_WEAPON_ACTION( wClass, wRef ) \
    LOCAL_PRIMARY_WEAPON_SET( wClass, wRef );\
    setdvar ui_inside_popup_nested 1;\
    setdvar ui_attachment_weap_slot loadout_primary;\
    open "ice_attachment_popup_"wClass;

#define LOCAL_PRIMARY_WEAPON_ACTION_OVERKILL( wClass, wRef ) \
    LOCAL_SECONDARY_WEAPON_SET( wClass, wRef );\
    setdvar ui_inside_popup_nested 1;\
    setdvar ui_attachment_weap_slot loadout_secondary;\
    open "ice_attachment_popup_"wClass;

#define LOCAL_PRIMARY_WEAPON_NOATTACHES_ACTION( wClass, wRef ) \
    LOCAL_PRIMARY_WEAPON_SET( wClass, wRef );\
    setdvar ui_inside_popup_nested 1; \
    setdvar ui_attachment_weap_slot loadout_primary;\
    open "ice_attachment_popup_no_attach"; \
    open "ice_camo_popup_no_attach";	

#define LOCAL_PRIMARY_WEAPON_NOATTACHES_ACTION_OVERKILL( wClass, wRef ) \
    LOCAL_SECONDARY_WEAPON_SET( wClass, wRef ); \
    ICE_CLOSE_ALL_POPUPS_ACTION

#define LOCAL_PRIMARY_ONFOCUS( wClass, wRef ) \
    execOnDvarStringValue "weap_allow_"wClass"_"wRef 0 "set ui_primary_hl_unlocked 0"; \
    execOnDvarStringValue "weap_allow_"wClass"_"wRef 1 "set ui_primary_hl_unlocked 1"; \
    exec "set ui_primary_highlighted "wRef; \
    setdvar ui_primary_equipped_overkill 0;

#define LOCAL_PRIMARY_ONFOCUS_OVERKILL( wClass, wRef ) \
    setdvar ui_primary_hl_unlocked 0;\
    exec "set ui_primary_highlighted "wRef;\
    setdvar ui_primary_equipped_overkill 1;

#define CHOICE_BUTTON_FOCUS_VIS_ADV_HK( itemIndex, textArg, actionArg, onFocusArg, leaveFocusArg, visArg, vis ) \
    CHOICE_BUTTON_FOCUS_VIS_ADV( itemIndex, textArg, actionArg, onFocusArg, leaveFocusArg, visArg, vis )
    /*execKey itemIndex { actionArg }*/

#define LOCAL_PRIMARY_WEAPON_VISIBLE( wClass, wRef ) \
    LOCAL_WEAPON_IS_ALLOWED ( wClass, wRef ) && LOCAL_PRIMARY_WEAPON_ALLOWED_OVERKILL ( wRef )

#define LOCAL_SECONDARY_WEAPON_VISIBLE( wClass, wRef ) \
    LOCAL_WEAPON_IS_ALLOWED ( wClass, wRef ) && LOCAL_SECONDARY_WEAPON_ALLOWED_OVERKILL ( wClass, wRef )

#define LOCAL_PRIMARY_WEAPON_ALLOWED_OVERKILL( wRef ) \
    dvarString( "ui_primary_selected" ) == "primary" && dvarString ( "loadout_secondary" ) != wRef

#define LOCAL_SECONDARY_WEAPON_ALLOWED_OVERKILL( wClass, wRef ) \
    dvarString( "ui_primary_selected" ) == "secondary" && dvarString ( "loadout_primary" ) != wRef && dvarString( "perk_"wClass"_allow_specialty_twoprimaries" ) > 0

#define LOCAL_WEAPON_DISABLED_OVERKILL( wClass, wRef ) \
    LOCAL_WEAPON_IS_ALLOWED ( wClass, wRef ) && dvarString( "loadout_perk2" ) == "specialty_twoprimaries" && \
    ( \
        ( dvarString( "ui_primary_selected" ) == "primary" && dvarString ( "loadout_secondary" ) == wRef ) || \
        ( dvarString( "ui_primary_selected" ) == "secondary" && dvarString ( "loadout_primary" ) == wRef ) \
    )

#define LOCAL_WEAPON_IS_ALLOWED( wClass, wRef ) \
    dvarBool( "weap_allow_"wClass"_"wRef )

// hacked to hide the second primary if same weapon is selected in first primary, change weapon description to "Already selected"
#define LOCAL_WEAPON_ITEM( itemNum, wName, wClass, wRef )\
    CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, LOCAL_PRIMARY_ONFOCUS( wClass, wRef ), ;, when( ! ( LOCAL_WEAPON_IS_ALLOWED( wClass, wRef ) ) ); )\
    CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, LOCAL_PRIMARY_ONFOCUS_OVERKILL( wClass, wRef ), ;, when( LOCAL_WEAPON_DISABLED_OVERKILL( wClass, wRef ) ); )\
    CHOICE_DBUTTON_VIS( itemNum, wName, when( 1 ); ) \
    /*Primary*/\
    CHOICE_BUTTON_FOCUS_VIS_ADV_HK( itemNum, wName, LOCAL_PRIMARY_WEAPON_ACTION( wClass, wRef ), \
        LOCAL_PRIMARY_ONFOCUS( wClass, wRef ), ;, when( \
        LOCAL_PRIMARY_WEAPON_VISIBLE( wClass, wRef ) );, \
        LOCAL_PRIMARY_WEAPON_VISIBLE( wClass, wRef ) ) \
    /*Secondary (overkill perk)*/\
    CHOICE_BUTTON_FOCUS_VIS_ADV_HK( itemNum, wName, LOCAL_PRIMARY_WEAPON_ACTION_OVERKILL( wClass, wRef ), \
        LOCAL_PRIMARY_ONFOCUS( wClass, wRef ), ;, when( \
        LOCAL_SECONDARY_WEAPON_VISIBLE( wClass, wRef ) );, \
        LOCAL_SECONDARY_WEAPON_VISIBLE( wClass, wRef ) )
    
#define LOCAL_WEAPON_NOATTACHES_ITEM( itemNum, wName, wClass, wRef )\
    CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, LOCAL_PRIMARY_ONFOCUS( wClass, wRef ), ;, when( ! ( LOCAL_WEAPON_IS_ALLOWED( wClass, wRef ) ) ); )\
    /*CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, LOCAL_PRIMARY_ONFOCUS_OVERKILL( wClass, wRef ), ;, when( LOCAL_WEAPON_DISABLED_OVERKILL( wClass, wRef ) ); )*/\
    CHOICE_DBUTTON_VIS( itemNum, wName, when( 1 ); ) \
    /*Primary*/\
    CHOICE_BUTTON_FOCUS_VIS_ADV_HK( itemNum, wName, LOCAL_PRIMARY_WEAPON_NOATTACHES_ACTION( wClass, wRef ), \
        LOCAL_PRIMARY_ONFOCUS( wClass, wRef ), ;, when( \
        LOCAL_PRIMARY_WEAPON_VISIBLE( wClass, wRef ) );, \
        LOCAL_PRIMARY_WEAPON_VISIBLE( wClass, wRef ) )\
    /*Secondary (overkill perk)*/\
    CHOICE_BUTTON_FOCUS_VIS_ADV_HK( itemNum, wName, LOCAL_PRIMARY_WEAPON_NOATTACHES_ACTION_OVERKILL( wClass, wRef ), \
        LOCAL_PRIMARY_ONFOCUS( wClass, wRef ), ;, when( \
        LOCAL_SECONDARY_WEAPON_VISIBLE( wClass, wRef ) );, \
        LOCAL_SECONDARY_WEAPON_VISIBLE( wClass, wRef ) )

#define LOCAL_WEAPON_CLASS_ACTION( wClass, className ) \
    play "mouse_click";\
    /*execnow "set loadout_class "wClass"; set ui_weapon_class_selected "className;*/\
    execnow "set ui_weapon_class_selected "className;\
    open "ice_weapon_popup_"wClass;

#define LOCAL_WEAPON_CLASS_ACTION_OVERKILL( wClass, className ) \
    LOCAL_WEAPON_CLASS_ACTION( wClass, className )

#define LOCAL_WEAPON_CLASS_ITEM( itemNum, wClass, className )\
    CHOICE_BUTTON_FOCUS_VIS( itemNum, className, LOCAL_WEAPON_CLASS_ACTION( wClass, className );, ;, ;, when( dvarString( "ui_primary_selected" ) == "primary" ) );\
    CHOICE_BUTTON_FOCUS_VIS( itemNum, className, LOCAL_WEAPON_CLASS_ACTION_OVERKILL( wClass, className );, ;, ;, when( dvarString( "ui_primary_selected" ) == "secondary" && dvarString( "perk_"wClass"_allow_specialty_twoprimaries" ) > 0 ) );\
    CHOICE_DBUTTON_VIS( itemNum, className, when( dvarString( "ui_primary_selected" ) == "secondary" && dvarString( "perk_"wClass"_allow_specialty_twoprimaries" ) == 0 ); )
    
#define LOCAL_WEAPON_CLASS_POPUP_ONOPEN\
    execnow "set ui_inside_popup weapon_class; set ui_show_preview 1";\
    scriptMenuResponse "ice_allow:secondary";

// primary weapon class dropdown
#define LOCAL_WEAPON_CLASS_POPUPS_GROUP( pos, y_offset )\
menuDef {\
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_class_popup_primary", 5, (CHOICE_X( pos )-2), (CHOICE_Y( pos )-4+y_offset), ;, LOCAL_WEAPON_CLASS_POPUP_ONOPEN, 1 )\
    onClose{execnow "set ui_show_preview 0; set ui_primary_highlighted 0; set ui_attachment_highlighted 0";	}\
    LOCAL_WEAPON_CLASS_ITEM( 1, "assault", "@MPUI_ASSAULT_RIFLES" )\
    LOCAL_WEAPON_CLASS_ITEM( 2, "specops", "@MPUI_SUB_MACHINE_GUNS" )\
    LOCAL_WEAPON_CLASS_ITEM( 3, "heavygunner", "@MPUI_LIGHT_MACHINE_GUNS" )\
    LOCAL_WEAPON_CLASS_ITEM( 4, "demolitions", "@MPUI_SHOTGUNS" )\
    LOCAL_WEAPON_CLASS_ITEM( 5, "sniper", "@MPUI_SNIPER_RIFLES" )\	
}

// primary and second primary class selection popup menus
LOCAL_WEAPON_CLASS_POPUPS_GROUP( 1, 0)

// hackaround to work for PC's floating mouse unfocusing
#undef  UI_FOCUSFIRST
#define UI_FOCUSFIRST "ui_primary_highlighted"

#define LOCAL_WEAPON_POPUP_ONOPEN( wRef, wClass )\
    execnow "set "UI_FOCUSFIRST" "wRef"; set ui_inside_popup "wClass;\
    scriptMenuResponse "ice_allow:"wClass":weap";\
    
// primary weapon items
#define LOCAL_WEAPON_POPUPS_GROUP( pos, y_offset )\
menuDef	{\
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_weapon_popup_assault", 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, LOCAL_WEAPON_POPUP_ONOPEN( REF_M16, "assault" ), 0 )\
    LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
    LOCAL_WEAPON_ITEM( 1, "@WEAPON_M16", "assault", REF_M16 )\
    LOCAL_WEAPON_ITEM( 2, "@WEAPON_AK47", "assault", REF_AK47 )\
    LOCAL_WEAPON_ITEM( 3, "@WEAPON_M4_CARBINE", "assault", REF_M4 )\
    LOCAL_WEAPON_ITEM( 4, "@WEAPON_G3", "assault", REF_G3 )\
    LOCAL_WEAPON_ITEM( 5, "@WEAPON_G36C", "assault", REF_G36C )\
    LOCAL_WEAPON_ITEM( 6, "@WEAPON_M14", "assault", REF_M14 )\
    LOCAL_WEAPON_NOATTACHES_ITEM( 7, "@WEAPON_MP44", "assault", REF_MP44 )\
}\
menuDef	{\
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_weapon_popup_heavygunner", 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, LOCAL_WEAPON_POPUP_ONOPEN( REF_M249SAW, "heavygunner" ), 0 )\
    LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
    LOCAL_WEAPON_ITEM( 1, "@WEAPON_SAW", "heavygunner", REF_M249SAW )\
    LOCAL_WEAPON_ITEM( 2, "@WEAPON_RPD", "heavygunner", REF_RPD )\
    LOCAL_WEAPON_ITEM( 3, "@WEAPON_M60E4", "heavygunner", REF_M60E4 )\
}\
menuDef	{\
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_weapon_popup_specops", 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, LOCAL_WEAPON_POPUP_ONOPEN( REF_MP5, "specops" ), 0 )\
    LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
    LOCAL_WEAPON_ITEM( 1, "@WEAPON_MP5", "specops", REF_MP5 )\
    LOCAL_WEAPON_ITEM( 2, "@WEAPON_SKORPION", "specops", REF_SKORPION )\
    LOCAL_WEAPON_ITEM( 3, "@WEAPON_UZI", "specops", REF_UZI )\
    LOCAL_WEAPON_ITEM( 4, "@WEAPON_AK74U", "specops", REF_AK74U )\
    LOCAL_WEAPON_ITEM( 5, "@WEAPON_P90", "specops", REF_P90 )\
}\
menuDef	{\
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_weapon_popup_demolitions", 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, LOCAL_WEAPON_POPUP_ONOPEN( REF_WINCHESTER1200, "demolitions" ), 0 )\
    LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
    LOCAL_WEAPON_ITEM( 1, "@WEAPON_WINCHESTER1200", "demolitions", REF_WINCHESTER1200 )\
    LOCAL_WEAPON_ITEM( 2, "@WEAPON_BENELLI", "demolitions", REF_BENELLIM4 )\
}\
menuDef	{\
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_weapon_popup_sniper", 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, LOCAL_WEAPON_POPUP_ONOPEN( REF_M40A3, "sniper" ), 0 )\
    LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
    LOCAL_WEAPON_ITEM( 1, "@WEAPON_M40A3", "sniper", REF_M40A3 )\
    LOCAL_WEAPON_ITEM( 2, "@WEAPON_M21", "sniper", REF_M21 )\
    LOCAL_WEAPON_ITEM( 3, "@WEAPON_DRAGUNOV", "sniper", REF_DRAGUNOVSVD )\
    LOCAL_WEAPON_ITEM( 4, "@WEAPON_REMINGTON700", "sniper", REF_REMINGTON700 )\
    LOCAL_WEAPON_ITEM( 5, "@WEAPON_BARRETT", "sniper", REF_BARRETT )\
}

// primary and second primary weapon selection popup menus
LOCAL_WEAPON_POPUPS_GROUP( 1, 0 )