unit Main;

{$IF Defined(Win32) or Defined(Win64)}
  {$DEFINE Windows}
{$ENDIF}

interface

{$DEFINE EnableBlueTooth}  // {$DEFINE EnableWifi}
{$DEFINE EnablePCSerial}
{$DEFINE EnableMediaPlay}
{$DEFINE EnableMultiThread}
{$DEFINE EnableFileIO}
{$DEFINE EnableInputBox}
{$DEFINE EnableLanguageSwitch}
{$DEFINE FixToolbarAlignLeadingSpace}


//{$DEFINE UseStringCommand}
//{$DEFINE EnableCheckSum}




{$IF defined(Android)}
  {$IF defined(EnableBlueTooth)}
  // BlueTooth --------------------------------------
  {$ELSEIF defined(EnableWifi)}
  // Wifi --------------------------------------------
  {$ENDIF}
{$ELSEIF defined(Windows) }
  // USB Comport ---------------------------------------
{$ENDIF}

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.IoUtils,

  Math,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Edit, FMX.ScrollBox, FMX.Memo,
  FMX.ListBox, System.ImageList, FMX.ImgList,
  FMX.Colors,

  {$IFDEF EnableMultiThread}
  System.Threading,
  {$ENDIF}
  {$IFDEF EnableMediaPlay}
  FMX.Media,
  {$ENDIF}

{$IF defined(Android)}
  {$IF defined(EnableBlueTooth)}
  AndroidBlueToothManage,
  {$ELSEIF defined(EnableWifi)}
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient,
  {$ENDIF}
{$ELSEIF defined(Windows) }
  {$IF defined(EnablePCSerial)}
  WinComportManage,
  {$ENDIF}
{$ENDIF}
  {$IFDEF EnableLanguageSwitch}
  MscLanguageTranslate,
  {$ENDIF}



  // /WebLib ----------------------------------------------
  OpenViewUrl,

  // RastLib -----------------------------------------------
  RastTypeDefine, RastManage,RastPaint, RastCanvasPaint,

  // M2dLib -------------------------------------------
  M2dTypeDefine, M2dGVariable, M2dQuery,

  // CrsLib ---------------------------------------------
  CrsFileTypeDefine, CrsFileManage,

  // UtyLib -----------------------------------------------
  UtyTypeDefine,


  MscMessageDefine, StringManage, MscUtility, MscUiManage

  ;



{$IFDEF Windows}
  //AnsiString
{$ELSE}
type
  AnsiString = String;
{$ENDIF}


{$IFDEF UseStringCommand}
{$ELSE}
const
  cSongBegin=101;
  cSongTones=102;
  cSongEnd=103;
  cCommandTones=5;
  cCommandLength=cCommandTones*2+4;

var
  //¨C­Ó«ü¥O¤º¦³ cSongxxx, toneNum,  5 notes, 5 beats, ¡@¤@­Óµ²§À¡@0 -------------------------------
  bCommand:Array[0..cCommandLength-1] of byte =
    ( cSongTones, cCommandTones, tnDo4,cB1, tnRe4,cB1, tnMi4, cB1, tnFa4, cB1, tnSo4, cB1, 0,0  );
{$ENDIF}

type
  PMusicTone = ^TMusicTone;
  TMusicTone = record
    mtNote:TToneNote;
    mtBeat:TToneBeat;
  end;
  TMusicToneList = TList; // list of pMusicTone;

const
  cPanelKeyNum=12;
  cPanelNum=4;
type
  TKeyButtons = Array[0..cPanelKeyNum*cPanelNum-1] of TColorButton;
  TPanelWhiteButtons = Array[0..6] of TColorButton;
  TPanelBlackButtons = Array[0..4] of TColorButton;
  TPianoWhiteButtons = Array[0..3] of TPanelWhiteButtons;
  TPianoBlackButtons = Array[0..3] of TPanelBlackButtons;
  TDoLabels = Array[0..3] of TLabel;

type
  TMainForm = class(TForm)
    StyleBook1: TStyleBook;
    tcMain: TTabControl;
    tiConnectiion: TTabItem;
    loConnect: TLayout;
    tlbarConnect: TToolBar;
    sbDiscover: TSpeedButton;
    sbConnect: TSpeedButton;
    lbxDevices: TListBox;
    loLog: TLayout;
    mmLog: TMemo;
    tlbarLog: TToolBar;
    sbClearAll: TSpeedButton;
    edCommand: TEdit;
    sbSendCommand: TSpeedButton;
    ckbxReceiveLog: TCheckBox;
    TimerReceive: TTimer;
    spltDevices: TSplitter;
    tiProgram: TTabItem;
    TimerTone: TTimer;
    loPianos: TLayout;
    loPiano12: TLayout;
    loPiano2: TLayout;
    btnSo3: TColorButton;
    btnRe3: TColorButton;
    btnDo3: TColorButton;
    btnDo3s: TColorButton;
    btnMi3: TColorButton;
    btnFa3: TColorButton;
    btnRe3s: TColorButton;
    btnFa3s: TColorButton;
    btnLa3: TColorButton;
    btnSi3: TColorButton;
    btnSo3S: TColorButton;
    btnLa3S: TColorButton;
    lblDo3: TLabel;
    loPiano1: TLayout;
    btnSo2: TColorButton;
    btnRe2: TColorButton;
    btnDo2: TColorButton;
    btnDo2S: TColorButton;
    btnMi2: TColorButton;
    btnFa2: TColorButton;
    btnRe2S: TColorButton;
    btnFa2S: TColorButton;
    btnLa2: TColorButton;
    btnSi2: TColorButton;
    btnSo2S: TColorButton;
    btnLa2S: TColorButton;
    lblDo2: TLabel;
    loPiano34: TLayout;
    loPiano4: TLayout;
    btnSo5: TColorButton;
    btnRe5: TColorButton;
    btnDo5: TColorButton;
    btnDo5s: TColorButton;
    btnMi5: TColorButton;
    btnFa5: TColorButton;
    btnRe5s: TColorButton;
    btnFa5s: TColorButton;
    btnLa5: TColorButton;
    btnSi5: TColorButton;
    btnSo5s: TColorButton;
    btnLa5s: TColorButton;
    lblDo5: TLabel;
    loPiano3: TLayout;
    btnSo4: TColorButton;
    btnRe4: TColorButton;
    btnDo4: TColorButton;
    btnDo4S: TColorButton;
    btnMi4: TColorButton;
    btnFa4: TColorButton;
    btnRe4S: TColorButton;
    btnFa4S: TColorButton;
    btnLa4: TColorButton;
    btnSi4: TColorButton;
    btnSo4s: TColorButton;
    btnLa4S: TColorButton;
    lblDo4: TLabel;
    ImageList1: TImageList;
    prsbarPlay: TProgressBar;
    mmDebug: TMemo;
    spltDbg: TSplitter;
    tlbarPiano: TToolBar;
    sbRecord: TSpeedButton;
    sbPlayMusic: TSpeedButton;
    sbClear: TSpeedButton;
    sbLoadMtf: TSpeedButton;
    sbSaveMtf: TSpeedButton;
    sbSend: TSpeedButton;
    sbLanguage: TSpeedButton;
    loTlbarRight: TLayout;
    rbSlow: TRadioButton;
    rbNormal: TRadioButton;
    rbFast: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbClearAllClick(Sender: TObject);
    procedure sbDiscoverClick(Sender: TObject);
    procedure sbConnectClick(Sender: TObject);
    procedure sbSendCommandClick(Sender: TObject);
    procedure ckbxReceiveLogChange(Sender: TObject);
    procedure TimerReceiveTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BlackKeyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure BlackKeyMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure WhiteKeyMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure WhiteKeyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure WhiteKeyMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure WhiteKeyMouseLeave(Sender: TObject);
    procedure WhiteKeyMouseEnter(Sender: TObject);
    procedure BlackKeyMouseEnter(Sender: TObject);
    procedure BlackKeyMouseLeave(Sender: TObject);
    procedure BlackKeyMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure TimerToneTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure sbRecordClick(Sender: TObject);
    procedure sbPlayMusicClick(Sender: TObject);
    procedure sbClearClick(Sender: TObject);
    procedure sbSendClick(Sender: TObject);
    procedure rbSlowChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure sbLoadMtfClick(Sender: TObject);
    procedure sbSaveMtfClick(Sender: TObject);
    procedure sbLanguageClick(Sender: TObject);
  private
    { Private declarations }
    {$IFDEF EnableMultiThread}
    FOnRunThread:boolean;
    {$ENDIF}
    {$IFDEF EnableMediaPlay}
    FMediaStartTime, FMediaEndTime:TMediaTime;
    FMediaPlayer:TMediaPlayer;
    {$ENDIF}
    {$IFDEF EnableFileIO}
    FLastImportFile:String;
    FSongName:String;
    {$ENDIF}
    FActTempo:byte;
    FLastPlayTime:Cardinal;
    FDoRecording:boolean;
    FMusicTones : TMusicToneList;
    FNoteFilePath:String;
    FNoteFileName:String;
    FActKeyIndex, FPriKeyIndex:integer;
    FWhiteButtons : TPianoWhiteButtons;
    FPriButtonColor:TAlphaColor;
    FKeyButtons : TKeyButtons;
    FBlackButtons : TPianoBlackButtons;
    FDoLabels:TDoLabels;
    FDoReplayMusic: boolean;
    procedure SetDoRecording(const Value: boolean);


  protected

  {$IFDEF EnableFileIO}
    // ÀÉ®×¦s¨ú --------------------------------------------------------------
    function Base_Load_TMusicToneFile(const afn:String; const aMusictones:TMusicToneList; 
      blDoClear:boolean=true):LongBool;
    function Base_Save_TMusicToneFile(afn:String; const aMusictones:TMusicToneList):LongBool;
    procedure Param_Load_TMusicToneFile(Sender: TObject; const aFns: string);
    procedure Param_Save_TMusicToneFile(Sender: TObject; const aFn: string);
  {$ENDIF}
  {$IFDEF EnableInputBox}
    procedure OnInputQuery_SongName(const AResult: TModalResult;
      const AValues: array of string);
  {$ENDIF}
    {$IFDEF EnableLanguageSwitch}
    procedure OnLanguageSwitch(sender:TObject; const LanguageFn:String);
    procedure OnWriteDefaultEnglishLanguageFile(sender:TObject; const LanguageFn:String);
    {$ENDIF}


    procedure CreateMembers;
    procedure InitialMembers_BeforeCreate;
    procedure InitialMembers_AfterCreate;
    procedure ReleaseMembers;

    procedure Load_IniFile;
    procedure Save_IniFile;

    // ¸ê®Æ³B²z ----------------------------------------------------
    procedure Clear_TMusicToneList(const aMusicToneLst:TMusicToneList);
    procedure Add_TMusicTone(const aMusicToneLst:TMusicToneList; aNote:TToneNote; aBeat:TToneBeat);
    procedure Play_MusicTone(aNote:TToneNote; aBeat:TToneBeat);
    procedure Play_TMusicTones(const aMusicToneLst:TMusicToneList);
    procedure Play_TMusicTones_Thread();

    function Get_TToneBeat(aDurationMSec:integer):TToneBeat;
    function Get_CheckSum(const sCmd:String):integer;

    procedure ByteArrayToString(byteAry:Array of byte; len:integer; var str:String);
    procedure StringToByteArray(const str:String; arrayLen:integer; var byteAry:Array of byte);


    // Resources-----------------------------------------------------
    function Resource_To_MP3File( const resName:String; const sDir:String; var fnMp3:String):LongBool;

    function Find_DefaultDevice(subStr:String; var aId:integer):LongBool;
    function DoDiscover_Devices(var numDevices:integer):LongBool;
    function DoConnect_Device(deviceID:integer):LongBool;
    function DoSend_Command(sCmd:String):LongBool;

    // Interface -----------------------------------------------------------
    procedure Initial_PianoButtons;
    procedure Initial_ButtonSize(var whiteBtnW, whiteBtnH:Single);
    procedure Initial_TPanelWhiteButtons(var pnlButtons:TPanelWhiteButtons; btnW:Single=60; btnH:Single=150);
    procedure Initial_TPanelBlackButtons(var pnlButtons:TPanelBlackButtons; whiteBtnW:Single; btnW:Single=40; btnH:Single=80);
    procedure Initial_WhiteButtons(btnW:Single=60; btnH:Single=150);
    procedure Initial_BlackButtons(whiteBtnW:Single; btnW:Single=40; btnH:Single=80);

    procedure Initial_Classes;
    procedure Initial_Interface;
    procedure Refresh_Interface_Resize;

    // MultiThread ---------------------------------------------------------
    procedure Thread_XXX(startId: integer);

    procedure PlayNote(keyId, aDurationMsec:integer);
    procedure Thread_PlayNote(noteId, aDurationMsec: integer);

    procedure Process_KeyChar(var keyChar:Char; Shift:TShiftState);



    // Event ------------------------------------------------------------
    procedure ProcessReceivedString(Sender:TObject; const aStr:AnsiString);
    procedure Clear_MusicTones(Sender:TObject);

  public
    { Public declarations }
    property DoRecording:boolean read FDoRecording write SetDoRecording;

  {$IFDEF EnableFileIO}
    procedure Dialog_Load_TMusicToneFileClick(Sender:TObject);
    procedure Dialog_Save_TMusicToneFileClick(Sender:TObject);
  {$ENDIF}

    procedure Stop_Play;
    procedure Play_Sound(keyId:integer; aDurationMsec:integer);

  end;

