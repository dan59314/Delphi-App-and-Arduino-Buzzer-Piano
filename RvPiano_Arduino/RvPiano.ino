
/* -----------------------------------------------------------------------------
  Copyright: (C) Daniel Lu, RasVector Technology.

  Email : dan59314@gmail.com
  YouTube : http://www.youtube.com/dan59314/playlist

  This software may be freely copied, modified, and redistributed
  provided that this copyright notice is preserved on all copies.
  The intellectual property rights of the algorithms used reside
  with the Daniel Lu, RasVector Technology.

  You may not distribute this software, in whole or in part, as
  part of any commercial product without the express consent of
  the author.

  There is no warranty or other guarantee of fitness of this
  software for any purpose. It is provided solely "as is".

  ---------------------------------------------------------------------------------
  版權宣告  (C) Daniel Lu, RasVector Technology.

  Email : dan59314@gmail.com
  Web :     http://www.rasvector.url.tw/
  YouTube : http://www.youtube.com/dan59314/playlist

  使用或修改軟體，請註明引用出處資訊如上。未經過作者明示同意，禁止使用在商業用途。
*/




#define EnableRgbLED
#define EnableButton
#define EnableBuzzer     //會影響 BlueTooth, pin10共用
#define EnableUltraSonic  

#define EnableCheckSum

//#define UseStringCommand
#define debug

#ifdef EnableButton
#include <ButtonManage.h>
#endif 
#ifdef EnableBuzzer
#include <BuzzerPlay.h>
#include <BuzzerNoteDefine.h>
#endif
#ifdef EnableUltraSonic
#include <UltraSonicManage.h>
#endif
#ifdef EnableRgbLED
#include "RgbLedControl.h"
#endif

#include <StringManage.h>
#include <CommonTypeDefine.h>
#include <RvUtility.h>
#include <PCSerialManage.h>
#include <BlueToothSerialManage.h>


// Const -----------------------------------------------------
#ifdef EnableButton
const int cButtonPin=4;  // 將 pin4 連接button和一個10K ohm電阻，接到 Ground
#endif 
#ifdef EnableBuzzer
const int cBuzzerPin = 7;
bool blPlayDefault=true;
#endif
#ifdef EnableUltraSonic
const int cTrigPin = 12;
const int cEchoPin = 13;
#endif
#ifdef EnableRgbLED
const int cPinR=5, cPinG=6, cPinB=9;
#endif
const long cCheckInterval_UltraSonic=1000;

// Variables -------------------------------------------------
#ifdef debug
char sPrnt[16];
#endif

#ifdef EnableUltraSonic
float gDistance;
#endif

#ifdef UseStringCommand
const byte cCommandCount = 5;
String sCommand[cCommandCount];  
#else
const byte cSongBegin=101, cSongTones=102, cSongEnd=103;
const byte cCommandTones=5; 
const byte cCommandLength=cCommandTones*2+4;
//每個指令內有 cSongxxx, toneNum,  5 notes, 5 beats, 　一個結尾　0 -------------------------------
#ifdef EnableBuzzer
byte bCommand[] = {cSongTones, cCommandTones, Do4,cB1, Re4,cB1, Mi4, cB1, Fa4, cB1, So4, cB1, 0,0 };
#else
byte bCommand[] = {cSongTones, cCommandTones, 38,8, 40,8, 42, 8, 43, 8, 45, 8, 0,0 };
#endif
#endif

unsigned long gLastListerningTime=millis();
unsigned long gIdleMsec=2000;

#ifdef EnableBuzzer
// Little Start --------------------------
TToneNote gDefaultNotes[] = {
    Do4,Do4,So4,So4,La4,La4,So4, 
    Fa4,Fa4,Mi4,Mi4,Re4,Re4,Do4,
    So4,So4,Fa4,Fa4,Mi4,Mi4,Re4,
    So4,So4,Fa4,Fa4,Mi4,Mi4,Re4,
    Do4,Do4,So4,So4,La4,La4,So4, 
    Fa4,Fa4,Mi4,Mi4,Re4,Re4,Do4, cRest };
    
