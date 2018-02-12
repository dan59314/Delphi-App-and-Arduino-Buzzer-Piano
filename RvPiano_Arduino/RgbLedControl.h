
// 2016'3'7  Daniel Lu CopyRight  ( dan59314@gmail.com) ---------
//
// 	Web : 		http://www.rasvector.url.tw/
// 	YouTube :	http://www.youtube.com/dan59314/playlist
//
//  跨平台、跨語言 核心函式庫
//
//  功能：
//    用來管理 DanLib 內所有資料結構的運作
//
//  注意
//    1. 請將所有 XXXLIb 使用到的 自訂資料結構宣告全部放到 XXXTypDefine.pas
//
//    2. 請將所有 Math2DLib 內的Data type 的管理放到 XXXManager 內，包括：
//		  <1> 資料的判斷和轉換：EX: IsEqual(), IsEmpty(), RadianToDegree()…..。
//		  <2> 資料的資料運作: EX: Add(), Release(), Delete(), Insert()…..。
//		  <3> 資料的取得：EX: QSin(), QCos()…..。
//
//    3. 所有資料運作皆以 真實座標系統 ( 右手系統 ) 運作，即
//       逆時鐘旋轉時，角度為正， 順時鐘旋轉時角度為負。
//
//		4. 先置換 "RgbLedControler" -> 類別名(EX:M2dManager)", 接著置換 "RgbLedControl" -> 檔案名稱(EX: M2dManage)
//		
//		5. Servo 和 Arduino board 必須分別獨立供電，否則Servo.write() 後會導致arduino 不斷 Reset();
//-------------------------------------------------------------------------

/*
 PWM PIN   3, 5, 6, 9, 10, 11

 Daniel Lu : dan59314@gmail.com
 http://www.rasvector.url.tw/
 http://www.youtube.com/dan59314/playlists

  傳入字串:[A/D],[Pin#],[Value], EX: D,13,0->將 Digitial Pin 13 　設為 0
  
  1. D,3,255  ->  　設定 Digintal D3 　為 255
  2. A,1 -> 　讀取 A3 　的 analog 　　數值
  3. C,255,255,255 -> 　設定 R,G,B 　顏色直到 PinR,PinG,PinB
  4, M,1  　設定 PlayMode, cListerning, cAuto, cRandom, cRambo ....
  5. P,3,5,6  -> 　　設定 PinR=3, PinG=5, PinB=6
  6. TD,200  -> gDelayMsc = 200 msec
  7. TI,30000  -> gIdleMsec = 30000 msec
  8. RS/RE ->　開始/結束紀錄
*/

// DanielClass.h

#ifndef _RgbLedControl_h
#define _RgbLedControl_h

#if defined(ARDUINO) && ARDUINO >= 100
#include "arduino.h"
#else
#include "WProgram.h"
#endif

#include "CommonTypeDefine.h"


// 自定義, 共同定義移到 CommonTypeDefine.h　------------------------------------------------
//typedef const unsigned char* PByte;  // 定義　PByte, 指向 byte 的 pointer

/*
enum TDanEnum {
  de01, de02, de03, de04, de05
};

struct TDanRec {

};
*/


//#define HardwareDelay;
#define CommonAnode
//#define debug;
#define enableBreath

// Type Define ***********************************************************************************
struct  TPinRec { 
      byte PinNo;
      byte Value;
      bool Enabled;
}; // TNOTE; 　不可加,　才能讓函式傳遞自定義資料參數  (注解 1)

struct TRGB{
      byte R,G,B;
      unsigned long DelayMSec;
};

enum TValueType {
  vtBrightnessLevel=0, vtFinal
};

enum TPlayMode{
  pmConstColor=0, pmPlayList, pmRandom, pmRambo, pmBlink, pmRGB, pmBreath, pmDistanceSensor, pmXyzSensor,
  pmFinal
};




// Constants *************************************************************************************
const int cPlayCount=50;
const int cMaxCommandStringLength =20; // length("C,255,255,255,12345");
const byte cRamboStep = 15, cBreathStep=10;
const unsigned long cMaxIdleMsec = 300000;

// Variables *********************************************************

class TRgbLedControler
{
private:
  #ifdef enableBreath
  byte FStepR, FStepG, FStepB;
  short FIncDecR, FIncDecG, FIncDecB;
  #endif
  unsigned long FLastActionTime;
  int FActId=0;
  unsigned long FDelayMsec=200;
  byte FRamboR=255, FRamboG=0, FRamboB=0;
  byte FActR=0, FActG=0, FActB=255;
  bool FDoRecord=false;
  byte FPinR=5, FPinG=6, FPinB=9;
  byte FBlinkCount=0;
  byte FBrightness=100;

  void(*FOnCallBack_myCheck)(TRgbLedControler*, byte &irCode); /*TRgbLedControler　的　Class callback function*/

protected:
  void CreateMembers();
  void InitialMembers();
  void ReleaseMembers(); 

  void initial_Variables();
  void initial_PlayRGBs();
  
  bool canDoAction(unsigned long &lastActTime, unsigned long setDelayMsc );
  void update_RamboRGB(byte &aR, byte &aG, byte &aB);
  void Add_PlayRGB(byte aR, byte aG, byte aB, unsigned long delyMsc=10);
  bool Update_PlayModeParam(bool blUpdateDelayMSec=false);
  
public:

  TPlayMode FPlayMode;
  struct TRGB FPlayRGBs[cPlayCount];
  
  TRgbLedControler();
  ~TRgbLedControler();

  TRgbLedControler(byte pinR=5, byte pinG=6, byte pinB=9,
    void(*pCallbackFunc)(TRgbLedControler*, byte &irCode)=NULL); /* overload constructor pCallBackFunc(sender, irCode) */

  void Initial(byte pinR, byte pinG, byte pinB,
    TPlayMode FPlayMode=pmBreath,  void(*pCallbackFunc)(TRgbLedControler *, byte &irCode)=NULL);
    
  void Set_DigitalPin(byte pin, byte value);
  byte Get_AnalogPin(byte pin);

  void Update_ActRGB(byte aR, byte aG, byte aB);
  
  void Set_PinRGB(byte pinR, byte pinG, byte pinB);
  void Set_PlayMode(TPlayMode FPlayMode);
  void Set_RGBColor(byte aR, byte aG, byte aB, unsigned long delyMsc=10);
  void Set_DelayMSec(unsigned long delyMsc);
  void Set_Brightness(byte brightness);
  void Set_TypeValue(TValueType aValTp, byte aVal);

  void Next_PlayMode(int incStep=1);
        
  void Process_PlayMode();

  void Start_RecordPlayRGBs();
  void End_RecordPlayRGBs();

  //void HelloWorld(TDanEnum de); // HelloWord (code 950 用雙斜線註解會造成編譯錯誤) 
  void Run(void); /* 執行 Run指令*/
};


extern TRgbLedControler RgbLedControler;

#endif


