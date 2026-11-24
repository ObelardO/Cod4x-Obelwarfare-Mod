// Step 3: rank summary. Included inside popup_unlock.

		// Rank name, icon, and the XP still needed to rank up.
		#define ALIGNED_IN_X	140
		#define ALIGNED_IN_Y	8

		#define RANK_XP_BASE	int(tablelookup( "mp/ranktable.csv", 0, string(stat(252)), 2))
		#define RANK_XP_SPAN	int(tablelookup("mp/ranktable.csv",0,stat(252),3))
		#define RANK_XP_INTO	(stat(2301)-RANK_XP_BASE)
		#define BAR_FIXED		178*(RANK_XP_INTO/RANK_XP_SPAN)
		#define ANIMATE_BAR		min( BAR_FIXED, BAR_FIXED*((milliseconds()-dvarInt(ui_time_marker))/PROGRESS_BAR_SPEED) )
		#define REQUIRED_XP		int(RANK_XP_INTO)
		#define ANIMATE_NUM		int(min( REQUIRED_XP, REQUIRED_XP*((milliseconds()-dvarInt(ui_time_marker))/PROGRESS_BAR_SPEED) ))
		#define REQUIRED_XP_STRING string(int(tablelookup( "mp/ranktable.csv", 0, string(stat(252)), 3 ))-ANIMATE_NUM)
		#define RANK_NAME( row ) "@"+tablelookup( "mp/ranktable.csv", 0, row, 5 )
		#define RANK_ICON( row ) tablelookup( "mp/rankIconTable.csv", 0, row, stat(2326)+1 )
		#define BELOW_MAX		EOG_STEP(3) && stat(252) < MAX_RANK
		#define XP_LINE( slot, label, value, color, labelVis, valueVis ) \
			PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME 0 0, slot, exp text( label ), TEXTSIZE_SMALL, 144, -10, ITEM_ALIGN_RIGHT, color visible when( labelVis ); ) \
			PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME 0 0, slot, exp text( value ), TEXTSIZE_SMALL, 152, -10, ITEM_ALIGN_LEFT, color visible when( valueVis ); )

		// Frame.
		FRAMING_VIS( RECT_MAINFRAME, EOG_STEP(3) )
		COLOR_STRIP( 3, 1 1 1 0.15 )

		// Current rank.
		PREPROC_TEXT_DRAW( ORIGIN_MAINFRAME 0 0, ALIGNED_IN_X (ALIGNED_IN_Y+24), text "@MPUI_RANK_PRE", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_RIGHT, EOG_TEXT_COLOR ON_STEP( 3 ) )
		PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME 32 32, (ALIGNED_IN_X+8) (ALIGNED_IN_Y-3), RANK_ICON( stat(252) ), 1 1 1 1, 0, 2, 0.6 0.55 0.45 1 ON_STEP( 3 ) )
		PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME 0 0, (ALIGNED_IN_X+46) (ALIGNED_IN_Y+24), exp text( RANK_NAME( stat(252) ) ), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_LEFT, EOG_TEXT_COLOR ON_STEP( 3 ) )

		// XP still required for the next rank, with the filling bar.
		PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME 0 0, (ALIGNED_IN_X+194) (ALIGNED_IN_Y+58), exp text( REQUIRED_XP_STRING ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, EOG_TEXT_COLOR visible when( BELOW_MAX ); )
		PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME 0 0, ALIGNED_IN_X (ALIGNED_IN_Y+58), exp text( "@MPUI_XP_REQUIRED_PRE" ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_RIGHT, EOG_TEXT_COLOR visible when( BELOW_MAX ); )
		PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME 180 14 , (ALIGNED_IN_X+6) (ALIGNED_IN_Y+42), "white", EOG_INNER_COLOR, WINDOW_BORDER_SUNKEN, 1, EOG_BORDER_COLOR visible when( BELOW_MAX ); )
		PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME 1 8 , (ALIGNED_IN_X+52) (ALIGNED_IN_Y+46), "line_vertical", 0.5 0.5 0.6 0.8, 0, 0, EOG_BORDER_COLOR visible when( BELOW_MAX ); )
		PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME 1 16 , (ALIGNED_IN_X+98) (ALIGNED_IN_Y+42), "line_vertical", 0.5 0.5 0.6 0.75, 0, 0, EOG_BORDER_COLOR visible when( BELOW_MAX ); )
		PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME 1 8 , (ALIGNED_IN_X+142) (ALIGNED_IN_Y+46), "line_vertical", 0.5 0.5 0.6 0.8, 0, 0, EOG_BORDER_COLOR visible when( BELOW_MAX ); )
		PREPROC_SHADER_DRAW_ADV( (ORIGIN_MAINFRAME_X+ALIGNED_IN_X+8), (ORIGIN_MAINFRAME_Y+ALIGNED_IN_Y+44), ANIMATE_BAR, 12, "line_vertical", 0.85 0.9 1 1, 0, 1, 1 1 1 1 visible when( BELOW_MAX ); )

		// Next rank.
		PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME 0 0, ALIGNED_IN_X (ALIGNED_IN_Y+92), exp text( "@MPUI_NEXT_RANK_PRE" ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_RIGHT, EOG_TEXT_COLOR visible when( BELOW_MAX ); )
		PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME 24 24, (ALIGNED_IN_X+12) (ALIGNED_IN_Y+74), RANK_ICON( stat(252)+1 ), 1 1 1 1, 0, 2, 0.6 0.55 0.45 1 visible when( BELOW_MAX ); )
		PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME 0 0, (ALIGNED_IN_X+46) (ALIGNED_IN_Y+92), exp text( RANK_NAME( string(stat(252)+1) ) ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, EOG_TEXT_COLOR visible when( BELOW_MAX ); )

		// Score, challenge, match bonus, and total XP from this match.
		PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME (WIDTH_MAINFRAME-14) 28, 8 206, "white", 1 1 1 0.075, 0, 0, 0 0 0 0 ON_STEP( 3 ) )
		INNER_FRAME( (WIDTH_MAINFRAME-12), (HEIGHT_MAINFRAME-116), 6, 110, EOG_STEP(3) )
		XP_LINE( ORIGIN_XP_SLOT1, "@MPUI_SCORE_PRE", dvarString( player_summary_score ) + " XP", EOG_TEXT_COLOR, EOG_STEP(3), EOG_STEP(3) && dvarString( player_summary_score ) != "" )
		XP_LINE( ORIGIN_XP_SLOT2, "@MPUI_CHALLENGES_PRE", dvarString( player_summary_challenge ) + " XP", EOG_TEXT_COLOR, EOG_STEP(3), EOG_STEP(3) && dvarString( player_summary_challenge ) != "" )
		XP_LINE( ORIGIN_XP_SLOT3, "@MPUI_MATCHBONUS_PRE", dvarString( player_summary_match ) + " XP", EOG_TEXT_COLOR, EOG_STEP(3), EOG_STEP(3) && dvarString( player_summary_match ) != "" )
		XP_LINE( ORIGIN_XP_SLOT4, "@MPUI_TOTALXP_PRE", dvarString( player_summary_xp ), COLOR_TITLE, EOG_STEP(3), EOG_STEP(3) )
