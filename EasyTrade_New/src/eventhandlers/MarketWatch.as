import businessobjects.BestMarketAndSymbolSummaryBO;
import businessobjects.BondBO;
import businessobjects.MarketWatchBO;
import businessobjects.OrderBO;
import businessobjects.QuickOrdersBO;
import businessobjects.SymbolBrowserBO;

import com.lightstreamer.as_client.events.NonVisualItemUpdateEvent;

import common.Constants;
import common.Messages;
import common.ReasonMessages;

import components.ComboBoxItem;
import components.EZCurrencyFormatter;
import components.EZNumberFormatter;

import controller.ModelManager;
import controller.SoundManager;
import controller.WindowManager;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.core.FlexGlobals;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.resources.ResourceManager;
import mx.utils.ObjectUtil;

import services.LSListener;

import view.MarketWatch;
import view.Order;
import view.SelectionMenu;

private var pageSize:uint = 0; 
private var intPages:uint = 0;
private var CurrPage:uint = 0;

/* Number of pages per view */
public var navSize:uint = 6;

private var index:uint = 0;
private var navPage:uint = 1;

private var hiddenArray:ArrayCollection =  new ArrayCollection();

[Bindable] 
public var nav:ArrayCollection = new ArrayCollection();

[Bindable]
private var bindedArray:ArrayCollection = new ArrayCollection();

[Bindable]
private var exchangeList:ArrayList=new ArrayList();

[Bindable]
private var marketList:ArrayList=new ArrayList();

[Bindable]
public var selectedIndex:Number=0;

[Bindable]
private var modelManager:ModelManager=ModelManager.getInstance();

[Bindable]
private var windowManager:WindowManager=WindowManager.getInstance();

private var isInvalidSymbol:Boolean=false;

private var sortColumn:String="";
private var sortDescending:Boolean=false;

[Bindable]
private var ctMenu:flash.ui.ContextMenu;
private var lastRollOverIndex:int=0;

[Bindable]
[Embed(source="../images/bondsup.jpg")]
private var bondsUp:Class;

[Bindable]
[Embed(source="../images/bondsover.jpg")]
private var bondsOver:Class;

[Bindable]
public var currentPage:Number=0;

[Bindable]
public var equitiesPage:Number

[Bindable]
public var bondsPage:Number;

[Bindable]
public var equitiesPreviousIndex:Number=0;

[Bindable]
public var bondsPreviousPage:Number=6;

[Bindable]
private var isBondsSelectedFirstTime:Boolean = false;

public var ebIndex:int;

private var alert:Alert;


[Bindable]
public var remainedVol:Number=0;
protected function group1_initializeHandler(event:FlexEvent):void
{
	var cmi:ContextMenuItem=new ContextMenuItem("View Details...", true);
	cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuItem_menuItemSelect);
	
	ctMenu=new ContextMenu();
	ctMenu.hideBuiltInItems();
	ctMenu.customItems=[cmi];
	ctMenu.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelect);
	
}

private function contextMenu_menuSelect(evt:ContextMenuEvent):void
{
	adgMarketWatch.selectedIndex=lastRollOverIndex;
}

private function contextMenuItem_menuItemSelect(event:ContextMenuEvent):void
{
	var obj:MarketWatchBO=adgMarketWatch.selectedItem as MarketWatchBO;
	if (obj.SYMBOL != "")
	{
		if (obj && (obj.internalExchangeID < 0 || obj.internalMarketID < 0))
		{
			return;
		}
		
		windowManager.initSymbolSummWindow();
		windowManager.viewManager.symbolSumm.txtExchange.text=obj.EXCHANGE;
		windowManager.viewManager.symbolSumm.internalExchangeID=obj.internalExchangeID;
		windowManager.viewManager.symbolSumm.txtMarket.text=obj.MARKET;
		windowManager.viewManager.symbolSumm.internalMarketID=obj.internalMarketID;
		windowManager.viewManager.symbolSumm.txtSymbol.text=obj.SYMBOL;
		windowManager.viewManager.symbolSumm.symbolID=obj.symbolID;
		windowManager.viewManager.symbolSumm.loadSymbolData();
		
		if (windowManager.symbolSummWindow && windowManager.canvas.windowManager.container.contains(windowManager.symbolSummWindow))
		{
			windowManager.canvas.windowManager.bringToFront(windowManager.symbolSummWindow);
			return;
		}
		
		windowManager.canvas.windowManager.add(windowManager.symbolSummWindow);
	}
	
//	var obj:Object = windowManager.viewManager.marketWatch.adgMarketWatch.selectedItem;
//	alert = Alert.show("Property A: " + obj.@propertyA + "\\n" + "Property B: " + obj.@propertyB, obj.@label, Alert.OK);
}

//By Muhammad Anas Naeem 14-3-2011
// This function is the core function for populating the data provider of the Market Watch and the pagination functionailty
//in it !!!
//Changes by Muhammad Anas Naeem 14-3-2011 for the pagination functionality for the market watch 
//In the pagination functionality there is only one and only one single data grid and the pages are created dynamically 
// by the dynamic data. So thereby to avoid the over head of making multiple data grids objects which reduce the UI performance 
//significantly thereby taking a long time to render the UI completly 

// Note Please 
// This pagination code is a mutual effort the credit goes to "Haroon Shafiq" former Principal Software Engineer at Infotech (Pvt) and worked as C++ developer , Java Developer and Flex Developer
//who helped me in making the functionality now he lives in Australia  :) The Australian guy :)
//Though he didn't coded with me but helped me alot in figuring out how to get this piece of job done 

protected function adgMarketWatch_creationCompleteHandler(event:FlexEvent):void
{
	//	(event.target as DataGrid).dataProvider=modelManager.marketWatchModel.marketWatch[selectedIndex];
//	windowManager.viewManager.marketWatch.ver
	for (var i:int=0; i < modelManager.exchangeModel.exchanges.length; ++i)
	{
		var obj:Object=modelManager.exchangeModel.exchanges.getItemAt(i);
		//var cbi:ComboBoxItem = new ComboBoxItem(obj.EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		var cbi:ComboBoxItem=new ComboBoxItem(obj.INTERNAL_EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		exchangeList.addItem(cbi);
	}
	
	hiddenArray = modelManager.marketWatchModel.marketWatch[selectedIndex];
	
	pageSize = 30;//(adgMarketWatch.height/adgMarketWatch.rowHeight)-1 ;        
	//used to hold the page size. i.e the maximum number of sysmbols allowed to be populated on a single page 
	
	intPages = 6;//Math.ceil(exchangeList.length/pageSize);
	//calculating the Pages for the moment there are total six pages in the Market Watch but can be increased as much as the need.
	
	refreshDataProvider(index);
	//refresh the data provider. This function is used to refresh the data provider every time the user switches between different pages
	
	if(intPages<=1){ 
		intPages = 1;
		
		createNavBar(1);
//		highLightPage(nav);
	}else{ //more pages !!!
		createNavBar(intPages);   
//		highLightPage(nav);
	}
//	highLightPage(nav);
	showHideColumns(false);
}

protected function adgMarketWatch_itemClickHandler(event:ListEvent):void
{
	var menu:SelectionMenu;
	if (event.columnIndex == 0 && event.target.id == "adgMarketWatch")
	{
		menu=PopUpManager.createPopUp(this, SelectionMenu) as SelectionMenu;
		menu.lstList.dataProvider=exchangeList;
		positionMenu(event, menu);
		menu.addEventListener(Constants.EVENT_MENU_CLOSE, exchangeSelectionMenuClosed);
	}
	else if (event.columnIndex == 1 && event.target.id == "adgMarketWatch")
	{
		if (this.adgMarketWatch.selectedItem.internalExchangeID < 0)
		{
			Alert.show(ResourceManager.getInstance().getString('marketwatch','invalidExchange'),ResourceManager.getInstance().getString('marketwatch','error'));
			return;
		}
		menu=PopUpManager.createPopUp(this.adgMarketWatch, SelectionMenu) as SelectionMenu;
		marketList=modelManager.exchangeModel.getexchangeMarkets(this.adgMarketWatch.selectedItem.internalExchangeID);
		menu.lstList.dataProvider=marketList;
		positionMenu(event, menu);
		menu.addEventListener(Constants.EVENT_MENU_CLOSE, marketSelectionMenuClosed);
	}
}

private function positionMenu(event:ListEvent, menu:SelectionMenu):void
{
	var ptCell:Point=new Point(event.itemRenderer.x + event.currentTarget.x, event.itemRenderer.y + event.currentTarget.y + event.currentTarget.headerHeight);
	var ptMenu:Point=this.contentToGlobal(ptCell);
	if (menu.height + ptMenu.y > event.currentTarget.parent.height)
	{
		ptCell=new Point(event.itemRenderer.x + event.currentTarget.x, event.itemRenderer.y + event.currentTarget.y + event.currentTarget.headerHeight - menu.height + event.currentTarget.rowHeight);
		ptMenu=this.contentToGlobal(ptCell);
	}
	menu.lstList.width=event.currentTarget.columns[1].width;
	menu.move(ptMenu.x, ptMenu.y);
}

