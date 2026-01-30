#define MM_HUD_IS_VISIBLE       ( dvarint( "ui_hud_hardcore" ) == 0 || dvarint( "ui_hud_hardcore_show_minimap" ) == 1 )

#define MM_HUD_ALIGN            HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP

#define MM_HUD_SIZE_W           110
#define MM_HUD_SIZE_H           110
#define MM_HUD_RECT             0 0 MM_HUD_SIZE_W MM_HUD_SIZE_H MM_HUD_ALIGN  
   

#define MM_ALLIES_HAVE_UAV      ( dvarint( "ui_uav_allies" ) && team( name ) == "TEAM_ALLIES" )
#define MM_AXIS_HAVE_UAV        ( dvarint( "ui_uav_axis" ) && team( name ) == "TEAM_AXIS" )
#define MM_CLIENT_HAS_UAV       ( dvarint( "ui_uav_client" ) && team( name ) == "TEAM_FREE" )
#define MM_HAS_UAV              ( MM_ALLIES_HAVE_UAV || MM_AXIS_HAVE_UAV || MM_CLIENT_HAS_UAV || dvarInt( "g_compassShowEnemies" ) )
   

#define MM_HUD_LAYER( nameText, backMat, drawerDef, alphaExp, isVisibleExp ) \
    itemDef \
    { \
        name			nameText \
        rect			0 0 MM_HUD_SIZE_W MM_HUD_SIZE_H MM_HUD_ALIGN \
        forecolor		1 1 1 alphaExp \
        background		backMat \
        ownerdraw		drawerDef \
        visible         when ( isVisibleExp ) \
        decoration \
    } 


menuDef
{
    name			"Compass_old"
    rect			MM_HUD_RECT
    exp				rect Y( ONLINEGAME_OFFSET_EXP )
	exp				rect X( ONLINEGAME_OFFSET_EXP )
    fullScreen		0
    visible 		when ( HUD_IS_VISIBLE && CLIENT_NOT_DEAD && ( MM_HUD_IS_VISIBLE || MM_HAS_UAV ) && !selecting_location() );

    // Background layer
    MM_HUD_LAYER( "minimapBG", "minimap_background", CG_PLAYER_COMPASS_BACK, HUD_FOREGROUND_ALPHA, 1 )

    // Map layer
    MM_HUD_LAYER( "mini_map",   "compass_map_default", CG_PLAYER_COMPASS_MAP,  HUD_ALPHA, 1 )

    // Objective pointers
    MM_HUD_LAYER( "compasspointers", "objective_line", CG_PLAYER_COMPASS_POINTERS, HUD_ALPHA, dvarint( "ui_hud_showobjicons" ) > 0 )

    // Friendlies pointers
    MM_HUD_LAYER( "compassfriendlies", "white", CG_PLAYER_COMPASS_FRIENDS, HUD_FOREGROUND_ALPHA, 1 )

    // Enemy pings
    MM_HUD_LAYER( "compassenemies", "white", CG_PLAYER_COMPASS_ENEMIES, HUD_FOREGROUND_ALPHA, MM_HAS_UAV || dvarint( "ui_minimap_show_enemies_firing" ) == 1 )

    // Helicopter pointers
    MM_HUD_LAYER( "compasshelicopters", "white", CG_PLAYER_COMPASS_HELICOPTERS, HUD_FOREGROUND_ALPHA, dvarint( "ui_hud_show_hardpoints" ) == 1 )

    // Plane pointers
    MM_HUD_LAYER( "compassplanes", "white", CG_PLAYER_COMPASS_PLANES, HUD_FOREGROUND_ALPHA, dvarint( "ui_hud_show_hardpoints" ) == 1 )

    // Player direction indicator
    MM_HUD_LAYER( "compassplayer", "compassping_player", CG_PLAYER_COMPASS_PLAYER, 1, 1 )
}