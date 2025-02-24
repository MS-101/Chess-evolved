unit Game;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, CustomDrawnControls, ChessPosition, ChessPiece;

type
  Pieces = (Pawn, Rook, Knight, Bishop, Queen, King);
  PieceCountersLArray = array[Pieces] of TLabel;

  { TGameF }

  TGameF = class(TForm)
    Background, ChessBoard: TImage;
    EnPassant: TChessPiece;
    MessageA, MessageB: TLabel;
    Player1Panel, Player1ScorePanel, Player1PiecesPanel: TPanel;
    Player2Panel, Player2ScorePanel, Player2PiecesPanel: TPanel;
    Player1Portrait, Player2Portrait: TImage;
    Player1gName, Player2gName: TLabel;
    PawnBlackCounter, RookBlackCounter, KnightBlackCounter, BishopBlackCounter, QueenBlackCounter: TImage;
    PawnBlackCounterL, RookBlackCounterL, KnightBlackCounterL, BishopBlackCounterL, QueenBlackCounterL: TLabel;
    PawnWhiteCounter, RookWhiteCounter, KnightWhiteCounter, BishopWhiteCounter, QueenWhiteCounter: TImage;
    PawnWhiteCounterL, RookWhiteCounterL, KnightWhiteCounterL, BishopWhiteCounterL, QueenWhiteCounterL: TLabel;
    PawnWhiteHelp, RookWhiteHelp, KnightWhiteHelp, BishopWhiteHelp, QueenWhiteHelp, KingWhiteHelp: TImage;
    PawnBlackHelp, RookBlackHelp, KnightBlackHelp, BishopBlackHelp, QueenBlackHelp, KingBlackHelp: TImage;
    PawnWhite1, PawnWhite2, PawnWhite3, PawnWhite4, PawnWhite5, PawnWhite6, PawnWhite7, PawnWhite8: TChessPiece;
    RookWhite1, RookWhite2, KnightWhite1, KnightWhite2, BishopWhite1, BishopWhite2, QueenWhite, KingWhite: TChessPiece;
    PawnBlack1, PawnBlack2, PawnBlack3, PawnBlack4, PawnBlack5, PawnBlack6, PawnBlack7, PawnBlack8: TChessPiece;
    RookBlack1, RookBlack2, KnightBlack1, KnightBlack2, BishopBlack1, BishopBlack2, QueenBlack, KingBlack: TChessPiece;
    Position1, Position2, Position3, Position4, Position5, Position6, Position7, Position8: TLabel;
    PositionA, PositionB, PositionC, PositionD, PositionE, PositionF, PositionG, PositionH: TLabel;
    A1, A2, A3, A4, A5, A6, A7, A8: TChessPosition;
    B1, B2, B3, B4, B5, B6, B7, B8: TChessPosition;
    C1, C2, C3, C4, C5, C6, C7, C8: TChessPosition;
    D1, D2, D3, D4, D5, D6, D7, D8: TChessPosition;
    E1, E2, E3, E4, E5, E6, E7, E8: TChessPosition;
    F1, F2, F3, F4, F5, F6, F7, F8: TChessPosition;
    G1, G2, G3, G4, G5, G6, G7, G8: TChessPosition;
    H1, H2, H3, H4, H5, H6, H7, H8: TChessPosition;
    MovedPiece, MovedFrom, MovementType, MovedTo, CapturedPiece: TImage;
    RookPromotionPanel, KnightPromotionPanel, BishopPromotionPanel, QueenPromotionPanel: TPanel;
    RookPromotion, KnightPromotion, BishopPromotion, QueenPromotion: TImage;
    MainMenuB, CollectionB, Start, Restart, SurrenderWhite, SurrenderBlack: TCDButton;
    //game initialization
    procedure FormCreate(Sender: TObject);
    procedure SetGameSettings();
    //button clicks
    procedure StartClick();
    procedure RestartClick(Sender: TObject);
    procedure SurrenderClick(Sender: TObject);
    procedure MainMenuBClick();
    procedure CollectionBClick();
    //promotions
    procedure PromotionsClick(Sender: TImage);
    procedure PromotionsMouseEnter(Sender: TImage);
    procedure PromotionsMouseLeave(Sender: TImage);
    procedure PromotionsShow();
    procedure PromotionsHide();
    //repetitive procedures
    procedure ChessboardClear(Sender: TObject);
    procedure WhiteTurn();
    procedure BlackTurn();
    procedure Victory();
    //unit links
    procedure PositionsClick(Sender: TChessPosition);
    procedure PiecesClick(Sender: TChessPiece);
    procedure HelpsClick(Sender: TImage);
  private

  public

  end;

var
  GameF: TGameF;
  Turn: shortstring;
  gSelectedPiece: TChessPiece;
  Player1ScoreInteger: integer=0;
  Player2ScoreInteger: integer=0;
  PreviousMovement: array[0..4] of TImage;
  gBoard: array[0..63] of TChessPosition;
  AllPieces: array[0..31] of TChessPiece;
  BlackPieces, WhitePieces: array[0..16] of TChessPiece;
  WhitePawns, BlackPawns: array[0..7] of TChessPiece;
  WhitePieceCountersL, BlackPieceCountersL: PieceCountersLArray;