protected function exchangeSelectionMenuClosed(event:Event):void
{
	if (!event.currentTarget.lstList.selectedItem)
	{
		return;
	}
	// modified on 31/3/2011
	//	this.adgMarketWatch.selectedItem.init();
	//	this.adgMarketWatch.selectedItem.EXCHANGE = event.currentTarget.lstList.selectedItem.label;
	//	this.adgMarketWatch.selectedItem.internalExchangeID = event.currentTarget.lstList.selectedItem.value;
	//	this.adgMarketWatch.selectedItem.exchangeID = ModelManager.getInstance().exchangeModel.getExchangeID(this.adgMarketWatch.selectedItem.internalExchangeID);
	if (this.adgMarketWatch.selectedItem.internalExchangeID != event.currentTarget.lstList.selectedItem.value)
	{
		this.adgMarketWatch.selectedItem.init();
		this.adgMarketWatch.selectedItem.EXCHANGE=event.currentTarget.lstList.selectedItem.label;
		this.adgMarketWatch.selectedItem.internalExchangeID=event.currentTarget.lstList.selectedItem.value;
		this.adgMarketWatch.selectedItem.exchangeID=ModelManager.getInstance().exchangeModel.getExchangeID(this.adgMarketWatch.selectedItem.internalExchangeID);
		this.adgMarketWatch.selectedItem.internalMarketID=-1;
		this.adgMarketWatch.selectedItem.marketID=-1;
		this.adgMarketWatch.selectedItem.MARKET="";
		this.adgMarketWatch.selectedItem.symbolID=-1;
		this.adgMarketWatch.selectedItem.SYMBOL="";
	} 
}

protected function marketSelectionMenuClosed(event:Event):void
{
	if (!event.currentTarget.lstList.selectedItem)
	{
		return;
	}
	// modified on 31/3/2011
	//	this.adgMarketWatch.selectedItem.init();
	//	this.adgMarketWatch.selectedItem.MARKET = event.currentTarget.lstList.selectedItem.label;
	//	this.adgMarketWatch.selectedItem.internalMarketID = event.currentTarget.lstList.selectedItem.value;
	//	this.adgMarketWatch.selectedItem.marketID = ModelManager.getInstance().exchangeModel.getMarketID(this.adgMarketWatch.selectedItem.internalExchangeID, this.adgMarketWatch.selectedItem.internalMarketID);
	
	if (this.adgMarketWatch.selectedItem.internalMarketID != event.currentTarget.lstList.selectedItem.value)
	{
		this.adgMarketWatch.selectedItem.init();
		this.adgMarketWatch.selectedItem.MARKET=event.currentTarget.lstList.selectedItem.label;
		this.adgMarketWatch.selectedItem.internalMarketID=event.currentTarget.lstList.selectedItem.value;
		this.adgMarketWatch.selectedItem.marketID=ModelManager.getInstance().exchangeModel.getMarketID(this.adgMarketWatch.selectedItem.internalExchangeID, this.adgMarketWatch.selectedItem.internalMarketID);
		this.adgMarketWatch.selectedItem.symbolID=-1;
		this.adgMarketWatch.selectedItem.SYMBOL="";
	}
}

protected function adgMarketWatch_doubleClickHandler(event:MouseEvent):void
{
	try
	{
		if (event.currentTarget.selectedItem && (event.currentTarget.selectedItem.internalExchangeID < 0 || event.currentTarget.selectedItem.internalMarketID < 0))
		{
			return;
		}
		
		//var windowManager:WindowManager = WindowManager.getInstance();
		if (windowManager.bestOrdersWindow && windowManager.canvas.windowManager.container.contains(windowManager.bestOrdersWindow))
		{
			windowManager.canvas.windowManager.bringToFront(windowManager.bestOrdersWindow);
			return;
		}
		windowManager.initBestOrdersWindow();
		windowManager.viewManager.bestOrders.txtExchange.text=event.currentTarget.selectedItem.EXCHANGE;
		windowManager.viewManager.bestOrders.internalExchangeID=event.currentTarget.selectedItem.internalExchangeID;
		windowManager.viewManager.bestOrders.txtMarket.text=event.currentTarget.selectedItem.MARKET;
		windowManager.viewManager.bestOrders.internalMarketID=event.currentTarget.selectedItem.internalMarketID;
		windowManager.viewManager.bestOrders.txtSymbol.text=event.currentTarget.selectedItem.SYMBOL;
		windowManager.viewManager.bestOrders.symbolID=event.currentTarget.selectedItem.symbolID;
		windowManager.viewManager.bestOrders.updateBestOrders();
		windowManager.canvas.windowManager.add(windowManager.bestOrdersWindow);
	}
	catch(e:Error)
	{
		trace(e.message);
	}
}

protected function toolbar_clickHandler(event:MouseEvent):void
{
	try
	{
		if(event)
		{
			if (event.currentTarget != null &&event.currentTarget.id == "equities") // Equities
			{
				currentPage = equitiesPreviousIndex;
				equitiesPage = 1;
				bonds.source = null;
				if(FlexGlobals.topLevelApplication.parameters.LOCALE == 'en_US')
				{
					bonds.source=bondsUp;
				}
				else
				{
//					bonds.source=AR_bondsUpImage;
				}
				bondsPage = 0;
				equities.source = null;
				if(FlexGlobals.topLevelApplication.parameters.LOCALE == 'en_US')
				{
					equities.source = equitiesOverImage;
				}
				else
				{
//					equities.source = AR_equtiesOverImage;
				}
				selectedIndex=0; //event.currentTarget.selectedIndex;
				refreshDataProvider(currentPage);
				adgMarketWatch.dataProvider=bindedArray;//modelManager.marketWatchModel.marketWatch[selectedIndex];
		//				showHideColumns(false);
				highLightPage(currentPage);			
			}
			else
			{
				selectedIndex=selectedIndex;
			}
			if (event.currentTarget != null && event.currentTarget.id == "bonds") // Bonds
			{
				currentPage = bondsPreviousPage;
				bondsPage = 2;
				equities.source = null;
				if(FlexGlobals.topLevelApplication.parameters.LOCALE == 'en_US')
				{
					equities.source = equitiesUpImage;
				}
				else
				{
//					equities.source = AR_equtiesUpImage;
				}
				equitiesPage = 0;
				bonds.source = null;
				if(FlexGlobals.topLevelApplication.parameters.LOCALE == 'en_US')
				{
					bonds.source=bondsOver;
				}
				else
				{
//					bonds.source=AR_bondsOverImage;
				}
				selectedIndex=1
//				pageNav.selectedIndex = selectedIndex+5;
				refreshDataProvider(currentPage);
				adgMarketWatch.dataProvider=bindedArray;//modelManager.marketWatchModel.marketWatch[selectedIndex];
				showHideColumns(true);
				isBondsSelectedFirstTime = true;
				highLightPage(currentPage);
			}
			else
			{
				currentPage = 0;
				equitiesPage = 1;
				bonds.source = null;
				if(FlexGlobals.topLevelApplication.parameters.LOCALE == 'en_US')
				{
					bonds.source=bondsUp;
				}
				else
				{
//					bonds.source=AR_bondsUpImage;
				}
				bondsPage = 0;
				equities.source = null;
				if(FlexGlobals.topLevelApplication.parameters.LOCALE == 'en_US')
				{
					equities.source = equitiesOverImage;
				}
				else
				{
//					equities.source = AR_equtiesOverImage;
				}
				selectedIndex=0; //event.currentTarget.selectedIndex;
//				refreshDataProvider(currentPage);
//				adgMarketWatch.dataProvider=bindedArray;
				showHideColumns(false);  
//				highLightPage(nav);
				/*pageNav.selectedIndex = selectedIndex;
				
				var curItem:Object = event.target.getChildAt(selectedIndex);  //d66316 0xff2020 fb6605
				selectedIndex==pageNav.selectedIndex ? curItem.setStyle("color", 0xfb6605) : curItem.setStyle("color", 0x000000);    */
			}
		}
		// This case doesn't happens but just in case 
		else
		{
			currentPage = 0;
			equitiesPage = 1;
			bonds.source = null;
			bonds.source=bondsUp;
			bondsPage = 0;
			equities.source = null;
			equities.source = equitiesOverImage;
			selectedIndex=0; //event.currentTarget.selectedIndex;
			refreshDataProvider(currentPage);
			adgMarketWatch.dataProvider=bindedArray;
			showHideColumns(false);  
		}
	}catch(e:Error)
	{
		trace(e.message);
	}
}

private function disable_toolbar_tabs():void
{
	//By Anas
	// temporarily added to disable last three tabs
	
	
	//	var img1:Image = this.derivatives as Image;
	//	btn1.enabled = false;
	//	
	//	var img2:Image = this.toolbar.dataGroup.getElementAt(3) as Image;
	//	btn2.enabled = false;
	//	
	//	var img3:Image = this.toolbar.dataGroup.getElementAt(4) as Image;
	//	btn3.enabled = false;
	
}

public function showHideColumns(toShow:Boolean):void
{
	//colIssueName.visible = toShow;
	if (modelManager.marketWatchModel.marketWatchCols.dispIRRCol)
		colIRR.visible=toShow;
	if (modelManager.marketWatchModel.marketWatchCols.dispAIRRCol)
		colAIRR.visible=toShow;
	if (modelManager.marketWatchModel.marketWatchCols.dispBaseRateCol)
		colBaseRate.visible=toShow;
	if (modelManager.marketWatchModel.marketWatchCols.dispSpreadRateCol)
		colSpreadRate.visible=toShow;
	if (modelManager.marketWatchModel.marketWatchCols.dispCouponRateCol)
		colCouponRate.visible=toShow;
	if (modelManager.marketWatchModel.marketWatchCols.dispNextCouponCol)
		colNextCoupon.visible=toShow;
	if (modelManager.marketWatchModel.marketWatchCols.dispMaturityDateCol)
		colMaturityDate.visible=toShow;
	
	if (modelManager.marketWatchModel.marketWatchCols.dispBuyYield)
		colBuyYield.visible=toShow;
	if (modelManager.marketWatchModel.marketWatchCols.dispSellYield)
		colSellYield.visible=toShow;
	if (modelManager.marketWatchModel.marketWatchCols.dispDaysToMaturityCol)
		colDaysToMaturity.visible=toShow;
	//colFloor.visible = toShow;
	//colCap.visible = toShow;
	//colMTM.visible = toShow;
}

