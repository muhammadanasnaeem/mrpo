package components
{
	import mx.formatters.CurrencyFormatter;

	public class EZCurrencyFormatter extends CurrencyFormatter
	{

		public function EZCurrencyFormatter()
		{
			thousandsSeparatorTo=",";
			thousandsSeparatorFrom=",";

			decimalSeparatorTo=".";
			decimalSeparatorFrom=".";

			currencySymbol="";
			precision=4;
			useThousandsSeparator=true;

		}
	}
}
