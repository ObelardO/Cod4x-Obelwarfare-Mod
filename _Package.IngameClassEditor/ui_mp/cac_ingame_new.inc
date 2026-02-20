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

// general definitions

#define CHOICE_X_START			0
#define CHOICE_Y_START			34

#define CHOICE_SEP_1			4
#define CHOICE_SEP_2			7

#include "ui_mp/menustyle.inc"
#include "ui/choices_setup_common.menu"
 
#define ORIGIN_STATUS			390 64
#define MENU_FONT_COLOR2		1 1 1 0.5


#define REF_NONE "none"

// including stats data
#include "ui_mp/stats_info.inc"

// including weapon data
#include "ui_mp/weaponinfo.menu"

	// ========================== Perk 1 special cases ===========================
	#define UPDATE_PERK1 \
		\
		/*Primary not blocking attachments*/\
		execOnDvarStringValue loadout_primary_attachment none "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment acog "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment silencer "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment reflex "set loadout_perk1_locked 0"; \
		\
		/*Secondary not blocking attachments*/\
		execOnDvarStringValue loadout_secondary_attachment gl "set loadout_perk1_locked 1; set loadout_perk1 specialty_null"; \
		execOnDvarStringValue loadout_secondary_attachment grip "set loadout_perk1_locked 1; set loadout_perk1 specialty_null"; \
		execOnDvarStringValue loadout_secondary_attachment none "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_secondary_attachment acog "set loadout_perk1_locked 0"; \
		\
		/*Primary blocking attachments*/\
		execOnDvarStringValue loadout_primary_attachment gl "set loadout_perk1_locked 1; set loadout_perk1 specialty_null"; \
		execOnDvarStringValue loadout_primary_attachment grip "set loadout_perk1_locked 1; set loadout_perk1 specialty_null"; \
		\
		/*Primary blocking attachments*/\
		execOnDvarStringValue loadout_secondary_attachment gl "set loadout_perk1_locked 1; set loadout_perk1 specialty_null"; \
		execOnDvarStringValue loadout_secondary_attachment grip "set loadout_perk1_locked 1; set loadout_perk1 specialty_null";

	menuDef	{
		name			CAC_MENU_NAME
		//fullScreen		1
		rect			0 0 640 480
		focuscolor		COLOR_FOCUSED
		style			WINDOW_STYLE_EMPTY
		blurWorld		7.0
		onOpen {		
			setfocus primary_weapon_selection;
			UPDATE_PERK1;
		}
		onEsc {
			scriptMenuResponse "back";
		}

		// background overlay
		itemDef	{
			style			WINDOW_STYLE_FILLED
			rect			FULLSCREEN_WIDE
			backcolor		0 0 0 .75 //0 0.05 0.15 0.5
			visible			1
			decoration
		}
		// gradient_top
		itemDef	{
			style			WINDOW_STYLE_SHADER
			rect			0 0 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0
			background		"gradient_top"
			visible			1
			decoration
		}
		// gradient_bottom
		itemDef	{
			style			WINDOW_STYLE_SHADER
			rect			0 405 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0
			background		"gradient_bottom"
			visible			1
			decoration
		}

		/*
		itemDef
		{
			style			WINDOW_STYLE_SHADER
			rect			FULLSCREEN_WIDE
			background		"animbg_blur_back"
			backcolor		1 1 1 0.75
			visible			1
			decoration
		}
		*/

		// ------------------  statics ------------------------

		//CHOICE_MENU_TITLE( "@MPUI_CREATE_A_CLASS_CAP" )				
		CHOICE_MENU_TITLE( "@OW_ICE_TITLE" )				
		// ------------------------- buttons ------------------------------
		#define BACK_OPEN ;
		#include "ui_mp/navcontrols.inc"
		
		//=========================================================
		//===================== MENU SELECTION ====================
		//=========================================================
		
		// PRIMARY WEAPON BUTTON =============================================================
		#define CAC_SETUP_ACTION1 \
			execnow "set ui_primary_selected primary"; \
			play "mouse_click"; \
			open "nocd_popup_cac_primary";
		
		CHOICE_BUTTON_EX( 1, "@MPUI_PRIMARY_WEAPON1", CAC_SETUP_ACTION1, name primary_weapon_selection )

		#define CAC_SETUP_ACTION_ATTACHMENT \
			play "mouse_click"; \
			setdvar ui_primary_selected primary; \
			setdvar ui_inside_popup_nested 0; \
			uiScript openMenuOnDvar loadout_class assault "nocd_attachment_popup_assault_not_nested"; \
			uiScript openMenuOnDvar loadout_class specops "nocd_attachment_popup_specops_not_nested"; \
			uiScript openMenuOnDvar loadout_class heavygunner "nocd_attachment_popup_heavygunner_not_nested"; \
			uiScript openMenuOnDvar loadout_class demolitions "nocd_attachment_popup_demolitions_not_nested"; \
			uiScript openMenuOnDvar loadout_class sniper "nocd_attachment_popup_sniper_not_nested"; \

		CHOICE_BUTTON_BG( 2, 1 )
		CHOICE_HIGHLIGHT( 2, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 2, "@PERKS_ATTACHMENT", CAC_SETUP_ACTION_ATTACHMENT, when( !dvarBool( lock_primary_attachment ) && dvarString( loadout_primary ) != "mp44" ) )
		CHOICE_DBUTTON_VIS_NOHI( 2, "@PERKS_ATTACHMENT", when( dvarBool( lock_primary_attachment ) || dvarString( loadout_primary ) == "mp44" ) )

		// SECONDARY WEAPON/SIDE ARM BUTTON =============================================================
		#define CAC_SETUP_ACTION2 \
			play "mouse_click"; \
			open "nocd_popup_cac_secondary";

		#define CAC_SETUP_ACTION2_OVERKILL \
			execnow "set ui_primary_selected secondary"; \
			play "mouse_click"; \
			open "nocd_popup_cac_primary";

		CHOICE_BUTTON_BG( 3, 1 )
		CHOICE_HIGHLIGHT( 3, 1 )	
		//Pistol	
		CHOICE_BUTTON_VIS_NOHI( 3, "@MPUI_SIDE_ARM1", CAC_SETUP_ACTION2, when( dvarString( loadout_perk2 ) != "specialty_twoprimaries" && !dvarBool( lock_secondary ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 3, "@MPUI_SIDE_ARM1", when( dvarString( loadout_perk2 ) != "specialty_twoprimaries" && dvarBool( lock_secondary ) ) )
		//Second primary (overkill perk)
		CHOICE_BUTTON_VIS_NOHI( 3, "@MPUI_SECONDARY_WEAPON", CAC_SETUP_ACTION2_OVERKILL, when( dvarString( loadout_perk2 ) == "specialty_twoprimaries" && !dvarBool( lock_secondary ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 3, "@MPUI_SECONDARY_WEAPON", when( dvarString( loadout_perk2 ) == "specialty_twoprimaries" && dvarBool( lock_secondary ) ) )
		
		//CHOICE_BUTTON( 3, "@MPUI_SIDE_ARM1", CAC_SETUP_ACTION2 )
	
		// SPECIAL GRENADE BUTTON =============================================================
		#define CAC_SETUP_ACTION3 \
			play "mouse_click"; \
			open "nocd_popup_cac_extra";

		CHOICE_BUTTON_BG( 4, 1 )
		CHOICE_HIGHLIGHT( 4, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 4, "@MPUI_SPECIAL_GRENADE", CAC_SETUP_ACTION3, when( !dvarBool( lock_grenade ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 4, "@MPUI_SPECIAL_GRENADE", when( dvarBool( lock_grenade ) ) )	

		/* separator bar */ CHOICE_SEPARATOR( CHOICE_SEP_1 )
				
		#define CAC_SETUP_ACTION4 \
			play "mouse_click"; \
			open "nocd_popup_cac_perk1";	
		
		// PERK 1 BUTTON =============================================================
		// perk 1 empty warning
		CHOICE_BUTTON_BG_RAW( 5, "gradient_fadein", 0.5 0.15 0 0.5, when( !dvarBool( lock_perk1 ) && dvarString(loadout_perk1) == "specialty_null" && !dvarBool(loadout_perk1_locked) ); )
		CHOICE_BUTTON_FOCUS_VIS_ADV( 5, "@MPUI_PERK_1", CAC_SETUP_ACTION4, ;, ;, when( !dvarBool( lock_perk1 ) && !dvarBool(loadout_perk1_locked) ), !dvarBool(loadout_perk1_locked) )

		CHOICE_BUTTON_FOCUS_VIS_NOHI( 5, "", ;, ;, ;, when( dvarBool( lock_perk1 ) || dvarBool(loadout_perk1_locked) ) )
		CHOICE_DBUTTON_VIS( 5, "@MPUI_PERK_1", when( dvarBool( lock_perk1 ) || dvarBool(loadout_perk1_locked) ) )

		// PERK 2 BUTTON =============================================================
		#define CAC_SETUP_ACTION5 \		
			play "mouse_click"; \
			open "nocd_popup_cac_perk2";		

		CHOICE_BUTTON_BG_RAW( 6, "gradient_fadein", 0.5 0.15 0 0.5, when( !dvarBool( lock_perk2 ) && dvarString(loadout_perk2) == "specialty_null" ); )
		CHOICE_BUTTON_BG( 6, 1 )
		CHOICE_HIGHLIGHT( 6, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 6, "@MPUI_PERK_2", CAC_SETUP_ACTION5, when( !dvarBool( lock_perk2 ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 6, "@MPUI_PERK_2", when( dvarBool( lock_perk2 ) ) )
		//CHOICE_BUTTON( 6, "@MPUI_PERK_2", CAC_SETUP_ACTION5 )
		
		// PERK 3 BUTTON =============================================================
		#define CAC_SETUP_ACTION6 \		
			play "mouse_click"; \
			open "nocd_popup_cac_perk3";		

		CHOICE_BUTTON_BG_RAW( 7, "gradient_fadein", 0.5 0.15 0 0.5, when( !dvarBool( lock_perk3 ) && dvarString(loadout_perk3) == "specialty_null" ); )
		CHOICE_BUTTON_BG( 7, 1 )
		CHOICE_HIGHLIGHT( 7, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 7, "@MPUI_PERK_3", CAC_SETUP_ACTION6, when( !dvarBool( lock_perk3 ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 7, "@MPUI_PERK_3", when( dvarBool( lock_perk3 ) ) )
		
		/* separator bar */ CHOICE_SEPARATOR( CHOICE_SEP_2 )

		#define CAC_SETUP_ACTIONGO \		
			play "mouse_click"; \
			scriptMenuResponse "go";

		CHOICE_BUTTON( 8, "@MENU_ACCEPT", CAC_SETUP_ACTIONGO )
				
		/* ================================================================================= */
		/* ================================ LOADOUT DISPLAY ================================ */
		/* ================================================================================= */

		#define STAT_CAC_PRIMARY				tableLookup("mp/statstable.csv", 4, dvarString( loadout_primary ), 0)
		#define STAT_CAC_PRIMARY_ATTACHMENT		tableLookup("mp/attachmentTable.csv", 4, dvarString( loadout_primary_attachment ), 9)
		#define STAT_CAC_SECONDARY				tableLookup("mp/statstable.csv", 4, dvarString( loadout_secondary ), 0)
		#define STAT_CAC_SECONDARY_ATTACHMENT	tableLookup("mp/attachmentTable.csv", 4, dvarString( loadout_secondary_attachment ), 9)
		#define STAT_CAC_SPECIALTY_EQUIPMENT	tableLookup("mp/statstable.csv", 4, dvarString( loadout_perk1 ), 0)
		#define STAT_CAC_SPECIALTY_WEAPON		tableLookup("mp/statstable.csv", 4, dvarString( loadout_perk2 ), 0)
		#define STAT_CAC_SPECIALTY_ABILITY		tableLookup("mp/statstable.csv", 4, dvarString( loadout_perk3 ), 0)
		#define STAT_CAC_SPECIAL_GRENADE		tableLookup("mp/statstable.csv", 4, dvarString( loadout_grenade ), 0)
		#define STAT_CAC_CAMO					tableLookup("mp/attachmentTable.csv", 4, dvarString( loadout_camo ), 11)
		
		#include "ui_mp/cac_loadout_ingame.inc"

		#include "ui/safearea.menu"
	}

	// close all 2nd and 3rd layer popups on end action
	#define PREPROC_ATTACH_CLOSEALL \
	close "nocd_popup_cac_primary"; \
	close "nocd_popup_cac_secondary"; \
	close "nocd_popup_cac_assault"; \
	close "nocd_popup_cac_specops"; \
	close "nocd_popup_cac_heavygunner"; \
	close "nocd_popup_cac_sniper"; \
	close "nocd_popup_cac_demolitions"; \
	close "popup_cac_template"; \
	close "nocd_attachment_popup_assault"; \
	close "nocd_attachment_popup_specops"; \
	close "nocd_attachment_popup_heavygunner"; \
	close "nocd_attachment_popup_sniper"; \
	close "nocd_attachment_popup_demolitions"; \
	close "nocd_attachment_popup_assault_not_nested"; \
	close "nocd_attachment_popup_specops_not_nested"; \
	close "nocd_attachment_popup_heavygunner_not_nested"; \
	close "nocd_attachment_popup_sniper_not_nested"; \
	close "nocd_attachment_popup_demolitions_not_nested"; \
	close "nocd_attachment_popup_pistol"; \
	close "nocd_attachment_popup_fake";	\
	close "nocd_popup_cac_camo"; \
	close "nocd_popup_cac_camo_no_attach";
	

#include "ui_mp/popupstyle.inc"	
#include "ui/choices_setup_popmenu.menu"

#undef CHOICE_SIZE_X
#define CHOICE_SIZE_X			216

#undef NEW_X_OFFSET			
#define NEW_X_OFFSET	(0-CHOICE_SIZE_X)

#undef NEW_Y_OFFSET			
#define NEW_Y_OFFSET	(0-2)

	// ====================================================================================================
	// primary weapon selection ===========================================================================
	// ====================================================================================================
	#define LOCAL_WEAPON_INFO_WINDOW( highlight_dvar ) \
		/* weapon information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" ); ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" );, 0, 0 )\ \
		/* weapon image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+72) -6 180 90 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" ); ) \
		/* weapon title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" ); ) \
		/* weapon desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( dvarBool( ui_primary_hl_unlocked ) ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@MENU_DISABLED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( !dvarBool( ui_primary_hl_unlocked ) && !dvarBool( ui_primary_equipped_overkill ) ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@OW_ICE_LOCK_EQUIPPED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( !dvarBool( ui_primary_hl_unlocked ) && dvarBool( ui_primary_equipped_overkill ) ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( !dvarBool( ui_primary_hl_unlocked ) ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, dvarString(ui_weapon_class_selected), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR ) \
		/* pointer icon */ \
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_down", 0.9 0.9 0.95 0.4, 0, 2, CHOICE_POPUP_BORDER_COLOR )

	#define LOCAL_PRIMARY_WEAPON_SET( wClass, wRef ) \
		play "mouse_click";\
		setdvar loadout_class wClass;\
		setdvar loadout_primary wRef;\
		setdvar loadout_primary_attachment REF_ATTACHMENT_NONE;\
		setdvar loadout_camo REF_CAMO_NONE;\
		scriptMenuResponse "set:primary:"wRef;\
		scriptMenuResponse "set:primary_attachment:"REF_ATTACHMENT_NONE;\
		scriptMenuResponse "set:camo:"REF_CAMO_NONE;\
		scriptMenuResponse "validate:perks";\
		UPDATE_PERK1;

	#define LOCAL_SECONDARY_WEAPON_SET( wClass, wRef ) \
		play "mouse_click";\
		setdvar loadout_class_secondary wClass;\
		setdvar loadout_secondary wRef;\
		setdvar loadout_secondary_attachment REF_ATTACHMENT_NONE;\
		scriptMenuResponse "set:secondary:"wRef;\
		scriptMenuResponse "set:secondary_attachment:"REF_ATTACHMENT_NONE;\
		scriptMenuResponse "validate:perks";\
		UPDATE_PERK1;

	#define LOCAL_PRIMARY_WEAPON_ACTION( wClass, wRef ) \
		LOCAL_PRIMARY_WEAPON_SET( wClass, wRef );\
		setdvar ui_inside_popup_nested 1;\
		open "nocd_attachment_popup_"wClass;

	#define LOCAL_PRIMARY_WEAPON_ACTION_OVERKILL( wClass, wRef ) \
		LOCAL_SECONDARY_WEAPON_SET( wClass, wRef );\
		setdvar ui_inside_popup_nested 1;\
		open "nocd_attachment_popup_"wClass;

	#define LOCAL_PRIMARY_WEAPON_ACTION3( wClass, wRef ) \
		LOCAL_PRIMARY_WEAPON_SET( wClass, wRef );\
		setdvar ui_inside_popup_nested 1; \
		open "nocd_attachment_popup_fake"; \
		open "nocd_popup_cac_camo_no_attach";	

	#define LOCAL_PRIMARY_WEAPON_ACTION3_OVERKILL( wClass, wRef ) \
		LOCAL_SECONDARY_WEAPON_SET( wClass, wRef ); \
		PREPROC_ATTACH_CLOSEALL

	#define WI_FOCUS_ACTION( wClass, wRef ) \
		execOnDvarStringValue "weap_allow_"wClass"_"wRef 0 "set ui_primary_hl_unlocked 0"; \
		execOnDvarStringValue "weap_allow_"wClass"_"wRef 1 "set ui_primary_hl_unlocked 1"; \
		exec "set ui_primary_highlighted "wRef; \
		setdvar ui_primary_equipped_overkill 0;

	#define WI_FOCUS_ACTION_OVERKILL( wClass, wRef ) \
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
		dvarString( ui_primary_selected ) == "primary" && dvarString ( loadout_secondary ) != wRef

	#define LOCAL_SECONDARY_WEAPON_ALLOWED_OVERKILL( wClass, wRef ) \
		dvarString( ui_primary_selected ) == "secondary" && dvarString ( loadout_primary ) != wRef && dvarString( "perk_"wClass"_allow_specialty_twoprimaries" ) > 0

	#define LOCAL_WEAPON_DISABLED_OVERKILL( wClass, wRef ) \
		LOCAL_WEAPON_IS_ALLOWED ( wClass, wRef ) && dvarString( loadout_perk2 ) == "specialty_twoprimaries" && \
		( \
			( dvarString( ui_primary_selected ) == "primary" && dvarString ( loadout_secondary ) == wRef ) || \
			( dvarString( ui_primary_selected ) == "secondary" && dvarString ( loadout_primary ) == wRef ) \
		)

	#define LOCAL_WEAPON_IS_ALLOWED( wClass, wRef ) \
		dvarBool( "weap_allow_"wClass"_"wRef )

	//#define LOCAL_WEAPON_IS_ALLOWED_OVERKILL( wClass, wRef )\
	//	LOCAL_WEAPON_IS_ALLOWED ( wClass, wRef ) && dvarString( "perk_"wClass"_allow_specialty_twoprimaries" ) == "1";

	#define LOCAL_WEAPON_RESET_ALLOWED( wClass, wRef ) \
		exec "set weap_allow_"wClass"_"wRef" 1"

	// hacked to hide the second primary if same weapon is selected in first primary, change weapon description to "Already selected"
	#define LOCAL_WEAPON_ITEM( itemNum, wName, wClass, wRef )\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, WI_FOCUS_ACTION( wClass, wRef ), ;, when( ! ( LOCAL_WEAPON_IS_ALLOWED( wClass, wRef ) ) ); )\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, WI_FOCUS_ACTION_OVERKILL( wClass, wRef ), ;, when( LOCAL_WEAPON_DISABLED_OVERKILL( wClass, wRef ) ); )\
		CHOICE_DBUTTON_VIS( itemNum, wName, when( 1 ); ) \
		/*Primary*/\
		CHOICE_BUTTON_FOCUS_VIS_ADV_HK( itemNum, wName, LOCAL_PRIMARY_WEAPON_ACTION( wClass, wRef ), \
			WI_FOCUS_ACTION( wClass, wRef ), ;, when( \
			LOCAL_PRIMARY_WEAPON_VISIBLE( wClass, wRef ) );, \
			LOCAL_PRIMARY_WEAPON_VISIBLE( wClass, wRef ) ) \
		/*Secondary (overkill perk)*/\
		CHOICE_BUTTON_FOCUS_VIS_ADV_HK( itemNum, wName, LOCAL_PRIMARY_WEAPON_ACTION_OVERKILL( wClass, wRef ), \
			WI_FOCUS_ACTION( wClass, wRef ), ;, when( \
			LOCAL_SECONDARY_WEAPON_VISIBLE( wClass, wRef ) );, \
			LOCAL_SECONDARY_WEAPON_VISIBLE( wClass, wRef ) )
		
	#define LOCAL_WEAPON_ITEM2( itemNum, wName, wClass, wRef )\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, WI_FOCUS_ACTION( wClass, wRef ), ;, when( ! ( LOCAL_WEAPON_IS_ALLOWED( wClass, wRef ) ) ); )\
		/*CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, WI_FOCUS_ACTION_OVERKILL( wClass, wRef ), ;, when( LOCAL_WEAPON_DISABLED_OVERKILL( wClass, wRef ) ); )*/\
		CHOICE_DBUTTON_VIS( itemNum, wName, when( 1 ); ) \
		/*Primary*/\
		CHOICE_BUTTON_FOCUS_VIS_ADV_HK( itemNum, wName, LOCAL_PRIMARY_WEAPON_ACTION3( wClass, wRef ), \
			WI_FOCUS_ACTION( wClass, wRef ), ;, when( \
			LOCAL_PRIMARY_WEAPON_VISIBLE( wClass, wRef ) );, \
			LOCAL_PRIMARY_WEAPON_VISIBLE( wClass, wRef ) )\
		/*Secondary (overkill perk)*/\
		CHOICE_BUTTON_FOCUS_VIS_ADV_HK( itemNum, wName, LOCAL_PRIMARY_WEAPON_ACTION3_OVERKILL( wClass, wRef ), \
			WI_FOCUS_ACTION( wClass, wRef ), ;, when( \
			LOCAL_SECONDARY_WEAPON_VISIBLE( wClass, wRef ) );, \
			LOCAL_SECONDARY_WEAPON_VISIBLE( wClass, wRef ) )

	#define LOCAL_WEAPON_CLASS_ACTION( wClass, className ) \
		play "mouse_click";\
		/*execnow "set loadout_class "wClass"; set ui_weapon_class_selected "className;*/\
		execnow "set ui_weapon_class_selected "className;\
		open "nocd_popup_cac_"wClass;\
		scriptMenuResponse "allow:"wClass":atch";

	#define LOCAL_WEAPON_CLASS_ACTION_OVERKILL( wClass, className ) \
		LOCAL_WEAPON_CLASS_ACTION( wClass, className )\
		scriptMenuResponse "allow:"wClass":perk2";
	/*
	#define LOCAL_WEAPON_CLASS( itemNum, wClass, className ) \
		CHOICE_BUTTON_EX( itemNum, className, LOCAL_WEAPON_CLASS_ACTION( wClass, className ), name wClass; )
	*/
	#define LOCAL_WEAPON_CLASS( itemNum, wClass, className )\
		CHOICE_BUTTON_FOCUS_VIS( itemNum, className, LOCAL_WEAPON_CLASS_ACTION( wClass, className );, ;, ;, when( dvarString( ui_primary_selected ) == "primary" ) );\
		CHOICE_BUTTON_FOCUS_VIS( itemNum, className, LOCAL_WEAPON_CLASS_ACTION_OVERKILL( wClass, className );, ;, ;, when( dvarString( ui_primary_selected ) == "secondary" && dvarString( "perk_"wClass"_allow_specialty_twoprimaries" ) > 0 ) );\
		CHOICE_DBUTTON_VIS( itemNum, className, when( dvarString( ui_primary_selected ) == "secondary" && dvarString( "perk_"wClass"_allow_specialty_twoprimaries" ) == 0 ); )
		
	#define LOCAL_WEAPON_ONOPEN\
		execnow "set ui_inside_popup weapon_class; set ui_show_preview 1";\
		scriptMenuResponse "allow:twoprimaries";

	// primary weapon class dropdown
	#define LOCAL_MASTER_CLASS_GROUP( suffix, pos, y_offset )\
	menuDef {\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_primary"suffix, 5, (CHOICE_X( pos )-2), (CHOICE_Y( pos )-4+y_offset), ;, LOCAL_WEAPON_ONOPEN, 1 )\
		onClose{execnow "set ui_show_preview 0; set ui_primary_highlighted 0; set ui_attachment_highlighted 0";	}\
		LOCAL_WEAPON_CLASS( 1, "assault", "@MPUI_ASSAULT_RIFLES" )\
		LOCAL_WEAPON_CLASS( 2, "specops", "@MPUI_SUB_MACHINE_GUNS" )\
		LOCAL_WEAPON_CLASS( 3, "heavygunner", "@MPUI_LIGHT_MACHINE_GUNS" )\
		LOCAL_WEAPON_CLASS( 4, "demolitions", "@MPUI_SHOTGUNS" )\
		LOCAL_WEAPON_CLASS( 5, "sniper", "@MPUI_SNIPER_RIFLES" )\	
	}

	#define LOCAL_WEAPON_CLASS_ONOPEN( wRef, wClass )\
		execnow "set "UI_FOCUSFIRST" "wRef"; set ui_inside_popup "wClass;\
		scriptMenuResponse "allow:"wClass":weap";\

	// primary and second primary class selection popup menus
	LOCAL_MASTER_CLASS_GROUP( "", 1, 0)

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_primary_highlighted"
		
	// primary weapon items
	#define LOCAL_MASTER_WEAPON_GROUP( suffix, pos, y_offset )\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_assault"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, LOCAL_WEAPON_CLASS_ONOPEN( REF_M16, "assault" ), 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( 1, "@WEAPON_M16", "assault", REF_M16 )\
		LOCAL_WEAPON_ITEM( 2, "@WEAPON_AK47", "assault", REF_AK47 )\
		LOCAL_WEAPON_ITEM( 3, "@WEAPON_M4_CARBINE", "assault", REF_M4 )\
		LOCAL_WEAPON_ITEM( 4, "@WEAPON_G3", "assault", REF_G3 )\
		LOCAL_WEAPON_ITEM( 5, "@WEAPON_G36C", "assault", REF_G36C )\
		LOCAL_WEAPON_ITEM( 6, "@WEAPON_M14", "assault", REF_M14 )\
		LOCAL_WEAPON_ITEM2( 7, "@WEAPON_MP44", "assault", REF_MP44 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_heavygunner"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, LOCAL_WEAPON_CLASS_ONOPEN( REF_M249SAW, "heavygunner" ), 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( 1, "@WEAPON_SAW", "heavygunner", REF_M249SAW )\
		LOCAL_WEAPON_ITEM( 2, "@WEAPON_RPD", "heavygunner", REF_RPD )\
		LOCAL_WEAPON_ITEM( 3, "@WEAPON_M60E4", "heavygunner", REF_M60E4 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_specops"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, LOCAL_WEAPON_CLASS_ONOPEN( REF_MP5, "specops" ), 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( 1, "@WEAPON_MP5", "specops", REF_MP5 )\
		LOCAL_WEAPON_ITEM( 2, "@WEAPON_SKORPION", "specops", REF_SKORPION )\
		LOCAL_WEAPON_ITEM( 3, "@WEAPON_UZI", "specops", REF_UZI )\
		LOCAL_WEAPON_ITEM( 4, "@WEAPON_AK74U", "specops", REF_AK74U )\
		LOCAL_WEAPON_ITEM( 5, "@WEAPON_P90", "specops", REF_P90 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_demolitions"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, LOCAL_WEAPON_CLASS_ONOPEN( REF_WINCHESTER1200, "demolitions" ), 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( 1, "@WEAPON_WINCHESTER1200", "demolitions", REF_WINCHESTER1200 )\
		LOCAL_WEAPON_ITEM( 2, "@WEAPON_BENELLI", "demolitions", REF_BENELLIM4 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_sniper"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, LOCAL_WEAPON_CLASS_ONOPEN( REF_M40A3, "sniper" ), 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( 1, "@WEAPON_M40A3", "sniper", REF_M40A3 )\
		LOCAL_WEAPON_ITEM( 2, "@WEAPON_M21", "sniper", REF_M21 )\
		LOCAL_WEAPON_ITEM( 3, "@WEAPON_DRAGUNOV", "sniper", REF_DRAGUNOVSVD )\
		LOCAL_WEAPON_ITEM( 4, "@WEAPON_REMINGTON700", "sniper", REF_REMINGTON700 )\
		LOCAL_WEAPON_ITEM( 5, "@WEAPON_BARRETT", "sniper", REF_BARRETT )\
	}
	

	// primary and second primary weapon selection popup menus
	LOCAL_MASTER_WEAPON_GROUP( "", 1, 0 )

	// ====================================================================================================
	// primary and second primary attachment selection ====================================================
	// ====================================================================================================
	#define LOCAL_ATTACHMENT_INFO_WINDOW( parentDvar ) \
		/* attachment information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString(ui_inside_popup) != "camo" );, 0, 0 ) \
		/* attachment image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+182) 6 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		/* attachment title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		/* attachment desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( dvarBool( ui_attachment_hl_unlocked ) ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@MENU_DISABLED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( !dvarBool( ui_attachment_hl_unlocked ) ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( !dvarBool( ui_attachment_hl_unlocked ) && dvarString(ui_inside_popup) != "camo" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarBool( ui_inside_popup_nested ) ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(parentDvar),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR visible when( dvarBool( ui_inside_popup_nested ) ); )\
		/* pointer icon */ \
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarBool( ui_inside_popup_nested ) ); )


	#define LOCAL_ATTACHMENT_ACTION( attachmentName, paction, wClass ) \
		setdvar loadout_primary_attachment attachmentName; \
		scriptMenuResponse "set:primary_attachment:"attachmentName;\
		UPDATE_PERK1 \
		close self;\
		uiScript openMenuOnDvar ui_inside_popup_nested 1 "nocd_attachment_popup_"wClass;\
		execOnDvarStringValue ui_inside_popup_nested 1 "set loadout_camo camo_none";\
		uiScript openMenuOnDvar ui_inside_popup_nested 1 "nocd_popup_cac_camo";
		
	#define LOCAL_ATTACHMENT_ACTION_OVERKILL( attachmentName, paction, wClass ) \
		setdvar loadout_secondary_attachment attachmentName; \
		scriptMenuResponse "set:secondary_attachment:"attachmentName;\
		UPDATE_PERK1 \
		PREPROC_ATTACH_CLOSEALL

	#define LOCAL_PISTOL_ATTACHMENT_ACTION( attachmentName, paction, wClass ) \
		setdvar loadout_secondary_attachment attachmentName; \
		scriptMenuResponse "set:secondary_attachment:"attachmentName;\
		PREPROC_ATTACH_CLOSEALL

	#define AI_FOCUS_ACTION( wClass, wRef ) \
		execOnDvarStringValue "attach_allow_"wClass"_"wRef 0 "set ui_attachment_hl_unlocked 0";\
		execOnDvarStringValue "attach_allow_"wClass"_"wRef 1 "set ui_attachment_hl_unlocked 1";\
		exec "set ui_attachment_highlighted "wRef;

	#define LOCAL_ATTACHMENT_ITEM( itemNum, wClass ,p_numref, wRef, paction, wSlot, bitMask )\
		/*Primary attachment*/\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,wRef,3), LOCAL_ATTACHMENT_ACTION( wRef, paction, wClass );, \
			AI_FOCUS_ACTION(wClass,wRef), ;, when( dvarString( ui_primary_selected ) == "primary" && dvarBool( "attach_allow_"wClass"_"wRef ) ), dvarString( ui_primary_selected ) == "primary" && dvarBool( "attach_allow_"wClass"_"wRef ) ) \
		/*Secondary attachment (overkill perk)*/\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,wRef,3), LOCAL_ATTACHMENT_ACTION_OVERKILL( wRef, paction, wClass );, \
			AI_FOCUS_ACTION(wClass,wRef), ;, when( dvarString( ui_primary_selected ) == "secondary" && dvarBool( "attach_allow_"wClass"_"wRef ) ), dvarString( ui_primary_selected ) == "secondary" && dvarBool( "attach_allow_"wClass"_"wRef ) ) \
		/*Disabled*/\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, AI_FOCUS_ACTION(wClass,wRef), ;, when( !dvarBool( "attach_allow_"wClass"_"wRef ) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,wRef,3), when( !dvarBool( "attach_allow_"wClass"_"wRef ) ); ) \
		
	#define LOCAL_PISTOL_ATTACHMENT_ITEM( itemNum, wClass ,p_numref, wRef, paction, wSlot, bitMask )\
		/*Pistol attachment*/\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,wRef,3), LOCAL_PISTOL_ATTACHMENT_ACTION( wRef, paction, wClass ), \
			AI_FOCUS_ACTION(wClass,wRef), ;, when( dvarBool( "attach_allow_"wClass"_"wRef ) ), dvarBool( "attach_allow_"wClass"_"wRef ) ) \
		/*Disabled*/\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, AI_FOCUS_ACTION(wClass,wRef), ;, when( !dvarBool( "attach_allow_"wClass"_"wRef ) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,wRef,3), when( !dvarBool( "attach_allow_"wClass"_"wRef ) ); ) \
		

	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_attachment_highlighted"

	#define LOCAL_ATTACHMENT_ONOPEN( wClass )\
		execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";\
		scriptMenuResponse "allow:"wClass":atch";
	
	// primary and second primary attachment items
	#define LOCAL_MASTER_ATTACHMENT_GROUP( suffix, pos, wSlot, y_offset )\
	menuDef { /* assault attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_attachment_popup_assault"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, LOCAL_ATTACHMENT_ONOPEN( "assault" ) , !dvarBool( ui_inside_popup_nested ) )\
		onClose{execnow "set ui_inside_popup 0";}\
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_"wSlot )\
		LOCAL_ATTACHMENT_ITEM( 1, "assault", NUM_NONE, "none", ;, wSlot, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, "assault", NUM_GL, "gl", play "mouse_click"; ;, wSlot, GL_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, "assault", NUM_SUPPRESSOR, "silencer", ;, wSlot, SILENCER_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, "assault", NUM_REFLEX, "reflex", ;, wSlot, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 5, "assault", NUM_ACOG, "acog", ;, wSlot, ACOG_NEW_BITMASK )\
	}\
	menuDef { /* LMG attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_attachment_popup_heavygunner"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, LOCAL_ATTACHMENT_ONOPEN( "heavygunner" ) , !dvarBool( ui_inside_popup_nested ) )\
		onClose{execnow "set ui_inside_popup 0";}\
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_"wSlot )\
		LOCAL_ATTACHMENT_ITEM( 1, "heavygunner", NUM_NONE, "none", ;, wSlot, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, "heavygunner", NUM_REFLEX, "reflex", ;, wSlot, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, "heavygunner", NUM_GRIP, "grip", ;, wSlot, GRIP_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, "heavygunner", NUM_ACOG, "acog", ;, wSlot, ACOG_NEW_BITMASK )\
	}\
	menuDef	{ /* SMG attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_attachment_popup_specops"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, LOCAL_ATTACHMENT_ONOPEN( "specops" ) , !dvarBool( ui_inside_popup_nested ) )\
		onClose{execnow "set ui_inside_popup 0";}\
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_"wSlot )\
		LOCAL_ATTACHMENT_ITEM( 1, "specops", NUM_NONE, "none", ;, wSlot, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, "specops", NUM_SUPPRESSOR, "silencer", ;, wSlot, SILENCER_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, "specops", NUM_REFLEX, "reflex", ;, wSlot, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, "specops", NUM_ACOG, "acog", ;, wSlot, ACOG_NEW_BITMASK )\
	}\
	menuDef { /* demolitions attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_attachment_popup_demolitions"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, LOCAL_ATTACHMENT_ONOPEN( "demolitions" ) , !dvarBool( ui_inside_popup_nested ) )\
		onClose{execnow "set ui_inside_popup 0";}\
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_"wSlot )\
		LOCAL_ATTACHMENT_ITEM( 1, "demolitions", NUM_NONE, "none", ;, wSlot, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, "demolitions", NUM_REFLEX, "reflex", ;, wSlot, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, "demolitions", NUM_GRIP, "grip", ;, wSlot, GRIP_NEW_BITMASK )\
	}\
	menuDef	{ /* sniper attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_attachment_popup_sniper"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, LOCAL_ATTACHMENT_ONOPEN( "sniper" ) , !dvarBool( ui_inside_popup_nested ) )\
		onClose{execnow "set ui_inside_popup 0";}\		
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_"wSlot )\
		LOCAL_ATTACHMENT_ITEM( 1, "sniper", NUM_NONE, "none", ;, wSlot, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, "sniper", NUM_ACOG, "acog", ;, wSlot, ACOG_NEW_BITMASK )\
	}

	menuDef	{ /* fake attachment heading for weapons without attachments to be displayed on top of camo popup */
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_attachment_popup_fake", 7, (CHOICE_X( 1 )-2), (CHOICE_Y( 1 ) + 44), ;, execnow "set ui_inside_popup attachment";, 0 )
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_primary" )
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(loadout_primary),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR )
		/* pointer icon */
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR )
	}

	// side arm attachment selection ======================================================================
	menuDef	{ /* pistol attachments*/
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_attachment_popup_pistol", 7, (CHOICE_X( 2 )-2), (CHOICE_Y( 2 )+24), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )
		onClose{execnow "set ui_inside_popup 0";}
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_secondary" )
		//LOCAL_ATTACHMENT_ITEM( 1, CAC_SECONDARY_ATTACHMENT, "pistol", NUM_NONE, "none", ;, "secondary", "ui_secondary_weapon", 0 )
		//LOCAL_ATTACHMENT_ITEM( 2, CAC_SECONDARY_ATTACHMENT, "pistol", NUM_SUPPRESSOR, "silencer", ;, "secondary", "ui_secondary_weapon", SILENCER_NEW_BITMASK )
		LOCAL_PISTOL_ATTACHMENT_ITEM( 1, "pistol", NUM_NONE, "none", ;, "secondary", 0 )
		LOCAL_PISTOL_ATTACHMENT_ITEM( 2, "pistol", NUM_SUPPRESSOR, "silencer", ;, "secondary", SILENCER_NEW_BITMASK )
	}
	
	// primary and second primary attachment popup menus
	//LOCAL_MASTER_ATTACHMENT_GROUP( CAC_PRIMARY_ATTACHMENT, "", 1, "primary", 0, "loadout_primary_attachment" )
	LOCAL_MASTER_ATTACHMENT_GROUP( "", 1, "primary", 0 )
	LOCAL_MASTER_ATTACHMENT_GROUP( "_not_nested", 1, "primary", -48)
	//LOCAL_MASTER_ATTACHMENT_GROUP( "_secondary", 1, "secondary", 0 )

	// ====================================================================================================
	// side arm selection ===============================================================================
	// ====================================================================================================
	#define LOCAL_SIDEARM_INFO_WINDOW( highlight_dvar ) \
		/* sidearm information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" ); ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString(ui_inside_popup) != "attachment" );, 0, 0 )\
		/* sidearm image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+138) -12 90 90 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" ); ) \
		/* sidearm title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( dvarString(ui_inside_popup) != "attachment" ); ) \
		/* sidearm desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( dvarBool( ui_sidearm_hl_unlocked ) ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@MENU_DISABLED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( !dvarBool( ui_sidearm_hl_unlocked ) ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( !dvarBool( ui_sidearm_hl_unlocked ) ); ) \

	#define LOCAL_SIDEARM_ACTION( wRef ) \
			play "mouse_click"; \
			setdvar	loadout_secondary wRef; \
			setdvar	loadout_secondary_attachment none; \
			scriptMenuResponse "set:secondary:"wRef;\
			PREPROC_ATTACH_CLOSEALL

	#define LOCAL_SIDEARM_ACTION2( wRef ) \		
			play "mouse_click"; \
			setdvar	loadout_secondary wRef; \
			setdvar	loadout_secondary_attachment none; \
			scriptMenuResponse "set:secondary:"wRef;\
			scriptMenuResponse "set:secondary_attachment:"REF_NONE;\
			setdvar	ui_inside_popup_nested 1;\
			open "nocd_attachment_popup_pistol";\
			scriptMenuResponse "allow:pistol:atch";
	
	#define SI_FOCUS_ACTION( wRef ) \
		execOnDvarStringValue "weap_allow_"wRef 0 "set ui_sidearm_hl_unlocked 0";\
		execOnDvarStringValue "weap_allow_"wRef 1 "set ui_sidearm_hl_unlocked 1";\
		exec "set ui_sidearm_highlighted "wRef;


	#define LOCAL_SIDEARM_ITEM( itemNum, wName, wRef, highlight_dvar )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, wName, LOCAL_SIDEARM_ACTION( wRef ), SI_FOCUS_ACTION( wRef ), ;, \
		when( dvarBool( "weap_allow_"wRef ) && ( wRef == REF_DESERTEAGLE || wRef == REF_DESERTEAGLEGOLD ) );, \
			  dvarBool( "weap_allow_"wRef ) && ( wRef == REF_DESERTEAGLE || wRef == REF_DESERTEAGLEGOLD ) ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, wName, LOCAL_SIDEARM_ACTION2( wRef ), SI_FOCUS_ACTION( wRef ), ;, \
		when( dvarBool( "weap_allow_"wRef ) && wRef != REF_DESERTEAGLE && wRef != REF_DESERTEAGLEGOLD );, \
			  dvarBool( "weap_allow_"wRef ) && wRef != REF_DESERTEAGLE && wRef != REF_DESERTEAGLEGOLD ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, SI_FOCUS_ACTION( wRef ), ;, when( !dvarBool( "weap_allow_"wRef ) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, wName, when( !dvarBool( "weap_allow_"wRef ) ); )
	// side arm selection popup menu
	
	#define LOCAL_SIDEARM_ITEM_ONOPEN( wclass )\
		execnow "set "UI_FOCUSFIRST" "REF_M9BERETTA"; set selected_weapon_class "wclass"; set ui_inside_popup "wclass;\
		scriptMenuResponse "allow:"wclass":weap";

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#ifdef PC
		#define UI_FOCUSFIRST "ui_sidearm_highlighted"
	#else
		#define UI_FOCUSFIRST "ui_fake_focus"
	#endif
	
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_secondary", 7, (CHOICE_X( 2 )-2), (CHOICE_Y( 2 )), ;, LOCAL_SIDEARM_ITEM_ONOPEN( "pistol" ), 1 )
		onClose{execnow "set ui_inside_popup 0";}
		LOCAL_SIDEARM_INFO_WINDOW( "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 1, "@WEAPON_BERETTA", REF_M9BERETTA, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 2, "@WEAPON_USP", REF_USP, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 3, "@WEAPON_COLT1911", REF_COLT45, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 4, "@WEAPON_DESERTEAGLE", REF_DESERTEAGLE, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 5, "@WEAPON_DESERTEAGLEGOLD", REF_DESERTEAGLEGOLD, "ui_sidearm_highlighted" )
	}

	// ====================================================================================================
	// camo skin selection ================================================================================
	// ====================================================================================================
	#define LOCAL_CAMO_INFO_WINDOW( highlight_dvar ) \
		/* camo information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 8 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 8 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0, 0 )\
		/* camo image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+184) 0 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/attachmentTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 0.75, 1, 7, 0.2 0.2 0.225 1 ) \
		/* camo title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmenttable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE ) \
		/* camo desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmenttable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( 1 ); )\
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/attachmenttable.csv",4,dvarString(loadout_primary_attachment),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR )\
		/* pointer icon */ \
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR )

	#define LOCAL_CAMO_ACTION( camoRef ) \
			play "mouse_click"; \
			setdvar loadout_camo camoRef;\
			scriptMenuResponse "set:camo:"camoRef;\
			PREPROC_ATTACH_CLOSEALL

	#define LOCAL_CAMO_ITEM( itemNum, camoName, pnum, camoRef, highlight_dvar, bitMask, visArg )\
		CHOICE_BUTTON_FOCUS( itemNum, camoName, LOCAL_CAMO_ACTION( camoRef );, execnow "set "highlight_dvar" "camoRef;, ; );

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_camo_highlighted"
	
	// camo skin selection for primary weapon popup menu
	#define LOCAL_CAMO_GROUP( prefix, onLeave )\
	menuDef	\
	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_camo"prefix, 8, (CHOICE_X( 1 )-2), (CHOICE_Y( 1 )+68), ;, execnow "set "UI_FOCUSFIRST" "REF_CAMO_NONE"; set ui_inside_popup camo";, 0 )\
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
	LOCAL_CAMO_GROUP( "", execnow "set ui_inside_popup attachment" )
	// camo skin selection for primary weapon without attachments
	LOCAL_CAMO_GROUP( "_no_attach", execnow "set ui_inside_popup 0"; close "nocd_attachment_popup_fake" )
	
	
	// ====================================================================================================
	// special grenade selection ==========================================================================
	// ====================================================================================================
	#define LOCAL_SGRENADE_INFO_WINDOW( highlight_dvar ) \
		/* special grenade information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT(6) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT(6)-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString(ui_inside_popup) != "attachment" );, 0, 0 )\
		/*PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) (CHOICE_POPUP_HEIGHT(3)-4) 2 (CHOICE_POPUP_HEIGHT(6)-CHOICE_POPUP_HEIGHT(3)+2) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 0, 2, CHOICE_POPUP_BORDER_COLOR )*/ \
		/* special grenade image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 6 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+178) -6 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR ) \
		/* special grenade title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 34 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE ) \
		/* special grenade desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 56 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR \
		visible when( ( ( dvarString(ui_sgrenade_highlighted)=="smoke_grenade") && (dvarString( loadout_perk1 )=="specialty_specialgrenade") ) == 0 ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 56 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@MENU_DISABLED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
		visible when( (dvarString(ui_sgrenade_highlighted)=="smoke_grenade") && (dvarString( loadout_perk1 )=="specialty_specialgrenade") ); )

	#define LOCAL_SGRENADE_ACTION( wRef ) \
		play "mouse_click"; \
		setdvar loadout_grenade wRef; \
		scriptMenuResponse "set:grenade:"wRef;\
		close "nocd_popup_cac_extra"
		
	#define LOCAL_SGRENADE_ITEM( itemNum, wName, wRef, highlight_dvar )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, wName, LOCAL_SGRENADE_ACTION( wRef ), execnow "set "highlight_dvar" "wRef, ;, \
		when( ( wRef == REF_SMOKE_X1 && (dvarString(loadout_perk1)=="specialty_specialgrenade") ) == 0 && dvarBool("weap_allow_"wRef) );, \
			  ( wRef == REF_SMOKE_X1 && (dvarString(loadout_perk1)=="specialty_specialgrenade") ) == 0 && dvarBool("weap_allow_"wRef) ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set "highlight_dvar" "wRef, ;, when( wRef == REF_SMOKE_X1 && (dvarString(loadout_perk1)=="specialty_specialgrenade") && dvarBool("weap_allow_"wRef)); ) \
		CHOICE_DBUTTON_VIS( itemNum, wName, when( (wRef == REF_SMOKE_X1 && (dvarString(loadout_perk1)=="specialty_specialgrenade")) || !dvarBool("weap_allow_"wRef) ); )
	
	#define LOCAL_SGRENADE_ONOPEN\
		execnow "set "UI_FOCUSFIRST" "REF_FLASH_X1"; set ui_inside_popup sgrenade";\
		scriptMenuResponse "allow:grenade:weap";

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_sgrenade_highlighted"
	
	// special grenade selection popup menus
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_extra", 6, (CHOICE_X( 3 )-2), (CHOICE_Y( 3 )+4), ;, LOCAL_SGRENADE_ONOPEN, 1 )
		onClose{ execnow "set ui_inside_popup 0"; }
		LOCAL_SGRENADE_INFO_WINDOW( "ui_sgrenade_highlighted" )
		LOCAL_SGRENADE_ITEM( 1, "@WEAPON_FLASH_GRENADE", REF_FLASH_X1, "ui_sgrenade_highlighted" )
		LOCAL_SGRENADE_ITEM( 2, "@WEAPON_STUN_GRENADE", REF_CONCUSSION_X1, "ui_sgrenade_highlighted" )
		LOCAL_SGRENADE_ITEM( 3, "@WEAPON_SMOKE_GRENADE", REF_SMOKE_X1, "ui_sgrenade_highlighted" )
	}
	
	// ====================================================================================================
	// perk selection =====================================================================================
	// ====================================================================================================
	
	#define LOCAL_PERK_INFO_ALLOWED\
		dvarBool( "perk_allow_" + dvarString( ui_perk_hl_ref ) )

	#define LOCAL_PERK_INFO_EQUIPPED( perkSlot )\
		dvarString( "loadout_"perkSlot ) == dvarString( ui_perk_hl_ref )

	#define LOCAL_PERK_INFO_NOT_EQUIPPED( perkSlot )\
		dvarString( "loadout_"perkSlot ) != dvarString( ui_perk_hl_ref )

	#define LOCAL_PERK_INFO_ALLOWED_GRENADE\
		( dvarString( ui_perk_hl_ref ) != REF_SPECIALGRENADE_X3 || dvarString( loadout_grenade ) != REF_SMOKE_X1 )

	#define LOCAL_PERK_INFO_NOT_ALLOWED_GRENADE\
		( dvarString( ui_perk_hl_ref ) == REF_SPECIALGRENADE_X3 && dvarString( loadout_grenade ) == REF_SMOKE_X1 )

	#define LOCAL_PERK_INFO_ALLOWED_CLASS( weaponSlot )\
		dvarBool( "perk_" + dvarString( weaponSlot ) + "_allow_" + dvarString( ui_perk_hl_ref ) )
	
	#define LOCAL_PERK_INFO_ALLOWED_OVERKILL\
		( dvarString( loadout_perk2 ) != REF_TWOPRIMARIES || LOCAL_PERK_INFO_ALLOWED_CLASS( loadout_class_secondary ) )

	#define LOCAL_PERK_INFO_NOT_ALLOWED_OVERKILL\
		( dvarString( ui_perk_hl_ref ) != REF_TWOPRIMARIES && dvarString( loadout_perk2 ) == REF_TWOPRIMARIES && LOCAL_PERK_INFO_ALLOWED_CLASS( loadout_class_secondary ) == 0 )
	
	#define LOCAL_PERK_INFO_VISIBLE( perkSlot )\
		/* PERK NOT EQUIPPED */\
		LOCAL_PERK_INFO_NOT_EQUIPPED( perkSlot ) &&\
		/* PERK ALLOWED */\
		LOCAL_PERK_INFO_ALLOWED &&\
		/* PERK ALLOWED FOR CLASS */\
		LOCAL_PERK_INFO_ALLOWED_CLASS( loadout_class ) &&\
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
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+188) -2 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString( ui_perk_hl_ref ),6), 1 1 1 0.75, 0, 0, 0.2 0.2 0.225 1 )\
		/* perk title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statsTable.csv",4,dvarString( ui_perk_hl_ref ),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE )\
		/* perk desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@"+tablelookup("mp/statsTable.csv",4,dvarString( ui_perk_hl_ref ),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR\
			visible when( LOCAL_PERK_INFO_VISIBLE( perkSlot ) ); )\
		/* perk desc locked - global*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@OW_ICE_LOCK_SERVER", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
			visible when( LOCAL_PERK_INFO_ALLOWED == 0 ); )\
		/* perk desc locked - class*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@OW_ICE_LOCK_CLASS", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
			visible when( LOCAL_PERK_INFO_ALLOWED && ( LOCAL_PERK_INFO_ALLOWED_CLASS( loadout_class ) == 0 || LOCAL_PERK_INFO_NOT_ALLOWED_OVERKILL ) ); )\
		/* perk desc locked - equipped*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@OW_ICE_LOCK_EQUIPPED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
			visible when( LOCAL_PERK_INFO_EQUIPPED( perkSlot ) ); )\
		/* perk desc locked - greanade*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@OW_ICE_LOCK_FRAG", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
			visible when( LOCAL_PERK_INFO_NOT_ALLOWED_GRENADE ); )
/*
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR \
		visible when( !dvarBool( ui_perk_hl_unlocked ) || !dvarBool( "perk_"+dvarString( loadout_class )+"_allow_"+dvarString( ui_perk_hl_ref )) ); ) \
*/

	#define LOCAL_PERK_ACTION( perkSlot, perkRef, paction ) \
			play "mouse_click"; \
			close self \
			exec "set loadout_"perkSlot" "perkRef;\
			scriptMenuResponse "set:"perkSlot":"perkRef;\
			paction
		
	#define LOCAL_PERK_ITEM( itemNum, camoName, perkSlot, perkRef, paction )\
		LOCAL_PERK_ITEM_VIS( itemNum, camoName, perkSlot, perkRef, paction, 1 )

	#define PI_FOCUS_ACTION( perkRef ) \
		execOnDvarStringValue "perk_allow_"perkRef 0 "set ui_perk_hl_unlocked 0";\
		execOnDvarStringValue "perk_allow_"perkRef 1 "set ui_perk_hl_unlocked 1";\
		exec "set ui_perk_hl_ref "perkRef;

	#define LOCAL_PERK_ALLOWED( perkRef )\
		dvarBool( "perk_allow_"perkRef )

	#define LOCAL_PERK_ALLOWED_CLASS( weaponSlot, perkRef )\
		dvarBool( "perk_" + dvarString( weaponSlot ) + "_allow_"perkRef )

	#define LOCAL_PERK_ALLOWED_GRENADE( perkRef )\
		( perkRef != REF_SPECIALGRENADE_X3 || dvarString( loadout_grenade ) != REF_SMOKE_X1 )

	#define LOCAL_PERK_ALLOWED_OVERKILL( perkRef )\
		( dvarString( loadout_perk2 ) != REF_TWOPRIMARIES || LOCAL_PERK_ALLOWED_CLASS( loadout_class_secondary, perkRef ) )

	#define LOCAL_PERK_EQUIPPED( perkSlot, perkRef )\
		dvarString( "loadout_"perkSlot ) == perkRef

	#define LOCAL_PERK_NOT_EQUIPPED( perkSlot, perkRef )\
		dvarString( "loadout_"perkSlot ) != perkRef

	#define LOCAL_PERK_CHOICE_VISIBLE( perkSlot, perkRef )\
		LOCAL_PERK_NOT_EQUIPPED( perkSlot, perkRef ) &&\
		LOCAL_PERK_ALLOWED( perkRef ) &&\
		LOCAL_PERK_ALLOWED_CLASS( loadout_class, perkRef ) &&\
		LOCAL_PERK_ALLOWED_GRENADE( perkRef ) &&\
		LOCAL_PERK_ALLOWED_OVERKILL( perkRef )

	#define LOCAL_PERK_CHOICE_NOT_VISIBLE( perkSlot, perkRef )\
		LOCAL_PERK_EQUIPPED( perkSlot, perkRef ) ||\
		LOCAL_PERK_ALLOWED( perkRef ) == 0 ||\
		LOCAL_PERK_ALLOWED_CLASS( loadout_class, perkRef ) == 0 ||\
		( perkRef == REF_SPECIALGRENADE_X3 && dvarString( loadout_grenade ) == REF_SMOKE_X1 ) ||\
		( perkRef != REF_TWOPRIMARIES && dvarString( loadout_perk2 ) == REF_TWOPRIMARIES && LOCAL_PERK_ALLOWED_CLASS( loadout_class_secondary, perkRef ) == 0 )

	#define LOCAL_PERK_ITEM_VIS( itemNum, camoName, perkSlot, perkRef, paction, visArg )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, camoName, LOCAL_PERK_ACTION( perkSlot, perkRef, paction );, PI_FOCUS_ACTION( perkRef ), ;, when( LOCAL_PERK_CHOICE_VISIBLE( perkSlot, perkRef ) && visArg );, 0 )\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;,PI_FOCUS_ACTION( perkRef ), ;, when( LOCAL_PERK_CHOICE_NOT_VISIBLE( perkSlot, perkRef ) && visArg ); )\
		CHOICE_DBUTTON_VIS( itemNum, camoName, when( LOCAL_PERK_CHOICE_NOT_VISIBLE( perkSlot, perkRef ) && visArg ); )

	#define LOCAL_PERK_ONOPEN( perkRef, perkSlot )\
		execnow "set "UI_FOCUSFIRST" "perkRef"; set ui_inside_popup "perkSlot;\
		scriptMenuResponse "allow:*current&all*:"perkSlot;

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_perk_hl_ref"

	// perk1 selection for primary weapon popup menu
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_perk1", 7, (CHOICE_X( 4 )-2), (CHOICE_Y( 4 )+18), ;, LOCAL_PERK_ONOPEN( REF_C4_X2, "perk1" ), 1 )
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

	#define LOCAL_RESET_PISTOL \
		execnowondvarstringvalue ui_dual_primaries 1 "set loadout_secondary "REF_M9BERETTA"; set loadout_secondary_attachment "REF_ATTACHMENT_NONE"; set ui_dual_primaries 0";\
		scriptMenuResponse "validate:perks";\
		UPDATE_PERK1;

	#define LOCAL_INIT_DUAL_PRIMARY_M16 \
		execnow "set loadout_class_secondary assault; set loadout_secondary "REF_M16"; set loadout_secondary_attachment "REF_ATTACHMENT_NONE"; set ui_dual_primaries 1";\
		scriptMenuResponse "set:secondary:"REF_M16;\
   		scriptMenuResponse "set:secondary_attachment:"REF_ATTACHMENT_NONE;\
		scriptMenuResponse "validate:perks"

	#define LOCAL_INIT_DUAL_PRIMARY_AK47 \
		execnow "set loadout_class_secondary assault; set loadout_secondary "REF_AK47"; set loadout_secondary_attachment "REF_ATTACHMENT_NONE"; set ui_dual_primaries 1";\
		scriptMenuResponse "set:secondary:"REF_AK47;\
   		scriptMenuResponse "set:secondary_attachment:"REF_ATTACHMENT_NONE;\
		scriptMenuResponse "validate:perks"

	// perk2 selection for primary weapon popup menu
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_perk2", 7, (CHOICE_X( 5 )-2), (CHOICE_Y( 5 )+22), ;, LOCAL_PERK_ONOPEN( REF_BULLETDAMAGE, "perk2" ), 1 )
		onClose{ execnow "set ui_inside_popup 0"; }
		LOCAL_PERK_INFO_WINDOW( "perk2" )
		LOCAL_PERK_ITEM( 1, "@PERKS_STOPPING_POWER", "perk2", REF_BULLETDAMAGE, LOCAL_RESET_PISTOL )
		LOCAL_PERK_ITEM( 2, "@PERKS_JUGGERNAUT", "perk2", REF_ARMORVEST, LOCAL_RESET_PISTOL )
		LOCAL_PERK_ITEM( 3, "@PERKS_SLEIGHT_OF_HAND", "perk2", REF_FASTRELOAD, LOCAL_RESET_PISTOL )
		LOCAL_PERK_ITEM( 4, "@PERKS_DOUBLE_TAP", "perk2", REF_ROF, LOCAL_RESET_PISTOL )
		/*hacked, init to m16 if not m16*/	
		LOCAL_PERK_ITEM_VIS( 5, "@PERKS_OVERKILL", "perk2", REF_TWOPRIMARIES, LOCAL_INIT_DUAL_PRIMARY_M16, dvarString ( "loadout_primary" ) != REF_M16 )
		/*hacked, init to ak47 if m16*/		
		LOCAL_PERK_ITEM_VIS( 5, "@PERKS_OVERKILL", "perk2", REF_TWOPRIMARIES, LOCAL_INIT_DUAL_PRIMARY_AK47, dvarString ( "loadout_primary" ) == REF_M16 )
		LOCAL_PERK_ITEM( 6, "@PERKS_UAV_JAMMER", "perk2", REF_GPSJAMMER, LOCAL_RESET_PISTOL )
		LOCAL_PERK_ITEM( 7, "@PERKS_SONIC_BOOM", "perk2", REF_EXPLOSIVEDAMAGE, LOCAL_RESET_PISTOL )
	}
				
	// perk3 selection for primary weapon popup menu
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "nocd_popup_cac_perk3", 8, (CHOICE_X( 6 )-2), (CHOICE_Y( 6 )+26), ;, LOCAL_PERK_ONOPEN( REF_LONGERSPRINT, "perk3" ), 1 )
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
