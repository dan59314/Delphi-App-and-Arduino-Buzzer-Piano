 ---------------------------------------------------------------------------------

  Copyright: (C) Daniel Lu, RasVector Technology.

  Email : dan59314@gmail.com
  
  linkedin : https://www.linkedin.com/in/daniel-lu-238910a4/
  
  Web :     http://www.rasvector.url.tw/
  
  YouTube : http://www.youtube.com/dan59314/playlist
  
  Instructables : https://goo.gl/EwRGYA
  
  

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
  
  linkedin : https://www.linkedin.com/in/daniel-lu-238910a4/
  
  Web :     http://www.rasvector.url.tw/
  
  YouTube : http://www.youtube.com/dan59314/playlist
  
  Instructables : https://goo.gl/EwRGYA
  
  

  使用或修改軟體，請註明引用出處資訊如上。未經過作者明示同意，禁止使用在商業用途。
  
  
  ---------------------------------------------------------------------------------

Androiduino Piano.  
      手機鋼琴 彈奏和錄製 音樂，然後將音樂透過藍芽發送到 Arduino buzzer 播放.

Instructables 完整教學:  https://www.instructables.com/id/RvPiano-Music-From-App-to-Arduino/

影片:
      超音波手勢控制影片 : https://goo.gl/4cxYoD

      錄製、播放、存、讀、發送 音樂:  https://goo.gl/fJDCCn

下載處:
      http://www.rasvector.url.tw/Download%20Pages/Download_Arduino.htm

      最近為了編寫 Arduino button 點擊 和 Ultrasonic 手勢控制功能，用 buzzer 播放音樂 來驗證控制效果。

     接著又繼續寫了 Windows 和 Android  鋼琴app, 用來彈奏並錄製歌曲,  準備透過 PC Serial,或手機藍芽 將歌曲傳送到 Arduino buzzer 播放，以後就可以隨時更新 Arduino 裝置上的個音樂了。影片如下，請打開音效。

      另外，目前 Button 和 Ultrasonic  已寫好的控制功能和手勢功能如下，控制效果良好，過一陣子會包裝好 Arduino library, 和完整範例 提供給大家下載，敬請關注。到粉絲頁按讚以便更新時收到通知。

       Button :  支援三個觸發事件
             buttonDown();  
             buttonClick(  int clickCount );
             buttonHoldOn( int holdTimeCnt );

       UltraSonic :  支援五種手勢控制
             OnWave()                 // Hand Wave in/out
             OnHolding()             // Hand In and holding
             OnHold()                  //  Hand out after holding
             OnNearToFar()        //  Hand out after holding from near to far
             OnFarToNear()        //  Hand out after hloding from far to near.

Get More free tools at    
http://www.rasvector.url.tw/hot_91270.html