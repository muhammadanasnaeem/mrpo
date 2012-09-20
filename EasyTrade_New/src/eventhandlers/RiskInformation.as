import controller.ModelManager;

import mx.controls.Alert;
import mx.events.FlexEvent;


public var modelManager:ModelManager = ModelManager.getInstance();
[Bindable]
public var internalExchangeID:Number=-1;
//public var marketID:Number = -1;
[Bindable]
public var internalMarketID:Number=-1;
public var internalSymbolID:Number=-1;
public var symbolID:Number=-1;

protected function txtClientCode_enterHandler(event:FlexEvent):void
{
	if(event == null && txtClientCode.text != '') 
	{
		Alert.show('Information',"Client Code missing");
		return;
	}
	if(txtClientCode.text != '')
	{
		modelManager.riskInformationModel.execute();
	}
	else
	{
		Alert.show('Information',"Client Code missing");
	}
}

public function fillRiskInformationReport():void
{
	 
}  