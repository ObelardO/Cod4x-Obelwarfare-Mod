// Score Bar
menuDef
{
    name			"scorebar"
    rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
    fullScreen		0
    visible 		when ( ( ( ( team( name ) == "TEAM_ALLIES" || team( name ) == "TEAM_AXIS" ) && gametype() != "bel" ) && !inkillcam() && NOT_SPECTATING_CLIENT && !menuisopen( background_main ) && !menuisopen( background_systemlink ) && !menuisopen( scoreboard )) && ( dvarInt( ui_hud_hardcore ) == 0 || dvarint( ui_hud_show_inventory ) > 0  ) && (dvarInt( "ui_score_bar" ) || team( name ) == "TEAM_SPECTATOR" || (dvarInt( "ui_timelimit" ) > 0 && timeLeft() < 0) || (timeLeft() >= 0 && (timeLeft() % 60 < 5 || timeLeft() < 60)) || (timeLeft() < 0 && (timeLeft() % 60 > (0-5))) || (dvarInt( "ui_scorelimit" ) > 0 && max( marinesfield( score ), opforfield( score ) ) / dvarInt( "ui_scorelimit" ) > 0.75 ) ) );

    #define BARWIDTH	400

    itemDef
    {
        style			WINDOW_STYLE_SHADER
        rect			(-BARWIDTH/2) 3 BARWIDTH 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        background		"line_horizontal"
        forecolor		0 0 0 1
        visible			1
        decoration
    }

    itemDef
    {
        rect		0 0 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        origin		0 20
        exp			text( locString( "@MENU_SCORE_WINNING", team( score ), otherteam( score ) ) );//exp text( "Winning " + team( score ) + " - " + otherteam( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	0.3 1 0.3 1
        visible 	when( team( score ) > otherteam( score ) )
        decoration
    }
    itemDef
    {
        rect		0 0 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        origin		0 20
        exp			text( locString( "@MENU_SCORE_LOSING", otherteam( score ), team( score ) ) );//exp text( "Losing " + otherteam( score ) + " - " + team( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 0.3 0.3 1
        visible 	when( team( score ) < otherteam( score ) )
        decoration
    }
    itemDef
    {
        rect		0 0 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
        origin		0 20
        exp			text( locString( "@MENU_SCORE_TIED", team( score ), otherteam( score ) ) );//exp text( "Tied " + team( score ) + " - " + otherteam( score ) );
        textfont	UI_FONT_OBJECTIVE
        textscale	0.35
        textalign	ITEM_ALIGN_CENTER
        textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
        forecolor	1 1 0.3 1
        visible 	when( team( score ) == otherteam( score ) )
        decoration
    }
}