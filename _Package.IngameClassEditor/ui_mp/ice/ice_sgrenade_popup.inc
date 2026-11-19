// ====================================================================================================
// special grenade selection ==========================================================================
// ====================================================================================================

#define LOCAL_SGRENADE_INFO_WINDOW( highlight_dvar ) \
    /* special grenade information side frame*/ \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT(6) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR ) \
    LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT(6)-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString( "ui_inside_popup" ) != "attachment" );, 0, 0 )\
    /*PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) (CHOICE_POPUP_HEIGHT(3)-4) 2 (CHOICE_POPUP_HEIGHT(6)-CHOICE_POPUP_HEIGHT(3)+2) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 0, 2, CHOICE_POPUP_BORDER_COLOR )*/ \
    /* special grenade image*/ \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 6 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString( "ui_inside_popup" ) != "attachment" ); ) \
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+178) -6 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString( highlight_dvar ),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR ) \
    /* special grenade title*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 34 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString( highlight_dvar ),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE ) \
    /* special grenade desc unlocked*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 56 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString( highlight_dvar ),7), TEXTSIZE_INFO_DESC, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR \
    visible when( ( ( dvarString( "ui_sgrenade_highlighted" )=="smoke_grenade") && (dvarString( "loadout_perk1" )=="specialty_specialgrenade") ) == 0 ); )\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 56 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@OW_ICE_LOCK_PERK", TEXTSIZE_INFO_DESC, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
    visible when( (dvarString( "ui_sgrenade_highlighted" )=="smoke_grenade") && (dvarString( "loadout_perk1" )=="specialty_specialgrenade") ); )

#define LOCAL_SGRENADE_ACTION( wRef ) \
    play "mouse_click"; \
    setdvar loadout_grenade wRef; \
    scriptMenuResponse "ice_set:grenade:"wRef;\
    close "ice_weapon_popup_extra"
    
#define LOCAL_SGRENADE_ITEM( itemNum, wName, wRef, highlight_dvar )\
    CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, wName, LOCAL_SGRENADE_ACTION( wRef ), execnow "set "highlight_dvar" "wRef, ;, \
    when( ( wRef == REF_SMOKE_X1 && ( dvarString( "loadout_perk1" )=="specialty_specialgrenade") ) == 0 && dvarBool( "weap_allow_"wRef ) );, \
            ( wRef == REF_SMOKE_X1 && ( dvarString( "loadout_perk1" )=="specialty_specialgrenade") ) == 0 && dvarBool( "weap_allow_"wRef ) ) \
    CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set "highlight_dvar" "wRef, ;, when( wRef == REF_SMOKE_X1 && (dvarString( "loadout_perk1" )=="specialty_specialgrenade") && dvarBool("weap_allow_"wRef)); ) \
    CHOICE_DBUTTON_VIS( itemNum, wName, when( ( wRef == REF_SMOKE_X1 && ( dvarString( "loadout_perk1" )=="specialty_specialgrenade" ) ) || !dvarBool( "weap_allow_"wRef ) ); )

#define LOCAL_SGRENADE_POPUP_ONOPEN\
    execnow "set "UI_FOCUSFIRST" "REF_FLASH_X1"; set ui_inside_popup sgrenade";\
    scriptMenuResponse "ice_allow:grenade:weap";

// hackaround to work for PC's floating mouse unfocusing
#undef  UI_FOCUSFIRST
#define UI_FOCUSFIRST "ui_sgrenade_highlighted"

// special grenade selection popup menus
menuDef	
{
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_weapon_popup_extra", 6, ICE_POPUP_X_START, (CHOICE_Y( 3 )+4), ;, LOCAL_SGRENADE_POPUP_ONOPEN, 1 )
    onClose{ execnow "set ui_inside_popup 0"; }
    LOCAL_SGRENADE_INFO_WINDOW( "ui_sgrenade_highlighted" )
    LOCAL_SGRENADE_ITEM( 1, "@WEAPON_FLASH_GRENADE", REF_FLASH_X1, "ui_sgrenade_highlighted" )
    LOCAL_SGRENADE_ITEM( 2, "@WEAPON_STUN_GRENADE", REF_CONCUSSION_X1, "ui_sgrenade_highlighted" )
    LOCAL_SGRENADE_ITEM( 3, "@WEAPON_SMOKE_GRENADE", REF_SMOKE_X1, "ui_sgrenade_highlighted" )
}