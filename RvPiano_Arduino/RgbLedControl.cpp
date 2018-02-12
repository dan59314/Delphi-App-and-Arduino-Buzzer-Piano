
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

#include "RgbLedControl.h"



// Variables *********************************************************


TRgbLedControler::TRgbLedControler()
{
	CreateMembers();
	InitialMembers();
}

TRgbLedControler::~TRgbLedControler()
{
	ReleaseMembers();
}

TRgbLedControler::TRgbLedControler(byte pinR=5, byte pinG=6, byte pinB=9, void(*pCallbackFunc)(TRgbLedControler *, byte &irCode))
{
	CreateMembers();
	InitialMembers();

  this->Set_PinRGB(pinR, pinG, pinB);
  
	FOnCallBack_myCheck = pCallbackFunc;
}


void TRgbLedControler::CreateMembers()
{

}

void TRgbLedControler::InitialMembers()
{

}

void TRgbLedControler::ReleaseMembers()
{

}

/*void TRgbLedControler::HelloWorld(TDanEnum de)
{
	switch (de)
	{
	case de01:
		break;
	case de02:
		break;
	case de03:
		break;
	case de04:
		break;
	case de05:
		break;
	}

}*/

void TRgbLedControler::initial_PlayRGBs()
{
   randomSeed(millis()); 
   for (int i=0; i<cPlayCount; i++)
   {
     FPlayRGBs[i].R = random(0,255);
     FPlayRGBs[i].G = random(0,255);
     FPlayRGBs[i].B = random(0,255);
     FPlayRGBs[i].DelayMSec = random(200,2000);     
   }
}

void TRgbLedControler::initial_Variables()
{
#ifdef enableBreath
  //FStepR, FStepG, FStepB;
  //FIncDecR, FIncDecG, FIncDecB;
#endif 
  /*
  FPlayMode = pmRambo;
  FActId=0;
  FDelayMsec=200;
  //gLastListerningTime, FLastActionTime;
  FRamboR=255, FRamboG=0, FRamboB=0;
  FActR=255, FActG=255, FActB=255;
  FDoRecord=false;
  FPinR=5, FPinG=6, FPinB=9;
  FBlinkCount=0;
  FBrightness = 255;  
   */
  FLastActionTime = millis();

  
  initial_PlayRGBs();
}

bool  TRgbLedControler::Update_PlayModeParam(bool blUpdateDelayMSec)
{    
  switch (FPlayMode)
  {
  case pmConstColor:
    break;
  case pmPlayList:
  {
    FDoRecord = false;
    FActId = 0;
    break;
  }
  case pmRandom:
  {
    if (blUpdateDelayMSec) FDelayMsec = 200;
    break;
  }
  case pmRambo:
  {
    if (blUpdateDelayMSec) FDelayMsec = 100;
    break;
  }
  case pmBlink:
  {
    if (blUpdateDelayMSec) FDelayMsec = 500;
    break;
  }
  case pmRGB:
  {
    if (blUpdateDelayMSec) FDelayMsec = 1000;
    break;
  }
  case pmBreath:
  {  
    if (blUpdateDelayMSec) FDelayMsec = 100;
    FStepR = FActR; FStepG = FActG; FStepB = FActB;
    FIncDecR = -constrain(FActR / cBreathStep, 2, 50);
    FIncDecG = -constrain(FActG / cBreathStep, 2, 50);
    FIncDecB = -constrain(FActB / cBreathStep, 2, 50);
    break;
  }
  case pmDistanceSensor: break;
  case pmXyzSensor: break;
  default:  break;
  }

  return true;
}

void TRgbLedControler::Set_PinRGB(byte pinR, byte pinG, byte pinB)
{  
    FPinR = pinR;    
    FPinG = pinG;    
    FPinB = pinB;    
    
    Process_PlayMode(); //　讓模式立刻切換
}


void TRgbLedControler::Set_TypeValue(TValueType aValTp, byte aVal)
{
   switch (aValTp)
   {
    case vtBrightnessLevel:
       Set_Brightness( aVal  );      
      break;
    case vtFinal:
      break;
    }  
}


