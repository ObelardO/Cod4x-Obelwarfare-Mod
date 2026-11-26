// Shared end-of-game card chrome. The page sets WIDTH_TOPBAR and HEIGHT_MAINFRAME first.

	#define POPUP_MOVE_SPEED		400
	#define ANIMATE_DISTANCE		400

	#define HEIGHT_TOPBAR			34
	#define ORIGIN_TOPBAR_X			0
	#define ORIGIN_TOPBAR_Y			0
	#define ORIGIN_TOPBAR			ORIGIN_TOPBAR_X ORIGIN_TOPBAR_Y
	#define RECT_TOPBAR				ORIGIN_TOPBAR WIDTH_TOPBAR HEIGHT_TOPBAR

	#define WIDTH_MAINFRAME			WIDTH_TOPBAR
	#define ORIGIN_MAINFRAME_X		ORIGIN_TOPBAR_X
	#define ORIGIN_MAINFRAME_Y		(ORIGIN_TOPBAR_Y+HEIGHT_TOPBAR+6)
	#define ORIGIN_MAINFRAME		ORIGIN_MAINFRAME_X ORIGIN_MAINFRAME_Y
	#define RECT_MAINFRAME			ORIGIN_MAINFRAME WIDTH_MAINFRAME HEIGHT_MAINFRAME

	#define EOG_NEXT_Y				(ORIGIN_TOPBAR_Y+HEIGHT_TOPBAR+6+HEIGHT_MAINFRAME)
	#define EOG_STRIP_RECT			ORIGIN_TOPBAR_X (ORIGIN_TOPBAR_Y+HEIGHT_TOPBAR) WIDTH_TOPBAR 6

	#define EOG_BASE_COLOR			0.25 0.25 0.27 1
	#define EOG_BG_COLOR			0.1 0.1 0.12 0.85
	#define EOG_SHINE_COLOR			0.9 0.9 0.9 0.45
	#define EOG_BORDER_SIZE			1
	#define EOG_BORDER_COLOR		0.35 0.35 0.37 1
	#define EOG_BORDER				WINDOW_BORDER_RAISED
	#define EOG_TEXT_COLOR			0.7 0.7 0.72 1
	#define EOG_TITLE_COLOR			COLOR_TITLE
	#define EOG_INNER_COLOR			0 0 0 0.3
	#define EOG_LABEL_COLOR			1 1 0.8 0.9

	#define TITLE_BG_COLOR_OFF		1 1 1 0.075
	#define TITLE_BG_COLOR_ON		1 0.8 0.4 0.6

	#define VIS_WEAPON				dvarInt(player_unlockweapons)!=0
	#define VIS_PERKS				dvarInt(player_unlockperks)!=0

	#define ZERO_TO_ONE				milliseconds()-dvarInt(ui_time_marker)
	#define UNIT_GROWTH				sin( sin( min( ZERO_TO_ONE, POPUP_MOVE_SPEED )*(1.5707/POPUP_MOVE_SPEED) )*1.5707 )
	#define FRAME_ANIMATE( offset )	offset-offset*UNIT_GROWTH
	#define EOG_SLIDE_Y( restY )	restY+FRAME_ANIMATE(ANIMATE_DISTANCE)

	#define FRAMING_VIS( prect, visArg ) \
		PREPROC_SHADER_DRAW( prect, 0 0, "white", EOG_BASE_COLOR, EOG_BORDER, EOG_BORDER_SIZE, 0 0 0 0 visible when(visArg) )\
		PREPROC_SHADER_DRAW( prect, 0 0, "white", EOG_BG_COLOR, EOG_BORDER, EOG_BORDER_SIZE, EOG_BORDER_COLOR visible when(visArg) )\
		PREPROC_SHADER_DRAW( prect, 0 0, "line_horizontal", EOG_SHINE_COLOR, EOG_BORDER, EOG_BORDER_SIZE, 0 0 0 0 visible when(visArg) )

	#define FRAMING( prect ) \
		FRAMING_VIS( prect, 1 )

	#define EOG_HEADER \
		FRAMING( RECT_TOPBAR ) \
		PREPROC_PERFORATION( (ORIGIN_TOPBAR_X+2), (ORIGIN_TOPBAR_Y+2), 64, 16, 0, 0, 0, 0 ) \
		PREPROC_PERFORATION( (ORIGIN_TOPBAR_X+2), (ORIGIN_TOPBAR_Y+2), 64, 16, 0, 16, 0, 0 ) \
		PREPROC_PERFORATION( (ORIGIN_TOPBAR_X+WIDTH_TOPBAR-64), (ORIGIN_TOPBAR_Y+2), -64, 16, 0, 0, 0, 0 ) \
		PREPROC_PERFORATION( (ORIGIN_TOPBAR_X+WIDTH_TOPBAR-64), (ORIGIN_TOPBAR_Y+2), -64, 16, 0, 16, 0, 0 )

	#define EOG_TITLE( textArg, visArg ) \
		PREPROC_TEXT_DRAW( RECT_TOPBAR, 0 0, exp text(textArg), TEXTSIZE_DEFAULT, 0, 1, ITEM_ALIGN_MIDDLE_CENTER, EOG_TITLE_COLOR visArg )

	#define EOG_FOOTER \
		PREPROC_SHADER_DRAW( ORIGIN_TOPBAR_X EOG_NEXT_Y WIDTH_TOPBAR HEIGHT_TOPBAR, 0 0, "white", EOG_BASE_COLOR, EOG_BORDER, EOG_BORDER_SIZE, 0 0 0 0 ) \
		PREPROC_SHADER_DRAW( ORIGIN_TOPBAR_X EOG_NEXT_Y WIDTH_TOPBAR HEIGHT_TOPBAR, 0 0, "white", EOG_BG_COLOR, EOG_BORDER, EOG_BORDER_SIZE, EOG_BORDER_COLOR ) \
		PREPROC_SHADER_DRAW( ORIGIN_TOPBAR_X EOG_NEXT_Y WIDTH_TOPBAR HEIGHT_TOPBAR, 0 0, "line_horizontal", EOG_SHINE_COLOR, EOG_BORDER, EOG_BORDER_SIZE, 0 0 0 0 ) \
		PREPROC_TEXT_DRAW( ORIGIN_TOPBAR_X EOG_NEXT_Y WIDTH_TOPBAR HEIGHT_TOPBAR, 0 0, exp text("@MENU_GOTO_NEXT"), TEXTSIZE_DEFAULT, 0, 1, ITEM_ALIGN_MIDDLE_CENTER, COLOR_TITLE textfont UI_FONT_OBJECTIVE ) \
		itemDef { \
			type			ITEM_TYPE_BUTTON \
			rect			ORIGIN_TOPBAR_X EOG_NEXT_Y WIDTH_TOPBAR HEIGHT_TOPBAR 0 0 \
			text			"" \
			textfont		UI_FONT_NORMAL \
			textAlign		ITEM_ALIGN_MIDDLE_CENTER \
			visible			1 \
			name			eog_next \
			mouseEnter		{ play "mouse_over"; } \
			action			{ play "mouse_click"; close self; } \
		}

	#define EOG_COLOR_STRIP( tint ) \
		FRAMING( EOG_STRIP_RECT ) \
		PREPROC_SHADER_DRAW( EOG_STRIP_RECT, 0 0, "white", tint, EOG_BORDER, EOG_BORDER_SIZE, 0 0 0 0 )

	#define INNER_FRAME( w, h, x, y, vis ) \
		PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME w h, x y, "white", EOG_INNER_COLOR, WINDOW_BORDER_SUNKEN, 1, EOG_BORDER_COLOR visible when( vis ); )

	#define SECTION_LABEL( y, label, vis ) \
		PREPROC_TEXT_DRAW_EXP( ORIGIN_MAINFRAME 80 20, 10 y, exp text( label ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_RIGHT, EOG_LABEL_COLOR visible when( vis ); )

	#define SHADE( prect, porigin, pshader, pcolor, vis ) \
		PREPROC_SHADER_DRAW( ORIGIN_MAINFRAME prect, porigin, pshader, pcolor, 0, 0, 0 0 0 0 visible when( vis ); )

	#define SHADE_ON( prect, porigin, pshader, cond ) \
		SHADE( prect, porigin, pshader, TITLE_BG_COLOR_ON, cond )

	#define SHADE_OFF_ON( prect, porigin, pshader, step, cond ) \
		SHADE_ON( prect, porigin, pshader, cond )

	// open is a menu action, so the page name stays in the dvar and the open is written here.
	#define EOG_GO( nextDvar ) \
		uiScript openMenuOnDvar nextDvar popup_eog_stats "popup_eog_stats"; \
		uiScript openMenuOnDvar nextDvar popup_eog_unlocks1 "popup_eog_unlocks1"; \
		uiScript openMenuOnDvar nextDvar popup_eog_unlocks2 "popup_eog_unlocks2"; \
		uiScript openMenuOnDvar nextDvar popup_eog_rank "popup_eog_rank"; \
		execNowOnDvarStringValue nextDvar none "closemenu popup_eog";
