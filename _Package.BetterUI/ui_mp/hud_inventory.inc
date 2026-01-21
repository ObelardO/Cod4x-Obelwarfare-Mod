
#define INV_ALIGN_L             HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
#define INV_ALIGN_R             HORIZONTAL_ALIGN_RIGTH VERTICAL_ALIGN_BOTTOM

#define INV_ICON_SIZE           20

#define INV_SPACING             10

#define INV_OFFSET_X            ( INV_BACK_PAD )
#define INV_OFFSET_Y            ( 0 - INV_ICON_SIZE - INV_BACK_PAD )


#define INV_SLOT_L1_IS_VISIBLE  1
#define INV_SLOT_L2_IS_VISIBLE  1
#define INV_SLOT_L3_IS_VISIBLE  1

#define INV_SLOT_L1_POS_X       ( INV_OFFSET_X )
#define INV_SLOT_L2_POS_X       ( INV_SLOT_L1_POS_X + ( INV_ICON_SIZE + INV_SPACING ) * INV_SLOT_L1_IS_VISIBLE )
#define INV_SLOT_L3_POS_X       ( INV_SLOT_L2_POS_X + ( INV_ICON_SIZE + INV_SPACING ) * INV_SLOT_L2_IS_VISIBLE )

//#define INV_SLOT_R1_IS_VISIBLE  0
//#define INV_SLOT_R2_IS_VISIBLE  0
//#define INV_SLOT_R3_IS_VISIBLE  0

#define INV_BACK_PAD            ( 1 )  
#define INV_BACK_SIZE           ( ( INV_ICON_SIZE + INV_BACK_PAD * 2 ) * 1.25 )
#define INV_BACK_ALPHA          ( HUD_BACK_ALPHA * 0.9 )        
      

#define INV_ICON_NONE           "white"

#define INV_CLR_WHITE           1 1 1
#define INV_CLR_RED             0.9 0 0



#define INV_SLOT_ICON_LEFT( xPos, isVisibleExp, iconDrawerDef, iconMaterial, keyBinding, alphaExp ) \
	itemDef \
	{ \
        rect			0 ( INV_OFFSET_Y - INV_BACK_PAD ) INV_BACK_SIZE INV_BACK_SIZE INV_ALIGN_L \
        exp				rect X( xPos - INV_BACK_PAD ) \
        forecolor		1 1 1 HUD_BACK_ALPHA \
		exp             forecolor A( alphaExp ) \
        style			WINDOW_STYLE_SHADER \
        background		"hud_background_quad" \
        visible			when ( isVisibleExp ) \
        decoration \
	} \
	itemDef \
	{ \
        rect			0 INV_OFFSET_Y INV_ICON_SIZE INV_ICON_SIZE INV_ALIGN_L \
        exp				rect X( xPos ) \
        forecolor		0 1 0 0.0 \
        style			WINDOW_STYLE_SHADER \
        background		INV_ICON_NONE \
        visible			when ( isVisibleExp ) \
		decoration \
    } \
    itemDef \
    { \
        rect			0 INV_OFFSET_Y INV_ICON_SIZE INV_ICON_SIZE INV_ALIGN_L \
        exp				rect X( xPos ) \
        forecolor		1 1 1 HUD_ALPHA \
        exp             forecolor A( alphaExp ) \
        iconDrawerDef \
        background		iconMaterial \
        visible			when ( isVisibleExp ) \
        textscale       0 \
        decoration \
    }

#define INV_SLOT_AMMO_LEFT( xPos, isVisibleExp, ammoDrawerDef, color, alphaExp, xOffset, yOffset ) \
    itemDef \
    { \
        rect			0 ( INV_OFFSET_Y + INV_ICON_SIZE - INV_BACK_PAD - yOffset + 2.5 ) 0 0 INV_ALIGN_L \
        exp             rect X( xPos + xOffset + INV_ICON_SIZE ) \
        textscale		( TEXTSIZE_SMALL * 0.6 ) \
        textstyle		ITEM_TEXTSTYLE_SHADOWED \
        textfont		UI_FONT_OBJECTIVE \
        forecolor		color HUD_FOREGROUND_ALPHA \
        textalign       ITEM_ALIGN_BOTTOM_LEFT \
        exp             forecolor A ( alphaExp ) \
        background      INV_ICON_NONE \
        ammoDrawerDef \
        visible			when ( isVisibleExp ) \
        decoration \
    } \
    itemDef \
	{ \
        rect			0 ( INV_OFFSET_Y + INV_ICON_SIZE - INV_BACK_PAD ) 1 1 INV_ALIGN_L \
        exp             rect X( xPos + INV_ICON_SIZE ) \
        forecolor		0 1 0 0 \
        style			WINDOW_STYLE_SHADER \
        background		INV_ICON_NONE \
        visible			when ( isVisibleExp ) \
		decoration \
    }