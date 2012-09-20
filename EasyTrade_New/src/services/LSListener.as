// Author Haroon Shafiq
package services
{
	import com.lightstreamer.as_client.ConnectionInfo;
	import com.lightstreamer.as_client.LSClient;
	import com.lightstreamer.as_client.NonVisualTable;
	import com.lightstreamer.as_client.events.NonVisualItemUpdateEvent;

	import common.Constants;
	import common.UpdatedField;

	import controller.ModelManager;
	import controller.ProfileManager;

	import mx.utils.StringUtil;

	public class LSListener
	{
		public static const fieldSchemaBestMarket:Array=["side_buy_order_0", "price_buy_order_0", "flag_id_buy_order_0", "volume_buy_order_0", "side_sell_order_0", "price_sell_order_0", "flag_id_sell_order_0", "volume_sell_order_0", "symbol_id_sell_order_0"];

		public static const fieldSchemaSymbolStat:Array=["lasttradesize", //0
			"lasttradeprice", //1
			"turnover", //2
			"totalnooftrades", //3
			"ohlcopen", //4
			"averageprice", //5
			"ohlchigh", //6
			"ohlclow", //7
			"netchange", //8
			"ohlcclose" //9
			];

		public static const fieldSchemaOrderConfirmation:Array=["MessageIdentifer", // 0
			"client_id", // 1
			"disclosed_volume", // 2
			"flag_id", // 3
			"is_short", // 4
			"market_id", // 5
			"order_no", // 6
			"price", // 7
			"ref_no", // 8
			"side", // 9
			"symbol_id", // 10
			"tif", // 11
			"entry_datetime", // 12
			"trailing_stoploss_dip", // 13
			"trigger_price", // 14
			"user_id", // 15
			"volume", // 16
			"ticket_no", // 17
			"exchange_id", // 18
			"rejection_reason", // 19
			"rejection_code", // 20
			"client_code", // 21
			"broker_id", // 22
			"is_negotiated", // 23
			"user_id", // 24
			"remaining_volume" // 25
			];


		public static const fieldSchemaMarketMessage:Array=["MessageIdentifer", // 0
			"exchange_id", // 1
			"market_id", // 2
			"current_state", // 3
			"name", // 4
			"description", // 5
			"State", // 6
			"start_datetime", // 7
			"time", // 8
			// Bulletin fields
			"message_text", // 9 - Bulletin Message Text
			"ID", // 10 - Bulletin AUD_TYPE id
			// Symbol Order Limit Change fields
			"EXCHANGE_ID", // 11
			"MARKET_ID", // 12
			"SYMBOL_ID", // 13
			"LIMIT_TYPE", // 14
			"UPPER_LIMIT", // 15
			"LOWER_LIMIT", // 16
			"symbol_id" // 17
			];

		///////////////////////////////////////////////////////////////

		private var lsClientOrderConfirmation_:LSClient=new LSClient();

		public function get lsClientOrderConfirmation():LSClient
		{
			return lsClientOrderConfirmation_;
		}
		///////////////////////////////////////////////////////////////

		private var lsClientBestMarket_:LSClient=new LSClient();

		public function get lsClientBestMarket():LSClient
		{
			return lsClientBestMarket_;
		}
		///////////////////////////////////////////////////////////////

		private var lsClientSymbolStats_:LSClient=new LSClient();

		public function get lsClientSymbolStats():LSClient
		{
			return lsClientSymbolStats_;
		}
		///////////////////////////////////////////////////////////////

		private var lsClientMarketSchedule_:LSClient=new LSClient();

		public function get lsClientMarketMessage():LSClient
		{
			return lsClientMarketSchedule_;
		}
		///////////////////////////////////////////////////////////////

		private static var instance:LSListener=new LSListener();

		///////////////////////////////////////////////////////////////

		public function LSListener()
		{
			if (instance)
			{
				throw new Error("LSListener can only be accessed through LSListener.getInstance()");
			}
		}

		///////////////////////////////////////////////////////////////

		public static function getInstance():LSListener
		{
			return instance;
		}

		///////////////////////////////////////////////////////////////

		public function init():void
		{
			lsClientOrderConfirmation.openConnection( createConnectionInfo( Constants.LIGHTSTREAMER_SERVER, Constants.LIGHTSTREAMER_PORT, Constants.ORDER_CONFIRMATION_DATA_ADAPTER) );
			lsClientBestMarket.openConnection( createConnectionInfo( Constants.LIGHTSTREAMER_SERVER, Constants.LIGHTSTREAMER_PORT, Constants.BEST_MARKET_DATA_ADAPTER ) );
			lsClientSymbolStats.openConnection( createConnectionInfo( Constants.LIGHTSTREAMER_SERVER, Constants.LIGHTSTREAMER_PORT, Constants.SYMBOL_STAT_DATA_ADAPTER ) );
			lsClientMarketMessage.openConnection( createConnectionInfo( Constants.LIGHTSTREAMER_SERVER, Constants.LIGHTSTREAMER_PORT, Constants.ANNOUNCEMENT_FEED_DATA_ADAPTER ) );
		}

		///////////////////////////////////////////////////////////////

		public function subscribeItem(itemName:*, schema:*, client:LSClient, listener:Function):void
		{
			var tbl:NonVisualTable=new NonVisualTable(itemName, schema, "RAW", false);
			client.subscribeTable(tbl);
			tbl.addEventListener(NonVisualItemUpdateEvent.NON_VISUAL_ITEM_UPDATE, listener);
		}

		public function subscribeBinaryItem(itemName:String, objectName:String, client:LSClient, listener:Function):void
		{
			var tbl:NonVisualTable=new NonVisualTable(itemName, objectName, "RAW", true);
			client.subscribeTable(tbl);
			tbl.addEventListener(NonVisualItemUpdateEvent.NON_VISUAL_ITEM_UPDATE, listener);
		}

		///////////////////////////////////////////////////////////////

		public static function extractFieldData(event:NonVisualItemUpdateEvent, field:*):String
		{
		var value:String; 
			if (event.isFieldChanged(field)) { 
				value = event.getFieldValue(field);
			} else { 
				value = event.getOldFieldValue(field); 
			} 
			return value; 
		}

		///////////////////////////////////////////////////////////////

		public static function getOldFieldData(event:NonVisualItemUpdateEvent, field:*):String
		{
		return event.getOldFieldValue(field);
		}

		///////////////////////////////////////////////////////////////

		public static function getActualUpdateCount(updatedFields:Array, fieldPos:Number):Number
		{
			var value:Array=new Array();
			var updatedField:Object=updatedFields[fieldPos];
			if (!updatedField)
			{
				return 0;
			}
			var fieldName:String=updatedField.fieldName;
			if (updatedField.newValue)
			{
				value=updatedField.newValue.split("###");
			}
			else
			{
				return 0;
			}
			return value.length - 1;
		}

		/**
		 * returns 0 if unchaged, 1 if new val is greater, 2 if new val is lesser.
		 * assumes the values are numeric.
		 */
		public static function isNewValueGreater(event:NonVisualItemUpdateEvent, field:*):Number
		{
			var retVal:Number=0;
			try
			{
				if (new Number(event.getFieldValue(field)) > new Number(event.getOldFieldValue(field)))
				{
					retVal=1;
				}
				else if (new Number(event.getFieldValue(field)) < new Number(event.getOldFieldValue(field)))
				{
					retVal=2;
				}
			}
			catch (err:Error)
			{
			}
			return retVal;
		}

		///////////////////////////////////////////////////////////////

		private function createConnectionInfo(server:String, port:Number, adapterName:String):ConnectionInfo
		{
			var cInfo:ConnectionInfo=new ConnectionInfo();
			cInfo.server=server;
			cInfo.user=ProfileManager.getInstance().userName;
			cInfo.password=ProfileManager.getInstance().password;
			cInfo.port=port;
			cInfo.controlPort=port;
			cInfo.adapterSet=adapterName;
			return cInfo;
		}
		///////////////////////////////////////////////////////////////
	}
}