const
  cBlackDivWhiteButtonWidth = 3.5/5.0;
  cBlackDivWhiteButtonHeight = 0.5;
  cMinButtonWidth=50.0;
  cMinButtonHeight=100.0;
  cButtonWidthDivHeight=0.4;

  cHeadDelayMsec = 100;
  cToneNoteDurationMsec = 1000;
  cStartToneNote = tnDo2;
  cNoteResName = '48_Notes';
  //cMiliSecond = {$IF Defined(Windows)}10000{$ELSE} 1{$ENDIF};  // Android ºë«×¸û¤p
  //cHalfSecond = 500*cMiliSecond;
  //cQuadSecond = 250*cMIliSecond;
  //cSecond = 1000*cMiliSecond;

  cInvalidPoint:TPoint=(X:-9999; Y:-9999);

var
  gDnMouseXY:TPoint;


var
  MainForm: TMainForm;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.Windows.fmx MSWINDOWS}


uses
  FMXMessageDlg, FmxListBox;



const
  cStartToneID = 11;



{$IFDEF EnableLanguageSwitch}
procedure TMainForm.OnLanguageSwitch(sender: TObject; const LanguageFn: String);
begin
  MscMessageDefine.MscMessageLanguageSwitch(LanguageFn);
  //VectTypeDefine.VectTypedefineLanguageSwitch(LanguageFn);
  //RastTypeDefine.RastTypedefineLanguageSwitch(LanguageFn);
  //VectNcToolManage.NcToolTypedefineLanguageSwitch(LanguageFn);
end;

procedure TMainForm.OnWriteDefaultEnglishLanguageFile(sender: TObject; const LanguageFn: String);
begin
  MscMessageDefine.MscMessageLanguageWriteDefaultLanguageString(LanguageFn);
  //VectTypeDefine.VectTypeDefineWriteDefaultLanguageString(LanguageFn);
  //RastTypeDefine.RastTypeDefineWriteDefaultLanguageString(LanguageFn);
  //VectNcToolManage.NcToolTypeDefineWriteDefaultLanguageString(LanguageFn);
end;
{$ENDIF}


{$IFDEF EnableFileIO}
function TMainForm.Base_Load_TMusicToneFile(const afn: String;
  const aMusictones: TMusicToneList; blDoClear:boolean): LongBool;
var
  pf:TextFile;
  oCursor:TCursor;
  readBytes,fileBytes, aPercent:integer;
  t0:Cardinal;
  lnStr,sbuffer:string;
  gLineNum : Cardinal;       
  pMt:PMusicTone;

  procedure subAdd_TMusicTone(note, beat:byte);
  begin
    note := Math.Max(tnRest, Math.Min(note, tReS8));
    beat := Math.Max(cb_8, Math.Min(beat, cB4));

    new(pMt); FillChar(pMt^, SizeOf(pMt^), 0);
    pMt^.mtNote := note;
    pMt^.mtBeat := beat;
    aMusicTones.Add(pMt);
  end;

  procedure subProcessLineString(const lnS:string);
  var
    incNum0,incNum1,i:integer;
    s0,s1,s2:String;
    s2560,s2561:T256Strings;
  begin
    s0 := lnS;
    StringManager.TrimLeadTailBlank(s0);
    if (''=s0) then exit;      
    if Pos('//', s0)=1 then exit;

    if Pos('MT,',s0)=1 then
    begin
      StringManager.GetT256Strings(s0, ',', incNum0, s2560);
      if (incNum0>1) then
      begin
        for i := 1 to incNum0-1 do
        begin
          StringManager.GetT256Strings(s2560[i], ':', incNum1, s2561);
          if (incNum1>=2) then
          begin
            subAdd_TMusicTone( StrToInt(s2561[0]), StrToInt(s2561[1]) );
          end;
        end;
      end;
    end;
    
  end;

begin
  result:=false;
  if (nil=aMusictones) then exit;

  if blDoClear then
    Self.Clear_TMusicToneList(aMusicTones);
    
  if not CrsFileManager.CrsFileExists(afn) then exit;


  try
    oCursor:=Screen.Cursor;
    Screen.Cursor := crHourGlass;

    AssignFile(pF, {$IFDEF FPC}UTF8ToAnsi{$ENDIF}(afn) );
    Reset(pF); //, tfCRLF); // Text file flags : tfCRLF   = $1;    // Dos compatibility flag, for CR+LF line breaks and EOF checks

    // ªì©l¤Æ Local ÅÜ¼Æ -----------------------------------------
    fileBytes := round(crsFileManager.FileSizeMegaByte(afn)*cMem_1MB); // FileSize(pF);

    readBytes:=0;
    glineNum:=0;
    t0:=GetTickCount;
    lnStr := '';
    sBuffer:='';

    
    while (not EOF(pF)) do
    begin
      Readln(pF, lnStr);
      inc(readBytes, Length(lnStr));
      inc(glineNUm);

      {if Assigned(FOnRunningProgress) then
      begin
        if (glineNum mod cTextFileLineModNum)=0 then
        begin
          aPercent:= round(readBytes/fileBytes*100)+1;
          FOnRunningProgress( format('%s %s...',[gVerbTypeName[vbOpen], 'VHF' ]) , aPercent );
        end;
      end;    }

      //FStringConvertProc(lnStr);

      try
        subProcessLineString(lnStr);
      except
        ShowMessage(lnStr);
      end;
    end;


    result:=(aMusicTones.Count>0);

  finally

    //if Assigned(FOnRunningProgress) then FOnRunningProgress( '', 0);
    Screen.Cursor := oCursor;

    CloseFile(pF);
  end;

end;

function TMainForm.Base_Save_TMusicToneFile(afn: String;
  const aMusictones: TMusicToneList): LongBool;
const
  cDecimalNum=5;
  cToneNumPerLine = 10;
var
  oCursor:TCursor;
  pF:TextFile;
  i,j,incNum,lnNum:integer;
  s1,bFn:string;
  t0, tAll: Cardinal;
  aHr, aMin, aSec, aMSec: Word;

  procedure subWrite_RasVectorInfo;
  begin

    writeln(pF, format('// RasVector Technology (c)', []) );
    writeln(pF, format('// Web : %s', [cRasVectorWeb]) );
    writeln(pF, format('// FaceBook : %s', [cRasVectorFaceBook]) );
    writeln(pF, format('// YouTube : %s', [cRasVectorYouTube]) );
    writeln(pF, format('// Email : %s', [cRasVectorEmail]) );
  end;

  procedure subWriteTMusicTones(sId, eId:integer);
  var
    i:Integer;
  begin
    // MT,1:4,1:2,2:2,3:4,3:2,4:2...........   MT,Note:Beat,Note:Beat,Note:Beat.......
    Write(pF, 'MT,');

    for i := sId to eId do
    with PMusicTone(aMusicTones[i])^ do
    begin
      write(pF, format('%d:%d,', [ mtNote, mtBeat]) );
    end;

    writeln(pF, '');
  end;