implementation

uses
  MainMenu, Collection, Help, Game_Positions, Game_Pieces;

{$R *.lfm}

{ TGameF }

//GAME INITIALIZATION

procedure TGameF.FormCreate(Sender: TObject);
begin
  //PreviousMovement array
  PreviousMovement[0]:=MovedPiece;
  PreviousMovement[1]:=MovedFrom;
  PreviousMovement[2]:=MovementType;
  PreviousMovement[3]:=MovedTo;
  PreviousMovement[4]:=CapturedPiece;
  //PreviousMovement initialization
  MovedFrom.Canvas.Font.Size:=20;
  MovedFrom.Canvas.Brush.Style:=bsClear;
  MovedTo.Canvas.Font.Size:=20;
  MovedTo.Canvas.Brush.Style:=bsClear;
  //gBoard array
  gBoard[0]:=A1;   gBoard[1]:=A2;   gBoard[2]:=A3;   gBoard[3]:=A4;   gBoard[4]:=A5;   gBoard[5]:=A6;   gBoard[6]:=A7;   gBoard[7]:=A8;
  gBoard[8]:=B1;   gBoard[9]:=B2;   gBoard[10]:=B3;  gBoard[11]:=B4;  gBoard[12]:=B5;  gBoard[13]:=B6;  gBoard[14]:=B7;  gBoard[15]:=B8;
  gBoard[16]:=C1;  gBoard[17]:=C2;  gBoard[18]:=C3;  gBoard[19]:=C4;  gBoard[20]:=C5;  gBoard[21]:=C6;  gBoard[22]:=C7;  gBoard[23]:=C8;
  gBoard[24]:=D1;  gBoard[25]:=D2;  gBoard[26]:=D3;  gBoard[27]:=D4;  gBoard[28]:=D5;  gBoard[29]:=D6;  gBoard[30]:=D7;  gBoard[31]:=D8;
  gBoard[32]:=E1;  gBoard[33]:=E2;  gBoard[34]:=E3;  gBoard[35]:=E4;  gBoard[36]:=E5;  gBoard[37]:=E6;  gBoard[38]:=E7;  gBoard[39]:=E8;
  gBoard[40]:=F1;  gBoard[41]:=F2;  gBoard[42]:=F3;  gBoard[43]:=F4;  gBoard[44]:=F5;  gBoard[45]:=F6;  gBoard[46]:=F7;  gBoard[47]:=F8;
  gBoard[48]:=G1;  gBoard[49]:=G2;  gBoard[50]:=G3;  gBoard[51]:=G4;  gBoard[52]:=G5;  gBoard[53]:=G6;  gBoard[54]:=G7;  gBoard[55]:=G8;
  gBoard[56]:=H1;  gBoard[57]:=H2;  gBoard[58]:=H3;  gBoard[59]:=H4;  gBoard[60]:=H5;  gBoard[61]:=H6;  gBoard[62]:=H7;  gBoard[63]:=H8;
  //AllPieces array
  AllPieces[0]:=RookWhite1;    AllPieces[1]:=KnightWhite1;     AllPieces[2]:=BishopWhite1;      AllPieces[3]:=QueenWhite;
  AllPieces[4]:=KingWhite;     AllPieces[5]:=BishopWhite2;     AllPieces[6]:=KnightWhite2;     AllPieces[7]:=RookWhite2;
  AllPieces[8]:=PawnWhite1;    AllPieces[9]:=PawnWhite2;       AllPieces[10]:=PawnWhite3;      AllPieces[11]:=PawnWhite4;
  AllPieces[12]:=PawnWhite5;   AllPieces[13]:=PawnWhite6;      AllPieces[14]:=PawnWhite7;      AllPieces[15]:=PawnWhite8;
  AllPieces[16]:=PawnBlack1;   AllPieces[17]:=PawnBlack2;      AllPieces[18]:=PawnBlack3;      AllPieces[19]:=PawnBlack4;
  AllPieces[20]:=PawnBlack5;   AllPieces[21]:=PawnBlack6;      AllPieces[22]:=PawnBlack7;      AllPieces[23]:=PawnBlack8;
  AllPieces[24]:=RookBlack1;   AllPieces[25]:=KnightBlack1;    AllPieces[26]:=BishopBlack1;    AllPieces[27]:=QueenBlack;
  AllPieces[28]:=KingBlack;    AllPieces[29]:=BishopBlack2;    AllPieces[30]:=KnightBlack2;    AllPieces[31]:=RookBlack2;
  //WhitePieces array
  WhitePieces[0]:=PawnWhite1;  WhitePieces[1]:=PawnWhite2;     WhitePieces[2]:=PawnWhite3;     WhitePieces[3]:=PawnWhite4;
  WhitePieces[4]:=PawnWhite5;  WhitePieces[5]:=PawnWhite6;     WhitePieces[6]:=PawnWhite7;     WhitePieces[7]:=PawnWhite8;
  WhitePieces[8]:=RookWhite1;  WhitePieces[9]:=KnightWhite1;   WhitePieces[10]:=BishopWhite1;  WhitePieces[11]:=QueenWhite;
  WhitePieces[12]:=KingWhite;  WhitePieces[13]:=BishopWhite2;  WhitePieces[14]:=KnightWhite2;  WhitePieces[15]:=RookWhite2;
  WhitePieces[16]:=EnPassant;
  //BlackPieces array
  BlackPieces[0]:=PawnBlack1;  BlackPieces[1]:=PawnBlack2;     BlackPieces[2]:=PawnBlack3;     BlackPieces[3]:=PawnBlack4;
  BlackPieces[4]:=PawnBlack5;  BlackPieces[5]:=PawnBlack6;     BlackPieces[6]:=PawnBlack7;     BlackPieces[7]:=PawnBlack8;
  BlackPieces[8]:=RookBlack1;  BlackPieces[9]:=KnightBlack1;   BlackPieces[10]:=BishopBlack1;  BlackPieces[11]:=QueenBlack;
  BlackPieces[12]:=KingBlack;  BlackPieces[13]:=BishopBlack2;  BlackPieces[14]:=KnightBlack2;  BlackPieces[15]:=RookBlack2;
  BlackPieces[16]:=EnPassant;
  //WhitePawns array
  WhitePawns[0]:=PawnWhite1;  WhitePawns[1]:=PawnWhite2;  WhitePawns[2]:=PawnWhite3;  WhitePawns[3]:=PawnWhite4;
  WhitePawns[4]:=PawnWhite5;  WhitePawns[5]:=PawnWhite6;  WhitePawns[6]:=PawnWhite7;  WhitePawns[7]:=PawnWhite8;
  //BlackPawns array
  BlackPawns[0]:=PawnBlack1;  BlackPawns[1]:=PawnBlack2;  BlackPawns[2]:=PawnBlack3;  BlackPawns[3]:=PawnBlack4;
  BlackPawns[4]:=PawnBlack5;  BlackPawns[5]:=PawnBlack6;  BlackPawns[6]:=PawnBlack7;  BlackPawns[7]:=PawnBlack8;
  //PieceCountersL arrays
  WhitePieceCountersL[Pawn]:=PawnWhiteCounterL;      BlackPieceCountersL[Pawn]:=PawnBlackCounterL;
  WhitePieceCountersL[Rook]:=RookWhiteCounterL;      BlackPieceCountersL[Rook]:=RookBlackCounterL;
  WhitePieceCountersL[Knight]:=KnightWhiteCounterL;  BlackPieceCountersL[Knight]:=KnightBlackCounterL;
  WhitePieceCountersL[Bishop]:=BishopWhiteCounterL;  BlackPieceCountersL[Bishop]:=BishopBlackCounterL;
  WhitePieceCountersL[Queen]:=QueenWhiteCounterL;    BlackPieceCountersL[Queen]:=QueenBlackCounterL;
  //create chessboard
  ChessboardClear(Sender);
  //settings
  SetGameSettings();
