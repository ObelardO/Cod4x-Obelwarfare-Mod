
#define ALLIES_HAVE_UAV (dvarint( "ui_uav_allies" ) && team( name ) == "TEAM_ALLIES" )
#define AXIS_HAVE_UAV (dvarint( "ui_uav_axis" ) && team( name ) == "TEAM_AXIS" )
#define CLIENT_HAS_UAV (dvarint( "ui_uav_client" ) && team( name ) == "TEAM_FREE" )

#define RECT_COMPASS	0 0 COMPASS_SIZE_MP COMPASS_SIZE_MP HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
#undef MINIMAP_ORIGIN
#define MINIMAP_ORIGIN 	14 19 //2 2

#define COMPASS_VISIBLE     ( dvarint( "ui_hud_hardcore" ) == 0 || dvarint( "ui_hud_hardcore_show_compass" ) == 1 )
#define MINIMAP_VISIBLE     ( dvarint( "ui_hud_hardcore" ) == 0 || dvarint( "ui_hud_hardcore_show_minimap" ) == 1 )
#define MINIMAP_UAV_VISIBLE ( ALLIES_HAVE_UAV || AXIS_HAVE_UAV || CLIENT_HAS_UAV || dvarInt( "g_compassShowEnemies" ) )

// Compass
menuDef
{
    name			"Compass_old"
    rect			RECT_COMPASS
    fullScreen		0
    visible 		when ( HUD_IS_VISIBLE );

    itemDef
    {
        name			"minimapBG"
        rect			(MINIMAP_X_MP - 14) (MINIMAP_Y_MP - 6) COMPASS_SIZE_MP COMPASS_SIZE_MP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        background		"minimap_background"
        ownerdraw		CG_PLAYER_COMPASS_BACK
        visible         when ( ( MINIMAP_VISIBLE || MINIMAP_UAV_VISIBLE ) && !selecting_location() );
        decoration
    }
    itemDef
    {
        name			"minimapTickerBorder"
        rect			MINIMAP_X_MP (MINIMAP_Y_MP - 15) MINIMAP_W_MP 14
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 0.1
        background		"minimap_tickertape_background"
        ownerdraw		CG_PLAYER_COMPASS_BACK
        visible         when ( (COMPASS_VISIBLE || MINIMAP_VISIBLE || MINIMAP_UAV_VISIBLE ) && !selecting_location() );
        decoration
    }
    // compass without obj points
    itemDef
    {
        name			"minimapTicker"
        rect			MINIMAP_X_MP (MINIMAP_Y_MP - 9) MINIMAP_W_MP 6
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        background		"minimap_tickertape_mp"
        ownerdraw		CG_PLAYER_COMPASS_TICKERTAPE_NO_OBJ
        visible         when ( (COMPASS_VISIBLE || MINIMAP_VISIBLE || MINIMAP_UAV_VISIBLE ) && !selecting_location() && !dvarint( "compass_objectives" ) );
        decoration
    }
    // compass with obj points
    itemDef
    {
        name			"minimapTicker"
        rect			MINIMAP_X_MP (MINIMAP_Y_MP - 9) MINIMAP_W_MP 6
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        background		"minimap_tickertape_mp"
        ownerdraw		CG_PLAYER_COMPASS_TICKERTAPE
        textscale		0.25
        textstyle		ITEM_TEXTSTYLE_SHADOWED
        visible         when ( (COMPASS_VISIBLE || MINIMAP_VISIBLE || MINIMAP_UAV_VISIBLE ) && !selecting_location() && dvarint( "compass_objectives" ) );
        decoration
    }
    itemDef
    {
        name			"mini_map"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 HUD_ALPHA
        background		"compass_map_default"
        ownerdraw		CG_PLAYER_COMPASS_MAP
        visible         when ( ( MINIMAP_VISIBLE || MINIMAP_UAV_VISIBLE ) && !selecting_location() );
        decoration
    }
    // Objective pointers
    itemDef
    {
        name			"compasspointers"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 HUD_ALPHA
        background		"objective_line"
        ownerdraw		CG_PLAYER_COMPASS_POINTERS
        visible         when ( ( MINIMAP_VISIBLE || MINIMAP_UAV_VISIBLE ) && !selecting_location() && dvarint( "ui_hud_showobjicons" ) > 0 );
        decoration
    }
    // Friendlies pointers
    itemDef
    {
        name			"compassfriendlies"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_PLAYER_COMPASS_FRIENDS
        visible         when ( ( MINIMAP_VISIBLE || MINIMAP_UAV_VISIBLE ) && !selecting_location() );
    }
    // Enemy pings
    itemDef
    {
        name			"compassenemies"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_PLAYER_COMPASS_ENEMIES
        visible         when ( ( ( MINIMAP_VISIBLE && dvarint( ui_minimap_show_enemies_firing ) == 1 ) || MINIMAP_UAV_VISIBLE ) && !selecting_location() );
    }
    // Helicopter pointers
    itemDef
    {
        name			"compasshelicopters"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_PLAYER_COMPASS_HELICOPTERS
        visible         when ( ( MINIMAP_VISIBLE || MINIMAP_UAV_VISIBLE ) && !selecting_location() && dvarint( "ui_hud_show_hardpoints" ) == 1 );
    }
    // Plane pointers
    itemDef
    {
        name			"compassplanes"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 HUD_FOREGROUND_ALPHA
        ownerdraw		CG_PLAYER_COMPASS_PLANES
        visible         when ( ( MINIMAP_VISIBLE || MINIMAP_UAV_VISIBLE ) && !selecting_location() && dvarint( "ui_hud_show_hardpoints" ) == 1 );
    }
    // Player direction indicator
    itemDef
    {
        name			"compassplayer"
        rect			MINIMAP_X_MP MINIMAP_Y_MP MINIMAP_W_MP MINIMAP_H_MP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1//HUD_FOREGROUND_ALPHA
        background		"compassping_player"
        ownerdraw		CG_PLAYER_COMPASS_PLAYER
        visible         when ( ( MINIMAP_VISIBLE || MINIMAP_UAV_VISIBLE ) && !selecting_location() );
    }
}