/**
 * Focus out Handler
 *
 */

protected function adgMarketWatch_FocusOutHandler(event:DataGridEvent):void
{
	
	isInvalidSymbol=false;
	// Get the cell editor and cast it to TextInput.
	var cellEditor:TextInput=mx.controls.TextInput(event.currentTarget.itemEditorInstance);
	
	// Get the new value from the editor.
	var newVal:String=cellEditor.text;
	//cellEditor.text = cellEditor.text.toUpperCase();
	// Get the old value.
	var oldVal:String=event.currentTarget.editedItemRenderer.data[event.dataField];
	
	if (oldVal)
		oldVal=oldVal.toUpperCase();
	if (newVal)
		newVal=newVal.toUpperCase();
	
	cellEditor.text=newVal;
	
	if (newVal != oldVal)
	{
		var mwbo:MarketWatchBO=event.currentTarget.selectedItem as MarketWatchBO;
		
		if (mwbo.internalExchangeID < 0 || mwbo.internalMarketID < 0)
		{
			cellEditor.text="";
			return;
		}
		//		event.stopImmediatePropagation();
		//		event.preventDefault();
		mwbo.SYMBOL=newVal.toUpperCase();
		addSymbolToWatch(event.currentTarget.selectedIndex);
		if (isInvalidSymbol)
		{
			cellEditor.text="";
			isInvalidSymbol=false;
			var marketWatchView1:MarketWatch = WindowManager.getInstance().viewManager.marketWatch;
			marketWatchView1.adgMarketWatch.selectedItem.SYMBOL = "";
		}
	}
	//	event.stopImmediatePropagation();
	//	event.preventDefault();	
	
}


/**
 * KeyUp handler
 */

// Modified on 14/1/2011 : This method is no more called as new implentation uses item edit end event 
protected function adgMarketWatch_keyUpHandler(event:KeyboardEvent):void
{
	// modified on 21/12/2010
	//if ( event.keyCode != 13 )
	if (!(event.keyCode == 13 || event.keyCode == 9))
	{
		return;
	}
	
	//get symbol data
	event.stopImmediatePropagation();
	event.preventDefault();
	/*modelManager.marketWatchModel.marketWatch[selectedIndex][event.currentTarget.selectedIndex].SYMBOL =
	modelManager.marketWatchModel.marketWatch[selectedIndex][event.currentTarget.selectedIndex].SYMBOL.toUpperCase();
	if ( modelManager.marketWatchModel.marketWatch[selectedIndex][event.currentTarget.selectedIndex].internalMarketID < 0 ||
	modelManager.marketWatchModel.marketWatch[selectedIndex][event.currentTarget.selectedIndex].SYMBOL.length <= 0)
	{
	return;
	}
	modelManager.marketWatchModel.marketWatch[selectedIndex][event.currentTarget.selectedIndex].init();
	var internalExchangeID:Number = modelManager.marketWatchModel.marketWatch[selectedIndex][event.currentTarget.selectedIndex].internalExchangeID;
	var internalMarketID:Number = modelManager.marketWatchModel.marketWatch[selectedIndex][event.currentTarget.selectedIndex].internalMarketID;
	
	
	/*var internalSymbolID:Number = modelManager.exchangeModel.getInternalSymbolIDByCode(
	internalExchangeID,
	internalMarketID,
	modelManager.marketWatchModel.marketWatch[selectedIndex][event.currentTarget.selectedIndex].SYMBOL
	);* /
	var obj:Object = modelManager.exchangeModel.getSymbolByCode(
	internalExchangeID,
	internalMarketID,
	modelManager.marketWatchModel.marketWatch[selectedIndex][event.currentTarget.selectedIndex].SYMBOL
	);
	
	if (!obj)
	{
	return;
	}*/
	
	addSymbolToWatch( /*obj, */event.currentTarget.selectedIndex);
}

/* Added by Anas 10th April 2012 if we want to add the symbol using the symbol browser window*/
public function addSymbolToWatchFromSymbolBrowser(selectIndex:Number,index:Number):void
{ 
	var marketWatchView:MarketWatch=WindowManager.getInstance().viewManager.marketWatch;
	marketWatchView.adgMarketWatch.selectedItem.init();
	/* Modified by Anas 13th April 2012 for if the user is dealing in the equities market*/
	if(equitiesPage == 1)
	{
		windowManager.viewManager.symbolBrowser.isInvalidSymbol = false;
//		showHideColumns(false);
	}
	if(bondsPage == 2)
	{
//		showHideColumns(true);
	}
	selectedIndex = selectIndex;
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL;//=modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL.toUpperCase();
	if (modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalMarketID < 0 || modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL.length <= 0)
	{
		// added on 10/1/2011
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
		// added on 2/2/2011
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=-1;
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].init();
		return;
	}
//	marketWatchView.adgMarketWatch.selectedItem.init();
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].init();
	var internalExchangeID:Number=modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalExchangeID;
	var internalMarketID:Number=modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalMarketID;
	
	var obj:Object=modelManager.exchangeModel.getSymbolByCode(internalExchangeID, internalMarketID, modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL);
	
	if (!obj)
	{
		// added on 10/1/2011
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
		// added on 2/2/2011
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=-1;
		isInvalidSymbol=true;
		return;
	}
	// added on 27/1/2011 to fix feed update issue
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=obj.SYMBOL_ID;
	
	// added on 10/12/2010
	if (modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID < 0)
	{
		var symbolId:Number=modelManager.exchangeModel.getSymbolID(internalExchangeID, internalMarketID, obj.INTERNAL_SYMBOL_ID);
		
		if (symbolId < 0)
		{
			Alert.show(ResourceManager.getInstance().getString('marketwatch','invalidSymbol'),ResourceManager.getInstance().getString('marketwatch','error'));
			modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
			// added on 2/2/2011
			modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=-1;
			isInvalidSymbol=true;
			return;
		}
		else
		{
			modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=symbolId;
		}
	}
	
	
	/***/
	var internalSymbolID:Number=obj.INTERNAL_SYMBOL_ID;
	
	if (obj.hasOwnProperty("SYMBOL_TYPE") && obj.SYMBOL_TYPE == "Bond")
	{
		// Modified by Anas due to the bonds market symbol handling 12th April 2012
		if (bondsPage != 2)
		{
			Alert.show(ResourceManager.getInstance().getString('marketwatch','noBondSymbol'), ResourceManager.getInstance().getString('marketwatch','error'));
			modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
			// added on 2/2/2011
			modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=-1;
			windowManager.viewManager.symbolBrowser.isInvalidSymbol=true;
			return;
		}
		showHideColumns(true);
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].IRR=(obj as BondBO).IRR.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].AIRR=(obj as BondBO).AIRR.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].BASE_RATE=(obj as BondBO).baseRate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SPREAD_RATE=(obj as BondBO).spreadRate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].COUPON_RATE=(obj as BondBO).couponRate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].DISCOUNT_RATE=(obj as BondBO).discountRate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].NEXT_COUPON=(obj as BondBO).nextCouponDate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].MATURITY_DATE=(obj as BondBO).maturityDate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].DAYS_TO_MATURITY = (obj as BondBO).daysToMaturity.toString();
		marketWatchView.adgMarketWatch.selectedItem.IRR=(obj as BondBO).IRR.toString();
		marketWatchView.adgMarketWatch.selectedItem.AIRR=(obj as BondBO).AIRR.toString();
		marketWatchView.adgMarketWatch.selectedItem.BASE_RATE=(obj as BondBO).baseRate.toString();
		marketWatchView.adgMarketWatch.selectedItem.SPREAD_RATE=(obj as BondBO).spreadRate.toString();
		marketWatchView.adgMarketWatch.selectedItem.COUPON_RATE=(obj as BondBO).couponRate.toString();
		marketWatchView.adgMarketWatch.selectedItem.DISCOUNT_RATE=(obj as BondBO).discountRate.toString();
		marketWatchView.adgMarketWatch.selectedItem.NEXT_COUPON=(obj as BondBO).nextCouponDate.toString();
		marketWatchView.adgMarketWatch.selectedItem.MATURITY_DATE=(obj as BondBO).maturityDate.toString();
		marketWatchView.adgMarketWatch.selectedItem.DAYS_TO_MATURITY = (obj as BondBO).daysToMaturity.toString();
		windowManager.viewManager.symbolBrowser.isInvalidSymbol = false;
		
	}
	// Modified by Anas due to the bonds market symbol handling 12th April 2012
	else if (bondsPage == 2)
	{
		Alert.show(ResourceManager.getInstance().getString('marketwatch','nonBondSymbol'), ResourceManager.getInstance().getString('marketwatch','error'));
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
		// added on 2/2/2011
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=-1;
		windowManager.viewManager.symbolBrowser.isInvalidSymbol = true;
		isInvalidSymbol=true;
		return;
	}
	
	if (internalSymbolID < 0)
	{
		Alert.show(ResourceManager.getInstance().getString('marketwatch','invalidSymbol'),ResourceManager.getInstance().getString('marketwatch','error'));
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
		isInvalidSymbol=true;
		return;
	}
	
	ModelManager.getInstance().symbolTickerFeedModel.addFeedItem(modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL, 0, 0, 0);
	
	/*var internalExchangeID:Number =
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalExchangeID;
	var internalMarketID:Number =
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalMarketID;*/
	
	//	ModelManager.getInstance().getBestMarketAndSymbolSummaryByName(
	//		internalExchangeID,
	//		internalMarketID,
	//		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL
	
	ModelManager.getInstance().getBestMarketAndSymbolSummary(internalExchangeID, internalMarketID, modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID, modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL);
	
	var key:String=modelManager.exchangeModel.getExchangeID(internalExchangeID) + "_" + modelManager.exchangeModel.getMarketID(internalExchangeID, internalMarketID) + "_" + modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID;
	var itemName:String="BMEMS_" + key;
	// End : modified on 4/4/2011 after discussion with usman
	LSListener.getInstance().subscribeItem(
		itemName,
		LSListener.fieldSchemaBestMarket,
		LSListener.getInstance().lsClientBestMarket,
		windowManager.viewManager.marketWatch.updateBestMarketOrderFields
	);
	
	// End Modified on 28/1/2011 to fix market watch update issue on relogin
	//Start :  modified on 03/01/2011
	//itemName = "Symbol_" + symbolID.toString();
	itemName = "STEMS_" + key;
	//End :  modified on 03/01/2011
	LSListener.getInstance().subscribeItem(
		itemName,
		LSListener.fieldSchemaSymbolStat,
		LSListener.getInstance().lsClientSymbolStats,
		windowManager.viewManager.marketWatch.updateSymbolStatsOrderFields
	);
	//	modelManager.marketWatchModel.marketWatch.
}
/* Ended by Anas 10th April 2012 if we want to add the symbol using the symbol browser window*/


