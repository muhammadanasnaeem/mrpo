
import businessobjects.BestMarketAndSymbolSummaryBO;
import businessobjects.BestMarketBO;
import businessobjects.BondBO;
import businessobjects.MarketWatchBO;
import businessobjects.OrderBO;
import businessobjects.QuickOrdersBO;
import businessobjects.SymbolSummaryBO;
import businessobjects.YieldBO;

import com.lightstreamer.as_client.ConnectionInfo;
import com.lightstreamer.as_client.LSClient;
import com.lightstreamer.as_client.NonVisualTable;
import com.lightstreamer.as_client.events.NonVisualItemUpdateEvent;

import common.Constants;
import common.HashMap;
import common.Messages;

import components.ComboBoxItem;
import components.EZCurrencyFormatter;
import components.EZDropDownTextInput;
import components.EZNumberFormatter;

import controller.ModelManager;
import controller.ViewManager;
import controller.WindowManager;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;

import flexlib.mdi.containers.MDIWindow;

import mx.charts.chartClasses.InstanceCache;
import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.controls.ComboBox;
import mx.controls.DateField;
import mx.controls.List;
import mx.core.IVisualElement;
import mx.events.FlexEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.resources.ResourceManager;

import services.LSListener;
import services.QWClient;

import spark.components.DropDownList;
import spark.components.RadioButton;
import spark.components.RadioButtonGroup;
import spark.components.TextInput;
import spark.components.supportClasses.SkinnableTextBase;
import spark.events.IndexChangeEvent;
import spark.events.TextOperationEvent;

import view.Order;

[Bindable]
[Embed(source='../../images/expander.png')]
public static var IMG_EXPANDER:Class;

[Bindable]
private var orderType:ArrayList=new ArrayList([new ComboBoxItem("", ""), new ComboBoxItem("SL", "SL"), new ComboBoxItem("MIT", "MIT"),]);


[Bindable]
private var sellShort:ArrayList=new ArrayList([new ComboBoxItem("0", "true"), new ComboBoxItem("1", "false")]);

[Bindable]
public var side:String="";


[Bindable]
public var userId:Number=-1;


[Bindable]
private var tradersList:ArrayCollection=new ArrayCollection();

public var isFirstSubmission:Boolean=true;
public var isSymbolDataFetched:Boolean=false;
public var isFromMenu:Boolean=false;

public var baseRate:Number=0;
public var maturityDate:Date=new Date();
public var issueDate:Date=new Date();
public var nextCouponDate:Date=new Date();
public var fetchBestMarket:Boolean=false;

//negotiated trade
public var COUNTER_CLIENT_ID:Number=-1;
public var COUNTER_ORDER_NO:Number=-1;
public var COUNTER_USER_ID:Number=-1;
public var CLIENT_ID:Number=-1;
public var NTType:String="";
public var IS_ORDER_NO_SWAPPED:Boolean=false;

public function group1_initializeHandler(event:FlexEvent):void
{
	// added on 14/1/2011
	exchangeList.removeAll();
	for (var i:int=0; i < ModelManager.getInstance().exchangeModel.exchanges.length; ++i)
	{
		var obj:Object=ModelManager.getInstance().exchangeModel.exchanges.getItemAt(i);
		//var cbi:ComboBoxItem = new ComboBoxItem(obj.EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		var cbi:ComboBoxItem=new ComboBoxItem(obj.INTERNAL_EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		exchangeList.addItem(cbi);
	}
	//exchangeID = -1;
	if (event)
	{
		internalExchangeID=-1;
		internalMarketID=-1;
		internalSymbolID=-1;
		symbolID=-1;
	}
	isFirstSubmission=true;
	isSymbolDataFetched=false;
	//isFromMenu = false;
	// commented on 11/1/2011
	//	for (var j:int = 0; j < numElements; ++j)
	//	{
	//		var el:IVisualElement = getElementAt(j);
	//		if (el is TextInput)
	//		{
	//			if ( !event &&
	//				(
	//					( (el as TextInput).id == txtExchange.id) ||
	//					( (el as TextInput).id == txtMarket.id) ||
	//					( (el as TextInput).id == txtSymbol.id)
	//				)
	//			)
	//			{
	//			}
	//			else// if ( ( el as TextInput).editable || (el as TextInput).id == txtMsg.id )
	//			{
	//				(el as TextInput).text = "";
	//			}
	//		}
	//		else if (el is DropDownList)
	//		{
	//			(el as DropDownList).selectedIndex = -1;
	//			(el as DropDownList).selectedItem = null;
	//		}
	//		else if (el is DateField)
	//		{
	//			(el as DateField).currentState = null;
	//		}
	//	}
	clearForm();
}

// added on 11/1/2011
public function clearForm():void
{
	try
	{
		for (var j:int=0; j < bcMain.numElements; ++j)
		{
			var el:IVisualElement=bcMain.getElementAt(j);
			clearElement(el);
		}
		
		for (var k:int=0; k < grpFields.numElements; ++k)
		{
			var grpEl:IVisualElement=grpFields.getElementAt(k);
			clearElement(grpEl);
		}
		if (grpBond != null)
		{
			for (var l:int=0; l < grpBond.numElements; ++l)
			{
				var grpBondEl:IVisualElement=grpBond.getElementAt(l);
				clearElement(grpBondEl);
			}
		}
		if (txtCounterPartyClientCode)
		{
			txtCounterPartyClientCode.text="";
		}
		if (txtCounterPartyUserName)
		{
			txtCounterPartyUserName.text="";
		}
		ModelManager.getInstance().buyFlag = true;
		ModelManager.getInstance().sellFlag = true;
	}
	
	catch (e:Error)
	{
		trace("Exception Caught");
	}
}

private function clearElement(el:IVisualElement):void
{
	if (el is TextInput)
	{
		if ((((el as TextInput).id == txtExchange.id) || ((el as TextInput).id == txtMarket.id) || ((el as TextInput).id == txtSymbol.id)))
		{
		}
		else // if ( ( el as TextInput).editable || (el as TextInput).id == txtMsg.id )
		{
			(el as TextInput).text="";
		}
		
		
	}
	else if (el is DropDownList)
	{
		(el as DropDownList).selectedIndex=-1;
		(el as DropDownList).selectedItem=null;
	}
		
		// added on 30/3/2011
	else if (el is ComboBox)
	{
		(el as ComboBox).selectedIndex=-1;
		(el as ComboBox).selectedItem=null;
	}
		
	else if (el is DateField)
	{
		(el as DateField).selectedDate=null;
	}
}

public function txtSymbol_focusOutHandler(event:FocusEvent):void
{
	if (txtSymbol.text.length == 0)
	{
		return;
	}
	
	var modelManager:ModelManager=ModelManager.getInstance();
//	txtSymbol.text=txtSymbol.text.toUpperCase();
	if (!isSymbolDataFetched)
	{
		/*var internalSymbolID:Number = modelManager.exchangeModel.getInternalSymbolIDByCode(
		internalExchangeID,
		internalMarketID,
		txtSymbol.text
		);*/
		var frmTxtFld:Boolean=true;
//		var obj:Object=modelManager.exchangeModel.getSymbolByCode(internalExchangeID, internalMarketID, txtSymbol.text,frmTxtFld);
		
		internalSymbolID=-1;
//		if (obj)
//		{
//			internalSymbolID=obj.INTERNAL_SYMBOL_ID;
//		}
//		
//		if (obj && obj.hasOwnProperty("SYMBOL_TYPE") && obj.SYMBOL_TYPE == "Bond")
//		{
//			txtCouponRate.text=(obj as BondBO).couponRate.toString();
//			var dateFormatter:DateFormatter=new DateFormatter();
//			dateFormatter.formatString="DD/MM/YYYY";
//			txtNextCoupon.text=dateFormatter.format((obj as BondBO).issueDate);
//			txtMaturityDate.text=dateFormatter.format((obj as BondBO).maturityDate);
//			nextCouponDate=(obj as BondBO).nextCouponDate;
//			issueDate=(obj as BondBO).issueDate;
//			maturityDate=(obj as BondBO).maturityDate;
//			baseRate=(obj as BondBO).baseRate;
//		}
		
		if (internalSymbolID < 0)
		{
			txtMsg.text=ResourceManager.getInstance().getString('marketwatch','invalidSymbol');
			txtSymbol.text="";
			return;
		}
		//modelManager.getBestMarketAndSymbolSummaryByName( internalExchangeID, internalMarketID, txtSymbol.text);
		// added on 10/12/2010
		var symbolID:Number=modelManager.exchangeModel.getSymbolID(internalExchangeID, internalMarketID, internalSymbolID);
		if (symbolID < 0)
		{
			txtMsg.text=ResourceManager.getInstance().getString('marketwatch','invalidSymbol');;
			txtSymbol.text="";
			return;
		}
		else
		{
			txtMsg.text="";
		}
		// Start : modified on 11/1/2011 to stop request to fetch best market data
		//modelManager.getBestMarketAndSymbolSummary( internalExchangeID, internalMarketID, symbolID,txtSymbol.text);
		var mwbo:MarketWatchBO=modelManager.marketWatchModel.getMarketWatchBO(internalExchangeID, internalMarketID, txtSymbol.text);
		if (mwbo)
		{
			updateBestMarketOrderFieldsByMWBO(mwbo);
			updateSymbolStatsOrderFieldsByMWBO(mwbo);
		}
		else
		{
			modelManager.getBestMarketAndSymbolSummary(internalExchangeID, internalMarketID, symbolID, txtSymbol.text);
		}
		// End : modified on 11/1/2011 to stop request to fetch best market data
		// modified on 20/12/2010
		//isSymbolDataFetched = true;
	}
}

/**
 * Reset Order View
 */
