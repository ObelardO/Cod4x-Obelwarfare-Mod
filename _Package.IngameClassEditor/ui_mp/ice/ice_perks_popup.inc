// ====================================================================================================
// perk selection =====================================================================================
// ====================================================================================================

#define LOCAL_PERK_INFO_ALLOWED\
    dvarBool( "perk_allow_" + dvarString( "ui_perk_hl_ref" ) )

#define LOCAL_PERK_INFO_EQUIPPED( perkSlot )\
    dvarString( "loadout_"perkSlot ) == dvarString( "ui_perk_hl_ref" )

#define LOCAL_PERK_INFO_NOT_EQUIPPED( perkSlot )\
    dvarString( "loadout_"perkSlot ) != dvarString( "ui_perk_hl_ref" )

#define LOCAL_PERK_INFO_ALLOWED_GRENADE\
    ( dvarString( "ui_perk_hl_ref" ) != REF_SPECIALGRENADE_X3 || dvarString( "loadout_grenade" ) != REF_SMOKE_X1 )

#define LOCAL_PERK_INFO_NOT_ALLOWED_GRENADE\
    ( dvarString( "ui_perk_hl_ref" ) == REF_SPECIALGRENADE_X3 && dvarString( "loadout_grenade" ) == REF_SMOKE_X1 )

#define LOCAL_PERK_INFO_ALLOWED_CLASS( weaponSlot )\
    dvarBool( "perk_" + dvarString( weaponSlot ) + "_allow_" + dvarString( "ui_perk_hl_ref" ) )

#define LOCAL_PERK_INFO_ALLOWED_OVERKILL\
    ( dvarString( "loadout_perk2" ) != REF_TWOPRIMARIES || LOCAL_PERK_INFO_ALLOWED_CLASS( "loadout_class_secondary" ) )

#define LOCAL_PERK_INFO_NOT_ALLOWED_OVERKILL\
    ( dvarString( "ui_perk_hl_ref" ) != REF_TWOPRIMARIES && dvarString( "loadout_perk2" ) == REF_TWOPRIMARIES && LOCAL_PERK_INFO_ALLOWED_CLASS( "loadout_class_secondary" ) == 0 )

#define LOCAL_PERK_INFO_VISIBLE( perkSlot )\
    /* PERK NOT EQUIPPED */\
    LOCAL_PERK_INFO_NOT_EQUIPPED( perkSlot ) &&\
    /* PERK ALLOWED */\
    LOCAL_PERK_INFO_ALLOWED &&\
    /* PERK ALLOWED FOR CLASS */\
    LOCAL_PERK_INFO_ALLOWED_CLASS( "loadout_class" ) &&\
    /* PERK ALLOWED BY GRENADE*/\
    LOCAL_PERK_INFO_ALLOWED_GRENADE &&\
    /* PERK ALLOWED BY OVERKILL WEAPON CLASS */\
    LOCAL_PERK_INFO_ALLOWED_OVERKILL

#define LOCAL_PERK_INFO_WINDOW( perkSlot )\
    /* perk information side frame*/\
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR )\
    LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0, 0 )\
    /* perk image*/\
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR )\
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+188) -2 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString( "ui_perk_hl_ref" ),6), 1 1 1 0.75, 0, 0, 0.2 0.2 0.225 1 )\
    /* perk title*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statsTable.csv",4,dvarString( "ui_perk_hl_ref" ),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE )\
    /* perk desc unlocked*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@"+tablelookup("mp/statsTable.csv",4,dvarString( "ui_perk_hl_ref" ),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR\
        visible when( LOCAL_PERK_INFO_VISIBLE( perkSlot ) ); )\
    /* perk desc locked - global*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@OW_ICE_LOCK_SERVER", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
        visible when( LOCAL_PERK_INFO_ALLOWED == 0 ); )\
    /* perk desc locked - class*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@OW_ICE_LOCK_CLASS", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
        visible when( LOCAL_PERK_INFO_ALLOWED && ( LOCAL_PERK_INFO_ALLOWED_CLASS( "loadout_class" ) == 0 || LOCAL_PERK_INFO_NOT_ALLOWED_OVERKILL ) ); )\
    /* perk desc locked - equipped*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@OW_ICE_LOCK_EQUIPPED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
        visible when( LOCAL_PERK_INFO_EQUIPPED( perkSlot ) ); )\
    /* perk desc locked - greanade*/\
    PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@OW_ICE_LOCK_FRAG", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
        visible when( LOCAL_PERK_INFO_NOT_ALLOWED_GRENADE ); )\
    /* perk desc locked image*/\
    PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR \
        visible when( dvarBool( "ui_perk_hl_locked" ) ); )

