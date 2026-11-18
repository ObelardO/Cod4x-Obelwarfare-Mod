		itemDef
		{
			name			desc_arrow
			style			WINDOW_STYLE_SHADER
			rect			ORIGIN_DESCRIPTION 10 10 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP
			origin			-12 6
			background		"ui_arrow_right"
			forecolor		1 1 1 0.3
			visible			when( !dvarBool( ui_hide_desc ) );
			decoration
		}

		LOCAL_DESC( 1 )     	LOCAL_DESC2( 1 )
		LOCAL_DESC( 2 )     	LOCAL_DESC2( 2 )
		LOCAL_DESC( 3 )     	LOCAL_DESC2( 3 )
		LOCAL_DESC( 4 )     	LOCAL_DESC2( 4 )
		LOCAL_DESC( 5 )     	LOCAL_DESC2( 5 )
		LOCAL_DESC( 6 )     	LOCAL_DESC2( 6 )
		LOCAL_DESC( 7 )     	LOCAL_DESC2( 7 )
		LOCAL_DESC( 8 )     	LOCAL_DESC2( 8 )
		LOCAL_DESC( 9 )     	LOCAL_DESC2( 9 )
		LOCAL_DESC( 10 )    	LOCAL_DESC2( 10 )

		CHOICE_BUTTON_FOCUS_VIS_ADV( 1, LOCAL_NAME(1), LOCAL_TIER_ACTION( "1", "270" ), SHOW_DESC(1), HIDE_DESC(1), when( stat(270) > 0 );, stat(270) > 0 )
				CHOICE_BUTTON_BG( 1, when( stat(270) == 0 ); )
				CHOICE_BUTTON_FOCUS_VIS_NOHI( 1, LOCAL_NAME(1), ;, SHOW_DESC2(1), HIDE_DESC2(1), when( stat(270) == 0 ); forecolor LOCAL_UNLOCK_COLOR )

		CHOICE_BUTTON_FOCUS_VIS_ADV( 2, LOCAL_NAME(2), LOCAL_TIER_ACTION( "2", "271" ), SHOW_DESC(2), HIDE_DESC(2), when( stat(271) > 0 );, stat(271) > 0 )
				CHOICE_BUTTON_BG( 2, when( stat(271) == 0 ); )
				CHOICE_BUTTON_FOCUS_VIS_NOHI( 2, LOCAL_NAME(2), ;, SHOW_DESC2(2), HIDE_DESC2(2), when( stat(271) == 0 ); forecolor LOCAL_UNLOCK_COLOR )

		CHOICE_BUTTON_FOCUS_VIS_ADV( 3, LOCAL_NAME(3), LOCAL_TIER_ACTION( "3", "272" ), SHOW_DESC(3), HIDE_DESC(3), when( stat(272) > 0 );, stat(272) > 0 )
				CHOICE_BUTTON_BG( 3, when( stat(272) == 0 ); )
				CHOICE_BUTTON_FOCUS_VIS_NOHI( 3, LOCAL_NAME(3), ;, SHOW_DESC2(3), HIDE_DESC2(3), when( stat(272) == 0 ); forecolor LOCAL_UNLOCK_COLOR )

		CHOICE_BUTTON_FOCUS_VIS_ADV( 4, LOCAL_NAME(4), LOCAL_TIER_ACTION( "4", "273" ), SHOW_DESC(4), HIDE_DESC(4), when( stat(273) > 0 );, stat(273) > 0 )
				CHOICE_BUTTON_BG( 4, when( stat(273) == 0 ); )
				CHOICE_BUTTON_FOCUS_VIS_NOHI( 4, LOCAL_NAME(4), ;, SHOW_DESC2(4), HIDE_DESC2(4), when( stat(273) == 0 ); forecolor LOCAL_UNLOCK_COLOR )

		CHOICE_BUTTON_FOCUS_VIS_ADV( 5, LOCAL_NAME(5), LOCAL_TIER_ACTION( "5", "274" ), SHOW_DESC(5), HIDE_DESC(5), when( stat(274) > 0 );, stat(274) > 0 )
				CHOICE_BUTTON_BG( 5, when( stat(274) == 0 ); )
				CHOICE_BUTTON_FOCUS_VIS_NOHI( 5, LOCAL_NAME(5), ;, SHOW_DESC2(5), HIDE_DESC2(5), when( stat(274) == 0 ); forecolor LOCAL_UNLOCK_COLOR )

		CHOICE_SEPARATOR( CHOICE_SEP_1 )

		CHOICE_BUTTON_FOCUS_VIS_ADV( 6, LOCAL_NAME(6), LOCAL_TIER_ACTION( "6", "275" ), SHOW_DESC(6), HIDE_DESC(6), when( stat(275) > 0 );, stat(275) > 0 )
				CHOICE_BUTTON_BG( 6, when( stat(275) == 0 ); )
				CHOICE_BUTTON_FOCUS_VIS_NOHI( 6, LOCAL_NAME(6), ;, SHOW_DESC2(6), HIDE_DESC2(6), when( stat(275) == 0 ); forecolor LOCAL_UNLOCK_COLOR )

		CHOICE_BUTTON_FOCUS_VIS_ADV( 7, LOCAL_NAME(7), LOCAL_TIER_ACTION( "7", "276" ), SHOW_DESC(7), HIDE_DESC(7), when( stat(276) > 0 );, stat(276) > 0 )
				CHOICE_BUTTON_BG( 7, when( stat(276) == 0 ); )
				CHOICE_BUTTON_FOCUS_VIS_NOHI( 7, LOCAL_NAME(7), ;, SHOW_DESC2(7), HIDE_DESC2(7), when( stat(276) == 0 ); forecolor LOCAL_UNLOCK_COLOR )

		CHOICE_BUTTON_FOCUS_VIS_ADV( 8, LOCAL_NAME(8), LOCAL_TIER_ACTION( "8", "277" ), SHOW_DESC(8), HIDE_DESC(8), when( stat(277) > 0 );, stat(277) > 0 )
				CHOICE_BUTTON_BG( 8, when( stat(277) == 0 ); )
				CHOICE_BUTTON_FOCUS_VIS_NOHI( 8, LOCAL_NAME(8), ;, SHOW_DESC2(8), HIDE_DESC2(8), when( stat(277) == 0 ); forecolor LOCAL_UNLOCK_COLOR )

		CHOICE_BUTTON_FOCUS_VIS_ADV( 9, LOCAL_NAME(9), LOCAL_TIER_ACTION( "9", "278" ), SHOW_DESC(9), HIDE_DESC(9), when( stat(278) > 0 );, stat(278) > 0 )
				CHOICE_BUTTON_BG( 9, when( stat(278) == 0 ); )
				CHOICE_BUTTON_FOCUS_VIS_NOHI( 9, LOCAL_NAME(9), ;, SHOW_DESC2(9), HIDE_DESC2(9), when( stat(278) == 0 ); forecolor LOCAL_UNLOCK_COLOR )

		CHOICE_BUTTON_FOCUS_VIS_ADV( 10, LOCAL_NAME(10), LOCAL_TIER_ACTION( "10", "279" ), SHOW_DESC(10), HIDE_DESC(10), when( stat(279) > 0 );, stat(279) > 0 )
				CHOICE_BUTTON_BG( 10, when( stat(279) == 0 ); )
				CHOICE_BUTTON_FOCUS_VIS_NOHI( 10, LOCAL_NAME(10), ;, SHOW_DESC2(10), HIDE_DESC2(10), when( stat(279) == 0 ); forecolor LOCAL_UNLOCK_COLOR )

		CHOICE_NEWICON_VIS( 1, "specialty_new", when( stat( "270" ) > 1 ) )
		CHOICE_NEWICON_VIS( 2, "specialty_new", when( stat( "271" ) > 1 ) )
		CHOICE_NEWICON_VIS( 3, "specialty_new", when( stat( "272" ) > 1 ) )
		CHOICE_NEWICON_VIS( 4, "specialty_new", when( stat( "273" ) > 1 ) )
		CHOICE_NEWICON_VIS( 5, "specialty_new", when( stat( "274" ) > 1 ) )
		CHOICE_NEWICON_VIS( 6, "specialty_new", when( stat( "275" ) > 1 ) )
		CHOICE_NEWICON_VIS( 7, "specialty_new", when( stat( "276" ) > 1 ) )
		CHOICE_NEWICON_VIS( 8, "specialty_new", when( stat( "277" ) > 1 ) )
		CHOICE_NEWICON_VIS( 9, "specialty_new", when( stat( "278" ) > 1 ) )
		CHOICE_NEWICON_VIS( 10, "specialty_new", when( stat( "279" ) > 1 ) )

		CHOICE_NEWICON_VIS( 1, "specialty_locked", when( stat( "270" ) == 0 ) )
		CHOICE_NEWICON_VIS( 2, "specialty_locked", when( stat( "271" ) == 0 ) )
		CHOICE_NEWICON_VIS( 3, "specialty_locked", when( stat( "272" ) == 0 ) )
		CHOICE_NEWICON_VIS( 4, "specialty_locked", when( stat( "273" ) == 0 ) )
		CHOICE_NEWICON_VIS( 5, "specialty_locked", when( stat( "274" ) == 0 ) )
		CHOICE_NEWICON_VIS( 6, "specialty_locked", when( stat( "275" ) == 0 ) )
		CHOICE_NEWICON_VIS( 7, "specialty_locked", when( stat( "276" ) == 0 ) )
		CHOICE_NEWICON_VIS( 8, "specialty_locked", when( stat( "277" ) == 0 ) )
		CHOICE_NEWICON_VIS( 9, "specialty_locked", when( stat( "278" ) == 0 ) )
		CHOICE_NEWICON_VIS( 10, "specialty_locked", when( stat( "279" ) == 0 ) )
