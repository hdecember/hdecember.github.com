package seed.utils.net
{
	import flash.events.Event;
	import seed.utils.net.SeedLoaderProgressEvent;
	/**
	 * ...
	 * @author Huang Di
	 */
	public class SeedQueueLoader extends SeedLoaderCore
	{
		private var _filesTotal:int;
		private var _filesLoaded:int;
		private var _currentLoadingIndex:int;
		
		private var _maxLoaderCount:int;
		private var _loaderList:Array;
		
		
		
		private var _loadedList:Array;
		private var _loadingList:Array;
		private var _toLoadList:Array;
		
		public function SeedQueueLoader(maxLoaderCount:int = 1) 
		{
			_maxLoaderCount = Math.max(1, maxLoaderCount);
			_loadedList = [];
			_loadingList = [];
			_toLoadList = [];
		}
		public function append(seedLoaderCore:SeedLoaderCore):SeedQueueLoader
		{
			_toLoadList.push(seedLoaderCore);
			return this;
		}
		public function getChildByName():SeedLoaderCore
		{
			//for each(var item:SeedLoaderCore in )
		}
		public function getChildrenByStatus():SeedLoaderCore
		{
			
		}
		public function getChildAt():SeedLoaderCore
		{
			
		}
		override public function load():void
		{
			dispatchEvent(new SeedLoaderEvent(SeedLoaderEvent.OPEN));
			_filesTotal = _toLoadList.length;
			
			for (var i:int = 0; i < Math.min(_maxLoaderCount, _filesTotal); i++ )
			{
				loadNext();
			}
		}
		override _passThroughEvent
		protected function loadNext(e:Event = null):void
		{			
			if (e != null)
			{
				_loadingList.splice(_loadingList.indexOf(e.target), 1);
				_loadedList.push(e.target);
			}
			if (_toLoadList.length > 0)
			{
				var currentLoader:SeedLoaderCore = _toLoadList.shift() as SeedLoaderCore;
				currentLoader.addEventListener(SeedLoaderEvent.COMPLETE, loadNext);
				currentLoader.addEventListener(SeedLoaderEvent.PROGRESS, onProgressEvent);
				currentLoader.addEventListener(SeedLoaderEvent.FAIL, onLoaderError);
				currentLoader.load();
				_loadingList.push(currentLoader);
			}
			if (_loadingList.length == 0)
			{
				dispatchEvent(new SeedLoaderEvent(SeedLoaderEvent.COMPLETE));
			}
		}
		
		protected function onProgressEvent(e:SeedLoaderEvent):void 
		{
			//dispatchEvent(new SeedLoaderProgressEvent(SeedLoaderProgressEvent.SEED_LOADER_PROGRESS, e.bytesLoaded, e.bytesTotal, _loadedList.length, _filesTotal));
		}
		
		protected function onLoaderError(e:SeedLoaderEvent):void 
		{
			dispatchEvent(e.clone());
		}
		
	}

}