TToneBeat gDefaultBeats[] = {
    cB1,cB1,cB1,cB1,cB1,cB1,cB2,
    cB1,cB1,cB1,cB1,cB1,cB1,cB2,
    cB1,cB1,cB1,cB1,cB1,cB1,cB2,
    cB1,cB1,cB1,cB1,cB1,cB1,cB2,
    cB1,cB1,cB1,cB1,cB1,cB1,cB2,
    cB1,cB1,cB1,cB1,cB1,cB1,cB2, cB4 };

const byte cPlayNoteNum=80;

TToneNote gPlayNotes[cPlayNoteNum];
TToneBeat gPlayBeats[cPlayNoteNum]; 

int gDefaultNoteNum = sizeof(gDefaultNotes)/sizeof(TToneNote),
    gNoteNum=0;  // /sizeof(byte0; 長度會錯誤
#endif


#ifdef EnableRgbLED
//const byte cClrNum=12;
//struct TRGB FPlayRGBs[cClrNum];
void Set_Color(byte aId)
{
    RgbLedControler.Set_RGBColor(
        RgbLedControler.FPlayRGBs[aId].R,
        RgbLedControler.FPlayRGBs[aId].G, 
        RgbLedControler.FPlayRGBs[aId].B);
}
#endif

void Switch_Song(bool playDefaultSong)
{
#ifdef EnableBuzzer
  blPlayDefault = playDefaultSong;
  BuzzerPlayer.FAbortPlay = true;
#ifdef debug
  sprintf(sPrnt, "Song Sitch: %d (%d, %d)", blPlayDefault, gDefaultNoteNum, gNoteNum);
  Serial.println(sPrnt); 
#endif
#endif
}

void BuzzerPlay(unsigned short aFrequency, unsigned short aDuration)
{
#ifdef EnableBuzzer
  BuzzerPlayer.Play_Tone( aFrequency, aDuration );
#endif
}

void Blink_LED()
{ 
#ifdef EnableRgbLED
    RgbLedControler.Set_RGBColor(0,0,0);
    delay(10);
    RgbLedControler.Set_RGBColor(255,0,0);
#endif  
}

void Println_Serial(String sPrnt)
{
  PCSerialManager.Send_String(sPrnt);
}

void Println_BlueTooth(String sPrnt)
{
  BlueToothSerialManager.Send_String(sPrnt);
}




bool Check_HasInput(unsigned long &lastListenTime, byte checkCount=1)
{    
  for (int i=0; i<checkCount;i++)
  {
    if (BlueToothSerialManager.Check_And_Process_String())
    {
        lastListenTime = millis();
        return true;
    }
    else if (PCSerialManager.Check_And_Process_String())
    {
        lastListenTime = millis();
        return true;
    }
    else if ( millis()-gLastListerningTime > cCheckInterval_UltraSonic)
    {
  #ifdef EnableButton
      if ( ButtonManager.Check_ButtonEvent(cButtonPin) )
      {
        return true;
      }
  #endif
  #ifdef EnableUltraSonic
      else if (UltraSonicGesturer.Check_WaveEvent() )
      {
        return true;
      }
  #endif
    }
    delay(10);  
  }
   
  return false;
}

#ifdef EnableButton
void Process_ButtonEvent(TButtonManager*, int buttonPin, TButtonState bs, int clickCnt)
{
  if (buttonPin==cButtonPin)
  {  
    Blink_LED();
     
    switch (bs)
    {
      case bsClick: 
#ifdef EnableBuzzer
        Switch_Song(! blPlayDefault);
        for (int i=0; i<clickCnt; i++)
          BuzzerPlay( cFrequency[Do2], 250 );       
#endif        
        break;
        
      case bsDoubleClick:
#ifdef EnableBuzzer
        BuzzerPlay( cFrequency[Do2], 50 );
        BuzzerPlay( cFrequency[Do2], 50 );
#endif
        break;

      case bsHolding:
#ifdef EnableBuzzer
        BuzzerPlay( cFrequency[Do3], 50 );
#endif
        break;
        
      case bsHold:
#ifdef EnableBuzzer
        BuzzerPlayer.Set_Tempo( cNormalTempo);
        BuzzerPlay( cFrequency[Do3], 500 );
#endif
        if (1==clickCnt)
        {
        }
        else if (2==clickCnt)
        {         
        }
        else if (3==clickCnt)
        {
        }
        break;
        
      case bsLongHold:
#ifdef EnableBuzzer
        BuzzerPlay( cFrequency[Do3], 500 );
#endif
        break;
    }
  }
  else
  {
  }
}
#endif 



