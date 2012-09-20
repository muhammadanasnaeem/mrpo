import businessobjects.MarketScheduleBO;
import businessobjects.MarketStateInfo;
import businessobjects.SymbolOrderLimitBO;

import com.lightstreamer.as_client.events.NonVisualItemUpdateEvent;

import common.States;
import common.Type;

import components.EZCurrencyFormatter;
import components.EZNumberFormatter;

import controller.ModelManager;
import controller.SoundManager;
import controller.WindowManager;

import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.formatters.NumberFormatter;
import mx.messaging.events.MessageEvent;
import mx.messaging.events.MessageFaultEvent;
import mx.preloaders.Preloader;
import mx.resources.ResourceManager;

import services.LSListener;

import view.BulletinControl;

[Bindable]
private var modelManager:ModelManager=ModelManager.getInstance();

[Bindable]
private var windowManager:WindowManager=WindowManager.getInstance();

[Bindable]
public var messagesArray:Array = new Array();

public function handleMarketMessage(event:NonVisualItemUpdateEvent):void

{
	//var event:NonVisualItemUpdateEvent = new NonVisualItemUpdateEvent(null, null, null, null);
	var itemNameUser:String="USER_" + modelManager.userID;
	var itemNameMarketMessage:String="Market_Message";
	var statusMsg:String="";

	var updateType:String = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[0]);
	if (event.item == itemNameMarketMessage)
	{
		if (updateType == "2") // Market schedule update
		{
			var marketSchedule:MarketScheduleBO = new MarketScheduleBO();
			
			marketSchedule.INTERNAL_EXCHANGE_ID = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[1]));
			marketSchedule.INTERNAL_MARKET_ID = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[2]));
			
			var stateInfo:MarketStateInfo = new MarketStateInfo();
			stateInfo.state_ = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[6]);
			
			var strDateTime:String = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[7]);
			var arrDateTime:Array = strDateTime.split("T");
			if (arrDateTime.length < 2)
			{
				stateInfo.startDateTime_ = new Date();
			}
			else
			{
				var arrDate:Array=(arrDateTime[0] as String).split("-");
				var arrTime:Array=(arrDateTime[1] as String).split(":");

				stateInfo.startDateTime_.setFullYear(new Number(arrDate[0]));
				stateInfo.startDateTime_.setMonth(new Number(arrDate[1]));
				stateInfo.startDateTime_.setDate(new Number(arrDate[2]));
				stateInfo.startDateTime_.setHours(new Number(arrTime[0]));
				stateInfo.startDateTime_.setMinutes(new Number(arrTime[1]));

				var arrSeconds:Array=(arrTime[2] as String).split(",");

				stateInfo.startDateTime_.setSeconds(new Number(arrSeconds[0]));
			}
			marketSchedule.SCHEDULE.addItem(stateInfo);
			modelManager.exchangeScheduleModel.updateMarketSchedule(marketSchedule);