public function updateBestMarketOrderFieldsByMWBO(mwbo:MarketWatchBO):void
{
	try
	{
		if (txtBuy)
		{
			txtBuy.text=moneyFormatter.format(mwbo.BUY);
		}
		if (txtBuyVolume)
		{
			txtBuyVolume.text=mwbo.BUY_VOLUME;
		}
		if (txtSell)
		{
			txtSell.text=moneyFormatter.format(mwbo.SELL);
		}
		if (txtSellVolume)
		{
			txtSellVolume.text=mwbo.SELL_VOLUME;
		}
		
		// Start added on 27/1/2011 to update Bid (Price / Yield) and Ask (Price / Yield) fields 
		
		txtBondAskPrice.text=txtSell.text;
		if ((txtBondAskPrice.text.length > 0 && txtBondAskPrice.text != "0") && (txtCouponRate.text.length > 0))
		{
			txtBondAskYield.text=moneyFormatter.format(calculateCurrentYield(new Number(txtBondAskPrice.text), new Number(txtCouponRate.text)).toString());
		}
		txtBondBidPrice.text=txtBuy.text;
		if ((txtBondBidPrice.text.length > 0 && txtBondBidPrice.text != "0") && (txtCouponRate.text.length > 0))
		{
			txtBondBidYield.text=moneyFormatter.format(calculateCurrentYield(new Number(txtBondBidPrice.text), new Number(txtCouponRate.text)).toString());
		}
	}
	catch (e:Error)
	{
		trace(e.errorID + '  ' + e.message);
	}
	
	// End added on 27/1/2011 to update Bid (Price / Yield) and Ask (Price / Yield) fields
}

public function updateSymbolStatsOrderFieldsByMWBO(mwbo:MarketWatchBO):void
{
	if (txtLast)
	{
		txtLast.text=moneyFormatter.format(mwbo.LAST);
		txtCurrent.text=moneyFormatter.format(mwbo.LAST);
	}
	if (txtChange)
	{
		txtChange.text=moneyFormatter.format(mwbo.CHANGE);
	}
	if (txtTurnOver)
	{
		txtTurnOver.text=numberFormatter.format(mwbo.TURN_OVER);
	}
	if (txtOpen)
	{
		txtOpen.text=moneyFormatter.format(mwbo.OPEN);
	}
	if (txtLow)
	{
		txtLow.text=moneyFormatter.format(mwbo.LOW);
	}
	if (txtHigh)
	{
		txtHigh.text=moneyFormatter.format(mwbo.HIGH);
	}
}

public function updateBestMarketAndSymbolStats():void
{
	
	var mwbo:MarketWatchBO=ModelManager.getInstance().marketWatchModel.getMarketWatchBO(internalExchangeID, internalMarketID, txtSymbol.text);
	if (mwbo)
	{
		updateBestMarketOrderFieldsByMWBO(mwbo);
		updateSymbolStatsOrderFieldsByMWBO(mwbo);
	}
	else
	{
		ModelManager.getInstance().getBestMarketAndSymbolSummary(internalExchangeID, internalMarketID, symbolID, txtSymbol.text);
	}
}

protected function txtSymbol_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 13)
	{
		event.stopImmediatePropagation();
		txtSymbol_focusOutHandler(null);
	}
}

protected function orderChangeHandler(event:TextOperationEvent):void
{
	isFirstSubmission=true;
	if (event.currentTarget == txtSymbol)
	{
		isSymbolDataFetched=false;
	}
	
	if(event.currentTarget.id == "txtPrice" && txtPrice.text != "" && txtPrice.text != "0") 
	{
		txtCalculatedYield.text = moneyFormatter.format(calculateCurrentYield(new Number(txtPrice.text), new Number(txtCouponRate.text)).toString());

		if (internalExchangeID > -1 && internalMarketID > -1 && internalSymbolID > -1)
		{
			var obj:Object=ModelManager.getInstance().exchangeModel.getSymbol(internalExchangeID, internalMarketID, internalSymbolID);
			if (obj.hasOwnProperty("SYMBOL_TYPE") && obj.SYMBOL_TYPE == "Bond")
			{
				var bondBO:BondBO=obj as BondBO;
				var yield:YieldBO=new YieldBO();
				
				yield.discountRate=new Number(bondBO.discountRate);
				yield.effectiveBaseRate=new Number(bondBO.baseRate);
				yield.spread=new Number(bondBO.spreadRate);
				yield.exchangeId=new Number(internalExchangeID);
				yield.marketId=new Number(internalMarketID);
				yield.symbolId=new Number(internalSymbolID);
				yield.couponRate=new Number(txtCouponRate.text);
				yield.currentRate=new Number(txtPrice.text);
				
				yield.nextCouponDate=nextCouponDate;
				yield.nextCouponDate.seconds = 1;
				yield.issueDate=issueDate;
				yield.issueDate.seconds = 1;
				yield.maturityDate=maturityDate;
				yield.maturityDate.seconds = 1;
				
				yield.rate=0;
				yield.currentYield=0;
				//QWClient.getInstance().calculateYieldFromBuyOrderWindow(yield);
			}
		}
	}
	else
	{
		trace('');
	}
}

public function updateOrderView(bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO):void
{
	if (txtSymbol && bestMarketAndSymbolSummary.symbolName == txtSymbol.text && bestMarketAndSymbolSummary.exchangeId == ModelManager.getInstance().exchangeModel.getExchangeID(internalExchangeID) && bestMarketAndSymbolSummary.marketId == ModelManager.getInstance().exchangeModel.getMarketID(internalExchangeID, internalMarketID))
	{
		if (bestMarketAndSymbolSummary.symbolSummary && bestMarketAndSymbolSummary.symbolSummary.stats)
		{
			txtLast.text=moneyFormatter.format(bestMarketAndSymbolSummary.symbolSummary.stats.lastTradePrice.toString());
			txtCurrent.text=moneyFormatter.format(bestMarketAndSymbolSummary.symbolSummary.stats.lastTradePrice.toString());
			txtChange.text=moneyFormatter.format(bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString());
			txtTurnOver.text=numberFormatter.format(bestMarketAndSymbolSummary.symbolSummary.stats.turnover.toString());
			txtOpen.text=moneyFormatter.format(bestMarketAndSymbolSummary.symbolSummary.stats.open.toString());
			txtLow.text=moneyFormatter.format(bestMarketAndSymbolSummary.symbolSummary.stats.low.toString());
			txtHigh.text=moneyFormatter.format(bestMarketAndSymbolSummary.symbolSummary.stats.high.toString());
		}
		else
		{
			txtLast.text="";
			txtCurrent.text="";
			txtChange.text="";
			txtTurnOver.text="";
			txtOpen.text="";
			txtLow.text="";
			txtHigh.text="";
		}
		txtBondAskPrice.text="";
		txtBondBidPrice.text="";
		if (bestMarketAndSymbolSummary.bestMarket)
		{
			if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO)
			{
				if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE > -1)
				{
					txtBuy.text=moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE.toString());
					//					//added on 20/12/2010
					//					if(ViewManager.getInstance().buyOrder == this)
					//						txtPrice.text = moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE.toString());					
				}
				else
				{
					txtBuy.text="";
					//					//added on 20/12/2010
					//					if(ViewManager.getInstance().buyOrder == this)
					//						txtPrice.text = "";
				}
				if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO.VOLUME > -1)
				{
					txtBuyVolume.text=bestMarketAndSymbolSummary.bestMarket.buyOrderBO.VOLUME.toString();
				}
				else
				{
					txtBuyVolume.text="";
				}
			}
			else
			{
				txtBuy.text="";
				txtBuyVolume.text="";
			}
			if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO)
			{
				if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE > -1)
				{
					txtSell.text=moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE.toString());
					//					//added on 20/12/2010
					//					if(ViewManager.getInstance().sellOrder == this)
					//						txtPrice.text = moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE.toString());
				}
				else
				{
					txtSell.text="";
					//					//added on 20/12/2010
					//					if(ViewManager.getInstance().sellOrder == this)
					//						txtPrice.text = "";
				}
				if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO.VOLUME > -1)
				{
					txtSellVolume.text=bestMarketAndSymbolSummary.bestMarket.sellOrderBO.VOLUME.toString();
				}
				else
				{
					txtSellVolume.text="";
				}
			}
			else
			{
				txtSell.text="";
				txtSellVolume.text="";
			}
			txtBondAskPrice.text=moneyFormatter.format(txtSell.text);
			if ((txtBondAskPrice.text.length > 0 && txtBondAskPrice.text != "0") && (txtCouponRate.text.length > 0))
			{
				txtBondAskYield.text=moneyFormatter.format(calculateCurrentYield(new Number(txtBondAskPrice.text), new Number(txtCouponRate.text)).toString());
			}
			txtBondBidPrice.text=moneyFormatter.format(txtBuy.text);
			if ((txtBondBidPrice.text.length > 0 && txtBondBidPrice.text != "0") && (txtCouponRate.text.length > 0))
			{
				txtBondBidYield.text=moneyFormatter.format(calculateCurrentYield(new Number(txtBondBidPrice.text), new Number(txtCouponRate.text)).toString());

				if (internalExchangeID > -1 && internalMarketID > -1 && internalSymbolID > -1)
				{
					var obj:Object=ModelManager.getInstance().exchangeModel.getSymbol(internalExchangeID, internalMarketID, internalSymbolID);
					if (obj.hasOwnProperty("SYMBOL_TYPE") && obj.SYMBOL_TYPE == "Bond")
					{
						var bondBO:BondBO=obj as BondBO;
						var yield:YieldBO=new YieldBO();
						
						yield.discountRate=new Number(bondBO.discountRate);
						yield.effectiveBaseRate=new Number(bondBO.baseRate);
						yield.spread=new Number(bondBO.spreadRate);
						yield.exchangeId=new Number(internalExchangeID);
						yield.marketId=new Number(internalMarketID);
						yield.symbolId=new Number(internalSymbolID);
						yield.couponRate=new Number(txtCouponRate.text);
						yield.currentRate=new Number(txtBondBidPrice.text);
						
						yield.nextCouponDate=nextCouponDate;
						yield.nextCouponDate.seconds = 1;
						yield.issueDate=issueDate;
						yield.issueDate.seconds = 1;
						yield.maturityDate=maturityDate;
						yield.maturityDate.seconds = 1;
						
						yield.rate=0;
						yield.currentYield=0;
						
						//QWClient.getInstance().calculateYieldFromBuyOrderWindowUsingBestMarket(yield);
					}
				}
				
				//for best Offer or sell yield calculation 
				
				if (internalExchangeID > -1 && internalMarketID > -1 && internalSymbolID > -1 && (txtBondAskPrice.text.length > 0 && txtBondAskPrice.text != "0"))
				{
					txtBondAskYield.text=moneyFormatter.format(calculateCurrentYield(new Number(txtBondAskPrice.text), new Number(txtCouponRate.text)).toString());

					var obj2:Object=ModelManager.getInstance().exchangeModel.getSymbol(internalExchangeID, internalMarketID, internalSymbolID);
					if (obj2.hasOwnProperty("SYMBOL_TYPE") && obj.SYMBOL_TYPE == "Bond")
					{
						var bondBO2:BondBO=obj as BondBO;
						var yield2:YieldBO=new YieldBO();
						
						yield2.discountRate=new Number(bondBO2.discountRate);
						yield2.effectiveBaseRate=new Number(bondBO2.baseRate);
						yield2.spread=new Number(bondBO2.spreadRate);
						yield2.exchangeId=new Number(internalExchangeID);
						yield2.marketId=new Number(internalMarketID);
						yield2.symbolId=new Number(internalSymbolID);
						yield2.couponRate=new Number(txtCouponRate.text);
						yield2.currentRate=new Number(txtBondAskPrice.text);
						
						yield2.nextCouponDate=nextCouponDate;
						yield2.nextCouponDate.seconds = 1;
						yield2.issueDate=issueDate;
						yield2.issueDate.seconds = 1;
						yield2.maturityDate=maturityDate;
						yield2.maturityDate.seconds = 1;
						
						yield2.rate=0;
						yield2.currentYield=0;
						
						//QWClient.getInstance().calculateYieldFromBuyOrderWindowUsingBestMarketSell(yield2);
					}
				}
			}
		}
	}
}