#define LOCAL_PERK_ACTION( perkSlot, perkRef, paction ) \
        play "mouse_click"; \
        close self \
        exec "set loadout_"perkSlot" "perkRef;\
        scriptMenuResponse "ice_set:"perkSlot":"perkRef;\
        paction
    
#define LOCAL_PERK_ITEM( itemNum, camoName, perkSlot, perkRef, paction )\
    LOCAL_PERK_ITEM_VIS( itemNum, camoName, perkSlot, perkRef, paction, 1 )

#define LOCAL_PERK_ONFOCUS( perkRef )\
    exec "set ui_perk_hl_ref "perkRef;\
    exec "set ui_perk_hl_locked 0";

#define LOCAL_PERK_LOCKED_ONFOCUS( perkRef )\
    LOCAL_PERK_ONFOCUS( perkRef );\
    exec "set ui_perk_hl_locked 1";

#define LOCAL_PERK_ALLOWED( perkRef )\
    dvarBool( "perk_allow_"perkRef )

#define LOCAL_PERK_ALLOWED_CLASS( weaponSlot, perkRef )\
    dvarBool( "perk_" + dvarString( weaponSlot ) + "_allow_"perkRef )

#define LOCAL_PERK_ALLOWED_GRENADE( perkRef )\
    ( perkRef != REF_SPECIALGRENADE_X3 || dvarString( "loadout_grenade" ) != REF_SMOKE_X1 )

#define LOCAL_PERK_ALLOWED_OVERKILL( perkRef )\
    ( dvarString( "loadout_perk2" ) != REF_TWOPRIMARIES || LOCAL_PERK_ALLOWED_CLASS( "loadout_class_secondary", perkRef ) )

#define LOCAL_PERK_EQUIPPED( perkSlot, perkRef )\
    dvarString( "loadout_"perkSlot ) == perkRef

#define LOCAL_PERK_NOT_EQUIPPED( perkSlot, perkRef )\
    dvarString( "loadout_"perkSlot ) != perkRef

#define LOCAL_PERK_CHOICE_NOT_LOCKED( perkSlot, perkRef )\
    LOCAL_PERK_NOT_EQUIPPED( perkSlot, perkRef ) &&\
    LOCAL_PERK_ALLOWED( perkRef ) &&\
    LOCAL_PERK_ALLOWED_CLASS( "loadout_class", perkRef ) &&\
    LOCAL_PERK_ALLOWED_GRENADE( perkRef ) &&\
    LOCAL_PERK_ALLOWED_OVERKILL( perkRef )

#define LOCAL_PERK_CHOICE_IS_LOCKED( perkSlot, perkRef )\
    LOCAL_PERK_EQUIPPED( perkSlot, perkRef ) ||\
    LOCAL_PERK_ALLOWED( perkRef ) == 0 ||\
    LOCAL_PERK_ALLOWED_CLASS( "loadout_class", perkRef ) == 0 ||\
    ( perkRef == REF_SPECIALGRENADE_X3 && dvarString( "loadout_grenade" ) == REF_SMOKE_X1 ) ||\
    ( perkRef != REF_TWOPRIMARIES && dvarString( "loadout_perk2" ) == REF_TWOPRIMARIES && LOCAL_PERK_ALLOWED_CLASS( "loadout_class_secondary", perkRef ) == 0 )

