// Stance indicator
	menuDef
	{
    	name			"stance"
    	// place this offscreen so it doesn't show the stance indicator but only shows the "prone blocked"
		rect			0 -93 0 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
    	fullScreen		0
		visible			when( !flashbanged() && !ui_active() && NOT_SPECTATING && team( name ) != "TEAM_SPECTATOR" );

		itemDef
		{
			name			"chRect"
			rect			-2 0 48 48 // 64x64
			ownerdraw		CG_PLAYER_STANCE
			textfont		UI_FONT_OBJECTIVE
			visible			when( !inkillcam() && !selecting_location() && dvarint( ui_hud_show_stance ) == 1 && dvarInt(ui_stance_color) == 0 );
			textscale		TEXTSIZE_SMALL
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			forecolor		1 1 1 HUD_ALPHA
			decoration
		}

		itemDef
		{
			name			"chRect"
			rect			-2 0 48 48 // 64x64
			ownerdraw		CG_PLAYER_STANCE
			textfont		UI_FONT_OBJECTIVE
			visible			when( !inkillcam() && !selecting_location() && dvarint( ui_hud_show_stance ) == 1 && dvarInt(ui_stance_color) == 1 );
			textscale		TEXTSIZE_SMALL
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			forecolor		0 0.5 0 HUD_ALPHA
			decoration
		}

		itemDef
		{
			name			"chRect"
			rect			-2 0 48 48 // 64x64
			ownerdraw		CG_PLAYER_STANCE
			textfont		UI_FONT_OBJECTIVE
			visible			when( !inkillcam() && !selecting_location() && dvarint( ui_hud_show_stance ) == 1 && dvarInt(ui_stance_color) == 2 );
			textscale		TEXTSIZE_SMALL
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			forecolor		1 1 0 HUD_ALPHA
			decoration
		}

		itemDef
		{
			name			"chRect"
			rect			-2 0 48 48 // 64x64
			ownerdraw		CG_PLAYER_STANCE
			textfont		UI_FONT_OBJECTIVE
			visible			when( !inkillcam() && !selecting_location() && dvarint( ui_hud_show_stance ) == 1 && dvarInt(ui_stance_color) == 3 );
			textscale		TEXTSIZE_SMALL
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			forecolor		1 0.5 0 HUD_ALPHA
			decoration
		}

		itemDef
		{
			name			"chRect"
			rect			-2 0 48 48 // 64x64
			ownerdraw		CG_PLAYER_STANCE
			textfont		UI_FONT_OBJECTIVE
			visible			when( !inkillcam() && !selecting_location() && dvarint( ui_hud_show_stance ) == 1 && dvarInt(ui_stance_color) == 4 );
			textscale		TEXTSIZE_SMALL
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			forecolor		1 0 0 HUD_ALPHA
			decoration
		}						
	}