#ifdef EnableUltraSonic
// Triggered if WaveEven ---------------------------------
void Process_WaveEvent(TUltraSonicGesturer*, TWaveState ws, int aCnt, float frDistCM, float toDistCM)
{
  Blink_LED();
  
  switch (ws)
  {
    case wsWaveIn:
#ifdef EnableBuzzer
       BuzzerPlay(cFrequency[Do1], 50 );
#endif
      break;
      
    case wsWaveOut:
#ifdef EnableBuzzer
       BuzzerPlay(cFrequency[Do1], 50 );
#endif
      break;
      
    case wsWave:
#ifdef EnableBuzzer      
      Switch_Song(! blPlayDefault);
      for (int i=0; i<aCnt; i++)
         BuzzerPlay(cFrequency[Do2], 100 );
#endif    
      break;

    case wsHolding:
#ifdef EnableBuzzer
      BuzzerPlay( 2100+2000/toDistCM, 100 );
#endif
      break;
      
    case wsHold:
#ifdef EnableBuzzer
       BuzzerPlayer.Set_Tempo( cNormalTempo);
       BuzzerPlay(cFrequency[Do3], 200 );
#endif
      break;
      
    case wsNearToFar:
#ifdef EnableBuzzer
       BuzzerPlayer.Set_Tempo( cSlowTempo);
       BuzzerPlay(cFrequency[Do2], 200 );
#endif
      break;
      
    case wsFarToNear:
#ifdef EnableBuzzer
       BuzzerPlayer.Set_Tempo( cQuickTempo);
       BuzzerPlay(cFrequency[Do4], 200 );
#endif
      break;
  }
}
#endif

#ifdef EnableBuzzer
void OnPlayNote(TBuzzerPlayer*, byte aNote, byte aBeat, bool &abortPlay)
{
   // 檢查一下，是否有輸入 ------------------------
   if ( Check_HasInput(gLastListerningTime) )
   { 
      abortPlay = true;
#ifdef debug
  Serial.println("abortPlay=true");
#endif
      return;
   }
   else
     abortPlay = false;
   
#ifdef debug
   //sprintf(sPrnt, "NB,%d:%d", aNote, aBeat);
   //Serial.println(sPrnt);
#endif    

   // 改變燈光顏色 -------------------------------------
#ifdef EnableRgbLED
    RgbLedControler.Set_RGBColor(0,0,0);
    delay(10);
    
    int aId = (aNote-2) % cRamboStep;
    Set_Color(aId);
#endif  

}

#endif



#ifdef UseStringCommand

void Add_Notes_StringCommand(String sNotes, int &incNoteNum)
{
   if (incNoteNum>=cPlayNoteNum) return;
   
   Blink_LED();
    
   byte cmdCnt;
   String strs[2];
   int nxtID=0, incID=0;
   String sField="";
   // note:beat,note:beat....    song
   while (StringManager.Get_NextString(sNotes,",",nxtID, sField, true) )
   {
      if (StringManager.Split(sField, ":", strs, cmdCnt))
      if (cmdCnt>=2)
      {
#ifdef EnableBuzzer
        gPlayNotes[incNoteNum] = strs[0].toInt();
        gPlayBeats[incNoteNum] = strs[1].toInt();
        incNoteNum++;
#endif
      }
   }
}

void Process_StringCommand(String sCmd[], int cmdCnt)
{     
  // SB@    sound begin
  // S@note:beat,note:beat....    song
  // SE@    sound end
  if (sCmd[0].equals("SB") ) //sCmd[0].indexOf("SB")==0)  
  { 
#ifdef EnableBuzzer
    gNoteNum = 0;
    Switch_Song(false);
#endif
  }
  else if (sCmd[0].equals("SE")) //(sCmd[0].indexOf("SE")==0)  
  { 
#ifdef debug
  Serial.print("Note: "); Serial.println(gNoteNum);
#endif
  }
  else if (sCmd[0].equals("S") && cmdCnt>=2) //(sCmd[0].indexOf("S")==0)  
  { 
#ifdef EnableBuzzer
    Add_Notes_StringCommand(sCmd[1], gNoteNum); 
#endif
  }
}

