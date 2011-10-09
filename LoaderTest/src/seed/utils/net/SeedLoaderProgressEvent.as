package seed.utils.net
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Huang Di
	 */
	public class SeedLoaderProgressEvent extends Event
	{
		public static const SEED_LOADER_PROGRESS:String = "SeedLoaderProgress";
		private var _filesTotal:int;
		private var _filesLoaded:int;
		private var _bytesTotal:uint;
		private var _bytesLoaded:uint;
		
		public function SeedLoaderProgressEvent(type:String, bytesLoaded:uint, bytesTotal:uint, filesLoaded:int, filesTotal:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_filesLoaded = filesLoaded;
			_filesTotal = filesTotal;
			_bytesTotal = bytesTotal;
			_bytesLoaded = bytesLoaded;
			super(type, bubbles, cancelable);
		}
		
		public function get filesTotal():int
		{
			return _filesTotal;
		}
		
		public function get filesLoaded():int
		{
			return _filesLoaded;
		}
		
		public function get bytesTotal():uint
		{
			return _bytesTotal;
		}
		
		public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}
		
		override public function clone():Event
		{
			return new SeedLoaderProgressEvent(type, _bytesLoaded, _bytesTotal, _filesLoaded, _filesTotal, bubbles, cancelable);
		}
	}

}