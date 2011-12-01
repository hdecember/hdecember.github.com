package seed.utils.net
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author Huang Di
	 */
	public class SeedSWFLoader extends SeedLoaderCore
	{
		private var _url:String;
		private var _useCache:Boolean;
		private var _content:*;
		private var _toCurrentDomain:Boolean;
		private var _loaderContext:LoaderContext;
		private var _urlLoader:URLLoader;
		private var _loader:Loader;
		
		public function SeedSWFLoader(url:String, useCache:Boolean = true, toCurrentDomain:Boolean = true, loaderContext:LoaderContext = null)
		{
			super();
			_url = url;
			_useCache = useCache;
			_toCurrentDomain = toCurrentDomain;
			if (_toCurrentDomain == false)
			{
				if (loaderContext)
				{
					_loaderContext = loaderContext;
				}
			}
		}
		
		override protected function loadStart():void
		{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener(Event.COMPLETE, onLoaderComplete);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgressEvent);
			_urlLoader.load(new URLRequest(_url));
		}
		
		private function onProgressEvent(e:ProgressEvent):void
		{
			dispatchEvent(new SeedLoaderEvent(SeedLoaderEvent.PROGRESS, this ));
		}
		
		private function onLoaderComplete(e:Event):void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBytesComplete);
			if (_toCurrentDomain)
			{
				_loader.loadBytes((e.target as URLLoader).data, new LoaderContext(false, ApplicationDomain.currentDomain));
			}
			else if (_loaderContext == null)
			{
				_loader.loadBytes((e.target as URLLoader).data);
			}
			else
			{
				_loader.loadBytes((e.target as URLLoader).data, _loaderContext);
			}
		}
		
		private function onLoadBytesComplete(e:Event):void
		{
			_content = (e.target as LoaderInfo).loader.content;
			CachePool.getInstance().loadFile(_url, _content);
			CachePool.getInstance().unRegisterLoader(this);
			dispatchEvent(new SeedLoaderEvent(SeedLoaderEvent.COMPLETE,this));
		}
		
		public function get bytesTotal():uint 
		{
			if (_urlLoader)
			{
				return _urlLoader.bytesTotal;
			}
			else
			{
				return SeedSWFLoader(CachePool.getInstance().checkLoadingQueue(url)).bytesTotal;
			}
		}
		public function get bytesLoaded():uint
		{
			if (_urlLoader)
			{
				return _urlLoader.bytesLoaded;
			}
			else
			{
				return SeedSWFLoader(CachePool.getInstance().checkLoadingQueue(url)).bytesLoaded;
			}
		}
		override public function get progress():Number 
		{
			return (bytesLoaded/bytesTotal);
		}
		override public function get url():String 
		{
			return _url;
		}
	}

}