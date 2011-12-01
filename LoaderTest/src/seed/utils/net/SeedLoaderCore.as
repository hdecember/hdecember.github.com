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
		private var _content:*;
		
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

		/////////////////////////////////////////
		//私有函数
		/////////////////////////////////////////
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
		protected function loadStart():void
		{
			
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
		/////////////////////////////////////////
		//公共接口
		/////////////////////////////////////////
		public function load():void
		{
			dispatchEvent(new SeedLoaderEvent(SeedLoaderEvent.OPEN, this));
			_content = CachePool.getInstance().getLoadedFile(url);
			if (_content)
			{
				dispatchEvent(new SeedLoaderEvent(SeedLoaderEvent.COMPLETE, this));
				return;
			}
			else
			{
				var loader:SeedLoaderCore = CachePool.getInstance().checkLoadingQueue(url);
				if (loader)
				{
					loader.addEventListener(SeedLoaderEvent.PROGRESS, _passThroughEvent);
					loader.addEventListener(SeedLoaderEvent.FAIL, _passThroughEvent);
					loader.addEventListener(SeedLoaderEvent.COMPLETE, _passThroughEvent);
					return;
				}
				else
				{
					CachePool.getInstance().registerLoader(this);
				}
			}
			loadStart();
		}

		public function unload():void
		{
			
		}
		public function get progress():Number
		{
			return NaN;
		}
		public function get name():String 
		{
			return _name;
		}
		public function get content():*
		{
			return _content;
		}
		public function get url():String
		{
			return "";
		}
	}

}