void TRgbLedControler::Set_PlayMode(TPlayMode playMode)
{  
  FPlayMode = playMode;  
  Update_PlayModeParam(true); // 重置一下delay時間，立即反應效果
  Process_PlayMode(); //　讓模式立刻切換
}

void TRgbLedControler::Start_RecordPlayRGBs()
{  
   FActId=0;
   FDoRecord = true;
   //Process_PlayMode(); //　讓模式立刻切換
}


void TRgbLedControler::End_RecordPlayRGBs()
{  
  // 　江尚未指定的 RGB 　重複填滿　-----------------------------------
  for (int i=FActId+1; i<cPlayCount; i++)
  {
    FPlayRGBs[i] = FPlayRGBs[i%FActId];      
  }

  FDoRecord = false;
  FActId = 0;
  //Process_PlayMode(); //　讓模式立刻切換
}

void TRgbLedControler::Set_DigitalPin(byte pin, byte value)
{
#ifdef CommonAnode
    analogWrite(pin, 255-value );
#else
    analogWrite(pin, value);
#endif
}

byte TRgbLedControler::Get_AnalogPin(byte pin)
{
  return analogRead(pin);
}

void TRgbLedControler::Add_PlayRGB(byte aR, byte aG, byte aB, unsigned long delyMsc)
{
  FActId++;
  if (FActId>=cPlayCount) FActId=0;
  else; 

  //delyMsc = delyMsc % 3000;
  
  FPlayRGBs[FActId].R = aR;
  FPlayRGBs[FActId].G = aG;
  FPlayRGBs[FActId].B = aB;
  FPlayRGBs[FActId].DelayMSec = delyMsc;
  
  Update_PlayModeParam(false);    
}


void TRgbLedControler::Set_DelayMSec(unsigned long delyMsc)
{
  FDelayMsec = delyMsc;
}

void TRgbLedControler::Update_ActRGB(byte aR, byte aG, byte aB)
{  
  if ( (aR!=0) or (aG!=0) or (aB!=0) )
  {   
    FActR = aR;
    FActB = aB;
    FActG = aG;
  }

  Update_PlayModeParam(true);
}

void TRgbLedControler::Set_Brightness(byte brightness)
{
  FBrightness = constrain(brightness, 1, 255);
  
  this->Set_RGBColor(FActR,FActG,FActB); 
}

void TRgbLedControler::Set_RGBColor(byte aR, byte aG, byte aB, unsigned long delyMsc)
{  
  if (FDoRecord)
  {    
     Add_PlayRGB(aR,aG,aB,delyMsc);
  }
  
  Set_DigitalPin( FPinR, (aR*FBrightness/255));  
  Set_DigitalPin( FPinG, (aG*FBrightness/255)); 
  Set_DigitalPin( FPinB, (aB*FBrightness/255));
  
}


void TRgbLedControler::update_RamboRGB(byte &aR, byte &aG, byte &aB)
{
  if (aB<10)
  {
    aR-=cRamboStep;
    aG+=cRamboStep;
    if (aR<10) 
    {
      aG = 255;
      aB = 10;
    }
  }
  else if (aR<10)
  {
    aG-=cRamboStep;
    aB+=cRamboStep;
    if (aG<10) 
    {
      aB = 255;
      aR = 10;
    }
  }
  else // if (aG<10)
  {
    aB-=cRamboStep;
    aR+=cRamboStep;
    if (aB<10) 
    {
      aR = 255;
      aG = 10;
    }
  }
}

bool TRgbLedControler::canDoAction(unsigned long &lastActTime, unsigned long setDelayMsc )
{
  unsigned long t1= millis();
  if (t1-lastActTime > setDelayMsc)
  {
    lastActTime = t1;
    return true;
  }
  else
   return false;
}



