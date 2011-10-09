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
		
		public function SeedQueueLoader(maxLoaderCount:int = 1) 
		{
			_maxLoaderCount = Math.max(1, maxLoaderCount);
			_loaderList = [];
		}
		public function append(seedLoaderCore:SeedLoaderCore):SeedQueueLoader
		{
			_loaderList.push(seedLoaderCore);
			return this;
		}
		public function getChildren():Array
		{
			return _loaderList;
		}
		public function getChildByName(name:String):SeedLoaderCore
		{
			for each(var item:SeedLoaderCore in _loaderList)
			{
				if (item.name == name)
				return item;
			}
			return null;
		}
		public function getChildrenByStatus():SeedLoaderCore
		{
			return null;
		}
		public function getChildAt(index:int):SeedLoaderCore
		{
			return _loaderList[index];			
		}
		override public function load():void
		{
			dispatchEvent(new SeedLoaderEvent(SeedLoaderEvent.OPEN,this));
			_filesTotal = _loaderList.length;
			_filesLoaded = 0;
			_currentLoadingIndex = 0;
			
			for (var i:int = 0; i < Math.min(_maxLoaderCount, _filesTotal); i++ )
			{
				loadNext();
			}
		}
		
		protected function loadNext(e:SeedLoaderEvent = null):void
		{			
			if (e != null)
			{
				_filesLoaded++;
				_passThroughEvent(e);
				dispatchEvent(new SeedLoaderEvent(SeedLoaderEvent.PROGRESS,this));
			}
			if (_currentLoadingIndex < _loaderList.length)
			{
				var currentLoader:SeedLoaderCore = _loaderList[_currentLoadingIndex] as SeedLoaderCore;
				currentLoader.addEventListener(SeedLoaderEvent.OPEN, _passThroughEvent);
				currentLoader.addEventListener(SeedLoaderEvent.PROGRESS, _passThroughEvent);
				currentLoader.addEventListener(SeedLoaderEvent.COMPLETE, loadNext);
				currentLoader.addEventListener(SeedLoaderEvent.FAIL, onLoaderError);
				currentLoader.load();
				_currentLoadingIndex++;
			}
			if (_filesTotal == _filesLoaded)
			{
				dispatchEvent(new SeedLoaderEvent(SeedLoaderEvent.COMPLETE,this));
			}
		}
		
		protected function onLoaderError(e:SeedLoaderEvent):void 
		{
			_passThroughEvent(e);
		}
		override public function get progress():Number 
		{
			return _filesLoaded/_filesTotal;
		}
	}

}