begin

  result:=false;

  if (nil=aMusicTones) or (aMusicTones.Count<=0) then exit;



  {$IFDEF FPC}
  bFn := FileUtil.SysToUTF8(afn);
  {$ELSE}
  bFn := afn;
  {$ENDIF}

  bFn := ChangeFileExt(bFn, '.mtf');

  try
    //aMirrorX:=false;

    oCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;

    {if Assigned(Self.FOnOutputLogInfo) then
    begin
      FOnOutputLogInfo( format( '*** %s [ %s %s ] -> %s', [ gVerbTypeName[vbSave], 'View', gNounTypeName[ntData], aFn ]));
    end;  }



    t0:=GetTickCount;

    AssignFile(pF, {$IFDEF FPC}UTF8ToAnsi{$ENDIF}(bFn) );
    ReWrite(pF);

    subWrite_RasVectorInfo;

    writeln(pF, format('// Name : %s', [FSongName]));
    writeln(pF, format('// Tones : %d', [aMusicTones.Count]));

    lnNum := aMusicTones.Count div cToneNumPerLine;

    incNum:=0;
    for i := 0 to lnNum-1 do
    begin
      subWriteTMusicTones(incNum, incNum+cToneNumPerLine-1);
      incNum := incNum+cToneNumPerLine;
    end;

    if (incNum<aMusicTones.Count) then
    begin
      subWriteTMusicTones(incNum, aMusicTones.Count-1);
    end;



    {if Assigned(Self.FOnOutputLogInfo) then
    begin
      //tAll := GetTickCount - t0;
      // EncodeMsec(tAll, aHr, aMin, aSec, aMSec);
      s1 := format('    T: %.*d:%.*d"%.*d', [2, aMin, 2, aSec, 3, aMSec]);
      FOnOutputLogInfo( s1 );

      FOnOutputLogInfo( format( '*** %s %s %s', [gVerbTypeName[vbSave], bfn, gAdjectiveTypeName[atSuccess] ]));
      FOnOutputLogInfo( ' ');
    end; }

    result:=true;
  finally
    Screen.Cursor := oCursor;

    //Setlength(gDynIntegers, 0);

    CloseFile(pF);

    //if Assigned(FOnRunningProgress) then FOnRunningProgress( '', 0 );
  end;
end;

procedure TMainForm.Param_Save_TMusicToneFile(Sender: TObject; const aFn: string);
var
  Values: array [0 .. 0] of String;
  bFn:String;
begin

{$IFDEF EnableInputBox}
  Values[0] := format('%s %s', ['Song', gNounTypeName[ntName]]);
  ;
  InputQuery('Enter Song Name', format('%s %s', [ 'Song', gNounTypeName[ntName]]), 
    Values,
    Self.OnInputQuery_SongName);
{$ENDIF}


  bFn:=ChangeFileExt(aFn, '.mtf');

  if Self.Base_Save_TMusicToneFile(bFn, FMusicTones) then
  begin
{$IFDEF debug}
    MscUtility.Open(bFn);
{$ENDIF}
    DoToast( format('File saved "%s"', [bFn]), 2000 );
  end;
end;

procedure TMainForm.Param_Load_TMusicToneFile(Sender: TObject; const aFns: string);
var
  fns:T256Strings;
  incNum,i:integer;
  blLoad:boolean;
begin                   
  Self.Clear_TMusicToneList(FMusicTones);
    
  StringManager.GetT256Strings(aFns, ';', incNum, fns);

  if incNum>0 then
  begin       
    for i := 0 to incNum-1 do         
      Self.Base_Load_TMusicToneFile(fns[i], FMusicTones, false);
  end;

  if FMusicTones.Count>0 then
  begin      
    DoToast( format('[%d] File loaded Successed (Tone:%d).', [incNum, FMusicTones.Count]), 2000 );  
  end;
end;

procedure TMainForm.Dialog_Load_TMusicToneFileClick(Sender: TObject);
var
  aFn, sTitle: string;
begin
  aFn := FLastImportFile; // GetCurrentDir;
  sTitle := format('%s %s %s.', [gVerbTypeName[vbImport],
    'Music Tone', gNounTypeName[ntFile]]);

  CrsFileManage.ShowFolderFileBrowser0(aFn, sTitle, ffFile,
    Self.Param_Load_TMusicToneFile, ['.mtf'], false);

end;


procedure TMainForm.Dialog_Save_TMusicToneFileClick(Sender: TObject);
var
  aFn, sTitle: string;
begin
  aFn := FLastImportFile; // GetCurrentDir;
  sTitle := format('%s %s %s.', [gVerbTypeName[vbExport],
    'Music Tone', gNounTypeName[ntFile]]);

  CrsFileManage.ShowFolderFileBrowser0(aFn, sTitle, ffFile,
    Self.Param_Save_TMusicToneFile, ['.mtf'], true);
end;
{$ENDIF}

{$IFDEF EnableInputBox}
procedure TMainForm.OnInputQuery_SongName(const AResult: TModalResult;
  const AValues: array of string);
var
  sValue: String;
begin
  sValue := string.Empty;
  if AResult <> mrOK then
    exit;
  sValue := AValues[0];
  try
    if (sValue.Trim <> '') then
    begin
      FSongName := sVAlue;
    end;
  except
    on e: Exception do
    begin
      ShowMessage(e.Message);
    end;
  end;
end;
{$ENDIF}

function TMainForm.DoConnect_Device(deviceID:integer): LongBool;
begin

  result :=false;
  if (deviceID<0) or (deviceID>=lbxDevices.Items.Count) then exit;
  

{$IF defined(Android)}
  {$IF defined(EnableBlueTooth)}
  // BlueTooth --------------------------------------
    with AndroidBlueToothManager do
    begin
      //DisConnect;
      result := Connect_TBlueToothDevice( PBlueToothDevice(BlueToothDevices[deviceID])^);
    end;
  {$ELSEIF defined(EnableWifi)}
  // Wifi --------------------------------------------
    IdUdpClient1.Host := edIp.Text; // '192.168.3.29'; //
    IdUdpClient1.Port :=  StrToInt(edPort.Text); //8087;
    DoToast( format('%s ( %s )...',[gVerbTypeName[vbConnect], edIp.Text ]) );
    result := true;
  {$ENDIF}
{$ELSEIF defined(Windows) }
  {$IF defined(EnablePCSerial)}
  // USB Comport ---------------------------------------
  WinComportManager.CloseComport;

  if WinComportManager.OpenComport(StrToInt(lbxDevices.Items[deviceID])) then
  begin
    WinComportManager.SetupCOMPort(115200, 30, 30); // timeOut ¤£¯à³]¤Ó¤j¡A§_«h·|©ìºCµ{¦¡
    result := true;
  end;
  {$ENDIF}
{$ENDIF}
end;

procedure TMainForm.Add_TMusicTone(const aMusicToneLst: TMusicToneList;
  aNote: TToneNote; aBeat: TToneBeat);
var
  pMT:PMusicTone;
begin
  if not Assigned(aMusicToneLst) then exit;

  new(pMT);
  pMT^.mtNote := aNote;
  pMT^.mtBeat := aBeat;

  aMusicToneLst.Add(pMT);

end;

procedure TMainForm.BlackKeyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
var
  aId:integer;
begin
  //TColorButton(Sender).Color := $FF7D7D7D;
  //TColorButton(Sender).Repaint;
//{$IFDEF Windows}
  aId := TColorButton(Sender).Tag;
  Play_Sound(aId, cToneNoteDurationMsec);
//{$ELSE}
  // Andorid ¨S¦³ mousedown()¡A©Ò¥H¥²¶·¦bmousemove()¤º¥t¥~§PÂ_
//{$ENDIF}


end;

procedure TMainForm.ckbxReceiveLogChange(Sender: TObject);
var
  aStr:AnsiString;
begin


{$IF defined(Android)}
  TimerReceive.Enabled := ckbxReceiveLog.IsChecked;
  {$IF defined(EnableBlueTooth)}
  // BlueTooth --------------------------------------
  {$ELSEIF defined(EnableWifi)}
  // Wifi --------------------------------------------
  {$ENDIF}
{$ELSEIF defined(Windows) }
  {$IF defined(EnablePCSerial)}
  // USB Comport ---------------------------------------
  if ckbxReceiveLog.IsChecked then
    WinComportManager.OnReadString := Self.ProcessReceivedString
  else
    WinComportManager.OnReadString := nil;
  {$ENDIF}
{$ENDIF}

end;

procedure TMainForm.rbSlowChange(Sender: TObject);
begin
  with TRadioButton(Sender) do
  begin
    case Tag of
    0: FActTempo := cSlowTempo;
    1: FActTempo := cNormalTempo;
    2: FActTempo := cQuickTempo;
    end;
  end;
end;

procedure TMainForm.BlackKeyMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin

  gDnMouseXY:=cInvalidPoint;

  //TColorButton(Sender).Color := $FF000000;
end;

procedure TMainForm.ByteArrayToString(byteAry: array of byte; len:integer; var str: String);
var
  sAnsi:AnsiString;
  i:integer;
  aChr:Char;