end;

procedure TGameF.SetGameSettings();
begin
  {WHITE PLAYER}
  GameF.Player1gName.Caption:=Player1Name;
  //pawn white
  case PawnWhiteType of
    'Classic': begin
      GameF.PawnWhite1.Picture.LoadFromFile('Images/Pieces/Pawn_White_CLASSIC.png');
      GameF.PawnWhite2.Picture.LoadFromFile('Images/Pieces/Pawn_White_CLASSIC.png');
      GameF.PawnWhite3.Picture.LoadFromFile('Images/Pieces/Pawn_White_CLASSIC.png');
      GameF.PawnWhite4.Picture.LoadFromFile('Images/Pieces/Pawn_White_CLASSIC.png');
      GameF.PawnWhite5.Picture.LoadFromFile('Images/Pieces/Pawn_White_CLASSIC.png');
      GameF.PawnWhite6.Picture.LoadFromFile('Images/Pieces/Pawn_White_CLASSIC.png');
      GameF.PawnWhite7.Picture.LoadFromFile('Images/Pieces/Pawn_White_CLASSIC.png');
      GameF.PawnWhite8.Picture.LoadFromFile('Images/Pieces/Pawn_White_CLASSIC.png');
    end;
    'Red': begin
      GameF.PawnWhite1.Picture.LoadFromFile('Images/Pieces/Pawn_White_RED.png');
      GameF.PawnWhite2.Picture.LoadFromFile('Images/Pieces/Pawn_White_RED.png');
      GameF.PawnWhite3.Picture.LoadFromFile('Images/Pieces/Pawn_White_RED.png');
      GameF.PawnWhite4.Picture.LoadFromFile('Images/Pieces/Pawn_White_RED.png');
      GameF.PawnWhite5.Picture.LoadFromFile('Images/Pieces/Pawn_White_RED.png');
      GameF.PawnWhite6.Picture.LoadFromFile('Images/Pieces/Pawn_White_RED.png');
      GameF.PawnWhite7.Picture.LoadFromFile('Images/Pieces/Pawn_White_RED.png');
      GameF.PawnWhite8.Picture.LoadFromFile('Images/Pieces/Pawn_White_RED.png');
    end;
    'Blue': begin
      GameF.PawnWhite1.Picture.LoadFromFile('Images/Pieces/Pawn_White_BLUE.png');
      GameF.PawnWhite2.Picture.LoadFromFile('Images/Pieces/Pawn_White_BLUE.png');
      GameF.PawnWhite3.Picture.LoadFromFile('Images/Pieces/Pawn_White_BLUE.png');
      GameF.PawnWhite4.Picture.LoadFromFile('Images/Pieces/Pawn_White_BLUE.png');
      GameF.PawnWhite5.Picture.LoadFromFile('Images/Pieces/Pawn_White_BLUE.png');
      GameF.PawnWhite6.Picture.LoadFromFile('Images/Pieces/Pawn_White_BLUE.png');
      GameF.PawnWhite7.Picture.LoadFromFile('Images/Pieces/Pawn_White_BLUE.png');
      GameF.PawnWhite8.Picture.LoadFromFile('Images/Pieces/Pawn_White_BLUE.png');
    end;
    'Yellow': begin
      GameF.PawnWhite1.Picture.LoadFromFile('Images/Pieces/Pawn_White_YELLOW.png');
      GameF.PawnWhite2.Picture.LoadFromFile('Images/Pieces/Pawn_White_YELLOW.png');
      GameF.PawnWhite3.Picture.LoadFromFile('Images/Pieces/Pawn_White_YELLOW.png');
      GameF.PawnWhite4.Picture.LoadFromFile('Images/Pieces/Pawn_White_YELLOW.png');
      GameF.PawnWhite5.Picture.LoadFromFile('Images/Pieces/Pawn_White_YELLOW.png');
      GameF.PawnWhite6.Picture.LoadFromFile('Images/Pieces/Pawn_White_YELLOW.png');
      GameF.PawnWhite7.Picture.LoadFromFile('Images/Pieces/Pawn_White_YELLOW.png');
      GameF.PawnWhite8.Picture.LoadFromFile('Images/Pieces/Pawn_White_YELLOW.png');
    end;
  end;
  //rook white
  case RookWhiteType of
    'Classic': begin
      GameF.RookWhite1.Picture.LoadFromFile('Images/Pieces/Rook_White_CLASSIC.png');
      GameF.RookWhite2.Picture.LoadFromFile('Images/Pieces/Rook_White_CLASSIC.png');
    end;
    'Red': begin
      GameF.RookWhite1.Picture.LoadFromFile('Images/Pieces/Rook_White_RED.png');
      GameF.RookWhite2.Picture.LoadFromFile('Images/Pieces/Rook_White_RED.png');
    end;
    'Blue': begin
      GameF.RookWhite1.Picture.LoadFromFile('Images/Pieces/Rook_White_BLUE.png');
      GameF.RookWhite2.Picture.LoadFromFile('Images/Pieces/Rook_White_BLUE.png');
    end;
    'Yellow': begin
      GameF.RookWhite1.Picture.LoadFromFile('Images/Pieces/Rook_White_YELLOW.png');
      GameF.RookWhite2.Picture.LoadFromFile('Images/Pieces/Rook_White_YELLOW.png');
    end;
  end;
  //knight white
  case KnightWhiteType of
    'Classic': begin
      GameF.KnightWhite1.Picture.LoadFromFile('Images/Pieces/Knight_White_CLASSIC.png');
      GameF.KnightWhite2.Picture.LoadFromFile('Images/Pieces/Knight_White_CLASSIC.png');
    end;
    'Red': begin
      GameF.KnightWhite1.Picture.LoadFromFile('Images/Pieces/Knight_White_RED.png');
      GameF.KnightWhite2.Picture.LoadFromFile('Images/Pieces/Knight_White_RED.png');
    end;
    'Blue': begin
      GameF.KnightWhite1.Picture.LoadFromFile('Images/Pieces/Knight_White_BLUE.png');
      GameF.KnightWhite2.Picture.LoadFromFile('Images/Pieces/Knight_White_BLUE.png');
    end;
    'Yellow': begin
      GameF.KnightWhite1.Picture.LoadFromFile('Images/Pieces/Knight_White_YELLOW.png');
      GameF.KnightWhite2.Picture.LoadFromFile('Images/Pieces/Knight_White_YELLOW.png');
    end;
  end;
  //bishop white
  case BishopWhiteType of
    'Classic': begin
      GameF.BishopWhite1.Picture.LoadFromFile('Images/Pieces/Bishop_White_CLASSIC.png');
      GameF.BishopWhite2.Picture.LoadFromFile('Images/Pieces/Bishop_White_CLASSIC.png');
    end;
    'Red': begin
      GameF.BishopWhite1.Picture.LoadFromFile('Images/Pieces/Bishop_White_RED.png');
      GameF.BishopWhite2.Picture.LoadFromFile('Images/Pieces/Bishop_White_RED.png');
    end;
    'Blue': begin
      GameF.BishopWhite1.Picture.LoadFromFile('Images/Pieces/Bishop_White_BLUE.png');
      GameF.BishopWhite2.Picture.LoadFromFile('Images/Pieces/Bishop_White_BLUE.png');
    end;
    'Yellow': begin
      GameF.BishopWhite1.Picture.LoadFromFile('Images/Pieces/Bishop_White_YELLOW.png');
      GameF.BishopWhite2.Picture.LoadFromFile('Images/Pieces/Bishop_White_YELLOW.png');
    end;
  end;
  //queen white
  case QueenWhiteType of
    'Classic': GameF.QueenWhite.Picture.LoadFromFile('Images/Pieces/Queen_White_CLASSIC.png');
    'Red': GameF.QueenWhite.Picture.LoadFromFile('Images/Pieces/Queen_White_RED.png');
    'Blue': GameF.QueenWhite.Picture.LoadFromFile('Images/Pieces/Queen_White_BLUE.png');
    'Yellow': GameF.QueenWhite.Picture.LoadFromFile('Images/Pieces/Queen_White_YELLOW.png');
  end;
  //king white
  case KingWhiteType of
    'Classic': GameF.KingWhite.Picture.LoadFromFile('Images/Pieces/King_White_CLASSIC.png');
    'Red': GameF.KingWhite.Picture.LoadFromFile('Images/Pieces/King_White_RED.png');
    'Blue': GameF.KingWhite.Picture.LoadFromFile('Images/Pieces/King_White_BLUE.png');
    'Yellow': GameF.KingWhite.Picture.LoadFromFile('Images/Pieces/King_White_YELLOW.png');
  end;
  {BLACK PLAYER}
  Player2gName.Caption:=Player2Name;
  //pawn black
  case PawnBlackType of
    'Classic': begin
      GameF.PawnBlack1.Picture.LoadFromFile('Images/Pieces/Pawn_Black_CLASSIC.png');
      GameF.PawnBlack2.Picture.LoadFromFile('Images/Pieces/Pawn_Black_CLASSIC.png');
      GameF.PawnBlack3.Picture.LoadFromFile('Images/Pieces/Pawn_Black_CLASSIC.png');
      GameF.PawnBlack4.Picture.LoadFromFile('Images/Pieces/Pawn_Black_CLASSIC.png');
      GameF.PawnBlack5.Picture.LoadFromFile('Images/Pieces/Pawn_Black_CLASSIC.png');
      GameF.PawnBlack6.Picture.LoadFromFile('Images/Pieces/Pawn_Black_CLASSIC.png');
      GameF.PawnBlack7.Picture.LoadFromFile('Images/Pieces/Pawn_Black_CLASSIC.png');
      GameF.PawnBlack8.Picture.LoadFromFile('Images/Pieces/Pawn_Black_CLASSIC.png');
    end;
    'Red': begin
      GameF.PawnBlack1.Picture.LoadFromFile('Images/Pieces/Pawn_Black_RED.png');
      GameF.PawnBlack2.Picture.LoadFromFile('Images/Pieces/Pawn_Black_RED.png');
      GameF.PawnBlack3.Picture.LoadFromFile('Images/Pieces/Pawn_Black_RED.png');
      GameF.PawnBlack4.Picture.LoadFromFile('Images/Pieces/Pawn_Black_RED.png');
      GameF.PawnBlack5.Picture.LoadFromFile('Images/Pieces/Pawn_Black_RED.png');
      GameF.PawnBlack6.Picture.LoadFromFile('Images/Pieces/Pawn_Black_RED.png');
      GameF.PawnBlack7.Picture.LoadFromFile('Images/Pieces/Pawn_Black_RED.png');
      GameF.PawnBlack8.Picture.LoadFromFile('Images/Pieces/Pawn_Black_RED.png');
    end;
    'Blue': begin
      GameF.PawnBlack1.Picture.LoadFromFile('Images/Pieces/Pawn_Black_BLUE.png');
      GameF.PawnBlack2.Picture.LoadFromFile('Images/Pieces/Pawn_Black_BLUE.png');
      GameF.PawnBlack3.Picture.LoadFromFile('Images/Pieces/Pawn_Black_BLUE.png');
      GameF.PawnBlack4.Picture.LoadFromFile('Images/Pieces/Pawn_Black_BLUE.png');
      GameF.PawnBlack5.Picture.LoadFromFile('Images/Pieces/Pawn_Black_BLUE.png');
      GameF.PawnBlack6.Picture.LoadFromFile('Images/Pieces/Pawn_Black_BLUE.png');
      GameF.PawnBlack7.Picture.LoadFromFile('Images/Pieces/Pawn_Black_BLUE.png');
      GameF.PawnBlack8.Picture.LoadFromFile('Images/Pieces/Pawn_Black_BLUE.png');
    end;
    'Yellow': begin
      GameF.PawnBlack1.Picture.LoadFromFile('Images/Pieces/Pawn_Black_YELLOW.png');
      GameF.PawnBlack2.Picture.LoadFromFile('Images/Pieces/Pawn_Black_YELLOW.png');
      GameF.PawnBlack3.Picture.LoadFromFile('Images/Pieces/Pawn_Black_YELLOW.png');
      GameF.PawnBlack4.Picture.LoadFromFile('Images/Pieces/Pawn_Black_YELLOW.png');
      GameF.PawnBlack5.Picture.LoadFromFile('Images/Pieces/Pawn_Black_YELLOW.png');
      GameF.PawnBlack6.Picture.LoadFromFile('Images/Pieces/Pawn_Black_YELLOW.png');
      GameF.PawnBlack7.Picture.LoadFromFile('Images/Pieces/Pawn_Black_YELLOW.png');
      GameF.PawnBlack8.Picture.LoadFromFile('Images/Pieces/Pawn_Black_YELLOW.png');
    end;
  end;
  //rook black
  case RookBlackType of
    'Classic': begin
      GameF.RookBlack1.Picture.LoadFromFile('Images/Pieces/Rook_Black_CLASSIC.png');
      GameF.RookBlack2.Picture.LoadFromFile('Images/Pieces/Rook_Black_CLASSIC.png');
    end;
    'Red': begin
      GameF.RookBlack1.Picture.LoadFromFile('Images/Pieces/Rook_Black_RED.png');
      GameF.RookBlack2.Picture.LoadFromFile('Images/Pieces/Rook_Black_RED.png');
    end;
    'Blue': begin
      GameF.RookBlack1.Picture.LoadFromFile('Images/Pieces/Rook_Black_BLUE.png');
      GameF.RookBlack2.Picture.LoadFromFile('Images/Pieces/Rook_Black_BLUE.png');
    end;
    'Yellow': begin
      GameF.RookBlack1.Picture.LoadFromFile('Images/Pieces/Rook_Black_YELLOW.png');
      GameF.RookBlack2.Picture.LoadFromFile('Images/Pieces/Rook_Black_YELLOW.png');
    end;
  end;
  //knight black
  case KnightBlackType of
    'Classic': begin
      GameF.KnightBlack1.Picture.LoadFromFile('Images/Pieces/Knight_Black_CLASSIC.png');
      GameF.KnightBlack2.Picture.LoadFromFile('Images/Pieces/Knight_Black_CLASSIC.png');
    end;
    'Red': begin
      GameF.KnightBlack1.Picture.LoadFromFile('Images/Pieces/Knight_Black_RED.png');
      GameF.KnightBlack2.Picture.LoadFromFile('Images/Pieces/Knight_Black_RED.png');
    end;
    'Blue': begin
      GameF.KnightBlack1.Picture.LoadFromFile('Images/Pieces/Knight_Black_BLUE.png');
      GameF.KnightBlack2.Picture.LoadFromFile('Images/Pieces/Knight_Black_BLUE.png');
    end;
    'Yellow': begin
      GameF.KnightBlack1.Picture.LoadFromFile('Images/Pieces/Knight_Black_YELLOW.png');
      GameF.KnightBlack2.Picture.LoadFromFile('Images/Pieces/Knight_Black_YELLOW.png');
    end;
  end;
  //bishop black
  case BishopBlackType of
    'Classic': begin
      GameF.BishopBlack1.Picture.LoadFromFile('Images/Pieces/Bishop_Black_CLASSIC.png');
      GameF.BishopBlack2.Picture.LoadFromFile('Images/Pieces/Bishop_Black_CLASSIC.png');
    end;
    'Red': begin
      GameF.BishopBlack1.Picture.LoadFromFile('Images/Pieces/Bishop_Black_RED.png');
      GameF.BishopBlack2.Picture.LoadFromFile('Images/Pieces/Bishop_Black_RED.png');
    end;
    'Blue': begin
      GameF.BishopBlack1.Picture.LoadFromFile('Images/Pieces/Bishop_Black_BLUE.png');
      GameF.BishopBlack2.Picture.LoadFromFile('Images/Pieces/Bishop_Black_BLUE.png');
    end;
    'Yellow': begin
      GameF.BishopBlack1.Picture.LoadFromFile('Images/Pieces/Bishop_Black_YELLOW.png');
      GameF.BishopBlack2.Picture.LoadFromFile('Images/Pieces/Bishop_Black_YELLOW.png');
    end;
  end;
  //queen black
  case QueenBlackType of
    'Classic': GameF.QueenBlack.Picture.LoadFromFile('Images/Pieces/Queen_Black_CLASSIC.png');
    'Red': GameF.QueenBlack.Picture.LoadFromFile('Images/Pieces/Queen_Black_RED.png');
    'Blue': GameF.QueenBlack.Picture.LoadFromFile('Images/Pieces/Queen_Black_BLUE.png');
    'Yellow': GameF.QueenBlack.Picture.LoadFromFile('Images/Pieces/Queen_Black_YELLOW.png');
  end;
  //king black
  case KingBlackType of
    'Classic': GameF.KingBlack.Picture.LoadFromFile('Images/Pieces/King_Black_CLASSIC.png');
    'Red': GameF.KingBlack.Picture.LoadFromFile('Images/Pieces/King_Black_RED.png');
    'Blue': GameF.KingBlack.Picture.LoadFromFile('Images/Pieces/King_Black_BLUE.png');
    'Yellow': GameF.KingBlack.Picture.LoadFromFile('Images/Pieces/King_Black_YELLOW.png');
  end;