public function addSymbolToWatch( /*obj:Object, */index:Number):void
{ 
	/***/
	if(equitiesPage == 1)
	{
			selectedIndex = currentPage;
			showHideColumns(false);
	}
	// added by Anas on 12th April 2012 for the purpose if we have page number exceeded than 5 i.e if we are handling bond market
	var marketWatchView:MarketWatch=WindowManager.getInstance().viewManager.marketWatch;
	marketWatchView.adgMarketWatch.selectedItem.init();
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].EXCHANGE=modelManager.exchangeModel.getExchangeCode(marketWatchView.adgMarketWatch.selectedItem.internalExchangeID);
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].MARKET=modelManager.exchangeModel.getMarketCode(marketWatchView.adgMarketWatch.selectedItem.internalExchangeID, marketWatchView.adgMarketWatch.selectedItem.internalMarketID);
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL=marketWatchView.adgMarketWatch.selectedItem.SYMBOL;
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalExchangeID=marketWatchView.adgMarketWatch.selectedItem.internalExchangeID;
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalMarketID=marketWatchView.adgMarketWatch.selectedItem.internalMarketID;
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=marketWatchView.adgMarketWatch.selectedItem.symbolID;
	// ended by Anas 12/04/2012.
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL.toUpperCase();
	if (modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalMarketID < 0 || modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL.length <= 0)
	{
		// added on 10/1/2011
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
		// added on 2/2/2011
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=-1;
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].init();
		return;
	}
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].init();
	var internalExchangeID:Number=modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalExchangeID;
	var internalMarketID:Number=modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalMarketID;
	
	var obj:Object=modelManager.exchangeModel.getSymbolByCode(internalExchangeID, internalMarketID, modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL);
	
	if (!obj)
	{
		// added on 10/1/2011
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
		// added on 2/2/2011
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=-1;
		isInvalidSymbol=true;
		return;
	}
	// added on 27/1/2011 to fix feed update issue
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=obj.SYMBOL_ID;
	
	// added on 10/12/2010
	if (modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID < 0)
	{
		var symbolId:Number=modelManager.exchangeModel.getSymbolID(internalExchangeID, internalMarketID, obj.INTERNAL_SYMBOL_ID);
		
		if (symbolId < 0)
		{
			Alert.show(ResourceManager.getInstance().getString('marketwatch','invalidSymbol'),ResourceManager.getInstance().getString('marketwatch','error'));
			modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
			// added on 2/2/2011
			modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=-1;
			isInvalidSymbol=true;
			return;
		}
		else
		{
			modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=symbolId;
		}
	}
	
	
	/***/
	var internalSymbolID:Number=obj.INTERNAL_SYMBOL_ID;
	
	if (obj.hasOwnProperty("SYMBOL_TYPE") && obj.SYMBOL_TYPE == "Bond")
	{
		// Modified by Anas due to the bonds market symbol handling 12th April 2012
		if (bondsPage != 2)
		{
			Alert.show(Messages.ERROR_NO_BOND_SYMBOL, Messages.TITLE_ERROR);
			modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
			// added on 2/2/2011
			modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=-1;
			isInvalidSymbol=true;
			return;
		}
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].IRR=(obj as BondBO).IRR.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].AIRR=(obj as BondBO).AIRR.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].BASE_RATE=(obj as BondBO).baseRate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SPREAD_RATE=(obj as BondBO).spreadRate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].COUPON_RATE=(obj as BondBO).couponRate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].DISCOUNT_RATE=(obj as BondBO).discountRate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].NEXT_COUPON=(obj as BondBO).nextCouponDate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].MATURITY_DATE=(obj as BondBO).maturityDate.toString();
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].DAYS_TO_MATURITY = (obj as BondBO).daysToMaturity.toString();
		marketWatchView.adgMarketWatch.selectedItem.init();
		marketWatchView.adgMarketWatch.selectedItem.IRR=(obj as BondBO).IRR.toString();
		marketWatchView.adgMarketWatch.selectedItem.AIRR=(obj as BondBO).AIRR.toString();
		marketWatchView.adgMarketWatch.selectedItem.BASE_RATE=(obj as BondBO).baseRate.toString();
		marketWatchView.adgMarketWatch.selectedItem.SPREAD_RATE=(obj as BondBO).spreadRate.toString();
		marketWatchView.adgMarketWatch.selectedItem.COUPON_RATE=(obj as BondBO).couponRate.toString();
		marketWatchView.adgMarketWatch.selectedItem.DISCOUNT_RATE=(obj as BondBO).discountRate.toString();
		marketWatchView.adgMarketWatch.selectedItem.NEXT_COUPON=(obj as BondBO).nextCouponDate.toString();
		marketWatchView.adgMarketWatch.selectedItem.MATURITY_DATE=(obj as BondBO).maturityDate.toString();
		marketWatchView.adgMarketWatch.selectedItem.DAYS_TO_MATURITY = (obj as BondBO).daysToMaturity.toString();
	}
	// Modified by Anas due to the bonds market symbol handling 12th April 2012
	else if (bondsPage == 2)
	{
		Alert.show(Messages.ERROR_NON_BOND_SYMBOL, Messages.TITLE_ERROR);
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
		// added on 2/2/2011
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID=-1;
		isInvalidSymbol=true;
		return;
	}
	
	if (internalSymbolID < 0)
	{
		Alert.show(ResourceManager.getInstance().getString('marketwatch','invalidSymbol'),ResourceManager.getInstance().getString('marketwatch','error'));
		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL="";
		isInvalidSymbol=true;
		return;
	}
	
	ModelManager.getInstance().symbolTickerFeedModel.addFeedItem(modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL, 0, 0, 0);
	
	/*var internalExchangeID:Number =
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalExchangeID;
	var internalMarketID:Number =
	modelManager.marketWatchModel.marketWatch[selectedIndex][index].internalMarketID;*/
	
	//	ModelManager.getInstance().getBestMarketAndSymbolSummaryByName(
	//		internalExchangeID,
	//		internalMarketID,
	//		modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL
	
	ModelManager.getInstance().getBestMarketAndSymbolSummary(internalExchangeID, internalMarketID, modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID, modelManager.marketWatchModel.marketWatch[selectedIndex][index].SYMBOL);
	
	var key:String=modelManager.exchangeModel.getExchangeID(internalExchangeID) + "_" + modelManager.exchangeModel.getMarketID(internalExchangeID, internalMarketID) + "_" + modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID;
	var itemName:String="BMEMS_" + key;
	// End : modified on 4/4/2011 after discussion with usman
	LSListener.getInstance().subscribeItem(
		itemName,
		LSListener.fieldSchemaBestMarket,
		LSListener.getInstance().lsClientBestMarket,
		windowManager.viewManager.marketWatch.updateBestMarketOrderFields
	);
	
	// End Modified on 28/1/2011 to fix market watch update issue on relogin
	//Start :  modified on 03/01/2011
	//itemName = "Symbol_" + symbolID.toString();
	itemName = "STEMS_" + key;
	//End :  modified on 03/01/2011
	LSListener.getInstance().subscribeItem(
		itemName,
		LSListener.fieldSchemaSymbolStat,
		LSListener.getInstance().lsClientSymbolStats,
		windowManager.viewManager.marketWatch.updateSymbolStatsOrderFields
	);
}

