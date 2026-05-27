// ====================================================================================================
// camo skin selection ================================================================================
// ====================================================================================================
#define LOCAL_CAMO_INFO_WINDOW( highlight_dvar ) \
	/* camo information side frame*/ \
	PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 8 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR ) \
	LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 8 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0, 0 )\
	/* camo image*/ \
	PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR ) \
	PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+184) 0 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/attachmentTable.csv",4,dvarString( highlight_dvar ),6), 1 1 1 0.75, 1, 7, 0.2 0.2 0.225 1 ) \
	/* camo title*/\
	PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmenttable.csv",4,dvarString( highlight_dvar ),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE ) \
	/* camo desc unlocked*/\
	PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmenttable.csv",4,dvarString( highlight_dvar ),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( 1 ); )\
	PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )\
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/attachmenttable.csv",4,dvarString( "loadout_primary_attachment" ),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR )\
	/* pointer icon */ \
	PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR )

#define LOCAL_CAMO_ACTION( camoRef ) \
		play "mouse_click"; \
		setdvar loadout_camo camoRef;\
		scriptMenuResponse "ice_set:camo:"camoRef;\
		ICE_CLOSE_ALL_POPUPS_ACTION

#define LOCAL_CAMO_ITEM( itemNum, camoName, pnum, camoRef, highlight_dvar, bitMask, visArg )\
	CHOICE_BUTTON_FOCUS( itemNum, camoName, LOCAL_CAMO_ACTION( camoRef );, execnow "set "highlight_dvar" "camoRef;, ; );

#define LOCAL_CAMO_POPUP_ONOPEN\
    execnow "set "UI_FOCUSFIRST" "REF_CAMO_NONE"; set ui_inside_popup camo";

// hackaround to work for PC's floating mouse unfocusing
#undef  UI_FOCUSFIRST
#define UI_FOCUSFIRST "ui_camo_highlighted"

// camo skin selection for primary weapon popup menu
#define LOCAL_CAMO_POPUPS_GROUP( prefix, onLeave )\
menuDef	\
{\
	IMPROVED_POPUP_SETUP_ONOPEN( "ice_camo_popup"prefix, 8, (CHOICE_X( 1 )-2), (CHOICE_Y( 1 )+68), ;, LOCAL_CAMO_POPUP_ONOPEN, 0 )\
	onClose{onLeave;} \
	LOCAL_CAMO_INFO_WINDOW( "ui_camo_highlighted" )\
	LOCAL_CAMO_ITEM( 1, "@MPUI_NONE", CAMO_NONE, REF_CAMO_NONE, "ui_camo_highlighted", 0, 1 )\
	LOCAL_CAMO_ITEM( 2, "@MPUI_DESERT", CAMO_BROCKHUARD, REF_BROCKHUARD, "ui_camo_highlighted", DESERT_NEW_BITMASK, 1 )\
	LOCAL_CAMO_ITEM( 3, "@MPUI_WOODLAND", CAMO_BUSHDWELLER, REF_BUSHDWELLER, "ui_camo_highlighted", WOODLAND_NEW_BITMASK, 1 )\
	LOCAL_CAMO_ITEM( 4, "@MPUI_DIGITAL", CAMO_BLACKWHITEMARPAT, REF_BLACKWHITEMARPAT, "ui_camo_highlighted", DIGITAL_NEW_BITMASK, 1 )\
	LOCAL_CAMO_ITEM( 5, "@MPUI_RED_TIGER", CAMO_TIGERRED, REF_TIGERRED, "ui_camo_highlighted", REDTIGER_NEW_BITMASK, 1 )\
	LOCAL_CAMO_ITEM( 6, "@MPUI_BLUE_TIGER", CAMO_STAGGER, REF_STAGGER, "ui_camo_highlighted", BLUETIGER_NEW_BITMASK, 1 )\
}

// camo skin selection for primary weapon popup menu
LOCAL_CAMO_POPUPS_GROUP( "", execnow "set ui_inside_popup attachment" )
// camo skin selection for primary weapon without attachments
LOCAL_CAMO_POPUPS_GROUP( "_no_attach", execnow "set ui_inside_popup 0"; close "ice_attachment_popup_no_attach" )