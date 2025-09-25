#define MATCHTIMER_HUD_VISIBLE        ( ( team( name ) != "TEAM_SPECTATOR" || dvarInt( ui_broadcaster ) == 0 ) && dvarInt( "ui_timelimit" ) > 0 && !isIntermission() && !inkillcam() && !ui_active() && !isIntermission() && !flashbanged() && !scoped() && ( dvarInt( "ui_timelimit" ) * 60 - timeLeft() > 5 ) )

#define PLAYER_HUD_HEALTH_VISIBLE     ( ( team( name ) != "TEAM_SPECTATOR" || dvarInt( ui_broadcaster ) == 0 ) !flashbanged() && !isIntermission() && !ui_active() && !inkillcam() && !scoped() )



// Low health overlay
menuDef
{
    name			"Low Health"
    rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
    fullScreen		0
    visible			1
    
    //PEL VISUAL GUIDE INFO FRAME
    itemDef
    {
        name 			"visual_guide_frame"
        style           WINDOW_STYLE_SHADER
        rect 			200 308 240 120
        background		"white"
        forecolor       .2 .2 .2 .7
        bordercolor		1 1 1 .7
        border 			0
        bordersize		2
        visible 		when( dvarString( "g_gametype" ) == "vg" )
        decoration
    }
    
    itemDef
    {
        name			"title"
        type			ITEM_TYPE_TEXT
        rect			280 328 0 0
        text      		"VISUAL GUIDE"
        textfont		UI_FONT_NORMAL
        forecolor		0 1 0 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" )
        decoration	
    }
    //CATEGORIES
    itemDef
    {
        name			"category"
        type			ITEM_TYPE_TEXT
        rect			217 350 0 0
        text      		"@OW_MOVER_CAT"
        textfont		UI_FONT_NORMAL
        forecolor		1 1 1 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" )
        decoration	
    }
    itemDef
    {
        name			"category_allies_spawns"
        text			"@OW_MOVER_CAT_ALLIES"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "allies_spawns" )
        decoration	
    }
    itemDef
    {
        name			"category_allies_start_spawns"
        text			"@OW_MOVER_CAT_ALLIES_START"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "allies_start_spawns" )
        decoration	
    }
    itemDef
    {
        name			"category_axis_spawns"
        text			"@OW_MOVER_CAT_AXIS"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "axis_spawns" )
        decoration	
    }
    itemDef
    {
        name			"category_axis_start_spawns"
        text			"@OW_MOVER_CAT_AXIS_START"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "axis_start_spawns" )
        decoration	
    }
    itemDef
    {
        name			"category_attacker_spawns"
        text			"@OW_MOVER_CAT_ATTACKER"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "attacker_spawns" )
        decoration	
    }
    itemDef
    {
        name			"category_defender_spawns"
        text			"@OW_MOVER_CAT_DEFENDER"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "defender_spawns" )
        decoration	
    }
    itemDef
    {
        name			"category_neutral_spawns"
        text			"@OW_MOVER_CAT_NEUTRAL"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "spawns" )
        decoration	
    }
    itemDef
    {
        name			"category_objectives"
        text			"@OW_MOVER_CAT_OBJECTIVE"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "objectives" )
        decoration	
    }
    itemDef
    {
        name			"category_explosives"
        text			"@OW_MOVER_CAT_EXPLOSIVE"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "explosive" )
        decoration	
    }
    itemDef
    {
        name			"category_flags"
        text			"@OW_MOVER_CAT_FLAG"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "flags" )
        decoration	
    }
    itemDef
    {
        name			"category_extraction"
        text			"@OW_MOVER_CAT_EXTRACT"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "extract_zone" )
        decoration	
    }
    itemDef
    {
        name			"category_radios"
        text			"@OW_MOVER_CAT_RADIO"
        type			ITEM_TYPE_TEXT
        rect			280 350 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when ( dvarString( "g_gametype" ) == "vg" && dvarString( cat_info ) == "radios" )
        decoration	
    }
    
    //ITEMS
    itemDef
    {
        name			"item_index"
        type			ITEM_TYPE_TEXT
        rect			230 365 0 0
        text      		"Item #:"
        textfont		UI_FONT_NORMAL
        forecolor		1 1 1 1
        textscale		.30	
        visible			when( dvarString( "g_gametype" ) == "vg" )
        decoration	
    }
    itemDef
    {
        name			"item_index_info"
        type			ITEM_TYPE_TEXT
        rect			280 365 0 0
        dvar			item_index;
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" )
        decoration	
    }
    itemDef
    {
        name			"command"
        type			ITEM_TYPE_TEXT
        rect			210 380 0 0
        text      		"@OW_MOVER_CMD"
        textfont		UI_FONT_NORMAL
        forecolor		1 1 1 1
        textscale		.30	
        visible			when( dvarString( "g_gametype" ) == "vg" )
        decoration	
    }
    itemDef
    {
        name			"command_next_cat"
        text			"@OW_MOVER_CMD_CAT_NEXT"
        type			ITEM_TYPE_TEXT
        rect			280 380 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" && dvarString( cmd_info ) == "next_category" )
        decoration	
    }
    itemDef
    {
        name			"command_prev_cat"
        text			"@OW_MOVER_CMD_CAT_PREV"
        type			ITEM_TYPE_TEXT
        rect			280 380 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" && dvarString( cmd_info ) == "prev_category" )
        decoration	
    }
    itemDef
    {
        name			"command_next_item"
        text			"@OW_MOVER_CMD_ITEM_NEXT"
        type			ITEM_TYPE_TEXT
        rect			280 380 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" && dvarString( cmd_info ) == "next_item" )
        decoration	
    }
    itemDef
    {
        name			"command_prev_item"
        text			"@OW_MOVER_CMD_ITEM_PREV"
        type			ITEM_TYPE_TEXT
        rect			280 380 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" && dvarString( cmd_info ) == "prev_item" )
        decoration	
    }
    itemDef
    {
        name			"command_location"
        text			"@OW_MOVER_CMD_SHOW"
        type			ITEM_TYPE_TEXT
        rect			280 380 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" && dvarString( cmd_info ) == "location" )
        decoration	
    }
    itemDef
    {
        name			"command_reset_item"
        text			"@OW_MOVER_CMD_RESET_ITEM"
        type			ITEM_TYPE_TEXT
        rect			280 380 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" && dvarString( cmd_info ) == "reset_item_loc" )
        decoration	
    }
    itemDef
    {
        name			"command_reset_all"
        text			"@OW_MOVER_CMD_RESET_ALL"
        type			ITEM_TYPE_TEXT
        rect			280 380 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" && dvarString( cmd_info ) == "reset_all_loc" )
        decoration	
    }
    itemDef
    {
        name			"command_write_item"
        text			"@OW_MOVER_CMD_WRITE_ITEM"
        type			ITEM_TYPE_TEXT
        rect			280 380 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" && dvarString( cmd_info ) == "write_item_log" )
        decoration	
    }
    itemDef
    {
        name			"command_write_all"
        text			"@OW_MOVER_CMD_WRITE_ALL"
        type			ITEM_TYPE_TEXT
        rect			280 380 0 0
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( "g_gametype" ) == "vg" && dvarString( cmd_info ) == "write_all_log" )
        decoration	
    }
    //END VISUAL GUIDE

    //CAP INFO
    itemDef
    {
        name			"cap_open"
        type			ITEM_TYPE_TEXT
        rect			-50 0 0 0 HORIZONTAL_ALIGN_CENTER_SAFEAREA VERTICAL_ALIGN_CENTER_SAFEAREA
        text			"@OW_CAP_OPEN"
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( cap_info ) == "open" && dvarString( cap_enable ) == "true" )
        decoration	
    }
    itemDef
    {
        name			"cap_init"
        type			ITEM_TYPE_TEXT
        rect			-100 0 0 0 HORIZONTAL_ALIGN_CENTER_SAFEAREA VERTICAL_ALIGN_CENTER_SAFEAREA
        text			"@OW_CAP_INITIALIZING"
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( cap_info ) == "init" && dvarString( cap_enable ) == "true" )
        decoration	
    }
    itemDef
    {
        name			"cap_cycle_close"
        type			ITEM_TYPE_TEXT
        rect			35 -30 0 0 HORIZONTAL_ALIGN_CENTER_SAFEAREA VERTICAL_ALIGN_CENTER_SAFEAREA
        exp				text( "@OW_CAP_CYCLE_AND_CLOSE" )
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.30		
        visible			when( dvarString( cap_info ) == "cycle_close" && dvarString( cap_enable ) == "true" )
        decoration	
    }
    itemDef
    {
        name			"cap_timer"
        type			ITEM_TYPE_TEXT
        rect			35 20 0 0 HORIZONTAL_ALIGN_CENTER_SAFEAREA VERTICAL_ALIGN_CENTER_SAFEAREA
        dvar			cap_time
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.35		
        visible			when( dvarString( "cap_time" ) > 0 && dvarString( cap_enable ) == "true" && dvarString( cap_info ) == "cycle_close" )
        decoration	
    }
    itemDef
    {
        name			"cap_timer_text"
        text			"@OW_CAP_SECONDS_LEFT"
        type			ITEM_TYPE_TEXT
        rect			55 20 0 0 HORIZONTAL_ALIGN_CENTER_SAFEAREA VERTICAL_ALIGN_CENTER_SAFEAREA
        textfont		UI_FONT_NORMAL
        forecolor		1 1 0 1
        textscale		.35		
        visible			when( dvarString( "cap_time" ) > 0 && dvarString( cap_enable ) == "true" && dvarString( cap_info ) == "cycle_close" )
        decoration	
    }
    //END CAP INFO
    
    itemDef
    {
        name			"healthoverlay"
        rect			0 0 640 480
        forecolor		1 1 1 1
        background		"overlay_low_health"
        ownerdraw		CG_PLAYER_LOW_HEALTH_OVERLAY
        visible			when( dvarInt( ui_healthoverlay ) == 1 );
        decoration
    }

    // HEALTH BAR
    itemDef
    {
        name "healthbarback"
        rect 27 453 124 6
        forecolor 0.1 0.1 0.1 0.3
        background "white"
        ownerdraw CG_PLAYER_BAR_HEALTH_BACK
        visible when( !dvarInt( "wideScreen" ) && !flashbanged() && !isIntermission() && !ui_active() && team( name ) != "TEAM_SPECTATOR" );
        decoration
    }
    itemDef
    {
        name "healthbar"
        rect 28 454 122 4
        forecolor 0.7 0.7 0.7 0.3
        background "white"
        ownerdraw CG_PLAYER_BAR_HEALTH
        visible when( !dvarInt( "wideScreen" ) && !flashbanged() && !isIntermission() && !ui_active() && team( name ) != "TEAM_SPECTATOR" );
        decoration
    }
    itemDef
    {
        name "healthbarcross"
        rect 12 449 15 15
        forecolor 1.0 1.0 1.0 0.3
        //background "hud_healthbar_heart"
        background "hint_health"
        ownerdraw CG_PLAYER_BAR_HEALTH_BACK
        visible when( !dvarInt( "wideScreen" ) && !flashbanged() && !isIntermission() && !ui_active() && team( name ) != "TEAM_SPECTATOR" );
        decoration
    }

    
    // HEALTH BAR WIDESCREEN
    itemDef
    {
        name "healthbarback"
        rect 24 453 93 6
        forecolor 0.1 0.1 0.1 0.3
        background "white"
        ownerdraw CG_PLAYER_BAR_HEALTH_BACK
        visible when( dvarInt( "wideScreen" ) && !flashbanged() && !isIntermission() && !ui_active() && team( name ) != "TEAM_SPECTATOR" );
        decoration
    }
    itemDef
    {
        name "healthbar"
        rect 25 454 91 4
        forecolor 0.7 0.7 0.7 0.3
        background "white"
        ownerdraw CG_PLAYER_BAR_HEALTH
        visible when( dvarInt( "wideScreen" ) && !flashbanged() && !isIntermission() && !ui_active() && team( name ) != "TEAM_SPECTATOR" );
        decoration
    }
    itemDef
    {
        name "healthbarcross"
        rect 14 450 9 12
        forecolor 1.0 1.0 1.0 0.3
        background "hint_health"
        ownerdraw CG_PLAYER_BAR_HEALTH_BACK
        visible when( dvarInt( "wideScreen" ) && !flashbanged() && !isIntermission() && !ui_active() && team( name ) != "TEAM_SPECTATOR" );
        decoration
    }
    

    //RAUND TIMER
    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			0 53 32 32 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        origin			-15 -23
        exp				material( "hud_suitcase_bomb" );
        visible			when ( dvarBool( ui_bomb_timer ) && MATCHTIMER_HUD_VISIBLE );
        forecolor		1 1 1 0.25
        decoration
    }
    itemDef
    {
        rect		0 53 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        origin		-2 0
        exp text	( secondsAsCountdown( timeLeft() ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        visible 	when ( timeLeft() >= 60 && !dvarBool( ui_bomb_timer ) && MATCHTIMER_HUD_VISIBLE );
        forecolor	1 1 1 HUD_FOREGROUND_ALPHA
        decoration
    }
    itemDef
    {
        rect		0 53 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        origin		-2 0
        exp text	( secondsAsCountdown( timeLeft() ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 0.75 0 HUD_FOREGROUND_ALPHA
        visible 	when ( timeLeft() >= 30 && timeLeft() < 60 && !dvarBool( ui_bomb_timer ) && MATCHTIMER_HUD_VISIBLE );
        decoration
    }
    itemDef
    {
        rect		0 53 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        origin		-2 0
        exp text	( secondsAsCountdown( timeLeft() ) + "." + (9 - int( (milliseconds() / 100)%10 )) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 0.5 0 1
        visible 	when ( ( (timeLeft() >= 0 && timeLeft() < 30) || dvarBool( ui_bomb_timer ) ) && MATCHTIMER_HUD_VISIBLE );
        decoration
    }
}