private function calculateCurrentYield(currentPrice:Number, couponRate:Number):Number
{
	return (couponRate / currentPrice) * 100;
}

public function disableFields(isCancelOrder:Boolean):void
{
	try
	{
		if (chkNgtd)
		{
			chkNgtd.enabled=false;
		}
		if (isCancelOrder)
		{
			for (var j:int=0; j < bcMain.numElements; ++j)
			{
				var el:IVisualElement=bcMain.getElementAt(j);
				disableElement(el);
			}
			
			for (var k:int=0; k < grpFields.numElements; ++k)
			{
				var grpEl:IVisualElement=grpFields.getElementAt(k);
				disableElement(grpEl);
			}
			
			//		for (var l:int = 0; l < grpBond.numElements; ++l)
			//		{
			//			var grpBondEl:IVisualElement = grpBond.getElementAt(l);
			//			disableElement(grpBondEl);
			//		}
			if (txtOrderNum)
			{
				txtOrderNum.enabled=true;
				txtOrderNum.editable=true;
			}
		}
		else
		{
			if (isFromMenu)
			{
				if (txtOrderNum)
				{
					txtOrderNum.enabled=true;
					txtOrderNum.editable=true;
				}
			}
			else
			{
				if (txtOrderNum)
				{
					txtOrderNum.enabled=false;
					txtOrderNum.editable=false;
				}
			}
			if (txtAccount)
			{
				txtAccount.enabled=false;
				txtAccount.editable=false;
			}
			if (txtExchange)
			{
				txtExchange.enabled=false;
			}
			if (txtMarket)
			{
				txtMarket.enabled=false;
			}
			if (txtSymbol)
			{
				txtSymbol.enabled=false;
			}
			if (trader)
			{
				trader.enabled=false;
			}
			if (ddType)
			{
				ddType.enabled=false;
			}
//			isFromMenu = false;
		}
	}
	catch (e:Error)
	{
		trace('' + e.errorID + '' + e.message + '' + e.name);
	}
}

private function disableElement(el:IVisualElement):void
{
	if (el is TextInput)
	{
		(el as TextInput).text="";
		if ((el as TextInput).editable)
		{
			(el as TextInput).enabled=false;
		}
	}
	else if (el is DropDownList)
	{
		(el as DropDownList).selectedIndex=-1;
		(el as DropDownList).selectedItem=null;
		(el as DropDownList).enabled=false;
	}
		
		// added on 30/3/2011
	else if (el is ComboBox)
	{
		(el as ComboBox).selectedIndex=-1;
		(el as ComboBox).selectedItem=null;
		(el as ComboBox).enabled=false;
	}
		
	else if (el is DateField)
	{
		(el as DateField).text="";
		(el as DateField).currentState=null;
		(el as DateField).enabled=false;
	}
		
	else if (el is RadioButton)
	{
		(el as RadioButton).enabled=false;
	}
	else if (el is EZDropDownTextInput)
	{
		(el as EZDropDownTextInput).enabled=false;
	}
	
}

protected function txtOrderNum_changeHandler(event:TextOperationEvent):void
{
	isFirstSubmission=true;
}

protected function txtOrderNum_keyDownHandler(event:KeyboardEvent):void
{
	ModelManager.getInstance().updateRemainingOrders();
	if (event.keyCode == 9 || event.keyCode == 13)
	{
		// added on 4/3/2011
		if (event.currentTarget.editable)
		{
			if (isFirstSubmission)
			{
				//isFirstSubmission = false;
				var orderBO:OrderBO=ModelManager.getInstance().remainingOrdersModel.getOrderBOByOrderNumber(new Number(txtOrderNum.text));
				if (orderBO)
				{
					updateOrderViewByOrderBO(orderBO);
				}
				else
				{
					//if (!isFromMenu)
					//{
					// modified on 5/1/2011				
					//reset();
					ModelManager.getInstance().remainingOrdersModel.isFromOrderView=true;
					ModelManager.getInstance().remainingOrdersModel.orderView=this;
					ModelManager.getInstance().remainingOrdersModel.execute();
					//}
				}
				if (isFromMenu)
				{
//					event.stopImmediatePropagation();
				}
			}
		}
	}
}

/////////////////////////////

public function txtOrderNum_keyDownHandler1(event:MouseEvent):void
{
	ModelManager.getInstance().updateRemainingOrders();
	if (event != null )
	{
		// added on 4/3/2011
//		if (event.currentTarget.editable)
//		{
			if (isFirstSubmission)
			{
				//isFirstSubmission = false;
				var orderBO:OrderBO=ModelManager.getInstance().remainingOrdersModel.getOrderBOByOrderNumber(new Number(txtOrderNum.text));
				if (orderBO)
				{
					updateOrderViewByOrderBO(orderBO);
				}
				else
				{
					//if (!isFromMenu)
					//{
					// modified on 5/1/2011				
					//reset();
					ModelManager.getInstance().remainingOrdersModel.isFromOrderView=true;
					ModelManager.getInstance().remainingOrdersModel.orderView=this;
					ModelManager.getInstance().remainingOrdersModel.execute();
					//}
				}
				if (isFromMenu)
				{
					//					event.stopImmediatePropagation();
				}
			}
//		}
	}
}

// added on 5/1/2011
public function updateOrderViewAfterRefetch():void
{
	var orderBO:OrderBO=ModelManager.getInstance().remainingOrdersModel.getOrderBOByOrderNumber(new Number(txtOrderNum.text));
	if (orderBO)
	{
		updateOrderViewByOrderBO(orderBO);
	}
	else
	{
		//reset();
		clearForm();
		txtExchange.text="";
		txtMarket.text="";
		txtSymbol.text="";
		internalExchangeID=-1;
		internalMarketID=-1;
		internalSymbolID=-1;
		symbolID=-1;
		txtMsg.text=ResourceManager.getInstance().getString('marketwatch','plzCorrctInpt');
	}
}

