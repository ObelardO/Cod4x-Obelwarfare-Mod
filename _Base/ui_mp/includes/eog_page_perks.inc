// Step 2: features and perks. Included inside popup_unlock.

		// Frame. Always the full card height.
		FRAMING_VIS( RECT_MAINFRAME, EOG_STEP(2) )
		COLOR_STRIP( 2, 0 0 1 0.1 )

		// Inner plates for the feature row and the perk chart.
		INNER_FRAME( (WIDTH_MAINFRAME-12), 61, 6, 6, EOG_STEP(2) )
		INNER_FRAME( (WIDTH_MAINFRAME-12-24), 160, 30, 73, EOG_STEP(2) && VIS_PERKS )
		PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME (WIDTH_MAINFRAME-12-28) 88, 34 144, "white", 1 1 1 0.075, 0, 0, EOG_BORDER_COLOR WHEN_STEP( 2, VIS_PERKS ) )

		// Section title shades. Feature lights for a feature or a new challenge. Perk lights only when a perk is visible.
		#define LOCAL_FEATURES		dvarString(player_unlockfeatures) != 0 || dvarString(player_unlockchallenges) != 0

		SHADE_OFF_ON( 80 28, 10 9, "white", 2, LOCAL_FEATURES )
		SHADE_OFF_ON( 7 -28, 90 9, "button_highlight_end", 2, LOCAL_FEATURES )

		#define PERK_FILLED		dvarString(player_unlockperk0) != "" && VIS_PERKS
		SHADE( 63 33, 34 75, "white", TITLE_BG_COLOR_ON, EOG_STEP(2) && PERK_FILLED )
		SHADE( 56 28, 34 108, "white", TITLE_BG_COLOR_ON, EOG_STEP(2) && PERK_FILLED )
		SHADE( 7 -28, 90 108, "button_highlight_end", TITLE_BG_COLOR_ON, EOG_STEP(2) && PERK_FILLED )

		// Section titles.
		SECTION_LABEL( 30, "@MPUI_FEATURE_PRE", EOG_STEP(2) && LOCAL_FEATURES )
		SECTION_LABEL( 96, "@MPUI_PERK_PRE", EOG_STEP(2) && VIS_PERKS )

		// One feature line. Challenges are prefixed, then up to four feature names.
		#define LOCAL_FEATURE( ptext, visArg ) \
			PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME 348 38, 104 30, exp text( ptext ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, COLOR_TITLE WHEN_STEP( 2, visArg ) autowrapped )

		#define LOCAL_LOCSTRING0_CH locString("@MPUI_NEW_CHALLENGES")
		#define LOCAL_LOCSTRING1_CH LOCAL_LOCSTRING0_CH + ", " + locString("@"+dvarString(player_unlockfeature0))
		#define LOCAL_LOCSTRING2_CH LOCAL_LOCSTRING1_CH + ", " + locString("@"+dvarString(player_unlockfeature1))
		#define LOCAL_LOCSTRING3_CH LOCAL_LOCSTRING2_CH + ", " + locString("@"+dvarString(player_unlockfeature2))
		#define LOCAL_LOCSTRING4_CH LOCAL_LOCSTRING3_CH + ", " + locString("@"+dvarString(player_unlockfeature3))

		#define LOCAL_LOCSTRING1 locString("@"+dvarString(player_unlockfeature0))
		#define LOCAL_LOCSTRING2 LOCAL_LOCSTRING1 + ", " + locString("@"+dvarString(player_unlockfeature1))
		#define LOCAL_LOCSTRING3 LOCAL_LOCSTRING2 + ", " + locString("@"+dvarString(player_unlockfeature2))
		#define LOCAL_LOCSTRING4 LOCAL_LOCSTRING3 + ", " + locString("@"+dvarString(player_unlockfeature3))

		#define VIS_CH_FEATURE(features) dvarInt(player_unlockchallenges)!=0 && dvarInt(player_unlockfeatures)==features
		#define VIS_FEATURE(features) dvarInt(player_unlockchallenges)==0 && dvarInt(player_unlockfeatures)==features

		LOCAL_FEATURE( LOCAL_LOCSTRING0_CH, VIS_CH_FEATURE(0) )
		LOCAL_FEATURE( LOCAL_LOCSTRING1_CH, VIS_CH_FEATURE(1) )
		LOCAL_FEATURE( LOCAL_LOCSTRING2_CH, VIS_CH_FEATURE(2) )
		LOCAL_FEATURE( LOCAL_LOCSTRING3_CH, VIS_CH_FEATURE(3) )
		LOCAL_FEATURE( LOCAL_LOCSTRING4_CH, VIS_CH_FEATURE(4) )
		LOCAL_FEATURE( LOCAL_LOCSTRING1, VIS_FEATURE(1) )
		LOCAL_FEATURE( LOCAL_LOCSTRING2, VIS_FEATURE(2) )
		LOCAL_FEATURE( LOCAL_LOCSTRING3, VIS_FEATURE(3) )
		LOCAL_FEATURE( LOCAL_LOCSTRING4, VIS_FEATURE(4) )

		// Perk chart grid. Three rows, eight columns.
		#define PERK_SIZE		32 32
		#define MAP_START_X		52
		#define MAP_START_Y		144
		#define MAP_V_SPACING	28
		#define MAP_H_SPACING	50
		#define ROW1 			MAP_START_Y
		#define ROW2			(ROW1+MAP_V_SPACING)
		#define ROW3			(ROW2+MAP_V_SPACING)
		#define COL1			MAP_START_X
		#define COL2			(COL1+MAP_H_SPACING)
		#define COL3			(COL2+MAP_H_SPACING)
		#define COL4			(COL3+MAP_H_SPACING)
		#define COL5			(COL4+MAP_H_SPACING)
		#define COL6			(COL5+MAP_H_SPACING)
		#define COL7			(COL6+MAP_H_SPACING)
		#define COL8			(COL7+MAP_H_SPACING)

		#include "ui_mp/weaponinfo.menu"

		// Locked, already owned, or just unlocked. The new state keeps the original && / || precedence.
		#define PERK_OWNED( pref )	stat(int(tablelookup("mp/statsTable.csv",4,pref,1)))
		#define PERK_ICON( pref )	tablelookup("mp/statsTable.csv",4,pref,6)
		#define PERK_NOT_NEW( pref ) pref != dvarString(player_unlockperk0) && pref != dvarString(player_unlockperk1) && pref != dvarString(player_unlockperk2)
		#define PERK_IS_NEW( pref ) ( PERK_OWNED( pref )>0 && pref == dvarString(player_unlockperk0) || pref == dvarString(player_unlockperk1) || pref == dvarString(player_unlockperk2) )

		#define PERK_MAP_ITEM( porigin, pref )\
			PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME PERK_SIZE, porigin, PERK_ICON(pref), \
			0.125 0.125 0.125 0.5, 0, 0, 0 0 0 0 WHEN_STEP( 2, PERK_OWNED(pref)==0 && VIS_PERKS ) ) \
			PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME PERK_SIZE, porigin, PERK_ICON(pref), \
			1 1 1 0.6, 0, 0, 0 0 0 0 WHEN_STEP( 2, PERK_OWNED(pref)>0 && PERK_NOT_NEW(pref) && VIS_PERKS ) ) \
			PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME_X ORIGIN_MAINFRAME_Y PERK_SIZE, porigin, PERK_ICON(pref), \
			1 1 1 1 exp forecolor A( 0.5+(max( 0+sin(milliseconds()/200), 0-sin(milliseconds()/200) )/2) ), 0, 0, 1 0.9 0.75 0.85 WHEN_STEP( 2, PERK_IS_NEW(pref) && VIS_PERKS ) )

		#define PERK_ROW_NUM( row, num ) \
			PREPROC_TEXT_DRAW_EXP( (0) (row+6) 34 20, ORIGIN_MAINFRAME, exp text( num ), 0.8, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, 0.8 0.85 0.9 0.1 WHEN_STEP( 2, VIS_PERKS ) textfont UI_FONT_OBJECTIVE )
		PERK_ROW_NUM( ROW1, "1" )
		PERK_ROW_NUM( ROW2, "2" )
		PERK_ROW_NUM( ROW3, "3" )

		// Perk 1
		PERK_MAP_ITEM( COL1 ROW1 , REF_C4_X2 )
		PERK_MAP_ITEM( COL2 ROW1 , REF_SPECIALGRENADE_X3 )
		PERK_MAP_ITEM( COL3 ROW1 , REF_RPG_X2 )
		PERK_MAP_ITEM( COL4 ROW1 , REF_CLAYMORE_X2 )
		PERK_MAP_ITEM( COL5 ROW1 , REF_FRAG_X3 )
		PERK_MAP_ITEM( COL6 ROW1 , REF_EXTRAAMMO )
		PERK_MAP_ITEM( COL7 ROW1 , REF_DETECTEXPLOSIVE )
		PERK_MAP_ITEM( COL8 ROW1 , REF_NULL )

		// Perk 2
		PERK_MAP_ITEM( COL1 ROW2 , REF_BULLETDAMAGE )
		PERK_MAP_ITEM( COL2 ROW2 , REF_ARMORVEST )
		PERK_MAP_ITEM( COL3 ROW2 , REF_FASTRELOAD )
		PERK_MAP_ITEM( COL4 ROW2 , REF_ROF )
		PERK_MAP_ITEM( COL5 ROW2 , REF_TWOPRIMARIES )
		PERK_MAP_ITEM( COL6 ROW2 , REF_GPSJAMMER )
		PERK_MAP_ITEM( COL7 ROW2 , REF_EXPLOSIVEDAMAGE )
		PERK_MAP_ITEM( COL8 ROW2 , REF_NULL )

		// Perk 3
		PERK_MAP_ITEM( COL1 ROW3 , REF_LONGERSPRINT )
		PERK_MAP_ITEM( COL2 ROW3 , REF_BULLETACCURACY )
		PERK_MAP_ITEM( COL3 ROW3 , REF_PISTOLDEATH )
		PERK_MAP_ITEM( COL4 ROW3 , REF_GRENADEPULLDEATH )
		PERK_MAP_ITEM( COL5 ROW3 , REF_BULLETPENETRATION )
		PERK_MAP_ITEM( COL6 ROW3 , REF_HOLDBREATH )
		PERK_MAP_ITEM( COL7 ROW3 , REF_QUIETER )
		PERK_MAP_ITEM( COL8 ROW3 , REF_PARABOLIC )

		// The one or two perks unlocked this match, with name and description.
		#define PERK_NAME( pref_dvar ) \
			"@"+tablelookup("mp/statsTable.csv",4,dvarString(pref_dvar),3)
		#define PERK_DESC( pref_dvar ) \
			"@"+tablelookup("mp/statsTable.csv",4,dvarString(pref_dvar),7)
		#define PERK_MAP_ITEM_FIXED( porigin, pref ) \
			PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME PERK_SIZE, porigin, PERK_ICON(pref), \
			1 1 1 0.6, 0, 0, 0 0 0 0 WHEN_STEP( 2, pref != "" && VIS_PERKS ) )
		#define PERK_DETAIL( iconOrigin, nameOff, descOff, dvarName ) \
			PERK_MAP_ITEM_FIXED( iconOrigin, dvarString(dvarName) ) \
			PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME 140 20, nameOff, exp text( PERK_NAME(dvarName) ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, COLOR_TITLE autowrapped WHEN_STEP( 2, VIS_PERKS ) ) \
			PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME (WIDTH_MAINFRAME-98) 20, descOff, exp text( PERK_DESC(dvarName) ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, EOG_TEXT_COLOR autowrapped WHEN_STEP( 2, VIS_PERKS ) )

		PERK_DETAIL( 102 75, 140 91, 140 106, player_unlockperk0 )
		PERK_DETAIL( 102 108, 140 124, 140 138, player_unlockperk1 )
