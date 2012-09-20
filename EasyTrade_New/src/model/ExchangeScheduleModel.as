package model
{
	import businessobjects.ExchangeBO;
	import businessobjects.ExchangeScheduleBO;
	import businessobjects.MarketBO;
	import businessobjects.MarketScheduleBO;
	import businessobjects.MarketStateInfo;
	import businessobjects.MarketWatchBO;
	import businessobjects.SymbolStateInfo;
	
	import common.Constants;
	import common.Messages;
	import common.States;
	
	import controller.ModelManager;
	import controller.WindowManager;
	
	import filters.Filters;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.AnnouncerClient;
	import services.QWClient;

	public class ExchangeScheduleModel implements IModel
	{
		private var isDirty_:Boolean=true;

		public function get isDirty():Boolean
		{
			return isDirty_;
		}

		public function set isDirty(value:Boolean):void
		{
			isDirty_=value;
		}


		private var allExchangeSchedule_:ArrayCollection=new ArrayCollection(); // of ExchangeScheduleBO

		[Bindable]
		public function get allExchangeSchedule():ArrayCollection
		{
			return allExchangeSchedule_;
		}

		public function set allExchangeSchedule(value:ArrayCollection):void
		{
			allExchangeSchedule_=value;
		}

		public function ExchangeScheduleModel()
		{
		}

		public function execute():void
		{
			QWClient.getInstance().getExchangesMarketsSchedules(-1);
		}

		public function executeMarketStateChange(marketStateInfo:MarketStateInfo):void
		{
			AnnouncerClient.getInstance().MarketStateChange(marketStateInfo);
		}

		public function executeSymbolStateChange(symbolStateInfo:SymbolStateInfo):void
		{
			AnnouncerClient.getInstance().SymbolStateChange(symbolStateInfo);
		}

		public function onResult(event:ResultEvent):void
		{
			var exchangeMarketsSchedules:ArrayCollection=event.result as ArrayCollection;
			var exchanges:ArrayList=ModelManager.getInstance().exchangeModel.exchanges;
			var marketCurrentState:Number=-1;
			//for (var i:int = 0; i < exchanges.length; ++i)
			for (var i:int=0; i < exchangeMarketsSchedules.length; ++i)
			{
				var exchangeScheduleBO:ExchangeScheduleBO=getExchangeSchedule(exchangeMarketsSchedules[i].exchangeID.internalID_);
				if (exchangeScheduleBO == null)
				{
					exchangeScheduleBO=new ExchangeScheduleBO();
					exchangeScheduleBO.INTERNAL_EXCHANGE_ID=exchangeMarketsSchedules[i].exchangeID.internalID_;
					exchangeScheduleBO.EXCHANGE_ID=exchangeMarketsSchedules[i].exchangeID.actualID_;
					exchangeScheduleBO.CODE=ModelManager.getInstance().exchangeModel.getExchangeCode(exchangeScheduleBO.INTERNAL_EXCHANGE_ID);
					allExchangeSchedule_.addItem(exchangeScheduleBO);
				}

				var marketScheduleBO:MarketScheduleBO=getMarketSchedule(exchangeMarketsSchedules[i].exchangeID.internalID_, exchangeMarketsSchedules[i].marketID.internalID_);

				if (marketScheduleBO == null)
				{
					marketScheduleBO=new MarketScheduleBO();
					marketScheduleBO.INTERNAL_EXCHANGE_ID=exchangeMarketsSchedules[i].exchangeID.internalID_;
					marketScheduleBO.EXCHANGE_ID=exchangeMarketsSchedules[i].exchangeID.actualID_;
					marketScheduleBO.INTERNAL_MARKET_ID=exchangeMarketsSchedules[i].marketID.internalID_;
					marketScheduleBO.MARKET_ID=exchangeMarketsSchedules[i].marketID.actualID_;
					marketScheduleBO.CODE=ModelManager.getInstance().exchangeModel.getMarketCode(marketScheduleBO.INTERNAL_EXCHANGE_ID, marketScheduleBO.INTERNAL_MARKET_ID);
					exchangeScheduleBO.SCHEDULE.addItem(marketScheduleBO);
					marketCurrentState=ModelManager.getInstance().exchangeModel.getMarketState(exchangeMarketsSchedules[i].exchangeID.internalID_, exchangeMarketsSchedules[i].marketID.internalID_);
				}

				var marketStateInfo:MarketStateInfo=new MarketStateInfo();
				marketStateInfo.exchangeID.actualID_=exchangeMarketsSchedules[i].exchangeID.actualID_;
				marketStateInfo.exchangeID.internalID_=exchangeMarketsSchedules[i].exchangeID.internalID_;
				marketStateInfo.description_=exchangeMarketsSchedules[i].description_;
				marketStateInfo.marketID.actualID_=exchangeMarketsSchedules[i].marketID.actualID_;
				marketStateInfo.marketID.internalID_=exchangeMarketsSchedules[i].marketID.internalID_;
				marketStateInfo.name_=exchangeMarketsSchedules[i].name_;
				marketStateInfo.startDateTime_=exchangeMarketsSchedules[i].startDateTime_;
				marketStateInfo.state_=exchangeMarketsSchedules[i].state_;

				if (marketCurrentState == States.MARKET_STATES[marketStateInfo.state_])
				{
					marketStateInfo.isCurrentState=true;
				}
				else
				{
					marketStateInfo.isCurrentState=false;
				}

				marketScheduleBO.SCHEDULE.addItem(marketStateInfo);
			}
			CursorManager.removeBusyCursor();
		}

		public function onMarketStateChangeResult(event:ResultEvent):void
		{
			WindowManager.getInstance().viewManager.marketScheduleControl.resetFields(false);
			CursorManager.removeBusyCursor();
		}

		public function onSymbolStateChangeResult(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
		}

		public function onFault(event:FaultEvent):void
		{
//			isDirty = true;
//			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
//			CursorManager.removeBusyCursor();
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			WindowManager.getInstance().viewManager.marketScheduleControl.resetFields(false);
			CursorManager.removeBusyCursor();
		}

		private function updateExchangeSchedule(value:ExchangeScheduleBO):void
		{
			for (var i:int=0; i < allExchangeSchedule_.length; ++i)
			{
				var exchangeScheduleBO:ExchangeScheduleBO=allExchangeSchedule_.getItemAt(i) as ExchangeScheduleBO;
				if (exchangeScheduleBO && (value.INTERNAL_EXCHANGE_ID == exchangeScheduleBO.INTERNAL_EXCHANGE_ID))
				{
					//allExchangeSchedule_.setItemAt(value, i);
					break;
				}
			}
		}

		private function getExchangeSchedule(internalExchangeID:Number):ExchangeScheduleBO
		{
			var exchangeSchedule:ExchangeScheduleBO;
			for (var i:int=0; i < allExchangeSchedule_.length; ++i)
			{
				var exchangeScheduleBO:ExchangeScheduleBO=allExchangeSchedule_.getItemAt(i) as ExchangeScheduleBO;
				if (exchangeScheduleBO && (internalExchangeID == exchangeScheduleBO.INTERNAL_EXCHANGE_ID))
				{
					exchangeSchedule=exchangeScheduleBO;
					break;
				}
			}
			return exchangeSchedule;
		}

		public function updateMarketSchedule(value:MarketScheduleBO):void
		{
			for (var i:int=0; i < allExchangeSchedule_.length; ++i)
			{
				var exchangeScheduleBO:ExchangeScheduleBO=allExchangeSchedule_.getItemAt(i) as ExchangeScheduleBO;
				if (exchangeScheduleBO && (value.INTERNAL_EXCHANGE_ID == exchangeScheduleBO.INTERNAL_EXCHANGE_ID))
				{
					for (var j:int=0; j < exchangeScheduleBO.SCHEDULE.length; ++j)
					{
						var marketScheduleBO:MarketScheduleBO=exchangeScheduleBO.SCHEDULE.getItemAt(j) as MarketScheduleBO;
						if (marketScheduleBO && (value.INTERNAL_EXCHANGE_ID == marketScheduleBO.INTERNAL_EXCHANGE_ID && value.INTERNAL_MARKET_ID == marketScheduleBO.INTERNAL_MARKET_ID))
						{
							var stateInfo:MarketStateInfo=(value.SCHEDULE.getItemAt(0) as MarketStateInfo);
							for (var k:int=0; k < marketScheduleBO.SCHEDULE.length; ++k)
							{
								var msi:MarketStateInfo=(marketScheduleBO.SCHEDULE.getItemAt(k) as MarketStateInfo);
								if (stateInfo.state_ == States.MARKET_STATES[msi.state_])
								{
									msi.startDateTime_=stateInfo.startDateTime_;
									msi.isCurrentState=true;
										//this break is removed to traverse all msi in market schedule and set isCurrentState to false
										//break;
								}
								else
								{
									msi.isCurrentState=false;
								}
							}
						}
					}
				}
			}
		}

		public function getMarketSchedule(internalExchangeID:Number, internalMarketID:Number):MarketScheduleBO
		{
			var marketSchedule:MarketScheduleBO;
			for (var i:int=0; i < allExchangeSchedule_.length; ++i)
			{
				var exchangeScheduleBO:ExchangeScheduleBO=allExchangeSchedule_.getItemAt(i) as ExchangeScheduleBO;
				if (exchangeScheduleBO && (internalExchangeID == exchangeScheduleBO.INTERNAL_EXCHANGE_ID))
				{
					//var exchangeSchedule:ArrayCollection = exchangeScheduleBO.SCHEDULE;
					for (var j:int=0; j < exchangeScheduleBO.SCHEDULE.length; ++j)
					{
						var marketScheduleBO:MarketScheduleBO=exchangeScheduleBO.SCHEDULE.getItemAt(j) as MarketScheduleBO;
						if (marketScheduleBO && (internalExchangeID == marketScheduleBO.INTERNAL_EXCHANGE_ID && internalMarketID == marketScheduleBO.INTERNAL_MARKET_ID))
						{
							marketSchedule=marketScheduleBO;
							break;
						}
					}
				}
			}
			return marketSchedule;
		}

		// added on 24/3/2011 

		public function getCurrentMarketSchedule(internalExchangeID:Number, internalMarketID:Number):String
		{
			var currentState:String="";
			for (var i:int=0; i < allExchangeSchedule_.length; ++i)
			{
				var exchangeScheduleBO:ExchangeScheduleBO=allExchangeSchedule_.getItemAt(i) as ExchangeScheduleBO;
				if (exchangeScheduleBO && (internalExchangeID == exchangeScheduleBO.INTERNAL_EXCHANGE_ID))
				{
					for (var j:int=0; j < exchangeScheduleBO.SCHEDULE.length; ++j)
					{
						var marketScheduleBO:MarketScheduleBO=exchangeScheduleBO.SCHEDULE.getItemAt(j) as MarketScheduleBO;
						if (marketScheduleBO && (internalExchangeID == marketScheduleBO.INTERNAL_EXCHANGE_ID && internalMarketID == marketScheduleBO.INTERNAL_MARKET_ID))
						{
							//var stateInfo:MarketStateInfo = (value.SCHEDULE.getItemAt(0) as MarketStateInfo);
							for (var k:int=0; k < marketScheduleBO.SCHEDULE.length; ++k)
							{
								var msi:MarketStateInfo=(marketScheduleBO.SCHEDULE.getItemAt(k) as MarketStateInfo);
								if (msi.isCurrentState)
								{
									currentState=msi.state_;
									break;
								}
							}
						}
					}
				}
			}

			return currentState;
		}
	}
}