// added on 5/1/2011
private function updateOrderViewByOrderBO(orderBO:OrderBO):void
{
	//*************************//
	var window:MDIWindow=null;
	var orderVeiw:Order=null;
	var windowManager:WindowManager=WindowManager.getInstance();
	var modelManager:ModelManager=ModelManager.getInstance();
	var ob:OrderBO=orderBO;
	var g:Object=null;
	var foundUser:Boolean=false;
	for each (g in modelManager.userProfileModel.userProfile.grants)
	{
		if (ob.USER_ID == g.userId)
		{
			foundUser=true;
			break;
		}
	}
	
	if (!foundUser)
	{
		if ((ob.USER_ID != modelManager.userID) && (ob.IS_NEGOTIATED && ob.COUNTER_USER_ID != modelManager.userID))
		{
			return;
		}
	}
	//*************************//
	
	var backgroundColor:uint=0;
	if (orderBO.SIDE == "buy")
	{
		backgroundColor=Constants.BUY_COLOR_INT;
	}
	else
	{
		backgroundColor=Constants.SELL_COLOR_INT;
	}
	if ((this.parent as MDIWindow) && (this.parent as MDIWindow).id == Constants.CHANGE_ORDER_WINDOW_ID)
	{
		
		//*************************//
		if (foundUser)
		{
			var hasChangePrivilege:Boolean=false;
			var gs2:ArrayCollection=modelManager.userProfileModel.userProfile.grants;
			for each (var p2:Object in gs2)
			{
				for each (var s2:String in p2.privileges)
				{
					if (s2 == "ChangeOrder")
					{
						hasChangePrivilege=true;
					}
				}
			}
			if (!hasChangePrivilege)
			{
				return;
			}
		}
		//if (ob.IS_NEGOTIATED && (ob.USER_ID == modelManager.userID))
		if (ob.IS_NEGOTIATED && (ob.USER_ID == modelManager.userID && ob.USER_ID != ob.COUNTER_USER_ID))
		{
			return;
		}
		//*************************//
		
		WindowManager.getInstance().changeOrderWindow.setStyle("backgroundColor", backgroundColor);
		WindowManager.getInstance().updateChangeOrderWindow(orderBO);
		
		//*************************//
		window=windowManager.changeOrderWindow;
		orderVeiw=windowManager.viewManager.changeOrder;
		orderVeiw.COUNTER_CLIENT_ID=orderBO.COUNTER_CLIENT_ID;
		orderVeiw.COUNTER_ORDER_NO=orderBO.COUNTER_ORDER_NO;
		orderVeiw.COUNTER_USER_ID=orderBO.COUNTER_USER_ID;
		orderVeiw.NTType="Accepted";
		orderVeiw.focusManager.setFocus(orderVeiw.txtPrice);
		//*************************//
		
	}
	else if ((this.parent as MDIWindow) && (this.parent as MDIWindow).id == Constants.CANCEL_ORDER_WINDOW_ID)
	{
		//*************************//
		if (foundUser)
		{
			var hasCancelPrivilege:Boolean=false;
			var gs1:ArrayCollection=modelManager.userProfileModel.userProfile.grants;
			for each (var p1:Object in gs1)
			{
				for each (var s1:String in p1.privileges)
				{
					if (s1 == "CancelOrder")
					{
						hasCancelPrivilege=true;
					}
				}
			}
			if (!hasCancelPrivilege)
			{
				return;
			}
		}
		//*************************//
		
		WindowManager.getInstance().updateCancelOrderWindow(orderBO);
		WindowManager.getInstance().cancelOrderWindow.setStyle("backgroundColor", backgroundColor);
		
		//*************************//
		window=windowManager.cancelOrderWindow;
		orderVeiw=windowManager.viewManager.cancelOrder;
		orderVeiw.COUNTER_CLIENT_ID=orderBO.COUNTER_CLIENT_ID;
		orderVeiw.COUNTER_ORDER_NO=orderBO.COUNTER_ORDER_NO;
		orderVeiw.COUNTER_USER_ID=orderBO.COUNTER_USER_ID;
		orderVeiw.CLIENT_ID=orderBO.CLIENT_ID;
		orderVeiw.NTType="Rejected";
		orderVeiw.focusManager.setFocus(orderVeiw.txtOrderNum);
		//*************************//
		
	}
	
	this.opaqueBackground=backgroundColor;
	// added on 4/1/2011
	ModelManager.getInstance().orderModel.REF_NO=orderBO.REF_NO;
	// added on 12/1/2011
	ModelManager.getInstance().orderModel.CLIENT_ID=orderBO.CLIENT_ID;
	
	//*************************//
	// added on 4/1/2011
	modelManager.orderModel.REF_NO=orderBO.REF_NO;
	// added on 12/1/2011
	modelManager.orderModel.CLIENT_ID=orderBO.CLIENT_ID;
	modelManager.orderModel.USER_ID=orderBO.USER_ID;
	modelManager.orderModel.BROKER_ID=orderBO.BROKER_ID;
	
	if (window != null)
	{
		if (ob.IS_NEGOTIATED)
		{
			orderVeiw.enableFields(false);
			orderVeiw.enableNegotiatedTradePanel();
			orderVeiw.enableCounterClientID();
			orderVeiw.setFocusToCounterClientID();
		}
		else
		{
			orderVeiw.disableNegotiatedTradePanel();
		}
		if (orderBO.SIDE == "buy")
		{
			windowManager.setWindowColor(window, orderVeiw, Constants.BUY_COLOR_INT);
		}
		else
		{
			windowManager.setWindowColor(window, orderVeiw, Constants.SELL_COLOR_INT);
		}
	}
	//*************************//
	
}

protected function numberInput_focusOutHandler(event:FocusEvent):void
{
	if ((event.currentTarget as TextInput) === txtPrice || (event.currentTarget as TextInput) === txtTriggerPrice)
	{
		(event.currentTarget as TextInput).text=moneyFormatter.format((event.currentTarget as TextInput).text);
	}
	else
	{
		(event.currentTarget as TextInput).text=numberFormatter.format((event.currentTarget as TextInput).text);
	}
}

public function applyFilter():void
{
}
public var window:MDIWindow;

private var isBondPanelExpanded:Boolean=false;
public var isNgtdPanelExpanded:Boolean=false;

[Bindable]
private var pnlHeightMax:Number=80;
[Bindable]
private var pnlHeightMin:Number=15;
[Bindable]
private var pnlHeightDelta:Number=pnlHeightMax - pnlHeightMin;

[Bindable]
private var pnlngtdHeightMax:Number=30;
[Bindable]
private var pnlngtdHeightMin:Number=0;
[Bindable]
private var pnlngtdHeightDelta:Number=pnlngtdHeightMax - pnlngtdHeightMin;

[Bindable]
private var bondPanelHeightMin:Number=34;

[Bindable]
private var bondPanelHeightMax:Number=100;

[Bindable]
private var bondPanelBottomRulePositionNormal:Number=196;

[Bindable]
private var bondPanelBottomRulePositionExpanded:Number=262;

[Bindable]
private var marketDataTitlePositionNormal:Number=206;

[Bindable]
private var marketDataTitlePositionExpaded:Number=271;

[Bindable]
private var marketDataTopLeftRulePositionNormal:Number=211;

[Bindable]
private var marketDataTopLeftRulePositionExpanded:Number=276;

[Bindable]
private var marketDataTopRightRulePositionNormal:Number=208;

[Bindable]
private var marketDataTopRightRulePositionExpanded:Number=273;

[Bindable]
private var marketDataLeftRulePositionNormal:Number=211;

[Bindable]
private var marketDataLeftRulePositionExpanded:Number=276;

[Bindable]
private var marketDataRightRulePositionNormal:Number=210;

[Bindable]
private var marketDataRightRulePositionExpanded:Number=275;

[Bindable]
private var marketDataBottomRulePositionNormal:Number=331;

[Bindable]
private var marketDataBottomRulePositionExpanded:Number=396;

[Bindable]
private var marketDataBidPositionNormal:Number=222;

[Bindable]
private var marketDataBidPositionExpanded:Number=287;

[Bindable]
private var txtBuyPositionNormal:Number=236;

[Bindable]
private var txtBuyPositionExpanded:Number=301;

[Bindable]
private var txtLastPositionNormal:Number=264;

[Bindable]
private var txtLastPositionExpanded:Number=329;

[Bindable]
private var marketDataLastPositionNormal:Number=286;

[Bindable]
private var marketDataLastPositionExpanded:Number=351;

[Bindable]
private var marketDataOpenPostionNormal:Number=308;

[Bindable]
private var marketDataOpenPostionExpanded:Number=377;

[Bindable]
private var txtOpenPositionNormal:Number=306;

[Bindable]
private var txtOpenPositionExpanded:Number=371;

[Bindable]
private var messagesTxtLabelPositionNormal:Number=369;

[Bindable]
private var messagesTxtLabelPositionExpanded:Number=440;

[Bindable]
private var txtMsgPositionNormal:Number=369;

[Bindable]
private var txtMsgPositionExpanded:Number=438;

[Bindable]
private var okButtonPostionNormal:Number=341;

[Bindable]
private var okButtonPostionExpanded:Number=406;

[Bindable]
private var cancelButtonPositionNormal:Number=341;

[Bindable]
private var cancelButtonPositionExpanded:Number=406;

[Bindable]
private var marketDataChangePositionNormal:Number=288;

[Bindable]
private var marketDataChangePositionExpanded:Number=353;

[Bindable]
private var bondPanelPositionNormal:Number=174;

[Bindable]
private var bondPanelPositionExpanded:Number=233;

[Bindable]
private var additionalOrdersDetailsRuleBottomPositionNormal:Number=211;

[Bindable]
private var additionalOrdersDetailsRuleBottomPositionExpanded:Number=278;

[Bindable]
private var additionalOrdersLeftRuleExpandedHeight:Number=100;

[Bindable]
private var additionalOrdersLeftRuleNormalHeight:Number=34;

[Bindable]
private var additionalOrdersLeftRuleNormalPosition:Number=165;

[Bindable]
private var additionalOrdersLeftRuleExpandedPosition:Number=165;

[Bindable]
private var additionalDetailsRightRuleExpandedHeight:Number=100;

[Bindable]
private var additionalDetailsRightRuleNormalHeight:Number=34;

[Bindable]
private var additionalDetailsRightRuleExpandedPostion:Number=165;

[Bindable]
private var additionalDetailsRightRuleNormalPosition:Number=165;


/**
 * Reset Order View
 */
public function reset():void
{
	internalExchangeID=-1;
	if (txtExchange)
		txtExchange.text="";
	internalMarketID=-1;
	if (txtMarket)
		txtMarket.text="";
	internalSymbolID=-1;
	symbolID=-1;
	if (txtSymbol)
		txtSymbol.text="";
	isFirstSubmission=true;
	isSymbolDataFetched=false;
	if (txtVolume)
		txtVolume.text="";
	if (txtPrice)
		txtPrice.text="";
	if (txtDiscVol)
		txtDiscVol.text="";
	if (txtTriggerPrice)
		txtTriggerPrice.text="";
	if (txtOrderNum)
		txtOrderNum.text="";
	if (txtAccount)
		txtAccount.text="";
	if (txtCounterPartyClientCode)
		txtCounterPartyClientCode.text="";
	if (txtCounterPartyUserName)
		txtCounterPartyUserName.text="";
	if (grpNegotiatedTrade)
		grpNegotiatedTrade.visible=false;
	
	//if (negotiatedTradePanel)
	//	chkNgtd_changeHandler(null);
	
	NTType="";
	if (chkNgtd)
		chkNgtd.selected=false;
	
	if (dateTIF)
	{
		dateTIF.currentState=null;
		dateTIF.text="";
	}
	
	if (trader)
	{
		trader.selectedIndex=-1;
		trader.selectedItem=null;
	}
	
	if (rdogrpLmtMkt)
	{
		rdogrpLmtMkt.selectedValue="limit";
	}
	
	//isFromMenu = false;
	for (var j:int=0; j < numElements; ++j)
	{
		var el:IVisualElement=getElementAt(j);
		if (el is TextInput)
		{
			(el as TextInput).text="";
		}
		else if (el is DropDownList)
		{
			(el as DropDownList).selectedIndex=-1;
			(el as DropDownList).selectedItem=null;
		}
			// added on 30/3/2011
		else if (el is ComboBox)
		{
			(el as ComboBox).selectedIndex=-1;
			(el as ComboBox).selectedItem=null;
		}
			
			
		else if (el is DateField)
		{
			(el as DateField).currentState=null;
		}
	}
	
	enableFields(true);
}

/**
 * Updated Reset Order View method exclusive of exchange,market and symbol
 */