end;

//BUTTON CLICKS

procedure TGameF.StartClick();
begin
  HelpF.Hide;
  //change button visibility
  SurrenderWhite.Visible:=True;
  Start.Visible:=False;
  MainMenuB.Visible:=False;
  CollectionB.Visible:=False;
  //player turn message
  MessageA.Font.Color:=clWhite;
  MessageA.Caption:=Player1gName.Caption;
  MessageB.Font.Color:=clYellow;
  MessageB.Caption:='’s Turn';
  MessageA.Visible:=True;
  MessageB.Visible:=True;
  Turn:='White';
end;

procedure TGameF.RestartClick(Sender: TObject);
var
  i: byte;
begin
  HelpF.Hide;
  //reset piece movement
  for i:=0 to 31 do AllPieces[i].PieceHasMoved:=false;
  //reset white pawn promotions
  for i:=0 to 7 do begin
    WhitePawns[i].PieceType:='Pawn';
    WhitePawns[i].Picture:=PawnWhiteCounter.Picture;
  end;
  //reset black pawn promotions
  for i:=0 to 7 do begin
    BlackPawns[i].PieceType:='Pawn';
    BlackPawns[i].Picture:=PawnBlackCounter.Picture;
  end;
  //reset queens
  QueenWhite.PieceType:='Queen';
  QueenWhite.Picture:=QueenWhiteCounter.Picture;
  QueenBlack.PieceType:='Queen';
  QueenBlack.Picture:=QueenBlackCounter.Picture;
  //reset pieces placcement
  for i:=0 to 31 do begin
    case i of
      0..7: begin
        AllPieces[i].AnchorSide[akLeft].Control:=gBoard[i*8];
        AllPieces[i].AnchorSide[akTop].Control:=gBoard[i*8];
      end;
      8..15: begin
        AllPieces[i].AnchorSide[akLeft].Control:=gBoard[1+(i-8)*8];
        AllPieces[i].AnchorSide[akTop].Control:=gBoard[1+(i-8)*8];
      end;
      16..23: begin
        AllPieces[i].AnchorSide[akLeft].Control:=gBoard[6+(i-16)*8];
        AllPieces[i].AnchorSide[akTop].Control:=gBoard[6+(i-16)*8];
      end;
      24..31: begin
        AllPieces[i].AnchorSide[akLeft].Control:=gBoard[7+(i-24)*8];
        AllPieces[i].AnchorSide[akTop].Control:=gBoard[7+(i-24)*8];
      end;
    end;
  end;
  EnPassant.Left:=0;
  EnPassant.Top:=0;
  //reset score counters
  Player1ScoreInteger:=0;                 Player2ScoreInteger:=0;
  Player1ScorePanel.Caption:='0 Points';  Player2ScorePanel.Caption:='0 Points';
  //reset piece counters
  PawnWhiteCounterL.caption:='8';    PawnBlackCounterL.caption:='8';
  RookWhiteCounterL.caption:='2';    RookBlackCounterL.caption:='2';
  KnightWhiteCounterL.caption:='2';  KnightBlackCounterL.caption:='2';
  BishopWhiteCounterL.caption:='2';  BishopBlackCounterL.caption:='2';
  QueenWhiteCounterL.caption:='1';   QueenBlackCounterL.caption:='1';
  //reset game objects
  Restart.Visible:=False;
  MessageA.Visible:=False;
  MessageB.Visible:=False;
  Start.Visible:=True;
  MainMenuB.Visible:=True;
  CollectionB.Visible:=True;
  //clear chessboard
  ChessboardClear(Sender);
