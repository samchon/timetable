package comp.ui
{
	import spark.components.HGroup;
	
	public class HGroup extends spark.components.HGroup
	{
		public function HGroup()
		{
			super();
		}
		public function set padding(padding:int):void {
			this.paddingTop		= padding;
			this.paddingLeft	= padding;
			this.paddingRight	= padding;
			this.paddingBottom	= padding;
		}
	}
}