void TRgbLedControler::Process_PlayMode()
{  
  switch(FPlayMode)
  {
    case pmConstColor: 
      break;
    case pmPlayList:
      { 
        if (RgbLedControler.canDoAction(FLastActionTime, FPlayRGBs[FActId].DelayMSec))
        { 
          unsigned long delyMsc = FPlayRGBs[FActId].DelayMSec;
          
          FActId++;
          
          if (FActId>=cPlayCount) FActId=0;
          else;      
          this->Set_RGBColor( FPlayRGBs[FActId].R, FPlayRGBs[FActId].G, FPlayRGBs[FActId].B);  
          delay(delyMsc);
        }
        break;
      }
    case pmRandom: 
      {
        if (RgbLedControler.canDoAction(FLastActionTime, FDelayMsec))
        {
          this->Set_RGBColor( random(0,255), random(0,255), random(0,255));    
          delay(FDelayMsec);
        }
        break;
      }
     case pmRambo: 
      {
        if (RgbLedControler.canDoAction(FLastActionTime, FDelayMsec))
        {
          this->update_RamboRGB(FRamboR,FRamboG,FRamboB);
          this->Set_RGBColor( FRamboR, FRamboG, FRamboB);    
          delay(FDelayMsec);
        }
        break;
      }
     case pmBlink:
      {
        if (RgbLedControler.canDoAction(FLastActionTime, FDelayMsec))
        {
          if ((FBlinkCount % 2) == 0)
            this->Set_RGBColor( FActR,FActG,FActB);    
          else 
            this->Set_RGBColor(0,0,0);             
          FBlinkCount++;       
          delay(FDelayMsec);  
        }
        break;
      }
     case pmRGB:
      {
        if (RgbLedControler.canDoAction(FLastActionTime, FDelayMsec))
        {
          if ((FBlinkCount % 3) == 0)
            this->Set_RGBColor( 255, 0, 0);    
          else if ((FBlinkCount % 3) == 1)
            this->Set_RGBColor( 0, 255, 0);    
          else
            this->Set_RGBColor( 0, 0, 255);             
          FBlinkCount++;       
          delay(FDelayMsec);
        }
        break;
      }
#ifdef enableBreath
    case pmBreath :
    {
        if (RgbLedControler.canDoAction(FLastActionTime, FDelayMsec))
        {
          short aR, aG, aB;
          aR = FStepR + FIncDecR;  
          aG = FStepG + FIncDecG;
          aB = FStepB + FIncDecB;

          if (aR <= 0 && aG <= 0 && aB <= 0)
          {  
            FIncDecR = abs(FIncDecR); //FStepR = 0;
            FIncDecG = abs(FIncDecG); //FStepG = 0;
            FIncDecB = abs(FIncDecB); //FStepB = 0;
            
            delay(FDelayMsec); //在最亮時，和最暗時都多停留一下
          }
          else if (aR >= FActR && aG >= FActG && aB >= FActB)
          {
            FIncDecR = -abs(FIncDecR); //FStepR = FActR;
            FIncDecG = -abs(FIncDecG); //FStepG = FActG;
            FIncDecB = -abs(FIncDecB); //FStepB = FActB;
            
            delay(FDelayMsec); //在最亮時，和最暗時都多停留一下
          };
          
          FStepR = constrain(aR, 0, FActR);
          FStepG = constrain(aG, 0, FActG);
          FStepB = constrain(aB, 0, FActB);      

          this->Set_RGBColor(FStepR,FStepG,FStepB);
          delay(FDelayMsec);
        }
        break;
     }
#endif
     case pmDistanceSensor: break;
     case pmXyzSensor: break;
    default:  break;
  }
}

void TRgbLedControler::Next_PlayMode(int incStep)
{
   Set_PlayMode( (TPlayMode) ( (byte)FPlayMode + incStep) % (byte)pmFinal );
}

void TRgbLedControler::Initial(byte pinR, byte pinG, byte pinB,
  TPlayMode playMode, void(*pCallbackFunc)(TRgbLedControler *, byte &irCode))
{
  initial_Variables();

  Set_PinRGB(pinR,pinG,pinB);
  
  //FPlayMode = playMode;  
  //Update_PlayModeParam(true); //不能放在 initial_Variables() 內，兩層以上的 function call, 會造成 BlueTooth 失效
  Set_PlayMode(playMode);
  
	FOnCallBack_myCheck = pCallbackFunc;
}

void TRgbLedControler::Run()
{
}



TRgbLedControler RgbLedControler(5,6,9, NULL);
