#define	DPAD_BASE_SIZE			36
#define	DPAD_BASE_SIZE_HALF		18
#define DPAD_ICON_Y				-10//3
#define DPAD_LABEL_Y			38//44
#define DPAD_ICON_SPACING		30
#define DPAD_ICON_SPACING_HALF	20
#define	DPAD_BACK_SIZE			29

#define DPAD_SLOT_A_USABLE		ActionSlotUsable( 1 )
#define DPAD_SLOT_B_USABLE		ActionSlotUsable( 3 )
#define DPAD_SLOT_C_USABLE		ActionSlotUsable( 4 )

#define DPAD_WIDTH				( ( DPAD_SLOT_A_USABLE + DPAD_SLOT_B_USABLE + DPAD_SLOT_C_USABLE ) * DPAD_ICON_SPACING - DPAD_ICON_SPACING )
#define DPAD_WIDTH_HALF			( DPAD_WIDTH / 2 )	

#define DPAD_SLOT_A_POS_X		( 0 - DPAD_WIDTH_HALF - DPAD_BASE_SIZE_HALF )
#define DPAD_SLOT_B_POS_X		( DPAD_SLOT_A_POS_X + DPAD_ICON_SPACING * DPAD_SLOT_A_USABLE )
#define DPAD_SLOT_C_POS_X		( DPAD_SLOT_B_POS_X + DPAD_ICON_SPACING * DPAD_SLOT_B_USABLE )

//#define DPAD_VISIBLE			( dvarint( ui_hud_show_inventory ) >= dvarint( ui_hud_hardcore ) + 1 )
#define DPAD_VISIBLE			0

#define DPAD_SLOT_ITEM( vertPos, iconOwnerDraw, KeyBindingText, visibleExp ) \
	itemDef \
    { \
        rect			0 ( DPAD_ICON_Y + 15 ) DPAD_BACK_SIZE DPAD_BACK_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM \
        exp				rect X( vertPos + 7 ) \
        forecolor		1 1 1 HUD_BACK_ALPHA \
		exp forecolor 	A( HUD_BACK_ALPHA * HudFade( "dpad" ) ) \
        style			WINDOW_STYLE_SHADER \
        background		"hud_background_quad" \
        visible			when ( visibleExp ) \
        decoration \
    } \
	itemDef \
	{ \
		name			"slotIcon" \
		rect			0 DPAD_ICON_Y -DPAD_BASE_SIZE DPAD_BASE_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM \
		exp				rect X( vertPos ) \
		iconOwnerDraw \
		forecolor		1 1 1 HUD_ALPHA \
		visible			1 \
		origin			10 0 \
		decoration \
		textstyle		ITEM_TEXTSTYLE_SHADOWED \
		textalign		ITEM_ALIGN_LEFT \ 
		textalignx      40 \
		textscale		(TEXTSIZE_SMALL * 0.6) \
		textfont		UI_FONT_OBJECTIVE \
	} \
	itemDef \
	{ \
		rect		0 DPAD_LABEL_Y 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM \
		exp			rect X( vertPos + DPAD_BASE_SIZE_HALF + 2 ) \
		exp text	( KeyBinding( KeyBindingText ) ); \
		forecolor	1 1 0 0 \
		exp forecolor A	( HUD_ALPHA * HudFade( "dpad" ) ) \
		textfont	UI_FONT_OBJECTIVE \
		textscale	0.18 \
		textalign	ITEM_ALIGN_CENTER \
		textstyle	ITEM_TEXTSTYLE_SHADOWED \
		visible 	when( visibleExp ) \
		decoration \
	}

	menuDef
	{
		name			"DPad"
 	   	rect			0 -42 25 25 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
		exp				rect Y( -42 - (ONLINEGAME * ONLINEGAME_OFFSET) );
 	   	fullScreen		0
		visible			when( team( name ) != "TEAM_SPECTATOR" && !inkillcam() && !flashbanged() && !ui_active() && !scoped() && (dvarString( createfx ) != "on") && DPAD_VISIBLE );

		DPAD_SLOT_ITEM( DPAD_SLOT_A_POS_X, ownerdraw CG_PLAYER_ACTIONSLOT_1, "+actionslot 1", DPAD_SLOT_A_USABLE )
		DPAD_SLOT_ITEM( DPAD_SLOT_B_POS_X, ownerdraw CG_PLAYER_ACTIONSLOT_3, "+actionslot 3", DPAD_SLOT_B_USABLE )
		DPAD_SLOT_ITEM( DPAD_SLOT_C_POS_X, ownerdraw CG_PLAYER_ACTIONSLOT_4, "+actionslot 4", DPAD_SLOT_C_USABLE )
    }