public function resetOrderForm():void
{
	//	internalExchangeID = -1;
	//	if (txtExchange)
	//		txtExchange.text = "";
	//	internalMarketID = -1;
	//	if (txtMarket)
	//		txtMarket.text = "";
	//	internalSymbolID = -1;
	//	symbolID = -1;
	//	if (txtSymbol)
	//		txtSymbol.text = "";
	isFirstSubmission=true;
	isSymbolDataFetched=false;
	if (txtVolume)
		txtVolume.text="";
	if (txtPrice)
		txtPrice.text="";
	if (txtDiscVol)
		txtDiscVol.text="";
	if (txtTriggerPrice)
		txtTriggerPrice.text="";
	if (txtOrderNum)
		txtOrderNum.text="";
	if (txtAccount)
		txtAccount.text="";
	if (txtCounterPartyClientCode)
		txtCounterPartyClientCode.text="";
	if (txtCounterPartyUserName)
		txtCounterPartyUserName.text="";
	if (chkNgtd)
		chkNgtd.selected=false;
	if (grpNegotiatedTrade)
	{
		grpNegotiatedTrade.visible=false;
		disableNegotiatedTradePanel();
	}
	if (rdogrpLmtMkt)
	{
		rdogrpLmtMkt.selectedValue="limit";
	}
	
	if (dateTIF)
	{
		dateTIF.currentState=null;
		dateTIF.text="";
	}
	
	if (trader)
	{
		trader.selectedIndex=-1;
		trader.selectedItem=null;
	}
	
	//if (negotiatedTradePanel)
	//	chkNgtd_changeHandler(null);
	
	NTType="";
	//isFromMenu = false;
	for (var j:int=0; j < numElements; ++j)
	{
		var el:IVisualElement=getElementAt(j);
		if (el is TextInput)
		{
			(el as TextInput).text="";
		}
		else if (el is DropDownList)
		{
			(el as DropDownList).selectedIndex=-1;
			(el as DropDownList).selectedItem=null;
		}
			
		else if (el is ComboBox)
		{
			(el as ComboBox).selectedIndex=-1;
			(el as ComboBox).selectedItem=null;
		}
		else if (el is DateField)
		{
			(el as DateField).currentState=null;
		}
	}
	
	enableFields(true);
}

public function enableFields(toEnable:Boolean):void
{
	if (txtExchange)
		txtExchange.enabled=toEnable;
	if (txtMarket)
		txtMarket.enabled=toEnable;
	if (txtSymbol)
		txtSymbol.enabled=toEnable;
	if (txtVolume)
		txtVolume.enabled=toEnable;
	if (txtPrice)
		txtPrice.enabled=toEnable;
	if (txtDiscVol)
		txtDiscVol.enabled=toEnable;
	if (txtTriggerPrice)
		txtTriggerPrice.enabled=toEnable;
	if (txtOrderNum)
		txtOrderNum.enabled=toEnable;
	if (txtAccount)
		txtAccount.enabled=toEnable;
	if (txtCounterPartyClientCode)
		txtCounterPartyClientCode.enabled=toEnable;
	if (txtCounterPartyUserName)
		txtCounterPartyUserName.enabled=toEnable;
	if (chkNgtd)
		chkNgtd.enabled=toEnable;
	
	if (dateTIF)
	{
		dateTIF.enabled=toEnable;
	}
	
	if (rdogrpLmtMkt)
	{
		rdogrpLmtMkt.enabled=toEnable;
	}
	
	if (trader)
	{
		trader.enabled=toEnable;
	}
	
	//isFromMenu = false;
	for (var j:int=0; j < numElements; ++j)
	{
		var el:IVisualElement=getElementAt(j);
		if (el is TextInput)
		{
			(el as TextInput).enabled=toEnable;
		}
		else if (el is DropDownList)
		{
			(el as DropDownList).enabled=toEnable;
		}
			// added on 30/3/2011
		else if (el is ComboBox)
		{
			(el as ComboBox).enabled=toEnable;
		}
			
			
		else if (el is DateField)
		{
			(el as DateField).enabled=toEnable;
		}
	}
}

public function disableTrader():void
{
	if (trader)
	{
		trader.selectedIndex=-1;
		trader.selectedItem=null;
		trader.enabled=false;
	}
}

public function enableCounterClientID():void
{
	if (txtCounterPartyClientCode)
		txtCounterPartyClientCode.enabled=true;
}

public function enableNegotiatedTradePanel():void
{
	if (grpNegotiatedTrade && !isNgtdPanelExpanded && negotiatedTradePanel.height == pnlngtdHeightMin)
	{
		grpNegotiatedTrade.visible=true;
		negotiatedTradePanel.height=pnlngtdHeightMax;
		if (window)
			window.height=window.height + pnlngtdHeightDelta;
		grpFields.y=grpFields.y + pnlngtdHeightDelta;
		
		rdoLmt.y=rdoLmt.y - pnlngtdHeightDelta;
		rdoMkt.y=rdoMkt.y - pnlngtdHeightDelta;
		chkNgtd.y=chkNgtd.y - pnlngtdHeightDelta;
		
		grpNegotiatedTrade.visible=true;
		isNgtdPanelExpanded=true;
	}
	if (!grpNegotiatedTrade.visible)
	{
		grpNegotiatedTrade.visible=true;
	}
	if (window && window.height == 225)
	{
		window.height=window.height + pnlngtdHeightDelta;
	}
}

public function disableNegotiatedTradePanel():void
{
	if (grpNegotiatedTrade && isNgtdPanelExpanded && negotiatedTradePanel.height == pnlngtdHeightMax)
	{
		
		grpNegotiatedTrade.visible=false;
		negotiatedTradePanel.height=pnlngtdHeightMin;
		grpFields.y=grpFields.y - pnlngtdHeightDelta;
		
		rdoLmt.y=rdoLmt.y + pnlngtdHeightDelta;
		rdoMkt.y=rdoMkt.y + pnlngtdHeightDelta;
		chkNgtd.y=chkNgtd.y + pnlngtdHeightDelta;
		
		grpNegotiatedTrade.visible=false;
		isNgtdPanelExpanded=false;
	}
	if (window && window.height != 225)
	{
		//		window.height = window.height - pnlngtdHeightDelta;
	}
	
}

/**
 * Reset Order View
 */
//public function updateBestMarketOrderFields(event:NonVisualItemUpdateEvent):void
public function updateBestMarketOrderFields(event:NonVisualItemUpdateEvent):void
{
	if (txtBuy)
	{
		txtBuy.text=moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[1]));
	}
	if (txtBuyVolume)
	{
		txtBuyVolume.text=numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[3]));
	}
	if (txtSell)
	{
		txtSell.text=moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[5]));
	}
	if (txtSellVolume)
	{
		txtSellVolume.text=numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[7]));
	}
	
	// Start : added on 28/1/2011 to show updated Bond specific values
	
	if (txtSymbol)
	{
		var obj:Object=ModelManager.getInstance().exchangeModel.getSymbolByCode(internalExchangeID, internalMarketID, txtSymbol.text);
	}
	
	if (obj && obj.hasOwnProperty("SYMBOL_TYPE") && obj.SYMBOL_TYPE == "Bond")
	{
		txtCouponRate.text=(obj as BondBO).couponRate.toString();
		var dateFormatter:DateFormatter=new DateFormatter();
		dateFormatter.formatString="DD/MM/YYYY";
		txtNextCoupon.text=dateFormatter.format((obj as BondBO).issueDate);
		txtMaturityDate.text=dateFormatter.format((obj as BondBO).maturityDate);
		nextCouponDate=(obj as BondBO).nextCouponDate;
		issueDate=(obj as BondBO).issueDate;
		maturityDate=(obj as BondBO).maturityDate;
		baseRate=(obj as BondBO).baseRate;
		
		
		if (txtBondAskPrice)
		{
			txtBondAskPrice.text=moneyFormatter.format(txtSell.text);
		}
		
		if (txtBondBidPrice)
		{
			txtBondBidPrice.text=moneyFormatter.format(txtBuy.text);
		}
		
		
		if ((txtBondAskPrice.text.length > 0 && txtBondAskPrice.text != "0") && (txtCouponRate.text.length > 0))
		{
			txtBondAskYield.text=moneyFormatter.format(calculateCurrentYield(new Number(txtBondAskPrice.text), new Number(txtCouponRate.text)).toString());
		}
		
		if ((txtBondBidPrice.text.length > 0 && txtBondBidPrice.text != "0") && (txtCouponRate.text.length > 0))
		{
			txtBondBidYield.text=moneyFormatter.format(calculateCurrentYield(new Number(txtBondBidPrice.text), new Number(txtCouponRate.text)).toString());
		}
	} 
	
	// End : added on 28/1/2011 to show updated Bond specific values
}

/**
 * Reset Order View
 */
