package assets.skins
{
	import flash.display.GradientType;
	import flash.display.Graphics;

	import mx.skins.ProgrammaticSkin;

	import spark.skins.spark.BorderContainerSkin;

	public class BorderSkinClass extends BorderContainerSkin
	{
		public function BorderSkinClass()
		{
			super();
		}

		import mx.skins.ProgrammaticSkin;
		import flash.geom.Matrix;

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var g:Graphics=this.graphics;

			g.clear();

			var m:Matrix=new Matrix();
			m.createGradientBox(unscaledWidth, unscaledHeight);
			g.lineStyle(0, 0, 0);
			g.beginGradientFill(GradientType.LINEAR, [0xff8eba, 0xfe498c], [0.10, 0.90], [0.10, 0.90], m);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();

		}
	}
}