end;

procedure TGameF.SurrenderClick(Sender: TObject);
var
  i: byte;
begin
  HelpF.Hide;
  if Sender=SurrenderWhite then begin
    SurrenderWhite.Visible:=False;
    MessageA.Font.Color:=clSilver;
    MessageA.Caption:=Player2gName.Caption;
  end
  else begin
    SurrenderBlack.Visible:=False;
    MessageA.Font.Color:=clWhite;
    MessageA.Caption:=Player1gName.Caption;
  end;
  ChessboardClear(Sender);
  PromotionsHide();
  Victory();
  for i:=0 to 4 do PreviousMovement[i].Visible:=False;
end;

procedure TGameF.MainMenuBClick();
begin
  HelpF.Hide;
  MainMenuF.Show;
end;

procedure TGameF.CollectionBClick();
begin
  HelpF.Hide;
  CollectionF.Show;
end;

//PROMOTIONS

procedure TGameF.PromotionsClick(Sender: TImage);
begin
  case gSelectedPiece.PieceOwner of
    'White': BlackTurn();
    'Black': WhiteTurn();
  end;
  case Sender.Name of
    'RookPromotion': begin
      gSelectedPiece.Picture:=RookPromotion.Picture;
      gSelectedPiece.PieceType:='Rook';
    end;
    'KnightPromotion': begin
      gSelectedPiece.Picture:=KnightPromotion.Picture;
      gSelectedPiece.PieceType:='Knight';
    end;
    'BishopPromotion': begin
      gSelectedPiece.Picture:=BishopPromotion.Picture;
      gSelectedPiece.PieceType:='Bishop';
    end;
    'QueenPromotion': begin
      gSelectedPiece.Picture:=QueenPromotion.Picture;
      gSelectedPiece.PieceType:='Queen';
    end;
  end;
  MessageB.Caption:='’s Turn';
  ChessBoardClear(Sender);
  PromotionsHide();
