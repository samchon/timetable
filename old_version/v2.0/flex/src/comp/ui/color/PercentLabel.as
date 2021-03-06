package comp.ui.color
{
	import data.formatter.Format;
	
	import mx.controls.Label;
	
	public class PercentLabel extends Label
	{
		public function PercentLabel()
		{
			super();
		}
		public override function set data(item:Object):void {
			if(listData == null || item == null)
				return;
			
			var signBegin:String = "";
			var signEnd:String = "";
			if(item.hasOwnProperty("name") && item["name"] == "Average") {
				signBegin = "<u><b>";
				signEnd = "</b></u>";
			}
			var value:Number = Number(listData.label);
			if(value == int.MIN_VALUE)
				super.htmlText = "";
			else
				super.htmlText = "<font color='" + Format.getColor(value) + "'>" + signBegin + Format.doubleFormat(Math.abs(value * 100)) + signEnd + "%</font>";
		}
	}
}