public function handleOrderConfirmation(event:NonVisualItemUpdateEvent):void
{
	
	//var event:NonVisualItemUpdateEvent = new NonVisualItemUpdateEvent(null, null, null, null);
	//var windowManager:WindowManager = WindowManager.getInstance();
	var strMsg:String="";
	
	if (windowManager.marketWatchWindow)
	{
		
		if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[0]) == "0") // sub
		{
			if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[23]) == "1")
			{
				if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[9]) == "0")
				{
//					strMsg+=Constants.BUY_COLOR;
//					strMsg+="'>";
					strMsg+=LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[12]).replace("T", " ");
					strMsg+=' '+ResourceManager.getInstance().getString('marketwatch','negotiatedBuy')+' '
				}
				else
				{
//					strMsg+=Constants.SELL_COLOR;
//					strMsg+="'>";
					strMsg+=LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[12]).replace("T", " ");
					strMsg+=' '+ResourceManager.getInstance().getString('marketwatch','negotiatedSell')+' ';
				}
			}
			else
			{
				if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[9]) == "0")
				{
//					strMsg+=Constants.BUY_COLOR;
//					strMsg+="'>";
					strMsg+=LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[12]).replace("T", " ");
					strMsg+=' '+ResourceManager.getInstance().getString('marketwatch','buy')+' ';
				}
				else
				{
//					strMsg+=Constants.SELL_COLOR;
//					strMsg+="'>";
					strMsg+=LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[12]).replace("T", " ");
					strMsg+=' '+ResourceManager.getInstance().getString('marketwatch','sell')+' ';
				}
			}
			strMsg=formatOrderQueuedMessage(event, strMsg);
			SoundManager.getInstance().playBuySound();
		}
		else if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[0]) == "1") // can
		{
//			strMsg+="#FC0606";
//			strMsg+="'>";
			strMsg+=LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[12]).replace("T", " ");
			strMsg+=' '+ResourceManager.getInstance().getString('marketwatch','cancelled')+' ';
			if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[9]) == "0")
			{
				strMsg+=' '+ResourceManager.getInstance().getString('marketwatch','buy')+' ';
			}
			else
			{
				strMsg+=' '+ResourceManager.getInstance().getString('marketwatch','sell')+' ';
			}
			strMsg=formatOrderQueuedMessage(event, strMsg);
			//if (windowManager.cancelOrderWindow)
			if (windowManager.cancelOrderWindow && windowManager.canvas.windowManager.container.contains(windowManager.cancelOrderWindow))
			{
				var tempOrder:Order=new Order();
				windowManager.viewManager.cancelOrder.reset();
				windowManager.cancelOrderWindow.close();
			}
		}
		else if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[0]) == "2") // cha
		{
			if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[9]) == "0")
			{
//				strMsg+=Constants.BUY_COLOR;
//				strMsg+="'>";
				strMsg += LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[12]).replace("T", " ");
				strMsg+=' '+ResourceManager.getInstance().getString('marketwatch','changedBuy')+' ';
			}
			else
			{
//				strMsg+=Constants.SELL_COLOR;
//				strMsg+="'>";
				strMsg += LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[12]).replace("T", " ");
				strMsg+=' '+ResourceManager.getInstance().getString('marketwatch','changedSell')+' ';
			}
			strMsg=formatOrderQueuedMessage(event, strMsg);
			if (windowManager.changeOrderWindow)
			{
				windowManager.viewManager.changeOrder.reset();
				windowManager.changeOrderWindow.close();
			}
		}
		else if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[0]) == "3") // exe
		{
			if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[9]) == "0")
			{
//				strMsg+=Constants.BUY_COLOR;
//				strMsg+="'>";
				strMsg+=LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[12]).replace("T", " ");
				strMsg+=ResourceManager.getInstance().getString('marketwatch','trade');
				strMsg+=LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[17]);
				strMsg+=ResourceManager.getInstance().getString('marketwatch','bought');
			}
			else
			{
//				strMsg+=Constants.SELL_COLOR;
//				strMsg+="'>";
				strMsg+=LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[12]).replace("T", " ");
				strMsg+=ResourceManager.getInstance().getString('marketwatch','trade');
				strMsg+=LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[17]);
				strMsg+=ResourceManager.getInstance().getString('marketwatch','sold');
			}
			strMsg=formatOrderQueuedMessage(event, strMsg);
			SoundManager.getInstance().playTradeSound();
			//ModelManager.getInstance().userTradeHistoryModel.isDirty = true;
			//ModelManager.getInstance().updateUserTradeHistory();
		}
			// usman majeed - for RSS
		else if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[0]) == "4") // rejected
		{
			if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[9]) == "0")
			{
//				strMsg += Constants.REJ_COLOR;
//				strMsg += "'>";
				strMsg += LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[12]).replace("T", " ");
				strMsg += ' '+ResourceManager.getInstance().getString('marketwatch','rejectedBuyIn')+' ';
			}
			else
			{
//				strMsg += Constants.REJ_COLOR;
//				strMsg += "'>";
				strMsg += LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[12]).replace("T", " ");
				strMsg +=' '+ResourceManager.getInstance().getString('marketwatch','rejectedSellIn')+' ';
			}
			// modified on 24/2/2011
			var strExchangeCode:String = modelManager.exchangeModel.getExchangeCode( new Number (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[18])));
			var strMarketCode:String = modelManager.exchangeModel.getMarketCode( new Number (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[18])),
				new Number (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[5])) );
			
			//var symbolDetail:SymbolBO = modelManager.exchangeModel
			
			strMsg+=strMarketCode +' '+ResourceManager.getInstance().getString('marketwatch','marketIn')+' '+ strExchangeCode + ''+ResourceManager.getInstance().getString('marketwatch','exchange')+'. ';
			
			if(LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[20]) == "0")
			{
				strMsg += LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[19]); // external rejection
			}
			else
			{
				strMsg += getReasonMessage(new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[20])), event,strExchangeCode, strMarketCode);
			}
			//strMsg += LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[19]);
		}
		// usman majeed - for RSS
		strMsg+="";
//		strMsg+="</font><br />";
//		windowManager.viewManager.liveMessages.updateStatus2(event,strMsg);
		
		callLater(focusNewRow);
	}
	updateReports();
	
	windowManager.viewManager.liveMessages.txaMessages.validateNow();
	windowManager.viewManager.liveMessages.txaMessages.verticalScrollPosition=windowManager.viewManager.liveMessages.txaMessages.maxVerticalScrollPosition; // added on 2/12/2010
	//handleOrderConfirmation1(itemName, itemPos, updatedFields, index - 1);
}

private function getReasonMessage(index:Number, event:NonVisualItemUpdateEvent, strExchangeCode:String,strMarketCode:String):String
{
	// added on 24/2/2011
	var internalExchangeID:Number = new Number (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[18]));
	var exchangeID:Number = ModelManager.getInstance().exchangeModel.getExchangeID(internalExchangeID);
	var internalMarketID:Number = new Number (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[5]));
	var marketID:Number = ModelManager.getInstance().exchangeModel.getMarketID(internalExchangeID,internalMarketID);
	var internalSymbolID:Number = new Number (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[10]));
	var symbolID:Number = modelManager.exchangeModel.getSymbolID(internalExchangeID,internalMarketID,internalSymbolID);
	var strSymbolCode :String = modelManager.exchangeModel.getSymbolCode(internalExchangeID,internalMarketID,internalSymbolID);
	var strOrderVolume:String = LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[16]);
	
	var key:String = exchangeID+
		"_" + marketID+
		"_" + symbolID;
	var browser:SymbolBrowserBO = new SymbolBrowserBO();
	
	var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO = ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;
	if(bestMarketAndSymbolSummary && bestMarketAndSymbolSummary.symbolSummary && bestMarketAndSymbolSummary.symbolSummary.browser )
	{
		browser = bestMarketAndSymbolSummary.symbolSummary.browser;	
	}
	
	
	var message:String = "";
	switch (index)
	{
		case 1:
			message = ReasonMessages.INVALID_CLIENT + " "+ LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[21]) + ".";
			break;
		case 2:
			message = ReasonMessages.INVALID_EXCHANGE + " "+ strExchangeCode  + ".";
			break;
		case 3:
			message = ReasonMessages.INVALID_MARKET  + " "+ strMarketCode  + ".";
			break;	
		case 4:
			message = ReasonMessages.INVALID_SYMBOL + " " + strSymbolCode;
			break;
		case 5:
			message = "Market "+strMarketCode +" Not Allowed. ";
			break;
		case 6:
			message = ReasonMessages.INVALID_MARKET_STATE + " "+strMarketCode;
			break;
		case 7:
			message = ReasonMessages.CLEARINGID_NOT_DEFINED;
			break;
		case 8:
			message = strSymbolCode + " "+ReasonMessages.SYMBOL_SUSPENDED;
			break;
		case 9:
			message = ReasonMessages.USER_SUSPENDED;
			break;
		case 10:
			message = "Volume lot size for "+strSymbolCode+" is  "+browser.lotSize; //ReasonMessages.VOL_NOT_MTPLE_OF_BLOT;
			break;
		case 11:
			message = "Price tick size for "+strSymbolCode+" is  "+browser.tickSize;//ReasonMessages.PRICE_NOT_MTPLE_OF_TICK_SIZE;
			break;
		case 12:
			message = "Circuit breaker limits for "+strSymbolCode+" are "+browser.circuitBreakerDown + " - "+browser.circuitBreakerUp;//ReasonMessages.INVALID_PRICE;
			break;
		case 13:
			message = "Volume limits for "+strSymbolCode+" are "+browser.lowerVolumeLimit + " - "+browser.upperVolumeLimit;//ReasonMessages.VOL_UPPER_LIM_EXCEEDED;
			break;
		case 14:
			message = "Volume limits for "+strSymbolCode+" are "+browser.lowerVolumeLimit + " - "+browser.upperVolumeLimit;//ReasonMessages.VOL_LOWER_LIM_EXCEEDED;
			break;
		case 15:
			message = "Value limits for "+strSymbolCode+" are "+browser.lowerValueLimit + " - "+browser.upperValueLimit;//ReasonMessages.VAL_UPPER_LIM_EXCEEDED;
			break;
		case 16:
			message = "Value limits for "+strSymbolCode+" are "+browser.lowerValueLimit + " - "+browser.upperValueLimit;//ReasonMessages.VAL_LOWER_LIM_EXCEEDED;
			break;
		case 17:
			message = ReasonMessages.INVALID_TERMINAL;
			break;
		case 18:
			message = ReasonMessages.NO_OPPOSITE_SIDE + strSymbolCode + ". Volume: " + strOrderVolume + ".";
			break;
		case 19:
			message = ReasonMessages.GRANTS_NOT_AVAILABLE;
			break;
		case 20:
			message = ReasonMessages.CREDIT_LINE_LIMIT_EXCEEDED;
			break;
		case 21:
			message = ReasonMessages.SHORT_SELL + strSymbolCode + ". Volume: " + strOrderVolume + ".";
			break;
		case 22:
			message = ReasonMessages.NOT_AFFIRMED;
			break;
		case 23:
			message = ReasonMessages.CHANGE_NOT_ALLAOWED_NEGOTIATED_ORDER;
			break;
		case 24:
			message = ReasonMessages.INVALID_ORDER;
			break;
		case 25:
			message = ReasonMessages.DISCLOSED_VOLUME_LESS_THAN_VOLUME;
			break;
		case 26:
			message = ReasonMessages.DISCLOSED_VOLUME_NOT_MULTIPLE_OF_BOARDLOT+ ". Board Lot: " + browser.lotSize;
			break;
		
		case 27:
			message = ReasonMessages.VOLUME_NOT_MULTIPLE_OF_DISCLOSED_VOLUME;
			break;
		case 28:
			message = ReasonMessages.INVALID_BUYING_POWER;
			break;
		case 29:
			message = ReasonMessages.INVALID_USER;
			break;
		case 30:
			message = ReasonMessages.NOT_ALLOWED_IN_PREOPEN + " Market: " + strMarketCode + ".";
			break;
		case 31:
			message = ReasonMessages.INACTIVE_CLIENT + ". Account Code : " + LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[21]) ;
			break;
		case 32:
			message = ReasonMessages.CASH_LIMIT_EXCEEDED;
			break;
		case 33:
			message = ReasonMessages.NOT_SUFFICIENT_OPPOSIT_SIDE + strSymbolCode + ". Volume: " + strOrderVolume + ".";
			break;	
		default : 
			message = "";
	}
	return message;
}

