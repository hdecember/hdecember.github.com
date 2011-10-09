package seed.utils.net
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	/**
	 * 用法同URLLoader,在加载时会先判断内存的cache中是否有需要的文件
	 * @author Huang Di
	 */
	public class SeedBinaryLoader extends SeedLoaderCore
	{
		private var _url:String;
		private var _useCache:Boolean;
		private var _data:ByteArray;
		public function SeedBinaryLoader(url:String, useCache:Boolean = true)
		{
			_url = url;
			_useCache = useCache;
		}
		override public function load():void 
		{
			if (_useCache)
			{
				_data = CachePool.getInstance().getLoadedFile(_url);
			}
			if (_data == null)
			{
				var _urlLoader:URLLoader = new URLLoader();
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_urlLoader.addEventListener(Event.COMPLETE, onLoaderComplete);
				_urlLoader.addEventListener(ProgressEvent.PROGRESS,onProgressEvent)
				_urlLoader.load(new URLRequest(_url));
			}
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function onProgressEvent(e:ProgressEvent):void 
		{
			dispatchEvent(e.clone());
		}
		
		private function onLoaderComplete(e:Event):void 
		{
			_data = (e.target as URLLoader).data;
			CachePool.getInstance().loadFile(_url,_data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get data():ByteArray 
		{
			return _data;
		}
		
		public function set data(value:ByteArray):void 
		{
			_data = value;
		}
		
		override public function get url():String 
		{
			return _url;
		}
		
	}

}