end;

procedure TGameF.PromotionsMouseEnter(Sender: TImage);
begin
  Sender.Parent.Color:=$00004080;
end;

procedure TGameF.PromotionsMouseLeave(Sender: TImage);
begin
  Sender.Parent.Color:=$0071B8FF;
end;

procedure TGameF.PromotionsShow();
var
  i: byte;
begin
  for i:=0 to 4 do PreviousMovement[i].Visible:=False;
  case Turn of
    'White': begin
      RookPromotion.Picture:=RookWhiteCounter.Picture;
      KnightPromotion.Picture:=KnightWhiteCounter.Picture;
      BishopPromotion.Picture:=BishopWhiteCounter.Picture;
      QueenPromotion.Picture:=QueenWhiteCounter.Picture;
    end;
    'Black': begin
      RookPromotion.Picture:=RookBlackCounter.Picture;
      KnightPromotion.Picture:=KnightBlackCounter.Picture;
      BishopPromotion.Picture:=BishopBlackCounter.Picture;
      QueenPromotion.Picture:=QueenBlackCounter.Picture;
    end;
  end;
  GameF.ChessBoard.canvas.pen.width:=6;
  GameF.ChessBoard.canvas.pen.color:=clYellow;
  GameF.ChessBoard.Canvas.Line(gSelectedPiece.Left-GameF.ChessBoard.Left, gSelectedPiece.Top-GameF.ChessBoard.Top, gSelectedPiece.Left-GameF.ChessBoard.Left+75, gSelectedPiece.Top-GameF.ChessBoard.Top);
  GameF.ChessBoard.Canvas.Line(gSelectedPiece.Left-GameF.ChessBoard.Left, gSelectedPiece.Top-GameF.ChessBoard.Top, gSelectedPiece.Left-GameF.ChessBoard.Left, gSelectedPiece.Top-GameF.ChessBoard.Top+75);
  GameF.ChessBoard.Canvas.Line(gSelectedPiece.Left-GameF.ChessBoard.Left+75, gSelectedPiece.Top-GameF.ChessBoard.Top+75, gSelectedPiece.Left-GameF.ChessBoard.Left+75, gSelectedPiece.Top-GameF.ChessBoard.Top);
  GameF.ChessBoard.Canvas.Line(gSelectedPiece.Left-GameF.ChessBoard.Left+75, gSelectedPiece.Top-GameF.ChessBoard.Top+75, gSelectedPiece.Left-GameF.ChessBoard.Left, gSelectedPiece.Top-GameF.ChessBoard.Top+75);
  Turn:='Promotion';
  MessageB.Caption:='’s Promotion';
  KnightPromotionPanel.Visible:=True;
  RookPromotionPanel.Visible:=True;
  BishopPromotionPanel.Visible:=True;
  QueenPromotionPanel.Visible:=True;