//			statusMsg+="<font color='";
//			statusMsg+="#FFFFFF";
//			statusMsg+="'>";
			statusMsg = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[8]).replace("T", " ");
			var strMarketCode:String=modelManager.exchangeModel.getMarketCode(marketSchedule.INTERNAL_EXCHANGE_ID, marketSchedule.INTERNAL_MARKET_ID);
			var strExchangeCode:String=modelManager.exchangeModel.getExchangeCode(marketSchedule.INTERNAL_EXCHANGE_ID);																																																																							
			statusMsg+=(FlexGlobals.topLevelApplication.parameters.LOCALE == 'ar_SA')?' '+ResourceManager.getInstance().getString('marketwatch','marketStateOf')+' '+States.getMarketState(stateInfo.state_) +  ' ' +ResourceManager.getInstance().getString('marketwatch','inExchange') +' '+ strExchangeCode + " " + ResourceManager.getInstance().getString('marketwatch','inMarket')+' ' + strMarketCode :' '+ResourceManager.getInstance().getString('marketwatch','marketStateOf')+' '+ strMarketCode +' '+ResourceManager.getInstance().getString('marketwatch','inExchange')+' '+ strExchangeCode +' '+ResourceManager.getInstance().getString('marketwatch','is')+' '+ States.getMarketState(stateInfo.state_);
			WindowManager.getInstance().viewManager.marketScheduleControl.updateStatus(statusMsg);
			modelManager.exchangeModel.setMarketState(marketSchedule.INTERNAL_EXCHANGE_ID, marketSchedule.INTERNAL_MARKET_ID, new Number(stateInfo.state_));
			WindowManager.getInstance().viewManager.marketScheduleControl.resetFields(false);
			WindowManager.getInstance().viewManager.liveMessages.updateStatus(statusMsg);
			windowManager.viewManager.liveMessages.txaMessages.validateNow();
			windowManager.viewManager.liveMessages.txaMessages.verticalScrollPosition=windowManager.viewManager.liveMessages.txaMessages.maxVerticalScrollPosition; // added on 2/12/2010
			SoundManager.getInstance().playMarketStateSound();
			messagesArray.push(statusMsg);
		}
		else if (updateType == "3") // Symbol state changed
		{
			statusMsg = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[8]).replace("T", " ");
				var symbolState:String = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[6]);
			
			var symbolCode:String = modelManager.exchangeModel.getSymbolCode(
				new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[1])), // internal exchange id
				new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[2])), // internal market id
				new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[17])) // internal symbol id
				);
				statusMsg +=' '+ ResourceManager.getInstance().getString('marketwatch','symbolStateOf')+ ' ' + symbolCode +' '+ResourceManager.getInstance().getString('marketwatch','is')+' ' + States.getSymbolState(symbolState);
			modelManager.exchangeModel.setSymbolState(
				new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[1])), // internal exchange id
				new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[2])), // internal market id
				new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[17])), // internal symbol id
				symbolState);
			WindowManager.getInstance().viewManager.symbolStateControl.resetFields(false);
			WindowManager.getInstance().viewManager.liveMessages.updateStatus(statusMsg);
			windowManager.viewManager.liveMessages.txaMessages.validateNow();
			windowManager.viewManager.liveMessages.txaMessages.verticalScrollPosition=windowManager.viewManager.liveMessages.txaMessages.maxVerticalScrollPosition; // added on 2/12/2010
			messagesArray.push(statusMsg);
		}
		else if (updateType == "5") // Bulletin for all exchanges
		{
			//statusMsg = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[8]).replace("T", " ");
			statusMsg += ResourceManager.getInstance().getString('marketwatch','marketStateOf')+':' + LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[9]);
			WindowManager.getInstance().viewManager.liveMessages.updateBulletin(statusMsg);
			windowManager.viewManager.liveMessages.txaBulletins.validateNow();
			windowManager.viewManager.liveMessages.txaBulletins.verticalScrollPosition=windowManager.viewManager.liveMessages.txaBulletins.maxVerticalScrollPosition; // added on 2/12/2010
			messagesArray.push(statusMsg);
		}
		else if (updateType == "6") // Symbol Order Limit Change
		{
			var symbolOrderLimit:SymbolOrderLimitBO = new SymbolOrderLimitBO();
			symbolOrderLimit.INTERNAL_EXCHANGE_ID = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[11]));
			symbolOrderLimit.INTERNAL_MARKET_ID = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[12]));
			symbolOrderLimit.INTERNAL_SYMBOL_ID = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[13]));
			symbolOrderLimit.LIMIT_TYPE = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[14]);
			symbolOrderLimit.UPPER_LIMIT = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[15]));
			symbolOrderLimit.LOWER_LIMIT = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[16]));

			modelManager.exchangeModel.setSymbolOrderLimit(symbolOrderLimit);
			//statusMsg = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[8]).replace("T", " ");
			var marketCode:String=modelManager.exchangeModel.getMarketCode(symbolOrderLimit.INTERNAL_EXCHANGE_ID, symbolOrderLimit.INTERNAL_MARKET_ID);
			var symbol:String=modelManager.exchangeModel.getSymbolCode(symbolOrderLimit.INTERNAL_EXCHANGE_ID, symbolOrderLimit.INTERNAL_MARKET_ID, symbolOrderLimit.INTERNAL_SYMBOL_ID);
			statusMsg+=ResourceManager.getInstance().getString('marketwatch','ordrLimitforSym')+' ' + symbol + ' '+ResourceManager.getInstance().getString('marketwatch','inMarket')+' ' + marketCode + ' '+ResourceManager.getInstance().getString('marketwatch','for')+' ';
			statusMsg+=Type.OrderLimitType[symbolOrderLimit.LIMIT_TYPE];
			statusMsg+=' '+ResourceManager.getInstance().getString('marketwatch','ordrLimitforSym')+' ';
			var ezNumberFormatter:EZNumberFormatter=new EZNumberFormatter();
			//var upperLmtStr:String = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[15]));
			//var lowerLmtStr:String = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[16])); 
			statusMsg+=new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[16])) + " - "+ new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[15]));