//public function updateSymbolStatsOrderFields(event:NonVisualItemUpdateEvent):void
public function updateSymbolStatsOrderFields(event:NonVisualItemUpdateEvent):void
{
	var changeNumber:String = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[8])).toString();
	var itemID:Array = event.currentTarget.groupString.split("_");
	var windowManager:WindowManager=WindowManager.getInstance();
	var changeValue:Number = parseFloat(numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[8])));
	try
	{
	windowManager.viewManager.symbolSumm.highValue.text = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[6])).toString().slice(0, 5);
	windowManager.viewManager.symbolSumm.lowValue.text = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[7])).toString().slice(0, 5);
	}catch(e:Error)
	{
		trace(e.message);
	}
	if (windowManager.viewManager.quickOrders.firstSymbolDropDown != null 
		&& windowManager.viewManager.quickOrders.secondSymbolDropDown != null 
		&& windowManager.viewManager.quickOrders.thirdSymbolDropDown!= null 
		&& windowManager.viewManager.quickOrders.fourthSymbolDropDown!= null)
	{
		if(windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedItem != null && (windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3])
		{
			windowManager.viewManager.quickOrders.firstSegmentLowLabel.text=numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[7])).toString().slice(0, 5);
			windowManager.viewManager.quickOrders.firstHighValue.text=numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[6])).toString().slice(0, 5);
		}	
		if( windowManager.viewManager.quickOrders.secondSymbolDropDown.selectedItem != null && (windowManager.viewManager.quickOrders.secondSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3])
		{
			windowManager.viewManager.quickOrders.secondSegmentLowLabel.text=numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[7])).toString().slice(0, 5);
			windowManager.viewManager.quickOrders.secondHighValue.text=numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[6])).toString().slice(0, 5);
		}
		if(windowManager.viewManager.quickOrders.thirdSymbolDropDown.selectedItem != null && (windowManager.viewManager.quickOrders.thirdSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3])
		{
			windowManager.viewManager.quickOrders.thirdSegmentLowLabel.text=numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[7])).toString().slice(0, 5);
			windowManager.viewManager.quickOrders.thirdHighValue.text=numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[6])).toString().slice(0, 5);
		}	
		if(windowManager.viewManager.quickOrders.fourthSymbolDropDown.selectedItem != null && (windowManager.viewManager.quickOrders.fourthSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3])
		{
			windowManager.viewManager.quickOrders.fourthSegmentLowLabel.text=numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[7])).toString().slice(0, 5);
			windowManager.viewManager.quickOrders.fourthHighValue.text=numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[6])).toString().slice(0, 5);
		}
		
		if ( windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedItem != null && changeValue < 0
			&& (windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3]
		)
		{
			windowManager.viewManager.quickOrders.firstChangeValue.setStyle("backgroundColor", 0xdf241d);
			windowManager.viewManager.quickOrders.firstChangeValue.text=changeValue.toString();
		}
		if ( windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedItem != null  && changeValue > 0
			&& (windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3]
		)
		{
			windowManager.viewManager.quickOrders.firstChangeValue.setStyle("backgroundColor", 0x01e92a);
			windowManager.viewManager.quickOrders.firstChangeValue.text='+' + changeValue.toString();
		}
		//		if((windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == (windowManager.viewManager.quickOrders.secondSymbolDropDown.selectedItem as QuickOrdersBO).symbolID
		//			&& (windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == (windowManager.viewManager.quickOrders.thirdSymbolDropDown.selectedItem as QuickOrdersBO).symbolID
		//			&& (windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == (windowManager.viewManager.quickOrders.fourthSymbolDropDown.selectedItem as QuickOrdersBO).symbolID
		//		)
		//		{
		//			windowManager.viewManager.quickOrders.firstChangeValue.setStyle("backgroundColor", 0x01e92a);
		//			windowManager.viewManager.quickOrders.firstChangeValue.text='+' + numberFormatter.format(LSListener.extractFieldData(updatedFields, 8, index)).toString().slice(0, 5);
		//		}
		//		else
		//		{
		//			windowManager.viewManager.quickOrders.firstChangeValue.setStyle("backgroundColor", 0x01e92a);
		//			windowManager.viewManager.quickOrders.firstChangeValue.text='+' + numberFormatter.format(LSListener.extractFieldData(updatedFields, 8, index)).toString().slice(0, 5);
		//		}
		
		
		
		if ( windowManager.viewManager.quickOrders.secondSymbolDropDown.selectedItem != null  && changeValue < 0
			&&	 (windowManager.viewManager.quickOrders.secondSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3]
		)
		{
			windowManager.viewManager.quickOrders.secondChangeValue.text=changeValue.toString();
			windowManager.viewManager.quickOrders.secondChangeValue.setStyle("backgroundColor", 0xdf241d);
		}
		if (
			windowManager.viewManager.quickOrders.secondSymbolDropDown.selectedItem != null  && changeValue > 0
			&&	 (windowManager.viewManager.quickOrders.secondSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3]
		)
		{
			windowManager.viewManager.quickOrders.secondChangeValue.text='+'+changeValue.toString();
			windowManager.viewManager.quickOrders.secondChangeValue.setStyle("backgroundColor", 0x01e92a);
		}
		
		
		if (windowManager.viewManager.quickOrders.thirdSymbolDropDown.selectedItem != null  && changeValue < 0
			&& (windowManager.viewManager.quickOrders.thirdSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3]
		)
		{
			windowManager.viewManager.quickOrders.thirdChangeValue.setStyle("backgroundColor", 0xdf241d);
			windowManager.viewManager.quickOrders.thirdChangeValue.text=changeValue.toString();
		}
		if (
			windowManager.viewManager.quickOrders.thirdSymbolDropDown.selectedItem != null  && changeValue > 0
			&& (windowManager.viewManager.quickOrders.thirdSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3]
		)
		{
			windowManager.viewManager.quickOrders.thirdChangeValue.setStyle("backgroundColor", 0x01e92a);
			windowManager.viewManager.quickOrders.thirdChangeValue.text='+'+changeValue.toString();
		}
		
		if (windowManager.viewManager.quickOrders.fourthSymbolDropDown.selectedItem != null  && changeValue < 0
			&& (windowManager.viewManager.quickOrders.fourthSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3])
		{
			windowManager.viewManager.quickOrders.fourthChangeValue.setStyle("backgroundColor", 0xdf241d);
			windowManager.viewManager.quickOrders.fourthChangeValue.text=changeValue.toString();
		}
		if ( windowManager.viewManager.quickOrders.fourthSymbolDropDown.selectedItem != null  && changeValue > 0
			&& (windowManager.viewManager.quickOrders.fourthSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == itemID[3])
		{
			windowManager.viewManager.quickOrders.fourthChangeValue.setStyle("backgroundColor", 0x01e92a);
			windowManager.viewManager.quickOrders.fourthChangeValue.text='+' + changeValue.toString();
		}
		//		else
		//		{
		//			windowManager.viewManager.quickOrders.fourthChangeValue.setStyle("backgroundColor", 0x01e92a);
		//			windowManager.viewManager.quickOrders.fourthChangeValue.text='+' + numberFormatter.format(LSListener.extractFieldData(updatedFields, 8, index)).toString().slice(0, 5);
		//		}
	}
	if (txtLast)
	{
		txtLast.text=moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[1]));
		txtCurrent.text=moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[1]));
	}
	if (txtChange)
	{
		txtChange.text=moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[8]));
	}
	if (txtTurnOver)
	{
		txtTurnOver.text=numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[2]));
	}
	
	if (txtOpen)
	{
		txtOpen.text=moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[4]));
	}
	if (txtLow)
	{
		txtLow.text=moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[7]));
	}
	if (txtHigh)
	{
		txtHigh.text=moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[6]));
	}
}




