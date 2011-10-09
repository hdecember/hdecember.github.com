package seed.utils.net
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Huang Di
	 */
	public class SeedLoaderEvent extends Event
	{
		public static const OPEN:String = "open";
		public static const FAIL:String = "fail";
		public static const COMPLETE:String = "complete";
		public static const PROGRESS:String = "progress";
		
		public static const CHILD_OPEN:String = "childOpen";
		public static const CHILD_FAIL:String = "childFail";
		public static const CHILD_COMPLETE:String = "childComplete";
		public static const CHILD_PROGRESS:String = "childProgress";
		
		
		protected var _target:Object;
		protected var _ready:Boolean;
		
		public var data:*;
		
		public function SeedLoaderEvent(type:String, target:Object, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_target = target;
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new SeedLoaderEvent(type, data, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("SeedLoaderEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
		override public function get target():Object {
			if (_ready) {
				return _target;
			} else {
				_ready = true;
			}
			return null;
		}
	}

}