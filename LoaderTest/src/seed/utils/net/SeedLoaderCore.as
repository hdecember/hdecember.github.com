package  seed.utils.net
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Huang Di
	 */
	public class SeedLoaderCore extends EventDispatcher
	{
		private var _name:String;
		private var _progress:Number;
		public function SeedLoaderCore(name:String = null) 
		{
			if (name)
			{
				_name = name;
			}
			else
			{
				_name = generateUniqueName();
			}
			
		}
		public function load():void
		{
			
		}
		public function destroy():void
		{
			
		}
		public function get progress():Number
		{
			return 1;
		}
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		protected function _passThroughEvent(event:SeedLoaderEvent):void {
			var type:String = event.type;
			var target:Object = this;
			if (this.hasOwnProperty("getChildren")) {
				if (event is SeedLoaderEvent) {
					target = event.target;
				}
				if (type == "complete") {
					type = "childComplete";
				} else if (type == "open") {
					type = "childOpen";
				} else if (type == "progress") {
					type = "childProgress";
				} else if (type == "fail") {
					type = "childFail";
				}
			}
			if (this.hasEventListener(type)) {
				dispatchEvent(new SeedLoaderEvent(type, target , (event is SeedLoaderEvent && SeedLoaderEvent(event).data != null) ? SeedLoaderEvent(event).data : null));
			}
		}
		/////////////////////////////////////////
		//静态变量及函数
		/////////////////////////////////////////
		private static var id:int = -1;
		private static function generateUniqueName():String
		{
			id++;
			return "SeedLoader" + id;
		}
	}

}