public function imgExpander_clickHandler(event:MouseEvent):void
{
	var windowManager:WindowManager=WindowManager.getInstance();
	if (window)
	{
		if (isBondPanelExpanded)
		{
			var windowHeight1:Number=440;
			event.currentTarget.rotation=-90;
			bondPanel.height=pnlHeightMin;
			//			bg.height = pnlHeightMin;
			//			window.height = window.height - pnlHeightDelta;
			//			grpFields.y = grpFields.y - pnlHeightDelta;
			negotiatedTradePanel.y=negotiatedTradePanel.y - pnlHeightDelta;
			//			rdoLmt.y = rdoLmt.y + pnlHeightDelta;        
			//			rdoMkt.y = rdoMkt.y + pnlHeightDelta;
			//			chkNgtd.y = chkNgtd.y + pnlHeightDelta;
			
			grpFields.height=476;
			bcMain.height=476;
			bcMain.parent.height=476;
			if (windowManager.buyOrderWindow)
			{
				windowManager.buyOrderWindow.height=windowHeight1;
				bondPanelBottomRule.y=bondPanelBottomRulePositionNormal;
				additionalOrdersLeftRule.height=bondPanelHeightMin;
				additionalDetailsRightRule.height=bondPanelHeightMin;
				marketDataTitle.y=marketDataTitlePositionNormal;
				marketDataTopRightRule.y=marketDataTopRightRulePositionNormal;
				marketDataTopLeftRule.y=marketDataTopLeftRulePositionNormal;
				marketDataLeftRule.y=marketDataLeftRulePositionNormal;
				marketDataRightRule.y=marketDataRightRulePositionNormal;
				marketDataBottomRule.y=marketDataBottomRulePositionNormal;
				marketDataBid.y=marketDataBidPositionNormal;
				txtBuy.y=txtBuyPositionNormal;
				txtLast.y=txtLastPositionNormal;
				marketDataLast.y=marketDataLastPositionNormal;
				marketDataOpen.y=marketDataOpenPostionNormal;
				txtOpen.y=txtOpenPositionNormal;
				marketDataHigh.y=marketDataOpenPostionNormal;
				txtHigh.y=txtOpenPositionNormal;
				marketDataLow.y=marketDataOpenPostionNormal;
				txtLow.y=txtOpenPositionNormal;
				marketDataCurrent.y=marketDataOpenPostionNormal;
				txtCurrent.y=txtOpenPositionNormal;
				messagesTxtLabel.y=messagesTxtLabelPositionNormal;
				txtMsg.y=txtMsgPositionNormal;
				okButton.y=okButtonPostionNormal;
				cancelButton.y=cancelButtonPositionNormal;
				marketDataVolume.y=marketDataBidPositionNormal;
				txtBuyVolume.y=txtBuyPositionNormal;
				marketDataOffer.y=marketDataBidPositionNormal;
				txtSell.y=txtBuyPositionNormal;
				txtTurnOver.y=txtLastPositionNormal;
				marketDataTurnOver.y=marketDataLastPositionNormal;
				marketDataBuyVolume.y=marketDataBidPositionNormal;
				txtSellVolume.y=txtBuyPositionNormal;
				txtFlags.y=txtLastPositionNormal;
				marketDataFlags.y=marketDataLastPositionNormal;
				txtChange.y=txtLastPositionNormal;
				marketDataChange.y=marketDataChangePositionNormal;
			}
			
			if (windowManager.changeOrderWindow)
			{
				windowManager.changeOrderWindow.height=windowHeight1;
				bondPanelBottomRule.y=bondPanelBottomRulePositionNormal;
				additionalOrdersLeftRule.height=bondPanelHeightMin;
				additionalDetailsRightRule.height=bondPanelHeightMin;
				marketDataTitle.y=marketDataTitlePositionNormal;
				marketDataTopRightRule.y=marketDataTopRightRulePositionNormal;
				marketDataTopLeftRule.y=marketDataTopLeftRulePositionNormal;
				marketDataLeftRule.y=marketDataLeftRulePositionNormal;
				marketDataRightRule.y=marketDataRightRulePositionNormal;
				marketDataBottomRule.y=marketDataBottomRulePositionNormal;
				marketDataBid.y=marketDataBidPositionNormal;
				txtBuy.y=txtBuyPositionNormal;
				txtLast.y=txtLastPositionNormal;
				marketDataLast.y=marketDataLastPositionNormal;
				marketDataOpen.y=marketDataOpenPostionNormal;
				txtOpen.y=txtOpenPositionNormal;
				marketDataHigh.y=marketDataOpenPostionNormal;
				txtHigh.y=txtOpenPositionNormal;
				marketDataLow.y=marketDataOpenPostionNormal;
				txtLow.y=txtOpenPositionNormal;
				marketDataCurrent.y=marketDataOpenPostionNormal;
				txtCurrent.y=txtOpenPositionNormal;
//				ohlcHbox.y = txtOpenPositionNormal;
//				msgHbox.y = txtMsgPositionNormal;
				messagesTxtLabel.y=messagesTxtLabelPositionNormal;
				txtMsg.y=txtMsgPositionNormal;
				okButton.y=okButtonPostionNormal;
				cancelButton.y=cancelButtonPositionNormal;
				marketDataVolume.y=marketDataBidPositionNormal;
				txtBuyVolume.y=txtBuyPositionNormal;
				marketDataOffer.y=marketDataBidPositionNormal;
				txtSell.y=txtBuyPositionNormal;
				txtTurnOver.y=txtLastPositionNormal;
				marketDataTurnOver.y=marketDataLastPositionNormal;
				marketDataBuyVolume.y=marketDataBidPositionNormal;
				txtSellVolume.y=txtBuyPositionNormal;
				txtFlags.y=txtLastPositionNormal;
				marketDataFlags.y=marketDataLastPositionNormal;
				txtChange.y=txtLastPositionNormal;
				marketDataChange.y=marketDataChangePositionNormal;
			}
			if (windowManager.cancelOrderWindow)
			{
				windowManager.cancelOrderWindow.height=windowHeight1;
				bondPanelBottomRule.y=bondPanelBottomRulePositionNormal;
				additionalOrdersLeftRule.height=bondPanelHeightMin;
				additionalDetailsRightRule.height=bondPanelHeightMin;
				marketDataTitle.y=marketDataTitlePositionNormal;
				marketDataTopRightRule.y=marketDataTopRightRulePositionNormal;
				marketDataTopLeftRule.y=marketDataTopLeftRulePositionNormal;
				marketDataLeftRule.y=marketDataLeftRulePositionNormal;
				marketDataRightRule.y=marketDataRightRulePositionNormal;
				marketDataBottomRule.y=marketDataBottomRulePositionNormal;
				marketDataBid.y=marketDataBidPositionNormal;
				txtBuy.y=txtBuyPositionNormal;
				txtLast.y=txtLastPositionNormal;  
				marketDataLast.y=marketDataLastPositionNormal;
				marketDataOpen.y=marketDataOpenPostionNormal;
				txtOpen.y=txtOpenPositionNormal;
				marketDataHigh.y=marketDataOpenPostionNormal;
				txtHigh.y=txtOpenPositionNormal;
				marketDataLow.y=marketDataOpenPostionNormal;
				txtLow.y=txtOpenPositionNormal;
				marketDataCurrent.y=marketDataOpenPostionNormal;
				txtCurrent.y=txtOpenPositionNormal;
				messagesTxtLabel.y=messagesTxtLabelPositionNormal;
				txtMsg.y=txtMsgPositionNormal;
//				ohlcHbox.y = txtOpenPositionExpanded;
//				msgHbox.y = txtMsgPositionExpanded;
				okButton.y=okButtonPostionNormal;
				cancelButton.y=cancelButtonPositionNormal;
				marketDataVolume.y=marketDataBidPositionNormal;
				txtBuyVolume.y=txtBuyPositionNormal;
				marketDataOffer.y=marketDataBidPositionNormal;
				txtSell.y=txtBuyPositionNormal;
				txtTurnOver.y=txtLastPositionNormal;
				marketDataTurnOver.y=marketDataLastPositionNormal;
				marketDataBuyVolume.y=marketDataBidPositionNormal;
				txtSellVolume.y=txtBuyPositionNormal;
				txtFlags.y=txtLastPositionNormal;
				marketDataFlags.y=marketDataLastPositionNormal;
				txtChange.y=txtLastPositionNormal;
				marketDataChange.y=marketDataChangePositionNormal;
			}
		}
		else
		{
			var windowHeight:Number=510;
			event.currentTarget.rotation=0;
			bondPanel.height=pnlHeightMax;
			//			bg.height = pnlHeightMax;
			//			window.height = window.height + pnlHeightDelta;
			//			grpFields.y = grpFields.y + pnlHeightDelta;
			negotiatedTradePanel.y=negotiatedTradePanel.y + pnlHeightDelta;
			//			rdoLmt.y = rdoLmt.y - pnlHeightDelta;
			//			rdoMkt.y = rdoMkt.y - pnlHeightDelta;
			//			chkNgtd.y = chkNgtd.y - pnlHeightDelta;
			grpFields.height=540;
			bcMain.height=540;
			bcMain.parent.height=540;
			if (windowManager.buyOrderWindow)
			{
				windowManager.buyOrderWindow.height=windowHeight;
				additionalOrdersLeftRule.height=bondPanelHeightMax;
				additionalDetailsRightRule.height=bondPanelHeightMax;
				bondPanelBottomRule.y=bondPanelBottomRulePositionExpanded;
				marketDataTitle.y=marketDataTitlePositionExpaded;
				marketDataTopRightRule.y=marketDataTopRightRulePositionExpanded;
				marketDataTopLeftRule.y=marketDataTopLeftRulePositionExpanded;
				marketDataLeftRule.y=marketDataLeftRulePositionExpanded;
				marketDataRightRule.y=marketDataRightRulePositionExpanded;
				marketDataBottomRule.y=marketDataBottomRulePositionExpanded;
				marketDataBid.y=marketDataBidPositionExpanded;
				txtBuy.y=txtBuyPositionExpanded;
				txtLast.y=txtLastPositionExpanded;
				marketDataLast.y=marketDataLastPositionExpanded;
				marketDataOpen.y=marketDataOpenPostionExpanded;
				txtOpen.y=txtOpenPositionExpanded;
				marketDataHigh.y=marketDataOpenPostionExpanded;
				txtHigh.y=txtOpenPositionExpanded;
				marketDataLow.y=marketDataOpenPostionExpanded;
				txtLow.y=txtOpenPositionExpanded;
				marketDataCurrent.y=marketDataOpenPostionExpanded;
				txtCurrent.y=txtOpenPositionExpanded;
				messagesTxtLabel.y=messagesTxtLabelPositionExpanded;
				txtMsg.y=txtMsgPositionExpanded;
				okButton.y=okButtonPostionExpanded;
				cancelButton.y=cancelButtonPositionExpanded;
				marketDataVolume.y=marketDataBidPositionExpanded;
				txtBuyVolume.y=txtBuyPositionExpanded;
				marketDataOffer.y=marketDataBidPositionExpanded;
				txtSell.y=txtBuyPositionExpanded;
				txtTurnOver.y=txtLastPositionExpanded;
				marketDataTurnOver.y=marketDataLastPositionExpanded;
				marketDataBuyVolume.y=marketDataBidPositionExpanded;
				txtSellVolume.y=txtBuyPositionExpanded;
				txtFlags.y=txtLastPositionExpanded;
				marketDataFlags.y=marketDataLastPositionExpanded;
				txtChange.y=txtLastPositionExpanded;
				marketDataChange.y=marketDataChangePositionExpanded;
			}
			
			if (windowManager.changeOrderWindow)
			{
				windowManager.changeOrderWindow.height=windowHeight;
				additionalOrdersLeftRule.height=bondPanelHeightMax;
				additionalDetailsRightRule.height=bondPanelHeightMax;
				bondPanelBottomRule.y=bondPanelBottomRulePositionExpanded;
				marketDataTitle.y=marketDataTitlePositionExpaded;
				marketDataTopRightRule.y=marketDataTopRightRulePositionExpanded;
				marketDataTopLeftRule.y=marketDataTopLeftRulePositionExpanded;
				marketDataLeftRule.y=marketDataLeftRulePositionExpanded;
				marketDataRightRule.y=marketDataRightRulePositionExpanded;
				marketDataBottomRule.y=marketDataBottomRulePositionExpanded;
				marketDataBid.y=marketDataBidPositionExpanded;
				txtBuy.y=txtBuyPositionExpanded;
				txtLast.y=txtLastPositionExpanded;
				marketDataLast.y=marketDataLastPositionExpanded;
				marketDataOpen.y=marketDataOpenPostionExpanded;
				txtOpen.y=txtOpenPositionExpanded;
				marketDataHigh.y=marketDataOpenPostionExpanded;
				txtHigh.y=txtOpenPositionExpanded;
				marketDataLow.y=marketDataOpenPostionExpanded;
				txtLow.y=txtOpenPositionExpanded;
				marketDataCurrent.y=marketDataOpenPostionExpanded;
				txtCurrent.y=txtOpenPositionExpanded;
				messagesTxtLabel.y=messagesTxtLabelPositionExpanded;
				txtMsg.y=txtMsgPositionExpanded;
				okButton.y=okButtonPostionExpanded;
				cancelButton.y=cancelButtonPositionExpanded;
				marketDataVolume.y=marketDataBidPositionExpanded;
				txtBuyVolume.y=txtBuyPositionExpanded;
				marketDataOffer.y=marketDataBidPositionExpanded;
				txtSell.y=txtBuyPositionExpanded;
				txtTurnOver.y=txtLastPositionExpanded;
				marketDataTurnOver.y=marketDataLastPositionExpanded;
				marketDataBuyVolume.y=marketDataBidPositionExpanded;
				txtSellVolume.y=txtBuyPositionExpanded;
				txtFlags.y=txtLastPositionExpanded;
				marketDataFlags.y=marketDataLastPositionExpanded;
				txtChange.y=txtLastPositionExpanded;
				marketDataChange.y=marketDataChangePositionExpanded;
			}
			if (windowManager.cancelOrderWindow)
			{
				windowManager.cancelOrderWindow.height=windowHeight;
				additionalOrdersLeftRule.height=bondPanelHeightMax;
				additionalDetailsRightRule.height=bondPanelHeightMax;
				bondPanelBottomRule.y=bondPanelBottomRulePositionExpanded;
				marketDataTitle.y=marketDataTitlePositionExpaded;
				marketDataTopRightRule.y=marketDataTopRightRulePositionExpanded;
				marketDataTopLeftRule.y=marketDataTopLeftRulePositionExpanded;
				marketDataLeftRule.y=marketDataLeftRulePositionExpanded;
				marketDataRightRule.y=marketDataRightRulePositionExpanded;
				marketDataBottomRule.y=marketDataBottomRulePositionExpanded;
				marketDataBid.y=marketDataBidPositionExpanded;
				txtBuy.y=txtBuyPositionExpanded;
				txtLast.y=txtLastPositionExpanded;
				marketDataLast.y=marketDataLastPositionExpanded;
				marketDataOpen.y=marketDataOpenPostionExpanded;
				txtOpen.y=txtOpenPositionExpanded;
				marketDataHigh.y=marketDataOpenPostionExpanded;
				txtHigh.y=txtOpenPositionExpanded;
				marketDataLow.y=marketDataOpenPostionExpanded;
				txtLow.y=txtOpenPositionExpanded;
				marketDataCurrent.y=marketDataOpenPostionExpanded;
				txtCurrent.y=txtOpenPositionExpanded;
				messagesTxtLabel.y=messagesTxtLabelPositionExpanded;
				txtMsg.y=txtMsgPositionExpanded;
				okButton.y=okButtonPostionExpanded;
				cancelButton.y=cancelButtonPositionExpanded;
				marketDataVolume.y=marketDataBidPositionExpanded;
				txtBuyVolume.y=txtBuyPositionExpanded;
				marketDataOffer.y=marketDataBidPositionExpanded;
				txtSell.y=txtBuyPositionExpanded;
				txtTurnOver.y=txtLastPositionExpanded;
				marketDataTurnOver.y=marketDataLastPositionExpanded;
				marketDataBuyVolume.y=marketDataBidPositionExpanded;
				txtSellVolume.y=txtBuyPositionExpanded;
				txtFlags.y=txtLastPositionExpanded;
				marketDataFlags.y=marketDataLastPositionExpanded;
				txtChange.y=txtLastPositionExpanded;
				marketDataChange.y=marketDataChangePositionExpanded;
			}
			
		}
		grpBond.visible=!isBondPanelExpanded;
		isBondPanelExpanded=!isBondPanelExpanded;
	}
}