public function updateStatus(statusMsg:String):void
{
	//	windowManager.viewManager.liveMessages.txaMessages.htmlText += "<TEXTFORMAT><span style='background-color:#222021;'><font color='#FFFFFF'>" + statusMsg + "</font><span><br /></TEXTFORMAT>";
}

public function updateBulletin(statusMsg:String):void
{
	
}

public function updateAnnouncement(statusMsg:String):void  
{
	//	windowManager.viewManager.liveMessages.txaCorporateAnnouncements.htmlText += "<TEXTFORMAT><span style='background-color:#222021;'><font color='#FFFFFF'>" + statusMsg + "</font><span><br /></TEXTFORMAT>";
}

public function focusNewRow():void  
{
	
	windowManager.viewManager.liveMessages.txaMessages.verticalScrollPosition=windowManager.viewManager.liveMessages.txaMessages.maxVerticalScrollPosition;
	
}

private function formatOrderQueuedMessage(event:NonVisualItemUpdateEvent, strMsg:String):String
{
	var ezNumberFormatter:EZNumberFormatter = new EZNumberFormatter();
	var str:String = LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[16]);
	strMsg += ezNumberFormatter.format(str) + " ";
	var strSymbolCode:String = modelManager.exchangeModel.getSymbolCode( new Number (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[18])),
		new Number (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[5])),
		new Number (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[10])) );
	strMsg += strSymbolCode + " @ ";
	var ezCurrencyFormatter:EZCurrencyFormatter = new EZCurrencyFormatter();
	str = LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[7]);
	strMsg += ezCurrencyFormatter.format( str ) + ''+ ResourceManager.getInstance().getString('marketwatch','for')+'';
	strMsg += LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[21]) + ''+ ResourceManager.getInstance().getString('marketwatch','orderNumber')+'';
	strMsg += LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[6]) + ''+ ResourceManager.getInstance().getString('marketwatch','in')+'';
	var strMarketCode:String = modelManager.exchangeModel.getMarketCode( new Number (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[18])),
		new Number (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[5])) );
	strMsg += strMarketCode + ''+ ResourceManager.getInstance().getString('marketwatch','market')+'.';
	// added on 14/1/2011
	if (LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[0]) == "3")
	{
		var orderNo:Number = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[6]));
		var orderBO:OrderBO = ModelManager.getInstance().remainingOrdersModel.getOrderBOByOrderNumber(orderNo);
		if(orderBO)
		{
			var remaining_volume:Number =  new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[25]));
			remainedVol = remaining_volume;
			var volume:Number =  new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaOrderConfirmation[16])); 
			strMsg += ''+ ResourceManager.getInstance().getString('marketwatch','remainingVolume')+'' + remaining_volume;	
		}
		
	}
	return strMsg;
}

private function updateReports():void
{
	//ModelManager.getInstance().bestOrdersModel.isDirty = true;
	//ModelManager.getInstance().remainingOrdersModel.isDirty = true;
	//ModelManager.getInstance().updateRemainingOrders();
	//ModelManager.getInstance().updateBestOrders();
}

public function updateMarketWatchView(bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO):void
{
	for (var i:int=0; i < Constants.PAGE_COUNT_MARKET_WATCH; ++i)
	{
		for (var j:int=0; j < Constants.ROW_COUNT_MARKET_WATCH; ++j)
		{
			if (bestMarketAndSymbolSummary.symbolName == modelManager.marketWatchModel.marketWatch[i][j].SYMBOL && bestMarketAndSymbolSummary.exchangeId == modelManager.marketWatchModel.marketWatch[i][j].exchangeID && bestMarketAndSymbolSummary.marketId == modelManager.marketWatchModel.marketWatch[i][j].marketID)
			{
				if (bestMarketAndSymbolSummary.symbolSummary && bestMarketAndSymbolSummary.symbolSummary.browser)
				{
					// modified on 6/1/2011
					//modelManager.marketWatchModel.marketWatch[i][j].symbolID =
					//	bestMarketAndSymbolSummary.symbolSummary.browser.symbolID
					modelManager.marketWatchModel.marketWatch[i][j].symbolID=bestMarketAndSymbolSummary.symbolID;
					
					// added on 22/2/2011
					modelManager.marketWatchModel.marketWatch[i][j].SECTOR=bestMarketAndSymbolSummary.symbolSummary.browser.sector;
				}
				if (bestMarketAndSymbolSummary.symbolSummary && bestMarketAndSymbolSummary.symbolSummary.stats)
				{
					modelManager.marketWatchModel.marketWatch[i][j].LAST=bestMarketAndSymbolSummary.symbolSummary.stats.lastTradePrice.toString();
					modelManager.marketWatchModel.marketWatch[i][j].CHANGE=bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
					modelManager.marketWatchModel.marketWatch[i][j].TURN_OVER=bestMarketAndSymbolSummary.symbolSummary.stats.turnover.toString();
					modelManager.marketWatchModel.marketWatch[i][j].LAST_VOLUME=bestMarketAndSymbolSummary.symbolSummary.stats.lastTradeSize.toString();
					modelManager.marketWatchModel.marketWatch[i][j].LAST=bestMarketAndSymbolSummary.symbolSummary.stats.lastTradePrice.toString();
					modelManager.marketWatchModel.marketWatch[i][j].TURN_OVER=bestMarketAndSymbolSummary.symbolSummary.stats.turnover.toString();
					modelManager.marketWatchModel.marketWatch[i][j].TRADES=bestMarketAndSymbolSummary.symbolSummary.stats.totalNoOfTrades.toString();
					modelManager.marketWatchModel.marketWatch[i][j].OPEN=bestMarketAndSymbolSummary.symbolSummary.stats.open.toString();
					modelManager.marketWatchModel.marketWatch[i][j].AVERAGE=bestMarketAndSymbolSummary.symbolSummary.stats.averagePrice.toString();
					modelManager.marketWatchModel.marketWatch[i][j].HIGH=bestMarketAndSymbolSummary.symbolSummary.stats.high.toString();
					modelManager.marketWatchModel.marketWatch[i][j].LOW=bestMarketAndSymbolSummary.symbolSummary.stats.low.toString();
					modelManager.marketWatchModel.marketWatch[i][j].CHANGE=bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
				}
				if (bestMarketAndSymbolSummary.bestMarket)
				{
					if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO)
					{
						if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE > 0 && bestMarketAndSymbolSummary.bestMarket.buyOrderBO.VOLUME > 0)
						{
							modelManager.marketWatchModel.marketWatch[i][j].BUY=bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE.toString();
							modelManager.marketWatchModel.marketWatch[i][j].BUY_VOLUME=bestMarketAndSymbolSummary.bestMarket.buyOrderBO.VOLUME.toString();
						}
					}
					if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO)
					{
						if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE > 0 && bestMarketAndSymbolSummary.bestMarket.sellOrderBO.VOLUME > 0)
						{
							modelManager.marketWatchModel.marketWatch[i][j].SELL=bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE.toString();
							modelManager.marketWatchModel.marketWatch[i][j].SELL_VOLUME=bestMarketAndSymbolSummary.bestMarket.sellOrderBO.VOLUME.toString();
						}
					}
				}
			}
		}
	}
}