#else  // Not UseStringCommand ------------------------------------------------------------------

void Add_Notes_ByteCommand(byte bCmd[], int &incNoteNum)
{
#ifdef EnableBuzzer
   if (incNoteNum>=cPlayNoteNum) return;

   if (cSongTones != bCmd[0]) return;

   Blink_LED();
    
   int  toneId=2;
   for (int i=0; i<bCmd[1]; i++)
   {        
      gPlayNotes[incNoteNum] = bCmd[toneId];
      gPlayBeats[incNoteNum] = bCmd[toneId+1];        
      incNoteNum++;

      toneId += 2;
   }
#endif
}

void Process_ByteCommand(byte bCmd[], int len)
{
  if (len<2) return;
  
#ifdef debug
  for (int i=0; i< len; i++)
  {
    Serial.print(bCmd[i]); Serial.print(", ");
  }
  Serial.println("");
#endif

  switch (bCmd[0])
  {
    case cSongBegin:
#ifdef EnableBuzzer
#ifdef debug
      Serial.println("");
      Serial.println("SongBegin:");
#endif
      gNoteNum = 0;
      Switch_Song(false);
#endif
      break;

    case cSongTones:
#ifdef EnableRgbLED
      RgbLedControler.Set_RGBColor(0,0,0);
      delay(10);
      RgbLedControler.Set_RGBColor(255,0,0);
#endif  
#ifdef EnableBuzzer
      Add_Notes_ByteCommand(bCmd, gNoteNum); 
#endif
      break;

    case cSongEnd:
#ifdef debug
#ifdef EnableBuzzer
      Serial.print("SongEnd: "); Serial.println(gNoteNum);
      Serial.println("");
#endif
#endif
      break;
  }
}

#endif



void initial_DigitalPins()
{
  for (int i=2; i<14; i++)
  //if (! isHardware_RxTx_Pin(i))
  {
    pinMode(i, OUTPUT);
    analogWrite(i, 0);  
    delay(100);
    analogWrite(i,255); 
  }  
}

bool IsValidCheckSum_String(String str)
{
  String s0 = str.substring(0,str.length()-1);
  byte nChksum  = Get_CheckSum_Byte(s0);
  String s1 = (String)str[str.length()-1];
  byte oChksum = (byte) s1[0];

#ifdef debug
  Serial.print("nChkSum:oChkSum,   ");
  Serial.print(nChksum); Serial.print(":"); Serial.println(oChksum);
#endif

  return (oChksum == nChksum);
}

void Process_String(String &str)
{  
#ifdef debug
  Serial.print("Input: "); Serial.print("'"); Serial.print(str); Serial.println("'");
#endif


#ifdef UseStringCommand
#ifdef EnableCheckSum
  if (IsValidCheckSum_String(str))
  {    
#ifdef debug
  Serial.println("CheckSum OK");
#endif
  }
  else
  {
#ifdef debug
  Serial.println("CheckSum NG");
#endif
    return;
  }
#endif

  str.toUpperCase();    
  // SB@    sound begin
  // S@note:beat,note:beat....    song
  // SE@    sound end
  byte cmdCnt;
  if (StringManager.Split(str, "@", sCommand, cmdCnt))
  {
    Process_StringCommand(sCommand, cmdCnt);
  }   
#else
  StringToByteArray(str, cCommandLength, bCommand);
  Process_ByteCommand( bCommand, cCommandLength ); //str.length()); //
#endif
}

#ifdef EnableBuzzer
void Assign_DefaultNotes()
{
    int gNoteNum = min( sizeof(gDefaultNotes)/sizeof(TToneNote), sizeof(gPlayNotes)/sizeof(TToneNote));
    for (int i=0; i<gNoteNum; i++)
    {
      gPlayNotes[i] = gDefaultNotes[i];
      gPlayBeats[i] = gDefaultBeats[i];
    }
}