#define LOCAL_PERK_ITEM_VIS( itemNum, camoName, perkSlot, perkRef, paction, visArg )\
    CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, camoName, LOCAL_PERK_ACTION( perkSlot, perkRef, paction );, LOCAL_PERK_ONFOCUS( perkRef ), ;, when( LOCAL_PERK_CHOICE_NOT_LOCKED( perkSlot, perkRef ) && visArg );, 0 )\
    CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;,LOCAL_PERK_LOCKED_ONFOCUS( perkRef ), ;, when( LOCAL_PERK_CHOICE_IS_LOCKED( perkSlot, perkRef ) && visArg ); )\
    CHOICE_DBUTTON_VIS( itemNum, camoName, when( LOCAL_PERK_CHOICE_IS_LOCKED( perkSlot, perkRef ) && visArg ); )

#define LOCAL_PERK_POPUP_ONOPEN( perkRef, perkSlot )\
    execnow "set "UI_FOCUSFIRST" "perkRef"; set ui_inside_popup "perkSlot;\
    scriptMenuResponse "ice_allow:*current&all*:"perkSlot;

// hackaround to work for PC's floating mouse unfocusing
#undef  UI_FOCUSFIRST
#define UI_FOCUSFIRST "ui_perk_hl_ref"

// perk1 selection for primary weapon popup menu
menuDef	
{
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_perk1_popup", 7, (CHOICE_X( 4 )-2), (CHOICE_Y( 4 )+18), ;, LOCAL_PERK_POPUP_ONOPEN( REF_C4_X2, "perk1" ), 1 )
    onClose{ execnow "set ui_inside_popup 0"; }
    LOCAL_PERK_INFO_WINDOW( "perk1" )
    LOCAL_PERK_ITEM( 1, "@PERKS_C4_X_2", "perk1", REF_C4_X2, ; )
    LOCAL_PERK_ITEM( 2, "@PERKS_SPECIAL_GRENADES_X_3", "perk1", REF_SPECIALGRENADE_X3, ; )
    LOCAL_PERK_ITEM( 3, "@PERKS_RPG7_X_2", "perk1", REF_RPG_X2, ; )
    LOCAL_PERK_ITEM( 4, "@PERKS_CLAYMORE_X_2", "perk1", REF_CLAYMORE_X2, ; )
    LOCAL_PERK_ITEM( 5, "@PERKS_FRAG_X_3", "perk1", REF_FRAG_X3, ; )
    LOCAL_PERK_ITEM( 6, "@PERKS_BANDOLIER", "perk1", REF_EXTRAAMMO, ; )
    LOCAL_PERK_ITEM( 7, "@PERKS_BOMB_SQUAD", "perk1", REF_DETECTEXPLOSIVE, ; )
}

#define LOCAL_RESET_PISTOL_ACTION \
    execnowondvarstringvalue ui_dual_primaries 1 "set loadout_secondary "REF_M9BERETTA"; set loadout_secondary_attachment "REF_ATTACHMENT_NONE"; set ui_dual_primaries 0";\
    scriptMenuResponse "ice_validate:secondary:pistol";\
    ICE_UPDATE_PERK1_LOCKSTATE;

#define LOCAL_SET_PERK_OVERKILL_M16 \
    execnow "set loadout_class_secondary assault; set loadout_secondary "REF_M16"; set loadout_secondary_attachment "REF_ATTACHMENT_NONE"; set ui_dual_primaries 1";\
    scriptMenuResponse "ice_set:secondary:"REF_M16;\
    scriptMenuResponse "ice_set:secondary_attachment:"REF_ATTACHMENT_NONE;\
    scriptMenuResponse "ice_validate:secondary:assault";

#define LOCAL_SET_PERK_OVERKILL_AK47 \
    execnow "set loadout_class_secondary assault; set loadout_secondary "REF_AK47"; set loadout_secondary_attachment "REF_ATTACHMENT_NONE"; set ui_dual_primaries 1";\
    scriptMenuResponse "ice_set:secondary:"REF_AK47;\
    scriptMenuResponse "ice_set:secondary_attachment:"REF_ATTACHMENT_NONE;\
    scriptMenuResponse "ice_validate:secondary:assault";

