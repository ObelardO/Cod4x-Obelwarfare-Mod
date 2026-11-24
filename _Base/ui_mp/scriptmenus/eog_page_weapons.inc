// Step 1: weapons, camos, attachments. Included inside popup_unlock.

		// Frame. Tall when a weapon unlocked, short when only camos or attachments did.
		FRAMING_VIS( RECT_MAINFRAME, EOG_STEP(1) && VIS_WEAPON )
		FRAMING_VIS( ORIGIN_MAINFRAME WIDTH_MAINFRAME 93, EOG_STEP(1) && dvarInt(player_unlockweapons)==0 )
		COLOR_STRIP( 1, 1 0 0 0.1 )

		// Inner plates for the camo/attachment row and the weapon row.
		INNER_FRAME( (WIDTH_MAINFRAME-12), 81, 6, 6, EOG_STEP(1) )
		INNER_FRAME( (WIDTH_MAINFRAME-12), 140, 6, 93, EOG_STEP(1) && VIS_WEAPON )

		// Section title shades. Lit when that section has an unlock.
		#define CAMO_FILLED		dvarString(player_unlockcamo0a) != ""
		SHADE_OFF_ON( 87 10, 10 8, "white", 1, CAMO_FILLED )
		SHADE_OFF_ON( 80 28, 10 18, "white", 1, CAMO_FILLED )
		SHADE_OFF_ON( 7 -28, 90 18, "button_highlight_end", 1, CAMO_FILLED )

		#define ATTACH_FILLED	dvarString(player_unlockattachment0a) != ""
		SHADE_OFF_ON( 87 10, 10 76, "white", 1, ATTACH_FILLED )
		SHADE_OFF_ON( 80 28, 10 48, "white", 1, ATTACH_FILLED )
		SHADE_OFF_ON( 7 28, 90 48, "button_highlight_end", 1, ATTACH_FILLED )

		#define WEAPON_FILLED	dvarString(player_unlockweapon0) != "" && VIS_WEAPON
		SHADE( 80 28, 10 95, "white", TITLE_BG_COLOR_ON, EOG_STEP(1) && WEAPON_FILLED )
		SHADE( 7 -28, 90 95, "button_highlight_end", TITLE_BG_COLOR_ON, EOG_STEP(1) && WEAPON_FILLED )

		// Section titles.
		SECTION_LABEL( 116, "@MPUI_WEAPON_PRE", EOG_STEP(1) && VIS_WEAPON )
		SECTION_LABEL( 34, "@MPUI_CAMO_PRE", EOG_STEP(1) && CAMO_FILLED )
		SECTION_LABEL( 74, "@MPUI_ATTACHMENT_PRE", EOG_STEP(1) && ATTACH_FILLED )

		// Up to two unlocked weapons.
		#define WEAPON_SLOT_WIDTH	216
		#define WEAPON_SLOT_HEIGHT	100
		#define WEAPON_SLOT1_X		12
		#define WEAPON_SLOT2_X		(WEAPON_SLOT_WIDTH+(6)+WEAPON_SLOT1_X)
		#define WEAPON_SLOT_Y		(HEIGHT_TOPBAR+134)
		#define BLOCK_WIDTH			108

		#define WEAPON_SLOT_SET( px, py, pw, ph, pref, visArg )\
			PREPROC_SHADER_DRAW( (px+82) (py-20) -20 80, 0 0, "button_highlight_end", EOG_BASE_COLOR, 0, 0, 0 0 0 0 visArg ) \
			PREPROC_SHADER_DRAW( (px+102) (py-20) (pw-102) 80, 0 0, "white", EOG_BASE_COLOR, 0, 0, 0 0 0 0 visArg ) \
			PREPROC_SHADER_DRAW( (px+88) (py-18) -20 80, 0 0, "button_highlight_end", 0 0 0 0.45, 0, 0, 0 0 0 0 visArg ) \
			PREPROC_SHADER_DRAW( (px+108) (py-18) (pw-108) 80, 0 0, "white", 0 0 0 0.45, 0, 0, 0 0 0 0 visArg ) \
			PREPROC_SHADER_DRAW( px py pw ph, 0 0, "white", EOG_BASE_COLOR, 0, 0, 0 0 0 0 visArg ) \
			PREPROC_SHADER_DRAW( px py pw (ph/2), 0 0, "gradient_bottom", 1 1 1 0.5, 0, 0, 0 0 0 0 visArg ) \
			PREPROC_SHADER_DRAW( px (py+(ph/2)) pw (ph/2), 0 0, "gradient_top", 1 1 1 0.5, 0, 0, 0 0 0 0 visArg ) \
			PREPROC_TEXT_DRAW_EXP( px py (pw-4) 20, 0 0, exp text(STAT_NAME(pref)), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_RIGHT, COLOR_TITLE visArg ) \
			PREPROC_TEXT_DRAW_EXP( (px+4) (py+20) (pw-6) 20, 0 0, exp text(STAT_DESC(pref)), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, 1 1 1 0.6 autowrapped visArg ) \
			PREPROC_SHADER_DRAW( (px+90) (py+42) 120 60, 0 0, STAT_IMAGE( pref ), 1 1 1 1, 0, 0, 0 0 0 0 WHEN_STEP( 1, pref != "" && STAT_GROUP( pref ) != "weapon_pistol" && VIS_WEAPON ) ) \
			PREPROC_SHADER_DRAW( (px+150) (py+42) 60 60, 0 0, STAT_IMAGE( pref ), 1 1 1 1, 0, 0, 0 0 0 0 WHEN_STEP( 1, pref != "" && STAT_GROUP( pref ) == "weapon_pistol" && VIS_WEAPON ) ) \
			PREPROC_SHADER_DRAW( (px+2) (py+98) (-(pw-6)) 18, 0 -18, "gradient_fadein", 0 0 0 0.45, 0, 0, 0 0 0 0 visArg ) \
			PREPROC_TEXT_DRAW_EXP( (px+4) (py+98) (pw-6) 20, 0 -1, exp text("@"+tablelookup("mp/attributesTable.csv",0,STAT_GROUP(pref),1)), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, 1 1 1 0.6 autowrapped visArg )

		WEAPON_SLOT_SET( WEAPON_SLOT1_X, WEAPON_SLOT_Y, WEAPON_SLOT_WIDTH, WEAPON_SLOT_HEIGHT, dvarString(player_unlockweapon0), WHEN_STEP( 1, dvarString(player_unlockweapon0)!="" && VIS_WEAPON ) )
		WEAPON_SLOT_SET( WEAPON_SLOT2_X, WEAPON_SLOT_Y, WEAPON_SLOT_WIDTH, WEAPON_SLOT_HEIGHT, dvarString(player_unlockweapon1), WHEN_STEP( 1, dvarString(player_unlockweapon1)!="" && VIS_WEAPON ) )

		// Shared name plate for a camo or attachment block. pref_a is the weapon, pref_b the unlock.
		#define UNLOCK_LABELS( px, py, pref_a, pref_b ) \
			PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME (BLOCK_WIDTH-6) 16, (px+6) (py+2), "white", 0.15 0.15 0.15 1, 0, 0, 0 0 0 0 WHEN_STEP( 1, pref_a != "" ) ) \
			PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME (BLOCK_WIDTH-6) 20, (px+4) (py-1), exp text(STAT_NAME(pref_a)), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, COLOR_TITLE WHEN_STEP( 1, pref_a != "" ) ) \
			PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME BLOCK_WIDTH 20, (px+4) (py+16), exp text(ATTACH_NAME(pref_b)), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, EOG_TEXT_COLOR WHEN_STEP( 1, pref_a != "" ) )

		// Up to three camo unlocks. "..." when more than three.
		#define CAMO_SET( px, py, pref_a, pref_b )\
			PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME (BLOCK_WIDTH/3) 36, px py, ATTACH_IMAGE(pref_b), 1 1 1 1, 0, 0, 0 0 0 0 WHEN_STEP( 1, pref_a != "" ) ) \
			PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME (BLOCK_WIDTH/3) 36, (px+(BLOCK_WIDTH/3)) py, ATTACH_IMAGE(pref_b), 1 1 1 1, 0, 0, 0 0 0 0 WHEN_STEP( 1, pref_a != "" ) ) \
			PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME (BLOCK_WIDTH/3) 36, (px+((BLOCK_WIDTH/3)*2)) py, ATTACH_IMAGE(pref_b), 1 1 1 1, 0, 0, 0 0 0 0 WHEN_STEP( 1, pref_a != "" ) ) \
			PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME BLOCK_WIDTH 36, px py, "gradient_bottom", 1 1 1 0.75, 0, 0, 0 0 0 0 WHEN_STEP( 1, pref_a != "" ) ) \
			UNLOCK_LABELS( px, py, pref_a, pref_b )

		CAMO_SET( 100, 10, dvarString(player_unlockcamo0a), dvarString(player_unlockcamo0b) )
		CAMO_SET( 212, 10, dvarString(player_unlockcamo1a), dvarString(player_unlockcamo1b) )
		CAMO_SET( 324, 10, dvarString(player_unlockcamo2a), dvarString(player_unlockcamo2b) )

		// Up to three attachment unlocks. "..." when more than three.
		#define ATTACHMENT_SET( px, py, pref_a, pref_b )\
			PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME BLOCK_WIDTH 36, px py, "white", 0.37 0.37 0.4 1, 0, 0, 0 0 0 0 WHEN_STEP( 1, pref_a != "" ) ) \
			PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME BLOCK_WIDTH 36, px py, "gradient_bottom", 1 1 1 0.625, 0, 0, 0 0 0 0 WHEN_STEP( 1, pref_a != "" ) ) \
			UNLOCK_LABELS( px, py, pref_a, pref_b )

		ATTACHMENT_SET( 100, 48, dvarString(player_unlockattachment0a), dvarString(player_unlockattachment0b) )
		ATTACHMENT_SET( 212, 48, dvarString(player_unlockattachment1a), dvarString(player_unlockattachment1b) )
		ATTACHMENT_SET( 324, 48, dvarString(player_unlockattachment2a), dvarString(player_unlockattachment2b) )

		#define MORE_DOTS( y, countDvar ) \
			PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME 20 30, 434 y, exp text( "..." ), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE WHEN_STEP( 1, dvarInt(countDvar)>3 ) )
		MORE_DOTS( 10, player_unlockcamos )
		MORE_DOTS( 48, player_unlockattachments )
