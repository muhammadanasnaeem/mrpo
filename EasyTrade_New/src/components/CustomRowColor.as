package components
{
	import mx.controls.Label;
	import mx.controls.dataGridClasses.*;

	public class CustomRowColor extends Label
	{

		override public function set data(value:Object):void
		{
			if (value != null)
			{
				super.data=value;
				if (value[DataGridListData(listData).dataField] < 10)
				{
					setStyle("color", 0xFF0000);
				}
				else
				{
					setStyle("color", 0x000000);
				}
			}
		}
	}
}