end;

procedure TGameF.PromotionsHide();
var
  i: byte;
begin
  for i:=0 to 4 do PreviousMovement[i].Visible:=True;
  QueenPromotionPanel.Visible:=False;
  BishopPromotionPanel.Visible:=False;
  RookPromotionPanel.Visible:=False;
  KnightPromotionPanel.Visible:=False;
end;

//REPETITIVE PROCEDURES

procedure TGameF.ChessboardClear(Sender: TObject);
var
  i, y: integer;
begin
  //clear movement icons
  if Sender<>GameF then
  for i:=0 to 63 do begin
    gBoard[i].Picture:=nil;
    gBoard[i].Enabled:=False;
    gBoard[i].PositionMovement:='';
  end;
  //create chessboard
  ChessBoard.canvas.pen.width:=1;
  ChessBoard.canvas.pen.color:=clBlack;
  for y:=1 to 8 do begin
    for i:=1 to 8 do begin
      if y mod 2=0 then begin
        ChessBoard.canvas.brush.color:=clwhite;
        if not i mod 2=0 then ChessBoard.canvas.brush.color:=clBlack;
      end
      else if i mod 2=0 then ChessBoard.canvas.brush.color:=clBlack
      else ChessBoard.canvas.brush.color:=clwhite;
      ChessBoard.canvas.rectangle(0+(i-1)*75,0+(y-1)*75,75+(i-1)*75,75+(y-1)*75);
    end;
  end;