protected function btnCalculator_clickHandler(event:MouseEvent):void
{
	if (internalExchangeID > -1 && internalMarketID > -1 && internalSymbolID > -1)
	{
		var windowManager:WindowManager=WindowManager.getInstance();
		
		if (windowManager.yieldCalculatorWindow && windowManager.canvas.windowManager.container.contains(windowManager.yieldCalculatorWindow))
		{
			windowManager.canvas.windowManager.bringToFront(windowManager.yieldCalculatorWindow);
		}
		else
		{
			windowManager.initYieldCalculatorWindow();
			windowManager.canvas.windowManager.add(windowManager.yieldCalculatorWindow);
		}
		
		windowManager.viewManager.yieldCalculator.internalExchangeID=internalExchangeID;
		windowManager.viewManager.yieldCalculator.internalMarketID=internalMarketID;
		windowManager.viewManager.yieldCalculator.internalSymbolID=internalSymbolID;
		windowManager.viewManager.yieldCalculator.txtExchange.text=txtExchange.text;
		windowManager.viewManager.yieldCalculator.txtMarket.text=txtMarket.text;
		windowManager.viewManager.yieldCalculator.txtSymbol.text=txtSymbol.text;
		
		if (txtLast.text.length > 0)
		{
			windowManager.viewManager.yieldCalculator.txtCurrentRate.text=txtLast.text;
		}
		else
		{
			windowManager.viewManager.yieldCalculator.txtCurrentRate.text=baseRate.toString();
		}
		windowManager.viewManager.yieldCalculator.txtCouponRate.text=txtCouponRate.text;
		
		issueDate.seconds=1;
		windowManager.viewManager.yieldCalculator.issueDate=issueDate;
		nextCouponDate.seconds=1;
		windowManager.viewManager.yieldCalculator.nextCouponDate=nextCouponDate;
		maturityDate.seconds=1;
		windowManager.viewManager.yieldCalculator.maturityDate=maturityDate;
		
		windowManager.viewManager.yieldCalculator.reset(false);
	}
}

protected function rdogrpLmtMkt_changeHandler(event:Event):void
{
	if (event.currentTarget.selectedValue == "market")
	{
		txtPrice.text="";
		txtPrice.enabled=false;
	}
	else
	{
		txtPrice.enabled=true;
	}
}

public function setSelectedTrader(USER_ID:Number):void
{
	if (USER_ID > -1)
	{
		for (var i:int=0; i < tradersList.length; ++i)
		{
			var cbi:ComboBoxItem=tradersList.getItemAt(i) as ComboBoxItem;
			if (cbi && cbi.value == USER_ID.toString())
			{
				//trader.selectedIndex = i;
				trader.selectedItem=tradersList.getItemAt(i);
				break;
			}
		}
	}
	else
		trader.selectedItem=null;
	//trace("Selected Item ...........: "+trader.selectedItem.value);
}

public function chkNgtd_changeHandler(event:Event):void
{
	//if (!chkNgtd.selected)
	if (isNgtdPanelExpanded)
	{
		negotiatedTradePanel.height=pnlngtdHeightMin;
		if (window)
			window.height=window.height - pnlngtdHeightDelta;
		grpFields.y=grpFields.y - pnlngtdHeightDelta;
		
		rdoLmt.y=rdoLmt.y + pnlngtdHeightDelta;
		rdoMkt.y=rdoMkt.y + pnlngtdHeightDelta;
		chkNgtd.y=chkNgtd.y + pnlngtdHeightDelta;
		
		txtDiscVol.enabled=true;
		txtTriggerPrice.enabled=true;
		dateTIF.enabled=true;
		dateTIF.text="";
		ddType.selectedIndex=0;
		ddType.enabled=true;
		trader.selectedIndex=0;
		trader.enabled=true;
	}
	else
	{
		negotiatedTradePanel.height=pnlngtdHeightMax;
		if (window)
			window.height=window.height + pnlngtdHeightDelta;
		grpFields.y=grpFields.y + pnlngtdHeightDelta;
		
		rdoLmt.y=rdoLmt.y - pnlngtdHeightDelta;
		rdoMkt.y=rdoMkt.y - pnlngtdHeightDelta;
		chkNgtd.y=chkNgtd.y - pnlngtdHeightDelta;
		
		txtDiscVol.enabled=false;
		txtDiscVol.text="";
		txtTriggerPrice.enabled=false;
		txtTriggerPrice.text="";
		dateTIF.enabled=false;
		dateTIF.text="";
		ddType.selectedIndex=0;
		ddType.enabled=false;
		trader.selectedIndex=0;
		trader.enabled=false;
	}
	if (grpNegotiatedTrade)
	{
		grpNegotiatedTrade.visible=!isNgtdPanelExpanded;
		isNgtdPanelExpanded=!isNgtdPanelExpanded;
	}
}

//public function getSelectedTrader(USER_ID:Number):ComboBoxItem{
//	var cbi:ComboBoxItem = null;
//	if(USER_ID > -1)
//	{
//		for (var i:int = 0; i < tradersList.length; ++i)
//		{
//			 cbi = tradersList.getItemAt(i);
//			//var cbi:ComboBoxItem = new ComboBoxItem(obj.EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
//			if(cbi && cbi.value == USER_ID)
//			{
//				trader.selectedItem = cbi;
//				break;
//			}
//		}
//	}
//	return cbi;
//}


public function initTraders(privilegeType:String):void
{
	// added on 16/3/2011
	tradersList=ModelManager.getInstance().userProfileModel.getTraders(privilegeType);
}

public function setFocusToCounterClientID():void
{
	txtCounterPartyClientCode.setFocus();
}

public function setTabIndices(indexBase:Number):void
{
	txtExchange.tabIndex+=indexBase;
	txtMarket.tabIndex+=indexBase;
	txtSymbol.tabIndex+=indexBase;
	txtVolume.tabIndex+=indexBase;
	txtPrice.tabIndex+=indexBase;
	txtAccount.tabIndex+=indexBase;
	txtDiscVol.tabIndex+=indexBase;
	txtTriggerPrice.tabIndex+=indexBase;
	dateTIF.tabIndex+=indexBase;
	txtOrderNum.tabIndex+=indexBase;
	ddType.tabIndex+=indexBase;
	trader.tabIndex+=indexBase;
	
	if (grpFields != null)
	{
		rdoLmt.tabIndex+=indexBase;
		rdoMkt.tabIndex+=indexBase;
		chkNgtd.tabIndex+=indexBase;
		txtBuy.tabIndex+=indexBase;
		txtBuyVolume.tabIndex+=indexBase;
		txtSell.tabIndex+=indexBase;
		txtSellVolume.tabIndex+=indexBase;
		txtLast.tabIndex+=indexBase;
		txtChange.tabIndex+=indexBase;
		txtTurnOver.tabIndex+=indexBase;
		txtFlags.tabIndex+=indexBase;
		txtMsg.tabIndex+=indexBase;
	}
	
	if (grpBond != null)
	{
		txtBondBidPrice.tabIndex+=indexBase;
		txtBondAskPrice.tabIndex+=indexBase;
		txtBondBidYield.tabIndex+=indexBase;
		txtBondAskYield.tabIndex+=indexBase;
		txtCouponRate.tabIndex+=indexBase;
		txtNextCoupon.tabIndex+=indexBase;
		txtMaturityDate.tabIndex+=indexBase;
		btnCalculator.tabIndex+=indexBase;
	}
	if (grpNegotiatedTrade != null)
	{
		txtCounterPartyUserName.tabIndex+=indexBase;
		txtCounterPartyClientCode.tabIndex+=indexBase;
	}
}
