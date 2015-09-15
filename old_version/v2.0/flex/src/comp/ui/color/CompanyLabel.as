package comp.ui.color
{
	import data.formatter.Format;
	
	import mx.controls.Label;
	
	public class CompanyLabel extends Label
	{
		public function CompanyLabel()
		{
			super();
		}
		public override function set data(item:Object):void {
			if(listData == null || item == null)
				return;
			var name:String = listData.label;
			if(name == "Average")
				super.htmlText = "<b><u>" + name + "</u></b>";
			else
				super.htmlText = name;
		}
	}
}