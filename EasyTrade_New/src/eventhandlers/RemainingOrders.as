import assets.skins.BuyCancelButton;
import assets.skins.BuyOkButton;
import assets.skins.CancelButtonOverSkin;
import assets.skins.SellOkButtonOverSkin;

import businessobjects.GrantBO;
import businessobjects.OrderBO;

import common.Constants;

import components.ComboBoxItem;

import controller.ModelManager;
import controller.ProfileManager;
import controller.ViewManager;
import controller.WindowManager;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.net.FileReference;

import flashx.textLayout.operations.ApplyFormatOperation;

import flexlib.mdi.containers.MDIWindow;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.FlexEvent;
import mx.graphics.GradientEntry;
import mx.graphics.LinearGradient;
import mx.graphics.SolidColor;

import spark.primitives.Rect;

import view.Order;

[Bindable]
public var modelManager:ModelManager=ModelManager.getInstance();

[Bindable]
private var tradersList:ArrayCollection=new ArrayCollection();


public var fr:FileReference = new FileReference();

protected function group1_initializeHandler(event:FlexEvent):void
{
	// added on 27/12/2010
	exchangeList.removeAll();
	for (var i:int=0; i < ModelManager.getInstance().exchangeModel.exchanges.length; ++i)
	{
		var obj:Object=ModelManager.getInstance().exchangeModel.exchanges.getItemAt(i);
		//var cbi:ComboBoxItem = new ComboBoxItem(obj.EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		var cbi:ComboBoxItem=new ComboBoxItem(obj.INTERNAL_EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		exchangeList.addItem(cbi);
	}
	//exchangeID = -1;
	internalExchangeID=-1;
	//marketID = -1;
	internalMarketID=-1;
	symbolID=-1;
	// added on 24/12/2010
	//setDefaultExchangeAndMarket();

	fr=new FileReference();
	fr.addEventListener(IOErrorEvent.IO_ERROR, fileIOError_Handler);
	fr.addEventListener(Event.COMPLETE, fileSaved_Handler);
	// added on 16/3/2011
	tradersList=modelManager.userProfileModel.getTraders("RemainingOrders");

}