begin
  str := '';
  for i := 0 to len-1 do //High(byteAry) do
  begin
    aChr :=  Char( byteAry[i]);
    if (#13=aChr) then aChr:=#12
    else if (#10=aChr) then aChr:=#9;

    str := str + aChr;
  end;
end;

procedure TMainForm.BlackKeyMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
var
  aId:integer;
  procedure subMouseDown_Android;
  begin
    if M2dQueryer.IsEqual_TPoint(cInvalidPoint, gDnMouseXY) then
    begin
      gDnMouseXY := Point( round(X), round(Y));
    end
    else
    begin

    end;
  end;
begin
  //
 // {$IFDEF Windows}
 //{$ELSE}
  //Andorid ¨S¦³ mousedown()¡A©Ò¥H¥²¶·¦bmousemove()¤º¥t¥~§PÂ_
 // subMouseDown_Android;
 // {$ENDIF}


  aId := TColorButton(Sender).Tag;

  if (ssCtrl in Shift) then
  if (aId<>FActKeyIndex) then
  begin
    Play_Sound(aId, cToneNoteDurationMsec);
  end;

end;

procedure TMainForm.BlackKeyMouseLeave(Sender: TObject);
begin
  //
  TColorButton(Sender).Color := $FF000000;
  FActKeyIndex := -1;
  FPriKeyIndex := -1;
  //TColorButton(Sender).Repaint;
end;

procedure TMainForm.BlackKeyMouseEnter(Sender: TObject);
begin
  //
  TColorButton(Sender).Color := $FF505050;
  //TColorButton(Sender).Repaint;
end;

procedure TMainForm.WhiteKeyMouseEnter(Sender: TObject);
begin
  //
  TColorButton(Sender).Color := $FFA0A0A0;
  //TColorButton(Sender).Repaint;
end;

procedure TMainForm.WhiteKeyMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
var
  aID:integer;

  procedure subMouseDown_Android;
  begin
    if M2dQueryer.IsEqual_TPoint(cInvalidPoint, gDnMouseXY) then
    begin
      gDnMouseXY := Point( round(X), round(Y));
    end
    else
    begin

    end;
  end;
begin
  //{$IFDEF Windows}
  //{$ELSE}
  //Andorid ¨S¦³ mousedown()¡A©Ò¥H¥²¶·¦bmousemove()¤º¥t¥~§PÂ_
  //subMouseDown_Android;
  //{$ENDIF}

  aId := TColorButton(Sender).Tag;

  if (ssCtrl in Shift) then
  if (aId<>FActKeyIndex) then
  begin
    Play_Sound(aId, cToneNoteDurationMsec);
  end;

end;

procedure TMainForm.WhiteKeyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
var
  aId:integer;
begin

  aId := TColorButton(Sender).Tag;
  Play_Sound(aId, cToneNoteDurationMsec);
end;

procedure TMainForm.WhiteKeyMouseLeave(Sender: TObject);
begin
  TColorButton(Sender).Color := $FFFFFFFF;
  FActKeyIndex := -1;
  FPriKeyIndex := -1;
  //TColorButton(Sender).Repaint;
end;

procedure TMainForm.WhiteKeyMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  gDnMouseXY:=cInvalidPoint;

  //TColorButton(Sender).Color := $FFFFFFFF;
  //TColorButton(Sender).Repaint;

end;

procedure TMainForm.Clear_MusicTones(Sender: TObject);
begin
  Self.Clear_TMusicToneList(FMusicTones);
end;

procedure TMainForm.Clear_TMusicToneList(const aMusicToneLst: TMusicToneList);
var
  i: Integer;
begin
  Stop_Play;

  if not Assigned(aMusicToneLst) then exit;

  for i := 0 to aMusicToneLst.Count-1 do
  begin
    Dispose( PMusicTone(aMusicToneLst[i]) );
    aMusicToneLst[i] := nil;
  end;

  aMusicToneLst.Clear;
end;

procedure TMainForm.CreateMembers;
begin
  {$IFDEF EnableMediaPlay}
  FMediaPlayer := TMediaPlayer.Create(nil);
  {$ENDIF}
  FMusicTones := TMusicToneList.Create;

end;

function TMainForm.DoDiscover_Devices(var numDevices:integer): LongBool;
var
  s1:string;
  strs:TStringList;
  i: Integer;
begin
  //
  numDevices := 0;


  lbxDevices.Items.Clear;


{$IF defined(Android)}
  {$IF defined(EnableBlueTooth)}
  // BlueTooth --------------------------------------
  with AndroidBlueToothManager do
  begin
    if Discover_Devices() then
    for i := 0 to BlueToothDevices.Count-1 do
    with PBlueToothDevice(BlueToothDevices[i])^ do
    begin
      lbxDevices.Items.Add(btDeviceName);
    end;

    numDevices := BlueToothDevices.Count;

    {if lbxDevices.Items.Count>0 then
      DoToast( format('%s %s a Device!',[
         gAdverbTypeName[avPlease], gVerbTypeName[vbConnect]
            ]));       }
  end;

  {$ELSEIF defined(EnableWifi)}
  // Wifi --------------------------------------------

  {$ENDIF}
{$ELSEIF defined(Windows) }
  {$IF defined(EnablePCSerial)}
  // USB Comport ---------------------------------------
  try
    strs:=TStringList.Create;

    WinComportManager.EnumComPorts(strs);

    numDevices := strs.count;

    if strs.Count>0 then
    begin
      lbxDevices.Items.Clear;
      for i := 0 to strs.Count-1 do
        lbxDevices.Items.Add( copy(strs[i],4, length(strs[i])-3));
    end;

  finally
    strs.Free;
  end;
  {$ENDIF}

{$ENDIF}
  lbxDevices.ItemIndex := 0;

  result := numDevices>0;
end;

function TMainForm.Find_DefaultDevice(subStr:String; var aId: integer): LongBool;
var
  i:Integer;
begin
  aId:=-1;

  {$IFDEF Windows}
  aId := 0;
  lbxDevices.ItemIndex := aId;
  {$ELSE}
  with lbxDevices do
  for i := 0 to Items.Count-1 do
  begin
    if (Pos(subStr, UpperCase(Items[i]))>0)  then
    begin
      aId := i;
      lbxDevices.ItemIndex := aId;
      break;
    end;
  end;
  {$ENDIF}
  result := (aId>=0) and (aId<lbxDevices.Items.Count);
end;


procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FDoRecording:=false;;
  FDoReplayMusic:=false;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  numDevices,aID:integer;
begin
  InitialMembers_BeforeCreate;
  CreateMembers;
  InitialMembers_AfterCreate;

  Initial_Classes;
  Load_IniFile;

  Initial_Interface;

  if DoDiscover_Devices(numDevices) then
  begin
    tcMain.TabIndex := 0;
    if Self.Find_DefaultDevice('RV', aID) then
    {if DoConnect_Device(aID) then
    begin
      tcMain.TabIndex := 1;
      DoToast( format('"%s" is connected.', [lbxDevices.Items[aId]]) );
    end};
  end
  else
  begin
    tcMain.TabIndex := 1;
  end;



  {$IFDEF EnableLanguageSwitch}
  MscLanguageTranslater.ScanAndSaveFormComponentsText02(Self, OnWriteDefaultEnglishLanguageFile, OnLanguageSwitch);
  {$ENDIF}
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin


{$IF defined(Android)}
{$ELSEIF defined( Windows) }
  {$IF defined(EnablePCSerial)}
  WinComportManager.CloseComport;
  {$ENDIF}
{$ENDIF}


  Save_IniFile;

  ReleaseMembers;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  //Process_KeyChar(keyChar, Shift);
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  //
  Process_KeyChar(keyChar, Shift);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  Refresh_Interface_Resize;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  i:integer;
begin
  //
end;

function TMainForm.Get_CheckSum(const sCmd: String): integer;
var
  i:Integer;
begin
  result := 0;
  for i := 1 to length(sCmd) do
    result := result + Ord(sCmd[i]);
end;

function TMainForm.Get_TToneBeat(aDurationMSec: integer): TToneBeat;
var
  aDiv:integer;
  rtnBeat:TToneBeat;
begin
  rtnBeat := cB_2;  // 1/2 ©ç

  //durationMsec := round(aBeat*cMsecPerBeat*FActTempo div cTempoDiv);
  rtnBeat := round(aDurationMsec/cMsecPerBeat*cTempoDiv/FActTempo);

  rtnBeat := Math.Max(1, rtnBeat);

  result := rtnBeat;
end;

procedure TMainForm.InitialMembers_AfterCreate;
var
  i:integer;
  pMt:PMusicTone;
  curNote:byte;
  stNote:TToneNote;
begin
  TimerReceive.Interval := 100;

  FNoteFilePath := IncludeTrailingBackSlash(TPath.GetDocumentsPath);

{$IFDEF EnableMediaPlay}
  if Self.Resource_To_MP3File(cNoteResName, FNoteFilePath, FNoteFileName) then
    FMediaPlayer.FileName := FNoteFIlePath + FNoteFileName
  else
    FMediaPlayer.FileName := '';
{$ENDIF}

{$IFDEF Debug}
  for i := 0 to 3 do
  begin
    stNote := i*12;
    Self.Add_TMusicTone(FMusicTones, tnDo2+stNote, cB1);
    Self.Add_TMusicTone(FMusicTones, tnRe2+stNote, cB1);
    Self.Add_TMusicTone(FMusicTones, tnMi2+stNote, cB1);
    Self.Add_TMusicTone(FMusicTones, tnFa2+stNote, cB1);
    Self.Add_TMusicTone(FMusicTones, tnSo2+stNote, cB1);
    Self.Add_TMusicTone(FMusicTones, tnLa2+stNote, cB1);
    Self.Add_TMusicTone(FMusicTones, tnSi2+stNote, cB1);
  end;
{$ENDIF}
end;

procedure TMainForm.InitialMembers_BeforeCreate;
begin
  Initial_PianoButtons;

  FActTempo := cNormalTempo;
  FActKeyIndex:=-1;
  FPriKeyIndex:=-1;
  {$IFDEF EnableFileIO}
  FLastImportFile := INcludeTrailingBackSlash(TPath.GetDocumentsPath) + 'fn';
  {$ENDIF}
end;


procedure TMainForm.Initial_BlackButtons(whiteBtnW:Single; btnW, btnH: Single);
var
  i:integer;
begin
  for i := 0 to High(FBlackButtons) do
    Self.Initial_TPanelBlackButtons( FBlackButtons[i], whiteBtnW, btnW, btnH);
end;

procedure TMainForm.Initial_ButtonSize(var whiteBtnW, whiteBtnH: Single);
const
  cSp = 10;
var
  i:Integer;
  tmpBtnW,tmpBtnH,wBtnW,wBtnH,bBtnW,bBtnH,tW,tH:Single;
begin

  if (Self.width<Self.Height) then
  // Vertical
  begin
    wBtnW := (loPianos.Width-cSp*2)/7;  wBtnW:=Math.Max(cMinButtonWidth, wBtnW);
    //wBtnH := (loPianos.Height-cSp*4)/4;
    wBtnH:=wBtnW/cButtonWidthDivHeight;

    tW := wBtnW*7+cSp*4;
    tH := wBtnH*4+cSp*4;

    if (tW/tH < loPianos.Width/loPianos.Height) then
    // ¤Ó¹L²Óªø¡A¥²¶·¥H btnH ¬°·Ç
    begin
      wBtnH := (loPianos.Height-cSp*4)/4;
      wBtnW:=wBtnH*cButtonWidthDivHeight;
    end
    else
    begin
    end;

    bBtnW := wBtnW*cBlackDivWhiteButtonWidth;
    bBtnH := wBtnH*cBlackDivWhiteButtonHeight;
  end
  else
  // Horizontal
  begin
    //wBtnW := (loPianos.Width-cSp*4)/14;
    wBtnH := (loPianos.Height-cSp*4)/2;   wBtnH :=Math.Max(cMinButtonHeight, wBtnH);
    wBtnW:=wBtnH*cButtonWidthDivHeight;
    tW := wBtnW*14+cSp*4;
    tH := wBtnH*2+cSp*4;
    if (tW/tH > loPianos.Width/loPianos.Height) then
    // ¤Ó¹L²Óªø¡A¥²¶·¥H btnH ¬°·Ç
    begin
      wBtnW := (loPianos.Width-cSp*6)/14;
      wBtnH:=wBtnW/cButtonWidthDivHeight;
    end
    else
    begin
    end;

    bBtnW := wBtnW*cBlackDivWhiteButtonWidth;
    bBtnH := wBtnH*cBlackDivWhiteButtonHeight;
  end;

  whiteBtnW := wBtnW;
  whiteBtnH := wBtnH;

  Self.Initial_WhiteButtons(wBtnW, wBtnH);
  Self.Initial_BlackButtons(wBtnW, bBtnW, bBtnH);
end;

procedure TMainForm.Initial_Classes;
begin

  {$IFDEF EnableLanguageSwitch}
  MscLanguageTranslater.OnLanguageSwitch := Self.OnLanguageSwitch;
  MscLanguageTranslater.OnWriteDefaultEnglishLanguageFile := Self.OnWriteDefaultEnglishLanguageFile;
  {$ENDIF}
end;

procedure TMainForm.Initial_Interface;
var
  whiteBtnW,whiteBtnH:Single;
begin
  Initial_ButtonSize(whiteBtnW, whiteBtnH);

  tcMain.TabIndex := 0;

  mmDebug.Visible := {$IFDEF Debug}true{$ELSE}false{$ENDIF};
  spltDbg.Visible := mmDebug.Visible;
end;

procedure TMainForm.Initial_PianoButtons;
var
  i,iPnl, iKey:integer;
  blFindKey:boolean;
begin
  // Piano1 White Buttons ---------------------
  FWhiteButtons[0][0] := btnDo2;
  FWhiteButtons[0][1] := btnRe2;
  FWhiteButtons[0][2] := btnMi2;
  FWhiteButtons[0][3] := btnFa2;
  FWhiteButtons[0][4] := btnSo2;
  FWhiteButtons[0][5] := btnLa2;
  FWhiteButtons[0][6] := btnSi2;
  // Piano1 BlackButtons -----------------------
  FBlackButtons[0][0] := btnDo2s;
  FBlackButtons[0][1] := btnRe2s;
  FBlackButtons[0][2] := btnFa2s;
  FBlackButtons[0][3] := btnSo2s;
  FBlackButtons[0][4] := btnLa2s;


  // Piano2 White Buttons ---------------------
  FWhiteButtons[1][0] := btnDo3;
  FWhiteButtons[1][1] := btnRe3;
  FWhiteButtons[1][2] := btnMi3;
  FWhiteButtons[1][3] := btnFa3;
  FWhiteButtons[1][4] := btnSo3;
  FWhiteButtons[1][5] := btnLa3;
  FWhiteButtons[1][6] := btnSi3;
  // Piano2 BlackButtons -----------------------
  FBlackButtons[1][0] := btnDo3s;
  FBlackButtons[1][1] := btnRe3s;
  FBlackButtons[1][2] := btnFa3s;
  FBlackButtons[1][3] := btnSo3s;
  FBlackButtons[1][4] := btnLa3s;


  // Piano3 White Buttons ---------------------
  FWhiteButtons[2][0] := btnDo4;
  FWhiteButtons[2][1] := btnRe4;
  FWhiteButtons[2][2] := btnMi4;
  FWhiteButtons[2][3] := btnFa4;
  FWhiteButtons[2][4] := btnSo4;
  FWhiteButtons[2][5] := btnLa4;
  FWhiteButtons[2][6] := btnSi4;
  // Piano3 BlackButtons -----------------------
  FBlackButtons[2][0] := btnDo4s;
  FBlackButtons[2][1] := btnRe4s;
  FBlackButtons[2][2] := btnFa4s;
  FBlackButtons[2][3] := btnSo4s;
  FBlackButtons[2][4] := btnLa4s;


  // Piano4 White Buttons ---------------------
  FWhiteButtons[3][0] := btnDo5;
  FWhiteButtons[3][1] := btnRe5;
  FWhiteButtons[3][2] := btnMi5;
  FWhiteButtons[3][3] := btnFa5;
  FWhiteButtons[3][4] := btnSo5;
  FWhiteButtons[3][5] := btnLa5;
  FWhiteButtons[3][6] := btnSi5;
  // Piano4 BlackButtons -----------------------
  FBlackButtons[3][0] := btnDo5s;
  FBlackButtons[3][1] := btnRe5s;
  FBlackButtons[3][2] := btnFa5s;
  FBlackButtons[3][3] := btnSo5s;
  FBlackButtons[3][4] := btnLa5s;


  FDoLabels[0] := lblDo2;
  FDoLabels[1] := lblDo3;
  FDoLabels[2] := lblDo4;
  FDoLabels[3] := lblDo5;


  for i := 0 to High(FKeyButtons) do
  begin
    blFindKey := false;

    for iPnl := 0 to High(FWhiteButtons) do
    for iKey := 0 to High(FWhiteButtons[iPnl]) do
    if (FWhiteButtons[iPnl][iKey].Tag = i)  then
    begin
      FKeyButtons[i]:=FWhiteButtons[iPnl][iKey];
      blFindKey:=true;
      break;
    end;

    if not blFindKey then
    for iPnl := 0 to High(FBlackButtons) do
    for iKey := 0 to High(FBlackButtons[iPnl]) do
    if (FBlackButtons[iPnl][iKey].Tag = i)  then
    begin
      FKeyButtons[i]:=FBlackButtons[iPnl][iKey];
      blFindKey:=true;
      break;
    end;
  end;

end;

procedure TMainForm.Initial_TPanelBlackButtons(
  var pnlButtons: TPanelBlackButtons; whiteBtnW:Single; btnW, btnH: Single);
const
  cSp1 = 5;
  cMul:Array[0..4] of Single = (1,2,4,5,6);
var
  i: Integer;
  aLeft,aTop,btnW2:Single;
begin
  aLeft := 0.0;  aTop := cSp1;
  btnW2 := btnW/2.0;

  for i := 0 to High(pnlButtons) do
  if Assigned(pnlButtons[i]) then
  begin
    pnlButtons[i].Position.X := cMul[i]*whiteBtnW - btnW2;
    pnlButtons[i].Position.Y := aTop;
    pnlButtons[i].Width := btnW;
    pnlButtons[i].Height := btnH;
  end;
end;

procedure TMainForm.Initial_TPanelWhiteButtons(
  var pnlButtons: TPanelWhiteButtons; btnW, btnH: Single);
const
  cSp1=5;
var
  i: Integer;
  aLeft,aTop:Single;
begin
  aLeft := 0.0;  aTop := cSp1;

  for i := 0 to High(pnlButtons) do
  if Assigned(pnlButtons[i]) then
  begin
    pnlButtons[i].Position.X := aLeft;  aLeft:=aLeft+btnW;
    pnlButtons[i].Position.Y := aTop;
    pnlButtons[i].Width := btnW;
    pnlButtons[i].Height := btnH;
  end;
end;

procedure TMainForm.Initial_WhiteButtons(btnW, btnH: Single);
const
  cSp1=5;
var
  i:integer;
  aScale:single;
begin
  for i := 0 to High(FWhiteButtons) do
  begin
    Self.Initial_TPanelWhiteButtons( FWhiteButtons[i], btnW, btnH);
    FDoLabels[i].Position.X := FWhiteButtons[i][0].Position.X+cSp1;
    FDoLabels[i].Position.X := FWhiteButtons[i][0].Position.X+cSp1;
    aScale :=FWhiteButtons[i][0].Width/60.0;
    //aScale :=  Math.Max(1.0, aScale);
    FDoLabels[i].Scale.X := aScale;
    FDoLabels[i].Scale.Y := FDoLabels[i].Scale.X;
  end;
end;

procedure TMainForm.Load_IniFile;
begin

end;



procedure TMainForm.PlayNote(keyId, aDurationMsec: integer);
const
  cErrMsec=20;
var
  t0:Cardinal;
{$IFDEF EnableMediaPlay}
  tStt:TMediaTime;
{$ENDIF}
  fn:String;
begin


  TimerTone.Enabled := false;
  TimerTone.Interval :=  Math.Min(cToneNoteDurationMsec-cHeadDelayMsec-cErrMSec, aDurationMsec); //
  TimerTone.Enabled := true;
  FPriButtonColor := FKeyButtons[FActKeyIndex].Color ;
  FKeyButtons[FActKeyIndex].Color := $FFFF0000;

{$IFDEF EnableMediaPlay}
  tStt := keyId*cSecond;
  FMediaStartTime := tStt+(cHeadDelayMsec*cMiliSecond);
  FMediaEndTime := tStt + cSecond;

  FMediaPlayer.CurrentTime:= FMediaStartTime;

  FMediaPlayer.Play;
{$ENDIF}

  FPriKeyIndex :=FActKeyIndex;
end;

procedure TMainForm.Play_MusicTone(aNote: TToneNote; aBeat: TToneBeat);
var
  noteID:integer;
  durationMsec:integer;
  oClr:TAlphaColor;
begin

  noteId := integer(aNote)-integer(cStartToneNote);
  durationMsec := round(aBeat*cMsecPerBeat*FActTempo div cTempoDiv);

  oClr:=FKeyButtons[noteId].Color;

  Self.Play_Sound(noteId, durationMsec);
  MscUtility.PauseMsec(durationMsec);

  FKeyButtons[noteId].Color := oClr;
end;


procedure TMainForm.Play_Sound(keyId, aDurationMsec: integer);
var
  aNote:TToneNote;
  aBeat:TToneBeat;
  nBeat:integer;
  oClr:TAlphaColor;
begin

  FActKeyIndex := keyId;

  {$IFDEF UseBeep}
  MscUtility.DoBeep_Thread( cToneFrequency[ TTone(noteId++cStartToneID)], aDurationMsec);
  {$ELSE}
  Self.Thread_PlayNote(keyId, aDurationMsec);
  //Self.Thread_PlayNote(noteId+10, aDurationMsec);
  {$ENDIF}

  if FDoRecording then
  begin

    if FMusicTones.Count>0 then
    with PMusicTone(FMusicTones.Last)^ do
    begin
      mtBeat := Get_TToneBeat( GetTickCount-FLastPlayTime);
    end;

    aNote := TToneNote( keyId + integer(cStartToneNote) );
    aBeat := Get_TToneBeat(aDurationMsec);
    Self.Add_TMusicTone(FMusicTones, aNote, aBeat);

    FLastPlayTime := GetTickCount;
  end;

  //FKeyButtons[FActKeyIndex].Color := oClr;

end;

procedure TMainForm.Play_TMusicTones(const aMusicToneLst: TMusicToneList);
var
  i:integer;
begin
  prsbarPlay.Value := 0.0;

  DoRecording := false;

  if not Assigned(aMusicToneLst) then exit;

  Stop_Play;

  FDoReplayMusic:=true;

  i:=0;
  while (i<aMusicToneLst.Count) do
  begin
    with PMusicTone(aMusicToneLst[i])^ do
      Self.Play_MusicTone(mtNote, mtBeat);

    prsbarPlay.Value := (i/aMusicToneLst.Count)*100;

    if not FDoReplayMusic then exit;

    inc(i);
  end;

  FDoReplayMusic := false;
  prsbarPlay.Value := 0.0;

end;

procedure TMainForm.Play_TMusicTones_Thread;
var
  i:Integer;
  {$IFDEF  EnableMultiThread}
	Mythreadtask : ITask;
  {$ENDIF}
begin

  {$IFDEF  EnableMultiThread}
  if Assigned(Mythreadtask) then
	begin
		if Mythreadtask.Status = TTaskStatus.Running then
		begin
			//If it is already running don't start it again
			//Exit;
      if FOnRunThread then
      begin
        FOnRunThread := false;
        exit;
      end;
		end;
	end;

  FOnRunThread:=true;

	Mythreadtask := TTask.Create (
		procedure ()
		begin
			//Do all logic in here
			//If you need to do any UI related modifications
			TThread.Synchronize(TThread.CurrentThread,
        procedure()
			  begin
			  	//Remeber to wrap them inside a Syncronize
          Play_TMusicTones(FMusicTones);
          //if not FOnRunThread then exit;
			  end);

      //FOnRunThread := false; ·|¾É­P Thread ¥ß¨è°±¤î
		end).Start;
		// Ensure that objects hold no references to other objects so that they can be freed, to avoid memory leaks.

  {$ELSE}
  Play_TMusicTones(FMusicTones);
  {$ENDIF}
end;


procedure TMainForm.ProcessReceivedString(Sender: TObject;
  const aStr: AnsiString);
begin
  if (aStr<>'') then
  begin
    if (ckbxReceiveLog.IsChecked) then
      mmLog.Lines.Add(aStr);
  end;

end;

procedure TMainForm.Process_KeyChar(var keyChar: Char; Shift:TShiftState);

var
  aNote:TToneNote;
  noteID:integer;
  doPlay:boolean;
begin
  doPlay:=true;
  case KeyChar of
  'a':
    begin
      {if (ssCtrl in Shift) then aNote:=tnDo4
      else if (ssShift in Shift) then aNote:=tnDo5
      else if (ssAlt in Shift) then aNote:=tnDo2
      else} aNote:=tnDo3;
    end;
  's':
    begin
      {if (ssCtrl in Shift) then aNote:=tnRe4
      else if (ssShift in Shift) then aNote:=tnRe5
      else if (ssAlt in Shift) then aNote:=tnRe2
      else} aNote:=tnRe3;
    end;
  'd':
    begin
      {if (ssCtrl in Shift) then aNote:=tnMi4
      else if (ssShift in Shift) then aNote:=tnMi5
      else if (ssAlt in Shift) then aNote:=tnMi2
      else }
      aNote:=tnMi3;
    end;
  'f':
    begin
      {if (ssCtrl in Shift) then aNote:=tnFa4
      else if (ssShift in Shift) then aNote:=tnFa5
      else if (ssAlt in Shift) then aNote:=tnFa2
      else }
      aNote:=tnFa3;
    end;
  'g':
    begin
      {if (ssCtrl in Shift) then aNote:=tnSo4
      else if (ssShift in Shift) then aNote:=tnSo5
      else if (ssAlt in Shift) then aNote:=tnSo2
      else }
      aNote:=tnSo3;
    end;
  'h':
    begin
      {if (ssCtrl in Shift) then aNote:=tnLa4
      else if (ssShift in Shift) then aNote:=tnLa5
      else if (ssAlt in Shift) then aNote:=tnLa2
      else }
      aNote:=tnLa3;
    end;
  'j':
    begin
      {if (ssCtrl in Shift) then aNote:=tnSi4
      else if (ssShift in Shift) then aNote:=tnSi5
      else if (ssAlt in Shift) then aNote:=tnSi2
      else }
      aNote:=tnSi3;
    end;
  else
    doPlay:=false;
  end;

  if (doPlay) then
    Play_Sound(integer(aNote)-integer(cStartToneNote), cToneNoteDurationMsec);
end;

procedure TMainForm.Refresh_Interface_Resize;
const
  cSp=10;
  cTlbarBtnW=32;
var
  btnW,btnH:Single;

  procedure subInitial_Align;
  begin
    // tiConnect -------------------------------
    loConnect.Align := TAlignLayOut.None;
    spltDevices.Align := TAlignLayOut.None;
    loLog.Align := TAlignLayOut.None;

    // tiProgram -------------------------------
    tlBarPiano.Align :=TAlignLayout.None;
    prsbarPlay.Align := TAlignLayout.None;

    loPiano1.Align := TAlignLayOut.None;
    loPiano2.Align := TAlignLayOut.None;
    loPiano3.Align := TAlignLayOut.None;
    loPiano4.Align := TAlignLayOut.None;

    loPiano12.Align := TAlignLayOut.None;
    loPiano34.Align := TAlignLayOut.None;

    loPianos.Align := TAlignLayout.None;

    tcMain.Align := TAlignLayout.None;
  end;

  procedure subRefreshInterface_Horizontal;
  var
    aSize:Single;
    i:integer;
    procedure subRefresh_TiConnect_Horizontal;
    begin
      aSize:=Self.Width / 3 ;
      // tiConnect -------------------------------
      loConnect.Width := aSize;
      loConnect.Align := TAlignLayOut.Left;
      spltDevices.Align := TAlignLayOut.Left;
      loLog.Align := TAlignLayOut.Client;
    end;
    procedure subRefresh_TlbarPiano_Horizontal;
    var
      i:integer;
    begin

      tlBarPiano.Width := cTlbarBtnW;
      {$IFDEF FixToolbarAlignLeadingSpace}
      MscUiManager.FixToolbarAlignSpace(tlbarPiano, TAlignLayout.Top);
      {$ENDIF}
      MscUiManager.Align_TControl(tlbarPiano, TAlignLayout.Right, cTlbarBtnW);

     {
      for i := 0 to tlBarPiano.ControlsCount - 1 do
      with tlBarPiano.Controls[i] do
      begin
        Align := TAlignLayout.None;
        Height := cTlbarBtnW;
        Align := TAlignLayout.Top;
      end;
      //tlBarPiano.Align := TAlignLayout.None;
      tlBarPiano.Width := cTlbarBtnW;
      tlBarPiano.Align :=TAlignLayout.Left;
      tlBarPiano.Align :=TAlignLayout.Right;
       }


      // loTlbarRight --------------------------------------------
      loTlbarRight.Height := cTlbarBtnW*loTlbarRight.ControlsCount+cSp;
      {$IFDEF FixToolbarAlignLeadingSpace}
      MscUiManager.FixToolbarAlignSpace(loTlbarRight, TAlignLayout.Left);
      {$ENDIF}
      MscUiManager.Align_TControl(loTlbarRight, TAlignLayout.Bottom, cTlbarBtnW, TAlignLayout.Bottom);
      {loTlbarRight.Align := TAlignLayout.Bottom;
      for i := 0 to loTlbarRight.ControlsCount - 1 do
      with loTlbarRight.Controls[i] do
      begin
        Align := TAlignLayout.None;
        Height := cTlbarBtnW;
        Align := TAlignLayout.Bottom;
      end; }


      prsbarPlay.Orientation := TOrientation.Vertical;
      prsbarPlay.Width := 15;
      prsbarPlay.Align := TAlignLayout.Left;
      prsbarPlay.Align := TAlignLayout.Right;


    end;
    procedure subRefresh_loPianos_Horizontal;
    begin
      loPianos.Align := TAlignLayout.Client;

      aSize := btnH + cSp;
      loPiano34.Height := aSize;
      loPiano34.Align := TAlignLayOut.Bottom;
      loPiano34.Align := TAlignLayOut.Top;
      loPiano12.Height := aSize;
      loPiano12.Align := TAlignLayOut.Bottom;
      loPiano12.Align := TAlignLayOut.Top;

      aSize :=  btnW*7+cSp;
      loPiano3.Width := aSize;
      loPiano3.Align := TAlignLayOut.Right;
      loPiano3.Align := TAlignLayOut.Left;
      loPiano4.Width := aSize;
      loPiano4.Align := TAlignLayOut.Right;
      loPiano4.Align := TAlignLayOut.Left;
      loPiano1.Width := aSize;
      loPiano1.Align := TAlignLayOut.Right;
      loPiano1.Align := TAlignLayOut.Left;
      loPiano2.Width := aSize;
      loPiano2.Align := TAlignLayOut.Right;
      loPiano2.Align := TAlignLayOut.Left;

    end;
  begin
    // tiConnect --------------------------------
    subRefresh_TiConnect_Horizontal;

    // tiProgram -------------------------------
    subRefresh_TlbarPiano_Horizontal;
    subRefresh_loPianos_Horizontal;
  end;

  procedure subRefreshInterface_Vertical;
  var
    aSize:Single;
    i:integer;
    procedure subRefresh_TiConnect_Vertical;
    begin
      aSize:=Self.Height / 3 ;
      // tiConnect -------------------------------
      loConnect.Height := aSize;
      loConnect.Align := TAlignLayOut.Top;
      spltDevices.Align := TAlignLayOut.Top;
      prsbarPlay.Align := TAlignLayout.Top;
      loLog.Align := TAlignLayOut.Client;
    end;

    procedure subRefresh_TlbarPiano_Vertical;
    var
      i:integer;
    begin

      tlBarPiano.Height := cTlbarBtnW;
      {$IFDEF FixToolbarAlignLeadingSpace}
      MscUiManager.FixToolbarAlignSpace(tlbarPiano, TAlignLayout.Left);
      {$ENDIF}
      MscUiManager.Align_TControl(tlbarPiano, TAlignLayout.Top, cTlbarBtnW);

      {
      for i := 0 to tlBarPiano.ControlsCount - 1 do
      with tlBarPiano.Controls[i] do
      begin
        Align := TAlignLayout.None;
        Width := cTlbarBtnW;
        Align := TAlignLayout.Left;
      end;
      //tlBarPiano.Align := TAlignLayout.None;
      tlBarPiano.Height := cTlbarBtnW;
      tlBarPiano.Align :=TAlignLayout.Bottom;
      tlBarPiano.Align :=TAlignLayout.Top;
        }


      // loTlbarRight --------------------------------------------
      loTlbarRight.Width := cTlbarBtnW*loTlbarRight.ControlsCount+cSp;
      {$IFDEF FixToolbarAlignLeadingSpace}
      MscUiManager.FixToolbarAlignSpace(loTlbarRight, TAlignLayout.Top);
      {$ENDIF}
      MscUiManager.Align_TControl(loTlbarRight, TAlignLayout.Right, cTlbarBtnW, TAlignLayout.Right);

      {loTlbarRight.Align := TAlignLayout.Right;
      for i := 0 to loTlbarRight.ControlsCount - 1 do
      with loTlbarRight.Controls[i] do
      begin
        Align := TAlignLayout.None;
        Width := cTlbarBtnW;
        Align := TAlignLayout.Right;
      end;}


      prsbarPlay.Orientation := TOrientation.Horizontal;
      prsbarPlay.Height := 15;
      prsbarPlay.Align :=TAlignLayout.Bottom;
      prsbarPlay.Align :=TAlignLayout.Top;

    end;
    procedure subRefresh_loPianos_Vertical;
    begin
      loPianos.Align := TAlignLayout.Client;

      aSize := (btnH+cSp)*2;
      loPiano34.Height := aSize;
      loPiano34.Align := TAlignLayOut.Bottom;
      loPiano34.Align := TAlignLayOut.Top;
      loPiano12.Height := aSize;
      loPiano12.Align := TAlignLayOut.Bottom;
      loPiano12.Align := TAlignLayOut.Top;


      aSize :=  btnH+cSp;
      loPiano4.Height := aSize;
      loPiano4.Align := TAlignLayOut.Bottom;
      loPiano4.Align := TAlignLayOut.Top;
      loPiano3.Height := aSize;
      loPiano3.Align := TAlignLayOut.Bottom;
      loPiano3.Align := TAlignLayOut.Top;
      loPiano2.Height := aSize;
      loPiano2.Align := TAlignLayOut.Bottom;
      loPiano2.Align := TAlignLayOut.Top;
      loPiano1.Height := aSize;
      loPiano1.Align := TAlignLayOut.Bottom;
      loPiano1.Align := TAlignLayOut.Top;
    end;
  begin
    // tiConnect ----------------------
    subRefresh_tiConnect_Vertical;

    // tiProgram -------------------------------
    subRefresh_TlbarPiano_Vertical;
    subRefresh_loPianos_Vertical;
  end;
begin
  Initial_ButtonSize(btnW, btnH);

  subInitial_Align;

  if (Self.width<Self.Height) then
    subRefreshInterface_Vertical
  else
    subRefreshInterface_Horizontal;

  tcMain.Align := TAlignLayout.Client;

  //rbMain.Render;

end;

procedure TMainForm.ReleaseMembers;
begin
  {$IFDEF EnableMediaPlay}
  FMediaPlayer.Clear;
  FMediaPlayer.Free;
  {$ENDIF}

  Clear_TMusicToneList(FMusicTones);
  FMusicTones.Free;
end;

function TMainForm.Resource_To_MP3File(const resName:String; const sDir:String; var fnMp3: String): LongBool;
var
  InStream: TResourceStream;
  nDir:String;
begin
  result := false;
  fnMp3:='';

  if not DirectoryExists(sDir) then CreateDir(sDir);
  if not DirectoryExists(sDir) then exit;

  nDir := IncludeTrailingBackSlash(sDir);

  InStream := TResourceStream.Create(HInstance, resName, RT_RCDATA);
  try
    //aBmp.LoadFromStream(InStream);
    if Instream.Size>0 then
    begin
      fnMP3 := ChangeFileExt(resName, '.mp3');
      InStream.SaveToFile( nDir + fnMp3);
      result := true;
    end;
  finally
    InStream.Free;
  end;
end;


procedure TMainForm.Save_IniFile;
begin

end;


procedure TMainForm.sbClearAllClick(Sender: TObject);
begin
  mmLog.Lines.Clear;
  mmDebug.Lines.Clear;
end;

procedure TMainForm.sbClearClick(Sender: TObject);
begin
  if FMusicTones.Count>0 then
      FMXMessageDlg.AMessageDlg(format('%s %s [%d] %s %s?',
        [gVerbTypeName[vbClear], gAdjectiveTypeName[atCurrent], FMusicTones.Count, 'Tone',
         gNounTypeName[ntData]]
        ), Clear_MusicTones, nil);
end;

procedure TMainForm.sbConnectClick(Sender: TObject);
begin
  if DoConnect_Device(lbxDevices.ItemIndex) then
    DoToast( format('"%s" is connected.', [lbxDevices.Items[lbxDevices.ItemIndex]]) );
end;

procedure TMainForm.sbDiscoverClick(Sender: TObject);
var
  numDevices, aID:integer;
begin
  if DoDiscover_Devices(numDevices) then
  ;
  
end;

procedure TMainForm.sbLanguageClick(Sender: TObject);
begin
  {$IFDEF EnableLanguageSwitch}
  MscLanguageTranslater.SelectLanguage(Self);
  {$ENDIF}


end;

procedure TMainForm.sbLoadMtfClick(Sender: TObject);
begin

  Stop_Play;
  FDoReplayMusic := false;
  
  {$IFDEF EnableFileIO}
  Dialog_Load_TMusicToneFileClick(Sender);
  {$ENDIF}
end;

procedure TMainForm.sbRecordClick(Sender: TObject);
begin
  
  DoRecording := not FDoRecording;
end;

procedure TMainForm.sbSaveMtfClick(Sender: TObject);
begin

  if (FMusicTones.Count<=0) then exit;
                                     
  Stop_Play;
  FDoReplayMusic := false;
  
  {$IFDEF EnableFileIO}
  Dialog_Save_TMusicToneFileClick(Sender);
  {$ENDIF}

end;

procedure TMainForm.sbSendCommandClick(Sender: TObject);
begin
  DoSend_Command(edCommand.Text);
end;


procedure TMainForm.SetDoRecording(const Value: boolean);
var
  oRecord:boolean;
begin

  oRecord := FDoRecording;

  if oRecord then
  begin
    {if (FMusicTones.Count>0) then
    begin
        FMXMessageDlg.AMessageDlg(format('%s %s?',
          ['Play', 'Music',
           gNounTypeName[ntData]]
          ), sbPlayMusicClick, nil);
    end;   }
  end
  else
  begin

  end;

  Stop_Play;

  FDoRecording := Value;

  if (FDoRecording) then 
  begin       
    sbClearClick(sbClear);
    sbRecord.ImageIndex := 12;
  end
  else sbRecord.ImageIndex := 11;

end;

procedure TMainForm.Stop_Play;
begin
{$IFDEF EnableMediaPlay}
  FMediaPlayer.Stop; //¤£¯àÀWÁc©I¥s¡A·|³y¦¨ delay
{$ENDIF}

  TimerTone.Enabled := false;

  if (FPriKeyIndex>=0) and (FPriKeyIndex<High(FKeyButtons)) then
    FKeyButtons[FPriKeyIndex].Color := FPriButtonColor;
end;


procedure TMainForm.StringToByteArray(const str: String; arrayLen: integer;
  var byteAry: array of byte);
var
  i:integer;
begin
  for i := 1 to Math.Min(length(str), arrayLen) do
    byteAry[i-1] := Ord( str[i]);
end;


var
  gDelayMsec:Cardinal=200;

procedure TMainForm.sbSendClick(Sender: TObject);
const
  cRiseNoteNum=12;
  cDbgCnt=10;
var
  iDiv, iMod, i,j,id, incId:integer;
  s1:String;
  t0:Cardinal;


{$IFDEF UseStringCommand}
  procedure subSend_StringCommand0(sID, eId:integer; var incID:Integer);
  var
    sCmd:String;
    j:integer;
  begin
    if (eId<sId) then exit;

    sCmd:='S@';
    for j := sId to eId do
    with PMusicTone( FMusicTones[j] )^ do
    begin
      sCmd := sCmd + format('%d:%d,', [mtNote+cRiseNoteNum, mtBeat]);
      inc(incID);
    end;
    DoSend_Command(Copy(sCmd, 1, length(sCmd)-1) );
  end;

  procedure subSend_StringCommand;
  const
    cTonesPerCommand = 2;  //¤@¦¸¤£­n¶Ç¤Óªøªº«ü¥O¡A¥H§K±µ¦¬¥X¿ù
  var
    iDiv, iMod, i,j,id, incId:integer;
  begin
    //
    // SB@    sound begin
    // S@note:beat,note:beat....    song
    // SE@    sound end


    DoSend_Command('SB@');

    iDiv := FMusicTones.Count div cTonesPerCommand; //¨C¦¸¤­µ§

    incId:=0;
    for i := 0 to iDiv-1 do
    begin
      id := i*cTonesPerCommand;
      subSend_StringCommand0(id, id+cTonesPerCommand-1, incId);
    end;

    id := incId;
    subSend_StringCommand0(id, FMusicTones.Count-1, incId);

    DoSend_Command('SE@');
  end;
{$ELSE}
  procedure subSend_ByteCommand0(sID, eId:integer; var incID:Integer);
  var
    sCmd:String;
    j,toneNum,toneId:integer;
  begin
    if (eId<sId) then exit;

    toneNum := eId-sId+1;
    bCommand[0] := cSongTones;
    bCommand[1] := toneNum;

    toneId := 2;

    for j := sId to eId do
    with PMusicTone( FMusicTones[j] )^ do
    begin
      bCommand[toneId] := mtNote+cRiseNoteNum;
      bCommand[toneId+1 ] := mtBeat;
      toneId := toneId+2;
      inc(incID);
    end;

    bCommand[toneId] := 0;

    ByteArrayToString(bCommand, toneId+1, sCmd);
    DoSend_Command(sCmd);

  end;

  procedure subSend_ByteCommand;
  const
    cCmdDelyMsec=200;
  var
    i:integer;
    sCmd:String;
    btAry : Array[0..3] of byte;
  begin
    btAry[0]:=cSongBegin; btAry[1]:=0; //btAry[1]:=#13; btAry[2]:=#10;
    ByteArrayToString(btAry,2, sCmd);

    for i := 0 to 1 do
    begin
      DoSend_Command(sCmd);
      Sleep(cCmdDelyMsec);  // ¼È°± ¤@¤U¡AÅý Arduino ·PÀ³¨ì¡A¶i¤J ±µ¦¬¦r¦ê¼Ò¦¡
    end;


    iDiv := FMusicTones.Count div cCommandTones; //¨C¦¸¤­µ§

    incId:=0;
    for i := 0 to iDiv-1 do
    begin
      id := i*cCommandTones;
      subSend_ByteCommand0(id, id+cCommandTones-1, incId);
      Sleep(cCmdDelyMsec);  // ¼È°± ¤@¤U¡AÅý Arduino¨Ó±o¤Î³B²z
    end;

    id := incId;
    subSend_ByteCommand0(id, FMusicTones.Count-1, incId);
    Sleep(cCmdDelyMsec);  // ¼È°± ¤@¤U¡AÅý Arduino¨Ó±o¤Î³B²z


    btAry[0]:=cSongEnd; btAry[1]:=0; //btAry[1]:=#13; btAry[2]:=#10;
    ByteArrayToString(btAry, 2, sCmd);
    for i := 0 to 1 do
    begin
      DoSend_Command(sCmd);
      Sleep(cCmdDelyMsec);  // ¼È°± ¤@¤U¡AÅý Arduino ·PÀ³¨ì¡A¶i¤J ±µ¦¬¦r¦ê¼Ò¦¡
    end;

  end;
{$ENDIF}

begin

  {DoSend_Command('eSongBegin.');
  Sleep(gDelayMsec);

  for i := 0 to cDbgCnt-1 do
  begin
    //
    s1 := format('%d/%d-abcdefgh',[i+1, cDbgCnt]);
    //ByteArrayToString(bCommand, s1);
    DoSend_Command(s1);
  Sleep(gDelayMsec);
  end;

  DoSend_Command('gSongEnd.');
  Sleep(gDelayMsec);
  exit; }



  if (Self.FMusicTones.Count<=0) then exit;

  t0 := GetTickCount;

  {$IFDEF UseStringCommand}
  subSend_StringCommand;
  {$ELSE}
  subSend_ByteCommand;
  {$ENDIF}


  DoToast( format('Music sent successfully [%d] (%d msec).', [FMusicTones.Count, GetTickCount-t0]), 2000 );
end;



procedure TMainForm.sbPlayMusicClick(Sender: TObject);
begin

  FDoReplayMusic := not FDoReplayMusic;

  if (FDoReplayMusic) then   
  Self.Play_TMusicTones_Thread();
end;

procedure TMainForm.Thread_PlayNote(noteId, aDurationMsec: integer);
var
  i:Integer;
  {$IFDEF  EnableMultiThread}
	Mythreadtask : ITask;
  {$ENDIF}
begin

  {$IFDEF  EnableMultiThread}
  if Assigned(Mythreadtask) then
	begin
		if Mythreadtask.Status = TTaskStatus.Running then
		begin
			//If it is already running don't start it again
			//Exit;
      if FOnRunThread then
      begin
        FOnRunThread := false;
        exit;
      end;
		end;
	end;

  FOnRunThread:=true;

	Mythreadtask := TTask.Create (
		procedure ()
		begin
			//Do all logic in here
			//If you need to do any UI related modifications
			TThread.Synchronize(TThread.CurrentThread,
        procedure()
			  begin
			  	//Remeber to wrap them inside a Syncronize
          PlayNote(noteId, aDurationMsec);
          //if not FOnRunThread then exit;
			  end);

      //FOnRunThread := false; ·|¾É­P Thread ¥ß¨è°±¤î
		end).Start;
		// Ensure that objects hold no references to other objects so that they can be freed, to avoid memory leaks.

  {$ELSE}
    PlayNote(noteId, aDurationMsec);
  {$ENDIF}
end;

procedure TMainForm.Thread_XXX(startId: integer);
var
  i:Integer;
  {$IFDEF  EnableMultiThread}
	Mythreadtask : ITask;
  {$ENDIF}
begin
  {$IFDEF  EnableMultiThread}
  if Assigned(Mythreadtask) then
	begin
		if Mythreadtask.Status = TTaskStatus.Running then
		begin
			//If it is already running don't start it again
			//Exit;
      if FOnRunThread then
      begin
        FOnRunThread := false;
        exit;
      end;
		end;
	end;

  FOnRunThread:=true;

	Mythreadtask := TTask.Create (
		procedure ()
		begin
			//Do all logic in here
			//If you need to do any UI related modifications
			TThread.Synchronize(TThread.CurrentThread,
        procedure()
			  begin
			  	//Remeber to wrap them inside a Syncronize
          //Play_Image(startId);
          if not FOnRunThread then exit;
			  end);

      //FOnRunThread := false; ·|¾É­P Thread ¥ß¨è°±¤î
		end).Start;
		// Ensure that objects hold no references to other objects so that they can be freed, to avoid memory leaks.

  {$ELSE}
    //Play_Image(startId);
  {$ENDIF}
end;

procedure TMainForm.TimerReceiveTimer(Sender: TObject);
var
  s1:String;
begin
  if Self.ckbxReceiveLog.IsChecked then
  else exit;

{$IF defined(Android)}
  {$IF defined(EnableBlueTooth)}
  // BlueTooth --------------------------------------
  if AndroidBlueToothManager.IsConnected then
  if AndroidBlueToothManager.Read_String(s1) then
    mmLog.Lines.Add(s1);
  {$ELSEIF defined(EnableWifi)}
  // Wifi --------------------------------------------
  {$ENDIF}
{$ELSEIF defined(Windows) }
  {$IF defined(EnablePCSerial)}
  // USB Comport ---------------------------------------
  {$ENDIF}
{$ENDIF}
end;

procedure TMainForm.TimerToneTimer(Sender: TObject);
begin
  Stop_Play;
end;

function TMainForm.DoSend_Command(sCmd: String): LongBool;
var
  sNew, s1:String; //{$IFDEF Windows}AnsiString{$ELSE}String{$ENDIF};
  i,iChksum:integer;
  byteChkSum:byte;
  btAry:Array[0..cCommandLength-1] of byte;
begin

  result := false;
  if (''=sCmd) then exit;

  sNew := sCmd;

{$IFDEF EnableCheckSum}
  byteChksum := Get_CheckSum(sAnsi) and $FF;
  sNew := sNew + AnsiChar(byteChksum);
{$ENDIF}

{$IFDEF Debug}
  mmDebug.Lines.Add( sNew );
  StringToByteArray(sCmd, length(sCmd), btAry);
  s1:='';
  for i := 0 to length(sCmd)-1 do
    s1:=s1+IntToStr(btAry[i])+', ';
  mmDebug.Lines.Add(s1);
{$ENDIF}

{$IF defined(Android)}
  {$IF defined(EnableBlueTooth)}
  // BlueTooth --------------------------------------
  with AndroidBlueToothManager do
  if Send_String(sNew) then
  begin
    //DoToast(sAnsi);
    result:=true;
  end
  else
    DoToast( format('%s "%s" %s!',[gVerbTypeName[vbExport], edCommand.Text, gNounTypeName[ntError] ]));
  {$ELSEIF defined(EnableWifi)}
  // Wifi --------------------------------------------
  IdUdpClient1.Send(sNew);
  result := true;
  {$ENDIF}

{$ELSEIF defined(Windows) }
  {$IF defined(EnablePCSerial)}
  // USB Comport ---------------------------------------
  s1 := AnsiString(sNew+#13+#10);
  WinComportManager.SendText(s1);
  result := true;
  {$ENDIF}
{$ENDIF}
  Sleep(20);


end;

end.

