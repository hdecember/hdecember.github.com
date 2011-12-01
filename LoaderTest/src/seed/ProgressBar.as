package seed 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Huang Di
	 */
	public class ProgressBar extends Sprite
	{
		private var tf:TextField;
		
		public function ProgressBar() 
		{
			initBackground();
			initStatusText();
		}
		public function setProgress(loaded:Number, total:Number):void
		{
			var percentage:Number = Math.round(loaded * 100 / total);
			this.graphics.beginFill(0x7777AA, 1);
			this.graphics.drawRect(0, 0, 3 * percentage, 10);
			this.graphics.endFill();
		}
		
		public function setText(text:String):void
		{
			tf.text = text;
		}
		
		public function initStatusText():void
		{
			tf = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.x = 0;
			tf.y = 15;
			addChild(tf);
		}
		
		private function initBackground():void 
		{
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0,0,300,10);
			this.graphics.endFill();
		}
	}

}