protected function adgRemainingOrders_itemClickHandler(event:MouseEvent):void
{
	try
	{
		var windowManager:WindowManager=WindowManager.getInstance();
		if (!this.adgRemainingOrders.selectedItem)
		{
			return;
		}

		var ob:OrderBO=(this.adgRemainingOrders.selectedItem as OrderBO);
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

		if (this.adgRemainingOrders.selectedItem.SYMBOL_ID > 0)
		{
			var window:MDIWindow=null;
			var orderVeiw:Order=null;
			if (event.ctrlKey)
			{
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

				windowManager.viewManager.cancelOrder.isFromMenu=false;
				windowManager.viewManager.cancelOrder.reset();
				windowManager.viewManager.cancelOrder.disableFields(true);
				windowManager.viewManager.cancelOrder.isFirstSubmission=true;
				var cancelOrder:Order = windowManager.viewManager.cancelOrder;
				if (windowManager.cancelOrderWindow && windowManager.canvas.windowManager.container.contains(windowManager.cancelOrderWindow))
				{
					if((this.adgRemainingOrders.selectedItem as OrderBO).SIDE == "sell")
					{
						var rect:Rect = new Rect();
						var myFillo:LinearGradient=new LinearGradient();
						myFillo.rotation=90;
						var myFillColoro:GradientEntry=new GradientEntry(0xff8eba);
						myFillColoro.ratio=0.10;
						var myFillColors1:GradientEntry=new GradientEntry(0xfe498c);
						myFillColors1.ratio=0.90;
						myFillo.entries=[myFillColoro, myFillColors1];
						cancelOrder.bondPanel.backgroundFill=myFillo;
						
						
						
						
						var myFill2327:SolidColor=new SolidColor();
						myFill2327.color=0xbe3267;
						myFill2327.alpha=1;
						cancelOrder.bcMain.backgroundFill=myFill2327;
						
						windowManager.viewManager.cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.viewManager.cancelOrder.setStyle("borderColor", 0x909090);
						windowManager.viewManager.cancelOrder.setStyle("borderWeight", 1);
						windowManager.cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						cancelOrder.stdTopLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.topStdRt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdRgt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdBottom.setStyle("strokeColor", 0xbb3769);
						cancelOrder.addLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.addRgt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.additionalDetailsRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.bondPanelBottomRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataTopLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataTopRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataBottomRule.setStyle("strokeColor", 0xbb3769);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						cancelOrder.setStyle("borderVisible", true);
						cancelOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						cancelOrder.setStyle("borderThicknessTop", 2);
						cancelOrder.setStyle("color", Constants.TITLE_COLOR);
						cancelOrder.okButton.setStyle("skinClass", SellOkButtonOverSkin);
						cancelOrder.cancelButton.setStyle("skinClass", CancelButtonOverSkin);
						windowManager.cancelOrderWindow.setStyle("backgroundColor", 0x909090);
						windowManager.cancelOrderWindow.setStyle("borderWeight", 1);
//												cancelOrder.setStyle("backgroundColor", 0xbe3267);
						windowManager.updateCancelOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
						windowManager.canvas.windowManager.bringToFront(windowManager.cancelOrderWindow);
					}
					if((this.adgRemainingOrders.selectedItem as OrderBO).SIDE == "buy")
					{
						var myFill2:LinearGradient=new LinearGradient();
						myFill2.rotation=90;
						var myFillColor3:GradientEntry=new GradientEntry(0x94d9fa);
						myFillColor3.ratio=0.10;
						var myFillColor4:GradientEntry=new GradientEntry(0x5fc3f4);
						myFillColor4.ratio=0.90;
						myFill2.entries=[myFillColor3, myFillColor4];
						cancelOrder.bondPanel.backgroundFill=myFill2;
						
						var myFill2324:SolidColor=new SolidColor();
						myFill2324.color=0x0c70a2;
						myFill2324.alpha=1;
						cancelOrder.bcMain.backgroundFill=myFill2324;
						//						cancelOrder.grpFields.backgroundFill=myFill232;
						windowManager.cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.cancelOrderWindow.setStyle("borderColor", 0x909090);
						windowManager.cancelOrderWindow.setStyle("borderWeight", 1);
						windowManager.cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						cancelOrder.stdTopLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.topStdRt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdRgt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdBottom.setStyle("strokeColor", 0x51bbef);
						cancelOrder.addLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.addRgt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.additionalDetailsRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.bondPanelBottomRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataTopLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataTopRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataBottomRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.okButton.setStyle("skinClass", BuyOkButton);
						cancelOrder.cancelButton.setStyle("skinClass", BuyCancelButton);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.cancelOrderWindow.setStyle("borderColor", 0x909090);
						windowManager.cancelOrderWindow.setStyle("borderWeight", 1);
						cancelOrder.setStyle("borderVisible", true);
						cancelOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						cancelOrder.setStyle("borderThicknessTop", 2);
						cancelOrder.setStyle("color", Constants.TITLE_COLOR);
						
						windowManager.updateCancelOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
						windowManager.canvas.windowManager.bringToFront(windowManager.cancelOrderWindow);
					}
				}
				else
				{
					windowManager.initCancelOrderWindow();
					if((this.adgRemainingOrders.selectedItem as OrderBO).SIDE == "sell")
					{
						var rectuuu:Rect = new Rect();
						var myFilloo:LinearGradient=new LinearGradient();
						myFilloo.rotation=90;
						var myFillColoroo:GradientEntry=new GradientEntry(0xff8eba);
						myFillColoroo.ratio=0.10;
						var myFillColors11:GradientEntry=new GradientEntry(0xfe498c);
						myFillColors11.ratio=0.90;
						myFilloo.entries=[myFillColoroo, myFillColors11];
						cancelOrder.bondPanel.backgroundFill=myFilloo;
						
						
						
						
						var myFill23277:SolidColor=new SolidColor();
						myFill23277.color=0xbe3267;
						myFill23277.alpha=1;
						cancelOrder.bcMain.backgroundFill=myFill23277;
						
						windowManager.cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.cancelOrderWindow.setStyle("borderColor", 0x909090);
						windowManager.cancelOrderWindow.setStyle("borderWeight", 1);
						windowManager.cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						cancelOrder.stdTopLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.topStdRt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdRgt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdBottom.setStyle("strokeColor", 0xbb3769);
						cancelOrder.addLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.addRgt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.additionalDetailsRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.bondPanelBottomRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataTopLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataTopRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataBottomRule.setStyle("strokeColor", 0xbb3769);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						cancelOrder.setStyle("borderVisible", true);
						cancelOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						cancelOrder.setStyle("borderThicknessTop", 2);
						cancelOrder.setStyle("color", Constants.TITLE_COLOR);
						cancelOrder.okButton.setStyle("skinClass", SellOkButtonOverSkin);
						cancelOrder.cancelButton.setStyle("skinClass", CancelButtonOverSkin);
						windowManager.cancelOrderWindow.setStyle("backgroundColor", 0x909090);
						windowManager.cancelOrderWindow.setStyle("borderWeight", 1);
//												cancelOrder.setStyle("backgroundColor", 0xbe3267);
						windowManager.updateCancelOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
						windowManager.canvas.windowManager.add(windowManager.cancelOrderWindow);
						windowManager.canvas.windowManager.bringToFront(windowManager.cancelOrderWindow);
					}
					if((this.adgRemainingOrders.selectedItem as OrderBO).SIDE == "buy")
					{
						var myFill21:LinearGradient=new LinearGradient();
						myFill21.rotation=90;
						var myFillColor31:GradientEntry=new GradientEntry(0x94d9fa);
						myFillColor31.ratio=0.10;
						var myFillColor41:GradientEntry=new GradientEntry(0x5fc3f4);
						myFillColor41.ratio=0.90;
						myFill21.entries=[myFillColor31, myFillColor41];
						cancelOrder.bondPanel.backgroundFill=myFill21;
						
						var myFill23245:SolidColor=new SolidColor();
						myFill23245.color=0x0c70a2;
						myFill23245.alpha=1;
						cancelOrder.bcMain.backgroundFill=myFill23245;
						//						cancelOrder.grpFields.backgroundFill=myFill232;
						windowManager.cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.cancelOrderWindow.setStyle("borderColor", 0x909090);
						windowManager.cancelOrderWindow.setStyle("borderWeight", 1);
						windowManager.cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						cancelOrder.stdTopLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.topStdRt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdRgt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdBottom.setStyle("strokeColor", 0x51bbef);
						cancelOrder.addLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.addRgt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.additionalDetailsRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.bondPanelBottomRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataTopLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataTopRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataBottomRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.okButton.setStyle("skinClass", BuyOkButton);
						cancelOrder.cancelButton.setStyle("skinClass", BuyCancelButton);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.viewManager.cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.viewManager.cancelOrder.setStyle("borderColor", 0x909090);
						windowManager.viewManager.cancelOrder.setStyle("borderWeight", 1);
						cancelOrder.setStyle("borderVisible", true);
						cancelOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						cancelOrder.setStyle("borderThicknessTop", 2);
						cancelOrder.setStyle("color", Constants.TITLE_COLOR);
						
						windowManager.updateCancelOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
						windowManager.canvas.windowManager.add(windowManager.cancelOrderWindow);
						windowManager.canvas.windowManager.bringToFront(windowManager.cancelOrderWindow);
					}
				}
				window=windowManager.cancelOrderWindow;
				orderVeiw=windowManager.viewManager.cancelOrder;
				orderVeiw.COUNTER_CLIENT_ID=(this.adgRemainingOrders.selectedItem as OrderBO).COUNTER_CLIENT_ID;
				orderVeiw.COUNTER_ORDER_NO=(this.adgRemainingOrders.selectedItem as OrderBO).COUNTER_ORDER_NO;
				orderVeiw.COUNTER_USER_ID=(this.adgRemainingOrders.selectedItem as OrderBO).COUNTER_USER_ID;
				orderVeiw.CLIENT_ID=(this.adgRemainingOrders.selectedItem as OrderBO).CLIENT_ID;
				orderVeiw.IS_ORDER_NO_SWAPPED=(this.adgRemainingOrders.selectedItem as OrderBO).IS_ORDER_NO_SWAPPED;
				orderVeiw.NTType="Rejected";
				orderVeiw.focusManager.setFocus(orderVeiw.txtOrderNum);
			}
			else
			{
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

				if (ob.IS_NEGOTIATED && (ob.USER_ID == modelManager.userID && ob.USER_ID != ob.COUNTER_USER_ID))
				{
					return;
				}

				windowManager.viewManager.changeOrder.isFromMenu=false;
				windowManager.viewManager.changeOrder.reset();
				windowManager.viewManager.changeOrder.disableFields(false);
				windowManager.viewManager.changeOrder.isFirstSubmission=true;
				var changeOrder:Order = windowManager.viewManager.changeOrder;
				if (windowManager.changeOrderWindow && windowManager.canvas.windowManager.container.contains(windowManager.changeOrderWindow))
				{
					if((this.adgRemainingOrders.selectedItem as OrderBO).SIDE == "sell")
					{
						var recti:Rect = new Rect();
						var myFilloi:LinearGradient=new LinearGradient();
						myFilloi.rotation=90;
						var myFillColoroi:GradientEntry=new GradientEntry(0xff8eba);
						myFillColoroi.ratio=0.10;
						var myFillColors1i:GradientEntry=new GradientEntry(0xfe498c);
						myFillColors1i.ratio=0.90;
						myFilloi.entries=[myFillColoroi, myFillColors1i];
						changeOrder.bondPanel.backgroundFill=myFilloi;
						
						
						
						
						var myFill2327i:SolidColor=new SolidColor();
						myFill2327i.color=0xbe3267;
						myFill2327i.alpha=1;
						changeOrder.bcMain.backgroundFill=myFill2327i;
						
//						windowManager.viewManager.cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.changeOrderWindow.setStyle("borderColor", 0x909090);
						windowManager.changeOrderWindow.setStyle("borderWeight", 1);
						
						changeOrder.stdTopLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.topStdRt.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdRgt.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdBottom.setStyle("strokeColor", 0xbb3769);
						changeOrder.addLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.addRgt.setStyle("strokeColor", 0xbb3769);
						changeOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.additionalDetailsRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.bondPanelBottomRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataTopLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataTopRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataBottomRule.setStyle("strokeColor", 0xbb3769);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						changeOrder.setStyle("borderVisible", true);
						changeOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						changeOrder.setStyle("borderThicknessTop", 2);
						changeOrder.setStyle("color", Constants.TITLE_COLOR);
						changeOrder.okButton.setStyle("skinClass", SellOkButtonOverSkin);
						changeOrder.cancelButton.setStyle("skinClass", CancelButtonOverSkin);
						windowManager.changeOrderWindow.setStyle("borderColor", 0x909090);
						windowManager.changeOrderWindow.setStyle("borderWeight", 1);
						//												cancelOrder.setStyle("backgroundColor", 0xbe3267);
						
						windowManager.updateChangeOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
						windowManager.canvas.windowManager.bringToFront(windowManager.changeOrderWindow);
					}
					if((this.adgRemainingOrders.selectedItem as OrderBO).SIDE == "buy")
					{
						var myFill2u:LinearGradient=new LinearGradient();
						myFill2u.rotation=90;
						var myFillColor3u:GradientEntry=new GradientEntry(0x94d9fa);
						myFillColor3u.ratio=0.10;
						var myFillColor4u:GradientEntry=new GradientEntry(0x5fc3f4);
						myFillColor4u.ratio=0.90;
						myFill2u.entries=[myFillColor3u, myFillColor4u];
						changeOrder.bondPanel.backgroundFill=myFill2u;
						
						var myFill2324u:SolidColor=new SolidColor();
						myFill2324u.color=0x0c70a2;
						myFill2324u.alpha=1;
						changeOrder.bcMain.backgroundFill=myFill2324u;
						//						cancelOrder.grpFields.backgroundFill=myFill232;
//						windowManager.viewManager.changeOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.changeOrderWindow.setStyle("borderColor", 0x909090);
						windowManager.changeOrderWindow.setStyle("borderWeight", 1);
						
						changeOrder.stdTopLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.topStdRt.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdRgt.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdBottom.setStyle("strokeColor", 0x51bbef);
						changeOrder.addLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.addRgt.setStyle("strokeColor", 0x51bbef);
						changeOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.additionalDetailsRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.bondPanelBottomRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataTopLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataTopRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataBottomRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.okButton.setStyle("skinClass", BuyOkButton);
						changeOrder.cancelButton.setStyle("skinClass", BuyCancelButton);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.viewManager.changeOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.viewManager.changeOrder.setStyle("borderColor", 0x909090);
						windowManager.viewManager.changeOrder.setStyle("borderWeight", 1);
						changeOrder.setStyle("borderVisible", true);
						changeOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						changeOrder.setStyle("borderThicknessTop", 2);
						changeOrder.setStyle("color", Constants.TITLE_COLOR);
						
					
					windowManager.updateChangeOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
					windowManager.canvas.windowManager.bringToFront(windowManager.changeOrderWindow);
					}
				}
				else
				{
					windowManager.initChangeOrderWindow();
					if((this.adgRemainingOrders.selectedItem as OrderBO).SIDE == "sell")
					{
						var recth:Rect = new Rect();
						var myFilloh:LinearGradient=new LinearGradient();
						myFilloh.rotation=90;
						var myFillColoroh:GradientEntry=new GradientEntry(0xff8eba);
						myFillColoroh.ratio=0.10;
						var myFillColors1h:GradientEntry=new GradientEntry(0xfe498c);
						myFillColors1h.ratio=0.90;
						myFilloh.entries=[myFillColoroh, myFillColors1h];
						changeOrder.bondPanel.backgroundFill=myFilloh;
						
						
						
						
						var myFill2327h:SolidColor=new SolidColor();
						myFill2327h.color=0xbe3267;
						myFill2327h.alpha=1;
						changeOrder.bcMain.backgroundFill=myFill2327h;
						
//						windowManager.viewManager.cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.changeOrderWindow.setStyle("borderColor", 0x909090);
						windowManager.changeOrderWindow.setStyle("borderWeight", 1);
						changeOrder.stdTopLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.topStdRt.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdRgt.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdBottom.setStyle("strokeColor", 0xbb3769);
						changeOrder.addLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.addRgt.setStyle("strokeColor", 0xbb3769);
						changeOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.additionalDetailsRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.bondPanelBottomRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataTopLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataTopRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataBottomRule.setStyle("strokeColor", 0xbb3769);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						changeOrder.setStyle("borderVisible", true);
						changeOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						changeOrder.setStyle("borderThicknessTop", 2);
						changeOrder.setStyle("color", Constants.TITLE_COLOR);
						changeOrder.okButton.setStyle("skinClass", SellOkButtonOverSkin);
						changeOrder.cancelButton.setStyle("skinClass", CancelButtonOverSkin);
						windowManager.changeOrderWindow.setStyle("borderColor", 0x909090);
						windowManager.changeOrderWindow.setStyle("borderWeight", 1);
						//												cancelOrder.setStyle("backgroundColor", 0xbe3267);
						
						windowManager.updateChangeOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
						windowManager.canvas.windowManager.add(windowManager.changeOrderWindow);
						windowManager.canvas.windowManager.bringToFront(windowManager.changeOrderWindow);
					}
					if((this.adgRemainingOrders.selectedItem as OrderBO).SIDE == "buy")
					{
						var myFill2w:LinearGradient=new LinearGradient();
						myFill2w.rotation=90;
						var myFillColor3w:GradientEntry=new GradientEntry(0x94d9fa);
						myFillColor3w.ratio=0.10;
						var myFillColor4w:GradientEntry=new GradientEntry(0x5fc3f4);
						myFillColor4w.ratio=0.90;
						myFill2w.entries=[myFillColor3w, myFillColor4w];
						changeOrder.bondPanel.backgroundFill=myFill2w;
						
						var myFill2324w:SolidColor=new SolidColor();
						myFill2324w.color=0x0c70a2;
						myFill2324w.alpha=1;
						changeOrder.bcMain.backgroundFill=myFill2324w;
						//						cancelOrder.grpFields.backgroundFill=myFill232;
//						windowManager.viewManager.changeOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.changeOrderWindow.setStyle("borderColor", 0x909090);
						windowManager.changeOrderWindow.setStyle("borderWeight", 1);
						
						changeOrder.stdTopLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.topStdRt.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdRgt.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdBottom.setStyle("strokeColor", 0x51bbef);
						changeOrder.addLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.addRgt.setStyle("strokeColor", 0x51bbef);
						changeOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.additionalDetailsRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.bondPanelBottomRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataTopLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataTopRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataBottomRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.okButton.setStyle("skinClass", BuyOkButton);
						changeOrder.cancelButton.setStyle("skinClass", BuyCancelButton);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.viewManager.changeOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						windowManager.viewManager.changeOrder.setStyle("borderColor", 0x909090);
						windowManager.viewManager.changeOrder.setStyle("borderWeight", 1);
						changeOrder.setStyle("borderVisible", true);
						changeOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						changeOrder.setStyle("borderThicknessTop", 2);
						changeOrder.setStyle("color", Constants.TITLE_COLOR);
						
						
						windowManager.updateChangeOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
						windowManager.canvas.windowManager.add(windowManager.changeOrderWindow);
						windowManager.canvas.windowManager.bringToFront(windowManager.changeOrderWindow);
					}
				}
				window=windowManager.changeOrderWindow;
				orderVeiw=windowManager.viewManager.changeOrder;
				orderVeiw.COUNTER_CLIENT_ID=(this.adgRemainingOrders.selectedItem as OrderBO).COUNTER_CLIENT_ID;
				orderVeiw.COUNTER_ORDER_NO=(this.adgRemainingOrders.selectedItem as OrderBO).COUNTER_ORDER_NO;
				orderVeiw.COUNTER_USER_ID=(this.adgRemainingOrders.selectedItem as OrderBO).COUNTER_USER_ID;
				orderVeiw.CLIENT_ID=(this.adgRemainingOrders.selectedItem as OrderBO).CLIENT_ID;
				orderVeiw.NTType="Accepted";
				orderVeiw.IS_ORDER_NO_SWAPPED=(this.adgRemainingOrders.selectedItem as OrderBO).IS_ORDER_NO_SWAPPED;
				orderVeiw.focusManager.setFocus(orderVeiw.txtPrice);
			}

			// added on 4/1/2011
			modelManager.orderModel.REF_NO=(this.adgRemainingOrders.selectedItem as OrderBO).REF_NO;
			// added on 12/1/2011
			modelManager.orderModel.CLIENT_ID=(this.adgRemainingOrders.selectedItem as OrderBO).CLIENT_ID;
			modelManager.orderModel.USER_ID=(this.adgRemainingOrders.selectedItem as OrderBO).USER_ID;
			modelManager.orderModel.BROKER_ID=(this.adgRemainingOrders.selectedItem as OrderBO).BROKER_ID;

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
				/*			if (ob.IS_NEGOTIATED && (ob.COUNTER_USER_ID == modelManager.userID))
							{
								orderVeiw.disableTrader();
								orderVeiw.enableCounterClientID();

								if (this.adgRemainingOrders.selectedItem.SIDE == "buy")
								{
									windowManager.setWindowColor(window, orderVeiw, Constants.SELL_COLOR_INT);
								}
								else
								{
									windowManager.setWindowColor(window, orderVeiw, Constants.BUY_COLOR_INT);
								}
							}
							else
							*/
				{
					if (this.adgRemainingOrders.selectedItem.SIDE == "buy")
					{
						windowManager.setWindowColor(window, orderVeiw, Constants.BUY_COLOR_INT);
					}
					else
					{
						windowManager.setWindowColor(window, orderVeiw, Constants.SELL_COLOR_INT);
					}
				}
			}
		}
		windowManager.cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
		windowManager.changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
	}
	catch (e:Error)
	{
		trace('' + e.errorID);
	}
}

