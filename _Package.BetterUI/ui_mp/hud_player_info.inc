#define PLAYERINFO_IS_VISIBLE    	( dvarint( ui_hud_show_player_info ) >= dvarint( ui_hud_hardcore ) + 1 )

#define PLAYERINFO_HEALTH_POS_X     ( 0 )
#define PLAYERINFO_HEALTH_POS_Y     ( INV_OFFSET_Y - INV_SLOT_ANY_VISIABLE_LEFT * ( INV_BACK_HEIGHT + 4 ) - INV_BACK_PAD )
#define PLAYERINFO_HEALTH_MID_Y     ( PLAYERINFO_HEALTH_POS_Y + INV_BACK_HEIGHT_HALF )


// Stance indicator
	menuDef
	{
    	name			"stance"
		rect			0 0 0 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
		exp				rect Y( 0 - ONLINEGAME_OFFSET_EXP )
		exp				rect X( ONLINEGAME_OFFSET_EXP )
		fullScreen		1
		visible			when( HUD_IS_VISIBLE && dvarInt( ui_hud_show_inventory ) == 1 && dvarInt( ui_hud_has_weapon ) );


		//HEALTHBAR BACK
		itemDef
		{
			rect			0 0 ( INV_BACK_SIZE_QUAD * HUD_MINUS_ONE ) INV_BACK_SIZE INV_ALIGN_L
			exp             rect X( PLAYERINFO_HEALTH_POS_X )
			exp             rect Y( PLAYERINFO_HEALTH_POS_Y )
			forecolor		1 1 1 HUD_BACK_ALPHA
			style			WINDOW_STYLE_SHADER
			background		"hud_background_line"
			visible			when ( PLAYERINFO_IS_VISIBLE )
			decoration  
		}
		HUD_DEBUG_DOT( PLAYERINFO_HEALTH_POS_X, PLAYERINFO_HEALTH_POS_Y, INV_ALIGN_L )


		itemDef
		{
			name			"chRect"
			rect			-2 -60 48 48 // 64x64
			ownerdraw		CG_PLAYER_STANCE
			textfont		UI_FONT_OBJECTIVE
			visible			when( !inkillcam() && !selecting_location() && dvarint( ui_hud_show_stance ) == 1 && dvarInt(ui_stance_color) == 0 );
			textscale		TEXTSIZE_SMALL
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			forecolor		1 1 1 HUD_ALPHA
			decoration
		}
	}