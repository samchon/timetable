package Classes.resize
{
	import mx.controls.TextArea;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	

	/**
	 * Fired when the panel is about to start resizing. 
	 */
	[Event(name="resizeStart", type="mx.events.ResizeEvent")]

	/**
	 * Fired when the panel has finished resizing.
	 */
	[Event(name="resizeEnd", type="mx.events.ResizeEvent")]

	/**
	 *  The alpha value for the resize handle.
	 *  @default 0x666666
	 */
	[Style(name="resizeHandleColor", type="Color", inherit="no")]

	/**
	 *  The alpha value for the resize handle.
	 *  @default 1
	 */
	[Style(name="resizeHandleAlpha", type="Number", inherit="no")]

	[IconFile("ResizableTextArea.png")]
	
	/**
	 * Extends the TextArea class to let the user resize the textarea by dragging on a small
	 * 16x16 resize handle in the bottom right corner of the textarea.
	 * 
	 * See the ResizeManager class for more details.
	 * 
	 * You can also specify the minWidth, minHeight, maxWidth, and maxHeight properties
	 * to restrict the size of the textarea.
	 * 
	 *  <pre>
 	 *  &lt;ResizableTextArea
	 *   <strong>Styles</strong>
	 *   resizeHandleColor="0x666666"
	 *   resizeHandleAlpha="1"
	 * &gt;
 	 *      ...
 	 *      <i>child tags</i>
 	 *      ...
 	 *  &lt;/ui:ResizableTextArea&gt;
 	 *  </pre>
 	 * 
	 * @author Chris Callendar
	 * @date March 17th, 2009
	 */
	public class ResizableTextArea extends TextArea
	{
		// setup the default styles
		private static var classConstructed:Boolean = classConstruct(); 
		private static function classConstruct():Boolean {
			var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("ResizableTextArea");
            if (!style) {
                style = new CSSStyleDeclaration();
            }
            style.defaultFactory = function():void {
                this.resizeHandleColor = 0x666666;
                this.resizeHandleAlpha = 1;
            };
			StyleManager.setStyleDeclaration("ResizableTextArea", style, true);
            return true;
        };
        		
        public static const RESIZE_START:String = ResizeManager.RESIZE_START;
        public static const RESIZE_END:String = ResizeManager.RESIZE_END;

		private var resizeManager:ResizeManager;
		
		public function ResizableTextArea() {
			super();
			this.resizeManager = new ResizeManager(this);
			
			// set a minimum size for this textarea
			minWidth = 24;
			minHeight = 24;
		}
		
		[Inspectable(category="Common")]
		public function get resizable():Boolean {
			return resizeManager.enabled;
		}
		
		public function set resizable(resize:Boolean):void {
			resizeManager.enabled = resize;
		}
		
		/**
		 * If set to true then when this window is resized it will be put on top
		 * of the other children of this window's parent.
		 * Obviously this is only useful when the parent uses an absolute layout (e.g. Canvas).
		 */
		[Inspectable(category="Resize", defaultValue="false")]
		public function set bringToFrontOnResize(value:Boolean):void {
			resizeManager.bringToFrontOnResize = value;
		}

		public function get bringToFrontOnResize():Boolean {
			return resizeManager.bringToFrontOnResize;
		}
	
		/**
		 * Keeps the width to height aspect ratio fixed for this component when resizing (defaults to false).
		 */
		[Inspectable(category="Resize", defaultValue="false")]
		public function get keepAspectRatio():Boolean {
			return resizeManager.keepAspectRatio;
		}
		
		public function set keepAspectRatio(value:Boolean):void {
			resizeManager.keepAspectRatio = value;
		}
		
		override protected function childrenCreated():void {
			super.childrenCreated();
			addChild(resizeManager.resizeHandle);
		}
		
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);

			var allStyles:Boolean = (styleProp == null) || (styleProp == "styleName");
 			if (allStyles || (styleProp == "resizeHandleColor") || (styleProp == "resizeHandleAlpha")) {
 				resizeManager.resizeHandle.updateStyles(getStyle("resizeHandleColor"), getStyle("resizeHandleAlpha"));
			}
		}
			
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);

			// make the scrollbars not overlap our resize handle
			resizeManager.adjustScrollBars(horizontalScrollBar, verticalScrollBar);
			// keep the resize handle in the correct location
			resizeManager.resizeHandle.setResizeHandlePosition();
		}
		
		
	}
}