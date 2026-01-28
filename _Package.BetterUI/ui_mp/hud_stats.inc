#define STATS_WIDTH 160
#define STATS_CAT1  18
#define STATS_CAT2  21
#define STATS_VALUE 12
#define STATS_FONT_SCALE 0.25
#define STATS_TRANSPARENCY 0.7

// XP bar
menuDef
{
    name			"xpbar"
    rect			0 -8 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
    fullScreen		0
    visible 		when( dvarBool( "ui_hud_showstats" ) && !inkillcam() && !scoped() && !ui_active() && team( name ) != "TEAM_SPECTATOR" && NOT_SPECTATING_CLIENT );

    // Player statistics frame
    itemDef
    {
        style             WINDOW_STYLE_SHADER
        rect              (STATS_WIDTH*-1+13) 13 (STATS_WIDTH-20) 195 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        background        "white"
        forecolor         .2 .2 .2 (STATS_TRANSPARENCY-0.2)
        border             0
        visible                 1     decoration
    }

    // Accuracy
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT1) 22 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_ACCURACY"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 22 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_a" ) + " %" );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }	

    // Kills/Deaths Ratio
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT1) 37 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_KDRATIO"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 37 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_r" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }	

    // Total Kills
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT1) 52 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_KILLS"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 52 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_k" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }	

    // Current Killstreak
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT2) 62 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_CKILLSTREAK"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 62 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_cks" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }			

    // Highest Killstreak
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT2) 72 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_HKILLSTREAK"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 72 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_ks" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		
                    
    // Longest shot
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT2) 82 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_LONGEST"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 82 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_l" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }			

    // Melee Kills
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT2) 97 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_MELEE"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 97 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_mk" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }			

    // Headshots
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT2) 112 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_HEADSHOTS"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 112 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_h" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }

    // Longest Headshots
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT2) 122 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_LONGESTHS"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 122 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_lh" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }
    // Teamkills
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT1) 137 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_TEAMKILLS"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 137 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_t" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }	
    // Deaths
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT1) 152 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_DEATHS"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 152 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_d" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }

    // Suicides
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT2) 162 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_SUICIDES"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 162 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_s" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }

    // Current Deathstreak
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT2) 172 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_CDEATHSTREAK"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 172 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_cds" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }


    // Highest Deathstreak
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT2) 182 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_HDEATHSTREAK"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 182 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_ds" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }

    // Distance travelled
    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			(STATS_WIDTH*-1+STATS_CAT1) 197 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        text      "@OW_STATS_DISTANCE"
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_LEFT
        forecolor		1 1 1 STATS_TRANSPARENCY
        visible			1
        decoration	
    }		

    itemDef
    {
        type			ITEM_TYPE_TEXT
        rect			-STATS_VALUE 197 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
        exp				text( dvarstring( "ps_dt" ) );
        textfont		UI_FONT_NORMAL
        textscale		STATS_FONT_SCALE
        textAlign		ITEM_ALIGN_MIDDLE_RIGHT
        forecolor		1 1 0 STATS_TRANSPARENCY
        visible			1
        decoration	
    }
}