public function updateBestMarketOrderFields(event:NonVisualItemUpdateEvent):void
{  
	try
	{
		var windowManager:WindowManager=WindowManager.getInstance();
		//		windowManager.viewManager.quickOrders.quikcOrdersLiveValues(itemName ,itemPos ,updatedFields ,index);
		var itemID:Array = event.currentTarget.groupString.split("_");
		var ezNumberFormatter:EZNumberFormatter = new EZNumberFormatter();
		var ezCurrencyFormatter:EZCurrencyFormatter = new EZCurrencyFormatter();
		var splittedSellPrice:Array=ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[5])).toString().split(".");
		var splittedBuyPrice:Array=ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[1])).toString().split(".");
		
		
		for (var i:int=0; i < Constants.PAGE_COUNT_MARKET_WATCH; ++i)
		{
			for (var j:int=0; j < Constants.ROW_COUNT_MARKET_WATCH; ++j)
			{
				if (
					// modified on 4/4/2011
					modelManager.marketWatchModel.marketWatch[i][j].symbolID == itemID[3] 
					&& modelManager.marketWatchModel.marketWatch[i][j].marketID == itemID[2] 
					&& modelManager.marketWatchModel.marketWatch[i][j].exchangeID == itemID[1])
				{
					modelManager.marketWatchModel.marketWatch[i][j].BUY = 
						ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[1]));
					
					modelManager.marketWatchModel.marketWatch[i][j].BUY_OLD =
						ezCurrencyFormatter.format(LSListener.getOldFieldData(event, LSListener.fieldSchemaBestMarket[1]));
					
					modelManager.marketWatchModel.marketWatch[i][j].BUY_VOLUME = 
						ezNumberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[3]));
					
					modelManager.marketWatchModel.marketWatch[i][j].BUY_VOLUME_OLD = 
						ezNumberFormatter.format(LSListener.getOldFieldData(event, LSListener.fieldSchemaBestMarket[3]));
					
					modelManager.marketWatchModel.marketWatch[i][j].SELL = 
						ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[5]));
					
					modelManager.marketWatchModel.marketWatch[i][j].SELL_OLD = 
						ezCurrencyFormatter.format(LSListener.getOldFieldData(event, LSListener.fieldSchemaBestMarket[5]));
					
					modelManager.marketWatchModel.marketWatch[i][j].SELL_VOLUME = 
						ezNumberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[7]));
					
					modelManager.marketWatchModel.marketWatch[i][j].SELL_VOLUME_OLD = 
						ezNumberFormatter.format(LSListener.getOldFieldData(event, LSListener.fieldSchemaBestMarket[7]));
					//For Buy Buttons	
					if (windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedIndex != -1 
						&& (windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == 
						itemID[3]
					)
					{
						if (splittedBuyPrice)
						{
							windowManager.viewManager.quickOrders.firstBuyBeforeDecimal.text=ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[1])).toString();//(splittedBuyPrice[0] != null && !isNaN(splittedBuyPrice[0]) ? splittedBuyPrice[0] : splittedBuyPrice[0]="--");
//							windowManager.viewManager.quickOrders.firstBuyAfterDecimal.text="." + (splittedBuyPrice[1] != null && !isNaN(splittedBuyPrice[1]) ? splittedBuyPrice[1] : "");
						}
						
					}
					if (windowManager.viewManager.quickOrders.secondSymbolDropDown.selectedIndex != -1 
						&& (windowManager.viewManager.quickOrders.secondSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == 
						itemID[3]
					)
					{
						if (splittedBuyPrice)
						{
							windowManager.viewManager.quickOrders.secondBuyBeforeDecimal.text=ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[1])).toString();//(splittedBuyPrice[0] != null && !isNaN(splittedBuyPrice[0]) ? splittedBuyPrice[0] : splittedBuyPrice[0]="--");
//							windowManager.viewManager.quickOrders.secondBuyAfterDecimal.text="." + (splittedBuyPrice[1] != null && !isNaN(splittedBuyPrice[1]) ? splittedBuyPrice[1] : "");
						}
						
					}
					if (windowManager.viewManager.quickOrders.thirdSymbolDropDown.selectedIndex != -1
						&& (windowManager.viewManager.quickOrders.thirdSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == 
						itemID[3]
					)
					{
						if (splittedBuyPrice)
						{
							windowManager.viewManager.quickOrders.thirdBuyBeforeDecimal.text=ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[1])).toString();//(splittedBuyPrice[0] != null && !isNaN(splittedBuyPrice[0]) ? splittedBuyPrice[0] : splittedBuyPrice[0]="--");
//							windowManager.viewManager.quickOrders.thirdBuyAfterDecimal.text="." + (splittedBuyPrice[1] != null && !isNaN(splittedBuyPrice[1]) ? splittedBuyPrice[1] : "");
						}
						
					}
					if (windowManager.viewManager.quickOrders.fourthSymbolDropDown.selectedIndex != -1 
						&& (windowManager.viewManager.quickOrders.fourthSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == 
						itemID[3] 
					)
					{
						if (splittedBuyPrice)
						{
							windowManager.viewManager.quickOrders.fourthBuyBeforeDecimal.text=ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[1])).toString();//(splittedBuyPrice[0] != null && !isNaN(splittedBuyPrice[0]) ? splittedBuyPrice[0] : splittedBuyPrice[0]="--");
//							windowManager.viewManager.quickOrders.fourthBuyAfterDecimal.text="." + (splittedBuyPrice[1] != null && !isNaN(splittedBuyPrice[1]) ? splittedBuyPrice[1] : "");
						}
						
					}
					//For Sell Buttons
					if(windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedIndex != -1 
						&& (windowManager.viewManager.quickOrders.firstSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == 
						itemID[3] 
					)
					{
						if (splittedSellPrice)
						{
							windowManager.viewManager.quickOrders.firstSellBeforeDecimal.text=ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[5])).toString()//(splittedSellPrice[0] != null && !isNaN(splittedSellPrice[0]) ? splittedSellPrice[0] : splittedSellPrice[0]="--");
//							windowManager.viewManager.quickOrders.firstSellAfterDecimal.text="." + (splittedSellPrice[1] != null && !isNaN(splittedSellPrice[1]) ? splittedSellPrice[1] : "");
						}
						
					}
					if(windowManager.viewManager.quickOrders.secondSymbolDropDown.selectedIndex != -1 
						&& (windowManager.viewManager.quickOrders.secondSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == 
						itemID[3]
					)
					{
						if (splittedSellPrice)
						{
							windowManager.viewManager.quickOrders.secondSellBeforeDecimal.text=ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[5])).toString()//(splittedSellPrice[0] != null && !isNaN(splittedSellPrice[0]) ? splittedSellPrice[0] : splittedSellPrice[0]="--");
//							windowManager.viewManager.quickOrders.secondSellAfterDecimal.text="." + (splittedSellPrice[1] != null && !isNaN(splittedSellPrice[1]) ? splittedSellPrice[1] : "");
						}
						
					}	
					if (windowManager.viewManager.quickOrders.thirdSymbolDropDown.selectedIndex != -1
						&& (windowManager.viewManager.quickOrders.thirdSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == 
						itemID[3]
					)
					{
						if (splittedSellPrice)
						{
							windowManager.viewManager.quickOrders.thirdSellBeforeDecimal.text=ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[5])).toString()//(splittedSellPrice[0] != null && !isNaN(splittedSellPrice[0]) ? splittedSellPrice[0] : splittedSellPrice[0]="--");
//							windowManager.viewManager.quickOrders.thirdSellAfterDecimal.text="." + (splittedSellPrice[1] != null && !isNaN(splittedSellPrice[1]) ? splittedSellPrice[1] : "");
							
						}
						
					}
					if(windowManager.viewManager.quickOrders.fourthSymbolDropDown.selectedIndex != -1 
						&& (windowManager.viewManager.quickOrders.fourthSymbolDropDown.selectedItem as QuickOrdersBO).symbolID == 
						itemID[3] 
					)
					{
						if (splittedSellPrice)
						{
							
							windowManager.viewManager.quickOrders.fourthSellBeforeDecimal.text=ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[5])).toString()//(splittedSellPrice[0] != null && !isNaN(splittedSellPrice[0]) ? splittedSellPrice[0] : splittedSellPrice[0]="--");
//							windowManager.viewManager.quickOrders.fourthSellAfterDecimal.text="." + (splittedSellPrice[1] != null && !isNaN(splittedSellPrice[1]) ? splittedSellPrice[1] : "");
						}
						
					}
					
					
					if (modelManager.marketWatchModel.marketWatch[i][j].BUY_VOLUME == "0")
					{
						modelManager.marketWatchModel.marketWatch[i][j].BUY_VOLUME="";
						modelManager.marketWatchModel.marketWatch[i][j].BUY="";
					}
					
					if (modelManager.marketWatchModel.marketWatch[i][j].SELL_VOLUME == "0")
					{
						modelManager.marketWatchModel.marketWatch[i][j].SELL_VOLUME="";
						modelManager.marketWatchModel.marketWatch[i][j].SELL="";
					}
				}
			}
		}
		windowManager.viewManager.buyOrder.updateBestMarketOrderFields(event);
		windowManager.viewManager.sellOrder.updateBestMarketOrderFields(event);
		// added on 23/2/2011
		windowManager.viewManager.symbolSumm.updateBestMarketSymbolSummFields(event);
		// added on 1/4/2011
		//	updateBestMarketOrderFields1(itemName, itemPos, updatedFields, index - 1);
	}
	catch (e:Error)
	{
		trace(e.errorID + '' + e.message);
	}
}

//private function updateBestMarket(event:NonVisualItemUpdateEvent):void
//{
//	var itemID:Array = event.currentTarget.groupString.split("_");
//	
//	if (symbol.SYMBOL == itemID[0] && itemID[1] == modelManager.exchangeModel.getMarketID(internalExchangeID,internalMarketID))
//	{
//		symbol.BUY = moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[1]));
//		
//		symbol.BUY_VOLUME = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[3]));
//		
//		symbol.SELL = moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[5]));
//		
//		symbol.SELL_VOLUME = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[7]));
//	}	

//}