// perk2 selection for primary weapon popup menu
menuDef	
{
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_perk2_popup", 7, (CHOICE_X( 5 )-2), (CHOICE_Y( 5 )+22), ;, LOCAL_PERK_POPUP_ONOPEN( REF_BULLETDAMAGE, "perk2" ), 1 )
    onClose{ execnow "set ui_inside_popup 0"; }
    LOCAL_PERK_INFO_WINDOW( "perk2" )
    LOCAL_PERK_ITEM( 1, "@PERKS_STOPPING_POWER", "perk2", REF_BULLETDAMAGE, LOCAL_RESET_PISTOL_ACTION )
    LOCAL_PERK_ITEM( 2, "@PERKS_JUGGERNAUT", "perk2", REF_ARMORVEST, LOCAL_RESET_PISTOL_ACTION )
    LOCAL_PERK_ITEM( 3, "@PERKS_SLEIGHT_OF_HAND", "perk2", REF_FASTRELOAD, LOCAL_RESET_PISTOL_ACTION )
    LOCAL_PERK_ITEM( 4, "@PERKS_DOUBLE_TAP", "perk2", REF_ROF, LOCAL_RESET_PISTOL_ACTION )
    /*hacked, init to m16 if not m16*/	
    LOCAL_PERK_ITEM_VIS( 5, "@PERKS_OVERKILL", "perk2", REF_TWOPRIMARIES, LOCAL_SET_PERK_OVERKILL_M16, dvarString ( "loadout_primary" ) != REF_M16 )
    /*hacked, init to ak47 if m16*/		
    LOCAL_PERK_ITEM_VIS( 5, "@PERKS_OVERKILL", "perk2", REF_TWOPRIMARIES, LOCAL_SET_PERK_OVERKILL_AK47, dvarString ( "loadout_primary" ) == REF_M16 )
    LOCAL_PERK_ITEM( 6, "@PERKS_UAV_JAMMER", "perk2", REF_GPSJAMMER, LOCAL_RESET_PISTOL_ACTION )
    LOCAL_PERK_ITEM( 7, "@PERKS_SONIC_BOOM", "perk2", REF_EXPLOSIVEDAMAGE, LOCAL_RESET_PISTOL_ACTION )
}
            
// perk3 selection for primary weapon popup menu
menuDef	
{
    IMPROVED_POPUP_SETUP_ONOPEN( "ice_perk3_popup", 8, (CHOICE_X( 6 )-2), (CHOICE_Y( 6 )+26), ;, LOCAL_PERK_POPUP_ONOPEN( REF_LONGERSPRINT, "perk3" ), 1 )
    onClose{ execnow "set ui_inside_popup 0"; }
    LOCAL_PERK_INFO_WINDOW( "perk3" )
    LOCAL_PERK_ITEM( 1, "@PERKS_EXTREME_CONDITIONING", "perk3", REF_LONGERSPRINT, ; )
    LOCAL_PERK_ITEM( 2, "@PERKS_STEADY_AIM", "perk3", REF_BULLETACCURACY, ; )
    LOCAL_PERK_ITEM( 3, "@PERKS_LAST_STAND", "perk3", REF_PISTOLDEATH, ; )
    LOCAL_PERK_ITEM( 4, "@PERKS_MARTYRDOM", "perk3", REF_GRENADEPULLDEATH, ; )
    LOCAL_PERK_ITEM( 5, "@PERKS_DEEP_IMPACT", "perk3", REF_BULLETPENETRATION, ; )
    LOCAL_PERK_ITEM( 6, "@PERKS_IRON_LUNGS", "perk3", REF_HOLDBREATH, ; )
    LOCAL_PERK_ITEM( 7, "@PERKS_DEAD_SILENCE", "perk3", REF_QUIETER, ; )
    LOCAL_PERK_ITEM( 8, "@PERKS_EAVESDROP", "perk3", REF_PARABOLIC, ; )
}