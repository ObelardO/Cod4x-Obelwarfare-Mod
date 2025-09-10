//**************************************************************//
//  _____ _          _    _    _             __                 //
// |  _  | |        | |  | |  | |           / _|                //
// | | | | |__   ___| |  | |  | | __ _ _ __| |_ __ _ _ __ ___   //
// | | | | '_ \ / _ \ |  | |/\| |/ _` | '__|  _/ _` | '__/ _ \  //
// \ \_/ / |_) |  __/ |__\  /\  / (_| | |  | || (_| | | |  __/  //
//  \___/|_.__/ \___|____/\/  \/ \__,_|_|  |_| \__,_|_|  \___|  //
//                                                              //
//            Website: http://cod4.obelardo.ru                  //
//**************************************************************//

initCardsInfo()
{
    if( !isDefined( level.playerCardPers ) )
    {
        level.playerCardPers = [];

        fileName = "playercardpers.txt";

        if( isFileExists( fileName ) )
        {
            fileHeader = fileOpen( fileName, "read" );

            if( fileHeader != 0 )
            {
                line = fileReadLine( fileHeader );

                while( isDefined( line ) )
                {
                    lineTok = strTok( line, "," );

                    if( lineTok.size > 1 )
                    {
                        playerGuid = lineTok[0];
                        cardName = lineTok[1];

                        level.playerCardPers[playerGuid] = cardName;

                        preCacheShader( "playercard_emblem_" + cardName );
                    }

                    line = fileReadLine( fileHeader );
                }

                fileClose( fileHeader );
            }  
        }
    }
}

setPlayerCard()
{
    self.playerCard.cardName = "0";

    guid = self getGuid();

    if( isDefined( level.playerCardPers[guid] ) )
    {
        self.playerCard.cardName = level.playerCardPers[guid];
    }
}


isFileExists( fileName )
{
	fileName = "scriptdata/" + fileName;
	return fs_testfile( fileName );
}

fileOpen( fileName, mode )
{
	fileName = "scriptdata/" + fileName;
	return fs_fopen( fileName, mode );
}

fileReadLine( fileHeader )
{
	return fs_readline( fileHeader );
}

fileWriteLine( fileHeader, contents )
{
	fs_writeline( fileHeader, contents );
}

fileClose( fileHeader )
{
	fs_fclose( fileHeader );
}