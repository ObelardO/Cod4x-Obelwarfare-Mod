// ====================================================================================================
// side arm selection ===============================================================================
// ====================================================================================================
#define LOCAL_SIDEARM_INFO_WINDOW( highlight_dvar ) \
    /* sidearm information side frame*/ \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString( "ui_inside_popup" ) != "attachment" ); ) \
    LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString( "ui_inside_popup" ) != "attachment" );, 0, 0 )\
    /* sidearm image*/ \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString( "ui_inside_popup" ) != "attachment" ); ) \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+138) -12 90 90 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString( highlight_dvar ),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString( "ui_inside_popup" ) != "attachment" ); ) \
    /* sidearm title*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString( highlight_dvar ),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( dvarString( "ui_inside_popup" ) != "attachment" ); ) \
    /* sidearm desc unlocked*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString( highlight_dvar ),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( dvarBool( "ui_sidearm_hl_unlocked" ) ); )\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@OW_ICE_LOCK_SERVER", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( !dvarBool( "ui_sidearm_hl_unlocked" ) ); )\
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( !dvarBool( "ui_sidearm_hl_unlocked" ) ); ) \

#define LOCAL_SIDEARM_ACTION( wRef ) \		
        play "mouse_click"; \
        setdvar	loadout_secondary wRef; \
        setdvar	loadout_secondary_attachment none; \
        scriptMenuResponse "ice_set:secondary:"wRef;\
        scriptMenuResponse "ice_set:secondary_attachment:"REF_NONE;\
        setdvar	ui_inside_popup_nested 1;\
        setdvar ui_attachment_weap_slot loadout_secondary;\
        open "ice_attachment_popup_pistol";\
        scriptMenuResponse "ice_allow:pistol:atch";

#define LOCAL_SIDEARM_NOATTACHES_ACTION( wRef ) \
        play "mouse_click"; \
        setdvar	loadout_secondary wRef; \
        setdvar	loadout_secondary_attachment none; \
        scriptMenuResponse "ice_set:secondary:"wRef;\
        ICE_CLOSE_ALL_POPUPS_ACTION

#define LOCAL_SIDEARM_ONFOCUS( wRef ) \
    execOnDvarStringValue "weap_allow_"wRef 0 "set ui_sidearm_hl_unlocked 0";\
    execOnDvarStringValue "weap_allow_"wRef 1 "set ui_sidearm_hl_unlocked 1";\
    exec "set ui_sidearm_highlighted "wRef;

#define LOCAL_SIDEARM_ITEM( itemNum, wName, wRef, highlight_dvar )\
    CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, wName, LOCAL_SIDEARM_NOATTACHES_ACTION( wRef ), LOCAL_SIDEARM_ONFOCUS( wRef ), ;, \
    when( dvarBool( "weap_allow_"wRef ) && ( wRef == REF_DESERTEAGLE || wRef == REF_DESERTEAGLEGOLD ) );, \
            dvarBool( "weap_allow_"wRef ) && ( wRef == REF_DESERTEAGLE || wRef == REF_DESERTEAGLEGOLD ) ) \
    CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, wName, LOCAL_SIDEARM_ACTION( wRef ), LOCAL_SIDEARM_ONFOCUS( wRef ), ;, \
    when( dvarBool( "weap_allow_"wRef ) && wRef != REF_DESERTEAGLE && wRef != REF_DESERTEAGLEGOLD );, \
            dvarBool( "weap_allow_"wRef ) && wRef != REF_DESERTEAGLE && wRef != REF_DESERTEAGLEGOLD ) \
    CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, LOCAL_SIDEARM_ONFOCUS( wRef ), ;, when( !dvarBool( "weap_allow_"wRef ) ); ) \
    CHOICE_DBUTTON_VIS( itemNum, wName, when( !dvarBool( "weap_allow_"wRef ) ); )

#define LOCAL_SIDEARM_POPUP_ONOPEN( wclass )\
    execnow "set "UI_FOCUSFIRST" "REF_M9BERETTA"; set selected_weapon_class "wclass"; set ui_inside_popup "wclass;\
    scriptMenuResponse "ice_allow:"wclass":weap";

// hackaround to work for PC's floating mouse unfocusing
#undef  UI_FOCUSFIRST
#ifdef PC
    #define UI_FOCUSFIRST "ui_sidearm_highlighted"
#else
    #define UI_FOCUSFIRST "ui_fake_focus"
#endif

menuDef	
{
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_class_popup_secondary", 7, (CHOICE_X( 2 )-2), (CHOICE_Y( 2 )), ;, LOCAL_SIDEARM_POPUP_ONOPEN( "pistol" ), 1 )
    onClose{execnow "set ui_inside_popup 0";}
    LOCAL_SIDEARM_INFO_WINDOW( "ui_sidearm_highlighted" )
    LOCAL_SIDEARM_ITEM( 1, "@WEAPON_BERETTA", REF_M9BERETTA, "ui_sidearm_highlighted" )
    LOCAL_SIDEARM_ITEM( 2, "@WEAPON_USP", REF_USP, "ui_sidearm_highlighted" )
    LOCAL_SIDEARM_ITEM( 3, "@WEAPON_COLT1911", REF_COLT45, "ui_sidearm_highlighted" )
    LOCAL_SIDEARM_ITEM( 4, "@WEAPON_DESERTEAGLE", REF_DESERTEAGLE, "ui_sidearm_highlighted" )
    LOCAL_SIDEARM_ITEM( 5, "@WEAPON_DESERTEAGLEGOLD", REF_DESERTEAGLEGOLD, "ui_sidearm_highlighted" )
}