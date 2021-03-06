//+------------------------------------------------------------------+
//|                                                         asdf.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#property indicator_color1 Red
#property indicator_color2 Green

extern int Consecutive_Candles=2; // How many consecutive Bulls
extern int Consecutive_Gale=3; // How many consecutive martingales
extern int Minutes_Expire=5; // How many consecutive martingales
extern double InitialBOInvestment=1;
extern bool SoundAlert=true; // Do you want to Sound Alert?

bool bullCandlesOk = true;
bool bearCandlesOk = true;

int Bull_gale_count = 0;
int Bear_gale_count = 0;
int j=0;
int tkt=0;

double BOInvestment=1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   if(IsNewBar()==true)
     {

      bullCandlesOk = true;
      bearCandlesOk = true;
      j=Consecutive_Candles+1;
      BOInvestment=InitialBOInvestment;
      for(int i=1;i<=Consecutive_Candles;i++)
        {

         if(Close[i]>=Open[i])
           {//--- Check for BULL Candle
            bearCandlesOk=false;

           }// end if 
         else
           {//--- Check for BEAR Candle
            bullCandlesOk=false;

           }

        }// end for

      if(bullCandlesOk)
        {
         Bull_gale_count=0;

         while(Close[j]>=Open[j])
           {

            Bull_gale_count++;
            j++;

           }// end for
         if(Bull_gale_count<Consecutive_Gale && SoundAlert)
           {
           if(Bull_gale_count==0)
              {
               tkt=OrderSend(Symbol(),OP_SELL,BOInvestment,NormalizeDouble(Ask,Digits),0,0,0,"BO exp:"+IntegerToString(Minutes_Expire*60),0,0,clrGreen);
              }
            if(Bull_gale_count==1)
              {
               BOInvestment=BOInvestment*2.2;
               tkt=OrderSend(Symbol(),OP_SELL,BOInvestment,NormalizeDouble(Ask,Digits),0,0,0,"BO exp:"+IntegerToString(Minutes_Expire*60),0,0,clrGreen);
              }
            if(Bull_gale_count==2)
              {
               BOInvestment=BOInvestment*4.8;
               tkt=OrderSend(Symbol(),OP_SELL,BOInvestment,NormalizeDouble(Ask,Digits),0,0,0,"BO exp:"+IntegerToString(Minutes_Expire*60),0,0,clrGreen);
              }
            if(Bull_gale_count==3)
              {
               BOInvestment=BOInvestment*10;
               tkt=OrderSend(Symbol(),OP_SELL,BOInvestment,NormalizeDouble(Ask,Digits),0,0,0,"BO exp:"+IntegerToString(Minutes_Expire*60),0,0,clrGreen);
              }
            Alert(Symbol()," PUT qtd gale->",Bull_gale_count,
                  " qtd candle mesma direção->",Consecutive_Candles+Bull_gale_count);
           }
        }//end if

      if(bearCandlesOk)
        {
         Bear_gale_count=0;
         while(Close[j]<Open[j])
           {

            Bear_gale_count++;
            j++;

           }// end for
         if(Bear_gale_count<Consecutive_Gale && SoundAlert)
           {
            if(Bear_gale_count==0)
              {
               tkt=OrderSend(Symbol(),OP_BUY,BOInvestment,NormalizeDouble(Ask,Digits),0,0,0,"BO exp:"+IntegerToString(15*60),0,0,clrGreen);
              }
            if(Bear_gale_count==1)
              {
               BOInvestment=BOInvestment*2.2;
               tkt=OrderSend(Symbol(),OP_BUY,BOInvestment,NormalizeDouble(Ask,Digits),0,0,0,"BO exp:"+IntegerToString(15*60),0,0,clrGreen);
              }
            if(Bear_gale_count==2)
              {
               BOInvestment=BOInvestment*4.8;
               tkt=OrderSend(Symbol(),OP_BUY,BOInvestment,NormalizeDouble(Ask,Digits),0,0,0,"BO exp:"+IntegerToString(15*60),0,0,clrGreen);
              }
            if(Bear_gale_count==3)
              {
               BOInvestment=BOInvestment*10;
               tkt=OrderSend(Symbol(),OP_BUY,BOInvestment,NormalizeDouble(Ask,Digits),0,0,0,"BO exp:"+IntegerToString(15*60),0,0,clrGreen);
              }
            Alert(Symbol()," CALL qtd gale->",Bear_gale_count,
                  " qtd candle mesma direção->",Consecutive_Candles+Bear_gale_count);
           }

        }//end if
     }// end if(IsNewBar()==true)

  }
//+------------------------------------------------------------------+

// Check if there is a new bar
bool IsNewBar()
  {
   static datetime RegBarTime=0;
   datetime ThisBarTime=Time[0];

   if(ThisBarTime==RegBarTime)
     {
      return(false);
     }
   else
     {
      RegBarTime=ThisBarTime;
      return(true);
     }
  }
//+------------------------------------------------------------------+