protected function txtSymbol_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 9 || event.keyCode == 13)
	{
		txtSymbol.text=txtSymbol.text.toUpperCase();
		internalSymbolID=ModelManager.getInstance().exchangeModel.getInternalSymbolIDByCode(internalExchangeID, internalMarketID, txtSymbol.text);
		applyFilter();
	}
}

public function applyFilterEx():void
{
	txtSymbol.text=txtSymbol.text.toUpperCase();
	internalSymbolID=ModelManager.getInstance().exchangeModel.getInternalSymbolIDByCode(internalExchangeID, internalMarketID, txtSymbol.text);
	applyFilter();
}

public function applyFilter():void
{
	modelManager.remainingOrdersModel.remainingOrders.refresh();
}

/*public var userID:Number;
private var isExpanded:Boolean = false;

public function handleExpandAll(event:ItemClickEvent):void
{
	var lbl:String;
	if (isExpanded)
	{
		isExpanded = false;
		lbl = Constants.BTN_TEXT_EXPAND_ALL;
		adgRemainingOrders.collapseAll();
	}
	else
	{
		isExpanded = true;
		lbl = Constants.BTN_TEXT_COLLAPSE_ALL;
		adgRemainingOrders.expandAll();
	}
	var dp:ArrayCollection = new ArrayCollection();
	dp.addItem(lbl);
	dp.addItem(Constants.BTN_TEXT_REFRESH);
	//toolbar.dataProvider = dp;
}

public function reset():void
{
	isExpanded = false;
	var dp:ArrayCollection = new ArrayCollection();
	dp.addItem(Constants.BTN_TEXT_EXPAND_ALL);
	dp.addItem(Constants.BTN_TEXT_REFRESH);
	//toolbar.dataProvider = dp;
}
*/

protected function btnRefresh_clickHandler(event:MouseEvent):void
{
	ModelManager.getInstance().updateRemainingOrders();
}