public function updateSymbolStatsOrderFields(event:NonVisualItemUpdateEvent):void
{
	//var event:NonVisualItemUpdateEvent = new NonVisualItemUpdateEvent(null, null, null, null);
	//	var itemID:Array = event.currentTarget.groupString.split("_");
	var itemID:Array = event.currentTarget.groupString.split("_");
	var ezNumberFormatter:EZNumberFormatter=new EZNumberFormatter();
	var ezCurrencyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
	
	for (var i:int=0; i < Constants.PAGE_COUNT_MARKET_WATCH; ++i)
	{
		for (var j:int=0; j < Constants.ROW_COUNT_MARKET_WATCH; ++j)
		{
			if (
				// Modified on 03/01/2011
				//modelManager.marketWatchModel.marketWatch[i][j].symbolID == itemID[1]
				modelManager.marketWatchModel.marketWatch[i][j].exchangeID == itemID[1]
				&& modelManager.marketWatchModel.marketWatch[i][j].marketID == itemID[2]
				&& modelManager.marketWatchModel.marketWatch[i][j].symbolID == itemID[3])
			{
				modelManager.marketWatchModel.marketWatch[i][j].LAST_VOLUME = 
					ezNumberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[0]));
				
				modelManager.marketWatchModel.marketWatch[i][j].LAST = 
					ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[1]));
				
				modelManager.marketWatchModel.marketWatch[i][j].LAST_OLD = 
					ezCurrencyFormatter.format(LSListener.getOldFieldData(event, LSListener.fieldSchemaSymbolStat[1]));
				
				modelManager.marketWatchModel.marketWatch[i][j].LAST_FEED_UPDATED = true;
				
				modelManager.marketWatchModel.marketWatch[i][j].TURN_OVER = 
					ezNumberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[2]));
				
				modelManager.marketWatchModel.marketWatch[i][j].TRADES = 
					ezNumberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[3]));
				
				modelManager.marketWatchModel.marketWatch[i][j].OPEN = 
					ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[4]));
				
				modelManager.marketWatchModel.marketWatch[i][j].AVERAGE = 
					ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[5]));
				
				modelManager.marketWatchModel.marketWatch[i][j].HIGH = 
					ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[6]));
				
				modelManager.marketWatchModel.marketWatch[i][j].LOW = 
					ezCurrencyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[7]));
				
				modelManager.marketWatchModel.marketWatch[i][j].CHANGE = 
					ezNumberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[8]));
				
				modelManager.marketWatchModel.marketWatch[i][j].LAST_DAY_CLOSE_PRICE = 
					ezNumberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[9]));
				
				ModelManager.getInstance().symbolTickerFeedModel.addFeedItem(
					modelManager.marketWatchModel.marketWatch[i][j].SYMBOL,
					modelManager.marketWatchModel.marketWatch[i][j].CHANGE.replace(",", ""),
					modelManager.marketWatchModel.marketWatch[i][j].LAST.replace(",", ""),
					modelManager.marketWatchModel.marketWatch[i][j].LAST_VOLUME.replace(",", "")
				);
			}
		}
	}
	windowManager.viewManager.buyOrder.updateSymbolStatsOrderFields(event);
	windowManager.viewManager.sellOrder.updateSymbolStatsOrderFields(event);
	// added on 23/2/2011
	windowManager.viewManager.symbolSumm.updateSymbolStatsSymbolSummFields(event);
	//updateSymbolStatsOrderFields1(itemName, itemPos, updatedFields, index - 1);
}



// added on 4/3/2011
public function stringSortCompare(itemA:Object, itemB:Object):int
{
	var compareValue:int=0;
	var itemAValue:String="";
	var itemBValue:String="";
	if (sortColumn == "EXCHANGE")
	{
		itemAValue=itemA.EXCHANGE == null ? "" : itemA.EXCHANGE;
		itemBValue=itemB.EXCHANGE == null ? "" : itemB.EXCHANGE;
	}
	else if (sortColumn == "MARKET")
	{
		itemAValue=itemA.MARKET == null ? "" : itemA.MARKET;
		itemBValue=itemB.MARKET == null ? "" : itemB.MARKET;
	}
	else if (sortColumn == "SYMBOL")
	{
		itemAValue=itemA.SYMBOL;
		itemBValue=itemB.SYMBOL;
	}
	compareValue=ObjectUtil.stringCompare(itemAValue, itemBValue);
	if (!sortDescending && (itemAValue == "" || itemBValue == ""))
	{
		if (compareValue == -1)
		{
			compareValue=1;
		}
		else if (compareValue == 1)
		{
			compareValue=-1;
		}
	}
	
	return compareValue;
}

public function calculateCurrentYield(currentPrice:Number, couponRate:Number):Number
{
	if (currentPrice > 0 && couponRate > 0)
		return new Number(numberFormatter.format((couponRate / currentPrice) * 100));
	else
		return 0;
}


public function applyFilter():void
{
}

/*  pagination by Anas 5th April 2012*/
private function refreshDataProvider(start:uint):void
{
	bindedArray = new ArrayCollection( hiddenArray.source.slice((start * pageSize),(start * pageSize) + pageSize) );
}

// This function is used to create the top pagination navigation bar of the Market Watch i.e 1 2 3 4 5...
private function createNavBar(pages:uint = 1,intSet:uint = 0):void
{
		nav.removeAll();
		if( intSet > 1 )
		{
			var intLFive:int = intSet-navSize; // calculate start of last 5;
		}
		
		for( var x:uint = 0; x < navSize; x++)
		{
			var pg:uint = x + intSet;
			var vale:uint = pg + 1;
			nav.addItem({label:pg + 1,data: pg});
			var pgg:uint = pg+1;
			//if reach the last page stop adding linkselectors on the navbar
			if(pgg>=intPages)
			{ 
				x=navSize; 
			}
		}
		
		var lastpage:Number = 0;
		//calculate the lastpage button
		for( var y:uint = navSize; y <= pages-1;y = y + navSize )
		{ 
			if(y+5 > navSize)
			{
				lastpage = y;
			}
		}
		setTimeout(launchAlert,200);
}
 protected function launchAlert():void
 {
	 for(var v:int = 0 ; v < 10 ; v++)
	 {
	 trace('aaa');
	 }
 }

protected function highColor():void
{
	var curItem:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(0);
	curItem.setStyle("color", 0xfb6605);
	
}
// This  function is used to highlight the current Page number when user selects any page.
private function highLightPage(cpn:Number):void
{
	try
	{
		var cp:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(cpn);
		for(var k:int = 0 ; k < windowManager.viewManager.marketWatch.pageNav.numChildren ; k++)
		{
			if(isBondsSelectedFirstTime == true && bondsPreviousPage == 6)
			{
				for(var i6:int = 0 ; i6 < windowManager.viewManager.marketWatch.pageNav.numChildren ; i6++)
				{
					var cp060:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(i6);
					cp060.setStyle("color", 0x000000);	
				}
				
				isBondsSelectedFirstTime = false;
				var cp0:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(0);
				cp0.setStyle("color", 0xfb6605);	
			}
			
			if(isBondsSelectedFirstTime == true && bondsPreviousPage > 6)
			{
				switch(bondsPreviousPage)
				{
					case 7:
						for(var i7:int = 0 ; i7 < windowManager.viewManager.marketWatch.pageNav.numChildren ; i7++)
						{
							var cp07:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(i7);
							cp07.setStyle("color", 0x000000);	
						}
						var cp7:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(1);
						isBondsSelectedFirstTime = false;
						cp7.setStyle("color", 0xfb6605);
						break;
					case 8:
						for(var i8:int = 0 ; i8 < windowManager.viewManager.marketWatch.pageNav.numChildren ; i8++)
						{
							var cp08:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(i8);
							cp08.setStyle("color", 0x000000);	
						}
						var cp8:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(2);
						isBondsSelectedFirstTime = false;
						cp8.setStyle("color", 0xfb6605);
						break;
					case 9:
						for(var i9:int = 0 ; i9 < windowManager.viewManager.marketWatch.pageNav.numChildren ; i9++)
						{
							var cp09:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(i9);
							cp09.setStyle("color", 0x000000);	
						}
						var cp9:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(3);
						isBondsSelectedFirstTime = false;
						cp9.setStyle("color", 0xfb6605);
						break;
					case 10:
						for(var i10:int = 0 ; i10 < windowManager.viewManager.marketWatch.pageNav.numChildren ; i10++)
						{
							var cp010:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(i10);
							cp010.setStyle("color", 0x000000);	
						}
						var cp10:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(4);
						isBondsSelectedFirstTime = false;
						cp10.setStyle("color", 0xfb6605);
						break;
					case 11:
						for(var i11:int = 0 ; i11 < windowManager.viewManager.marketWatch.pageNav.numChildren ; i11++)
						{
							var cp011:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(i11);
							cp011.setStyle("color", 0x000000);	
						}
						var cp11:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(5);
						isBondsSelectedFirstTime = false;
						cp11.setStyle("color", 0xfb6605);
						break;
				}
			}
			
			k==cpn ? cp.setStyle("color", 0xfb6605) : cp.setStyle("color", 0x000000);
			
			if(k==cpn && bondsPreviousPage > 5 )
			{
				for(var t:int = 0 ; t < windowManager.viewManager.marketWatch.pageNav.numChildren ; t++)
				{
					var cpp:Object = windowManager.viewManager.marketWatch.pageNav.getChildAt(t);
					cpp.setStyle("color", 0x000000);
				}
				cp.setStyle("color", 0xfb6605);
				break;
			}
		}
	}catch(e:Error)
	{
		trace(e.message);
	}
}

/* Refresh data per page groups part of pagination code
Basically this function is called when the user click's any certain page number and accrodingly from this function the data provider
of that page is updated as an be seen the call to refreshDataProvider(); function.
*/
private function navigatePage(event:ItemClickEvent):void
{
	if(equitiesPage == 1)
	{
		currentPage = event.item.data;
		if(bondsPage == 0)
		{
			equitiesPreviousIndex = event.item.data;
		}
		bondsPage = 0;
	}
	if(bondsPage == 2)
	{  
		currentPage = event.item.data+6;
		if(equitiesPage == 0)
		{
			bondsPreviousPage = currentPage;
		}
		equitiesPage = 0;
	}
	refreshDataProvider(currentPage);
	var lb:String = event.item.label.toString();
	if( lb.indexOf("<") > -1 || lb.indexOf(">") > -1 )
	{
		//createNavBar(Math.ceil(orgData.length/pageSize),event.item.data);
		createNavBar(Math.ceil(hiddenArray.length/pageSize),event.item.data);
	}
}
/* end of pagination by Muhammad Anas Naeem 13th April 2012*/