//			if(Type.OrderLimitType[symbolOrderLimit.LIMIT_TYPE] == 'VALUE' || Type.OrderLimitType[symbolOrderLimit.LIMIT_TYPE] == 'VOLUME' )
//			{
//				var ezNumberFormatter:EZNumberFormatter = new EZNumberFormatter();
//				statusMsg += ezNumberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[16])) + " - "+ ezNumberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[15]));	
//			}
//			else
//			{
//				var ezCurrencyFormatter:EZCurrencyFormatter = new EZCurrencyFormatter()
//				statusMsg += ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[16])) + " - "+ ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[15]));
//			}


			WindowManager.getInstance().viewManager.liveMessages.updateStatus(statusMsg);
			windowManager.viewManager.liveMessages.txaMessages.validateNow();
			windowManager.viewManager.liveMessages.txaMessages.verticalScrollPosition=windowManager.viewManager.liveMessages.txaMessages.maxVerticalScrollPosition; // added on 2/12/2010
			messagesArray.push(statusMsg);
		}
	}
	else if (event.item == itemNameUser)
	{
		if (updateType == "2") // Market Schedule Update
		{
			messagesArray.push(statusMsg);
			WindowManager.getInstance().viewManager.liveMessages.updateStatus(statusMsg);
			windowManager.viewManager.liveMessages.txaMessages.validateNow();
			windowManager.viewManager.liveMessages.txaMessages.verticalScrollPosition=windowManager.viewManager.liveMessages.txaMessages.maxVerticalScrollPosition; // added on 2/12/2010
		}
	}
	else if ((event.item as String) && (event.item as String).indexOf("EXCHANGE_") == 0) // Exchange specific message
	{
		if (updateType == "5") // Bulletin  
		{
			var windMang:BulletinControl = WindowManager.getInstance().viewManager.bulletinControl;
			//statusMsg = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[8]).replace("T", " ");
			var exchangeCode:String=modelManager.exchangeModel.getExchangeByID(new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[9])));
			statusMsg+=' '+ResourceManager.getInstance().getString('marketwatch','bulletinForExchange')+' '+ windMang.txtExchange.text;
			statusMsg += ": " + LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[9]);
			WindowManager.getInstance().viewManager.liveMessages.updateBulletin(statusMsg);
			windowManager.viewManager.liveMessages.txaBulletins.validateNow();
			windowManager.viewManager.liveMessages.txaBulletins.verticalScrollPosition=windowManager.viewManager.liveMessages.txaBulletins.maxVerticalScrollPosition; // added on 2/12/2010
			messagesArray.push(statusMsg);
		}
	}
	else
	{
		return;
	}
//	statusMsg +="";
//	statusMsg += "</font><br />";
	//WindowManager.getInstance().viewManager.marketWatch.updateStatus(statusMsg);
//	handleMarketMessage1(itemName, itemPos, updatedFields, index - 1);
}

// Start : temp added for BlazeDS
//public function handleMarketMessageBlazeDS(event:MessageEvent):void
//{
//	var itemNameUser:String = "USER_" + modelManager.userID;
//	var itemNameMarketMessage:String = "Market_Message";
//	var statusMsg:String = "";
//	
//	var updateType:String = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[0]);
//	if (event.item == itemNameMarketMessage)
//	{
//		if (updateType == "2") // Market schedule update
//		{
//			var marketSchedule:MarketScheduleBO = new MarketScheduleBO();
//			
//			marketSchedule.INTERNAL_EXCHANGE_ID = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[1]));
//			marketSchedule.INTERNAL_MARKET_ID = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[2]));
//			
//			var stateInfo:MarketStateInfo = new MarketStateInfo();
//			stateInfo.state_ = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[6]);
//			
//			var strDateTime:String = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[7]);
//			var arrDateTime:Array = strDateTime.split("T");
//			if (arrDateTime.length < 2)
//			{
//				stateInfo.startDateTime_ = new Date();
//			}
//			else
//			{
//				var arrDate:Array = (arrDateTime[0] as String).split("-");
//				var arrTime:Array = (arrDateTime[1] as String).split(":");
//				
//				stateInfo.startDateTime_.setFullYear(new Number(arrDate[0]));
//				stateInfo.startDateTime_.setMonth(new Number(arrDate[1]));
//				stateInfo.startDateTime_.setDate(new Number(arrDate[2]));
//				stateInfo.startDateTime_.setHours(new Number(arrTime[0]));
//				stateInfo.startDateTime_.setMinutes(new Number(arrTime[1]));
//				
//				var arrSeconds:Array = (arrTime[2] as String).split(",");
//				
//				stateInfo.startDateTime_.setSeconds(new Number(arrSeconds[0]));
//			}
//			marketSchedule.SCHEDULE.addItem( stateInfo );
//			modelManager.exchangeScheduleModel.updateMarketSchedule(marketSchedule);
//			statusMsg = LSListener.extractFieldData(event, LSListener.fieldSchemaMarketMessage[8]).replace("T", " ");
//			statusMsg += " Market state is " + States.getMarketState(stateInfo.state_);
//			WindowManager.getInstance().viewManager.marketScheduleControl.updateStatus(statusMsg);
//			modelManager.exchangeModel.setMarketState(
//				marketSchedule.INTERNAL_EXCHANGE_ID,
//				marketSchedule.INTERNAL_MARKET_ID,
//				new Number(stateInfo.state_)
//			);
//			WindowManager.getInstance().viewManager.marketScheduleControl.resetFields(false);
//			WindowManager.getInstance().viewManager.marketWatch.updateStatus(statusMsg);
//			SoundManager.getInstance().playMarketStateSound();
//		}
//		
//	}
//	
//}
//
//public function handleMarketMessageFaultBlazeDS(event:MessageFaultEvent):void
//{
//	Alert.show("Message Fault : "+event.faultDetail);
//}
// End : temp added for BlazeDS