void Initial_gPlayNotes_StringCommand()
{  
  byte byteChksum;
  String s1="SB@";
#ifdef EnableCheckSum
  byteChksum = Get_CheckSum_Byte(s1);
  s1 = s1 + (char)byteChksum;
#endif
  Process_String(s1);
  
  s1 = "S@38:8,40:8,42:4,43:4,45:16";  
#ifdef EnableCheckSum
  byteChksum = Get_CheckSum_Byte(s1);
  s1 = s1 + (char)byteChksum;
#endif
  Process_String(s1);
  
  s1 = "S@45:4,43:4,42:4,40:4,38:16";
#ifdef EnableCheckSum
  byteChksum = Get_CheckSum_Byte(s1);
  s1 = s1 + (char)byteChksum;
#endif
  Process_String(s1);
  
  s1 = "SE@";
#ifdef EnableCheckSum
  byteChksum = Get_CheckSum_Byte(s1);
  s1 = s1 + (char)byteChksum;
#endif
  Process_String(s1); 
}


void Initial_gPlayNotes_ByteCommand()
{
  byte tmpCmd[2];
  
  tmpCmd[0]=cSongBegin; tmpCmd[1]=0;
  Process_ByteCommand(tmpCmd, 2);

  //bCommand = {cSongTones, Do4,cB1, Re4,cB1, Mi4,cB1, Fa4,cB1, So4,cB1, 0 };
  Process_ByteCommand(bCommand, cCommandLength);
  
  tmpCmd[0]=cSongEnd; tmpCmd[1]=0;
  Process_ByteCommand(tmpCmd, 2);
}
#endif

void setup() {
  
  initial_DigitalPins; //不能放在 RgbLedControler 內，Member function() 會造成 BlueTooth 失效

#ifdef EnableRgbLED
  RgbLedControler.Initial(cPinR,cPinG,cPinB,pmBreath);
#endif

#ifdef EnableButton
  pinMode(cButtonPin, INPUT); //INPUT_PULLUP);   //pinMode(cButtonPin, INPUT);
  digitalWrite(cButtonPin, HIGH );
  ButtonManager.Initial( &Process_ButtonEvent);
#endif 

#ifdef EnableUltraSonic
  UltraSonicGesturer.Initial(cTrigPin, cEchoPin, &Process_WaveEvent);
#endif


#ifdef EnableBuzzer
  Assign_DefaultNotes();
  BuzzerPlayer.Initial(cBuzzerPin, cNormalTempo, OnPlayNote);    
#endif

  PCSerialManager.begin(115200, &Process_String); 
  BlueToothSerialManager.begin(BaudRate_CH05, &Process_String);  // BaudRate_CH05 = 38400 

#ifdef EnableBuzzer  
  #ifdef UseStringCommand
    Initial_gPlayNotes_StringCommand();
  #else
    Initial_gPlayNotes_ByteCommand();
  #endif
#endif
}

void loop() {
  
  if ( Check_HasInput(gLastListerningTime) )
  {
#ifdef EnableBuzzer  
     BuzzerPlayer.FAbortPlay = true;
#endif
      //有收到字串，接著繼續接收，不去作 Process_PlayMode() loading 大的工作
  }
  else   
  {
    unsigned long dMsec = millis()-gLastListerningTime;    
    
    if (dMsec > gIdleMsec)
    {
#ifdef EnableRgbLED
      //RgbLedControler.Process_PlayMode();
#endif
#ifdef EnableBuzzer
      if (true==blPlayDefault)
      {
#ifdef debug
        Serial.print("oSong: "); Serial.println(gDefaultNoteNum);
#endif
        BuzzerPlayer.Play_Song(gDefaultNotes, gDefaultBeats, gDefaultNoteNum);
      }
      else
      {
#ifdef debug
        Serial.print("nSong: "); Serial.println(gNoteNum);
#endif
        BuzzerPlayer.Play_Song(gPlayNotes, gPlayBeats, gNoteNum);
      }
      gLastListerningTime = millis();
#endif
    }     
  }
  
}
