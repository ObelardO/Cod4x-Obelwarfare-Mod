#define PLAYERINFO_IS_VISIBLE    	( dvarint( ui_hud_show_player_info ) >= dvarint( ui_hud_hardcore ) + 1 )

#define PLAYERINFO_HEALTH_POS_X     ( INV_BACK_PAD )
#define PLAYERINFO_HEALTH_POS_Y     ( INV_OFFSET_Y - INV_SLOT_ANY_VISIABLE_LEFT * ( INV_BACK_HEIGHT + INV_SPACING ) - INV_BACK_PAD )
#define PLAYERINFO_HEALTH_MID_Y     ( PLAYERINFO_HEALTH_POS_Y + INV_BACK_HEIGHT_HALF )


//#define PLAYERINFO_STANCE_SIZE		( INV_ICON_SIZE * 2.1 )
#define PLAYERINFO_STANCE_SIZE		( 42 )
#define PLAYERINFO_STANCE_SIZE_HALF	( PLAYERINFO_STANCE_SIZE * 0.5 )

// Stance indicator
	menuDef
	{
    	name			"stance"
		rect			0 0 0 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
		exp				rect Y( 0 - ONLINEGAME_OFFSET_EXP )
		exp				rect X( ONLINEGAME_OFFSET_EXP )
		fullScreen		1
		visible			when( HUD_IS_VISIBLE && NOT_SPECTATING_CLIENT && dvarInt( ui_hud_show_inventory ) == 1 && dvarInt( ui_hud_has_weapon ) == 1 );


		//HEALTHBAR BACK
		itemDef
		{
			rect			0 0 ( INV_BACK_SIZE_QUAD * HUD_MINUS_ONE ) INV_BACK_SIZE INV_ALIGN_L
			exp             rect Y( PLAYERINFO_HEALTH_POS_Y )
			forecolor		1 1 1 HUD_BACK_ALPHA
			style			WINDOW_STYLE_SHADER
			background		"hud_background_line"
			visible			when ( PLAYERINFO_IS_VISIBLE )
			decoration  
		}
		//HUD_DEBUG_DOT( 0, PLAYERINFO_HEALTH_POS_Y, INV_ALIGN_L )


		itemDef
		{
			name			"chRect"
			rect			0 0 PLAYERINFO_STANCE_SIZE PLAYERINFO_STANCE_SIZE // 64x64
			exp             rect X( PLAYERINFO_HEALTH_POS_X - 7.5 )
			exp             rect Y( PLAYERINFO_HEALTH_MID_Y - PLAYERINFO_STANCE_SIZE_HALF - 1 )
			ownerdraw		CG_PLAYER_STANCE
			textfont		UI_FONT_OBJECTIVE
			visible			when( 1 );
			textscale		TEXTSIZE_SMALL
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			forecolor		1 1 1 HUD_ALPHA
			decoration
		}

		// HEALTH BAR WIDESCREEN
		itemDef
		{
			name 			"healthbarback"
			rect 			0 0 77 4.5
			exp             rect X( PLAYERINFO_HEALTH_POS_X + 24 )
			exp				rect Y( PLAYERINFO_HEALTH_MID_Y + 3.5 )
			forecolor 		0.1 0.1 0.1 0.3
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
			forecolor 		1 0.6 0.5 0.3
			background 		"white"
			ownerdraw 		CG_PLAYER_BAR_HEALTH
			visible 		when( 1 )
			decoration
		}
	}