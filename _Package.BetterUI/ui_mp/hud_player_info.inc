#define PLAYERINFO_IS_VISIBLE    	( dvarint( "ui_hud_show_player_info" ) >= dvarint( "ui_hud_hardcore" ) + 1 )

#define PLAYERINFO_HEALTH_POS_X     ( INV_BACK_PAD )
#define PLAYERINFO_HEALTH_POS_Y     ( INV_OFFSET_Y - INV_SLOT_ANY_VISIABLE_L * ( INV_BACK_HEIGHT + INV_SPACING ) - INV_BACK_PAD )
#define PLAYERINFO_HEALTH_MID_Y     ( PLAYERINFO_HEALTH_POS_Y + INV_BACK_HEIGHT_HALF )

#define PLAYERINFO_STANCE_SIZE		( 42 )
#define PLAYERINFO_STANCE_SIZE_HALF	( PLAYERINFO_STANCE_SIZE * 0.5 )

#define PLAYERINFO_LIVES_COUNT( visibleExp, textExp, color, alphaExp ) \
	itemDef \
	{ \
		name 			"livescounter" \
		rect 			0 0 75 2.5 INV_ALIGN_L \
		exp             rect X( PLAYERINFO_HEALTH_POS_X + 26 ) \
		exp				rect Y( PLAYERINFO_HEALTH_MID_Y - 1.5 ) \
		exp				text ( textExp ) \
		exp				forecolor A( alphaExp * INV_DPAD_ALPHA ) \
		textstyle		ITEM_TEXTSTYLE_SHADOWED \
        textscale		( TEXTSIZE_SMALL * 0.5 ) \
        textfont		UI_FONT_OBJECTIVE \
        textalign	    ITEM_ALIGN_BOTTOM_LEFT \
        forecolor		color HUD_FOREGROUND_ALPHA \
		visible 		when( visibleExp ) \
		decoration \
	}

menuDef
{
	name			"stance"
	rect			0 0 0 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
	exp				rect Y( 0 - ONLINEGAME_OFFSET_EXP )
	exp				rect X( ONLINEGAME_OFFSET_EXP )
	fullScreen		1
	visible			when( HUD_IS_VISIBLE && PLAYERINFO_IS_VISIBLE && CLIENT_NOT_DEAD && CLIENT_NOT_FREE_SPECTATING && INV_IS_VISIBLE && dvarInt( "ui_hud_has_weapon" ) == 1 );

	//PLAYER INFO BACK
	itemDef
	{
		rect			0 0 ( INV_BACK_SIZE_QUAD * HUD_MINUS_ONE ) INV_BACK_SIZE INV_ALIGN_L
		exp             rect Y( PLAYERINFO_HEALTH_POS_Y )
		forecolor		1 1 1 INV_BACK_ALPHA
		exp				forecolor A( INV_BACK_ALPHA * INV_DPAD_ALPHA )
		style			WINDOW_STYLE_SHADER
		background		"hud_background_line"
		visible			when ( 1 )
		decoration  
	}

	//STANCE ICON
	itemDef
	{
		name			"chRect"
		rect			0 0 PLAYERINFO_STANCE_SIZE PLAYERINFO_STANCE_SIZE // 64x64
		exp             rect X( PLAYERINFO_HEALTH_POS_X - 7.5 )
		exp             rect Y( PLAYERINFO_HEALTH_MID_Y - PLAYERINFO_STANCE_SIZE_HALF - 1 )
		ownerdraw		CG_PLAYER_STANCE
		textfont		UI_FONT_OBJECTIVE
		exp				forecolor A( HUD_ALPHA * INV_DPAD_ALPHA )
		visible			when( 1 );
		textscale		TEXTSIZE_SMALL
		textstyle		ITEM_TEXTSTYLE_SHADOWED
		forecolor		1 1 1 HUD_ALPHA
		decoration
	}

	//HEALTH BAR
	itemDef
	{
		name 			"healthbarback"
		rect 			0 0 77 4.5
		exp             rect X( PLAYERINFO_HEALTH_POS_X + 24 )
		exp				rect Y( PLAYERINFO_HEALTH_MID_Y + 3.5 )
		forecolor 		0.1 0.1 0.1 0.3
		exp				forecolor A( INV_DPAD_ALPHA )
		background 		"white"
		ownerdraw 		CG_PLAYER_BAR_HEALTH_BACK
		visible			when( 1 );
		decoration
	}
	itemDef
	{
		name 			"healthbar"
		rect 			0 0 75 2.5
		exp             rect X( PLAYERINFO_HEALTH_POS_X + 25 )
		exp				rect Y( PLAYERINFO_HEALTH_MID_Y + 4.5 )
		exp				forecolor A( INV_DPAD_ALPHA )
		forecolor 		1 0.6 0.5 0.3
		background 		"white"
		ownerdraw 		CG_PLAYER_BAR_HEALTH
		visible 		when( 1 )
		decoration
	}

	//MP_NO_RESPAWN, OW_LAST_LIFE, OW_LIVES_LEFT

	PLAYERINFO_LIVES_COUNT( dvarInt( "ui_hud_lives_count" ) == 1, "x1", INV_CLR_WHITE, 1 - INV_LAST_ALPHA_EXP )
	PLAYERINFO_LIVES_COUNT( dvarInt( "ui_hud_lives_count" ) == 1, "x1", INV_CLR_RED, INV_LAST_ALPHA_EXP )

	PLAYERINFO_LIVES_COUNT( dvarInt( "ui_hud_lives_count" ) > 1,  "x" + dvarInt( "ui_hud_lives_count" ), INV_CLR_WHITE, 1 )
}