end;

procedure TGameF.WhiteTurn();
begin
  Turn:='White';
  GameF.MessageA.Font.Color:=clWhite;
  GameF.MessageA.Caption:=GameF.Player1gName.Caption;
  GameF.SurrenderWhite.Visible:=True;
  GameF.SurrenderBlack.Visible:=False;
end;

procedure TGameF.BlackTurn();
begin
  Turn:='Black';
  GameF.MessageA.Font.Color:=clSilver;
  GameF.MessageA.Caption:=GameF.Player2gName.Caption;
  GameF.SurrenderWhite.Visible:=False;
  GameF.SurrenderBlack.Visible:=True;
end;

procedure TGameF.Victory();
begin
  Turn:='';
  MessageB.Font.Color:=clLime;
  MessageB.Caption:=' WINS!!!';
  MessageA.Visible:=True;
  MessageB.Visible:=True;
  Restart.Visible:=True;
end;

//UNIT LINKS

procedure TGameF.PositionsClick(Sender: TChessPosition);
begin
  Game_Positions.PositionClick(Sender);
end;

procedure TGameF.PiecesClick(Sender: TChessPiece);
begin
  Game_Pieces.PieceClick(Sender);
end;

procedure TGameF.HelpsClick(Sender: TImage);
begin
  HelpF.HelpClick(Sender);
end;

end.
