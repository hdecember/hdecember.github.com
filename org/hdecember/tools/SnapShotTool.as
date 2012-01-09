package org.hdecember.tools
{
	import com.adobe.images.JPGEncoder;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * Provide screenshots tool 
	 * @author HDecember
	 */
	public class SnapShotTool extends EventDispatcher
	{
		private var _stage:Stage;
		private var _bounds:Rectangle;
		private var _container:Sprite;
		private var _snapshotMask:Sprite;
		private var _snapshotArea:Shape;
		private var _fullSnapshotData:BitmapData;
		private var _data:*;
		
		/**
		 * If bounds is not defined it will use a rectangle(x=0,y=0,width=stage.stageWidth,height=stage.stageHeight)as default.
		 * @param	stage
		 * @param	bounds
		 */
		public function SnapShotTool(stage:Stage, bounds:Rectangle = null)
		{
			this.stage = stage;
			if (!bounds)
			{
				bounds = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			}
			this.bounds = bounds;
		}
		
		/**
		 * Create a mask and ready for user to make a clip
		 */
		public function ready():void
		{
			//generate complete snapshot
			_fullSnapshotData.draw(stage);
			
			//layout
			_container = new Sprite();
			_container.x = _bounds.x;
			_container.y = _bounds.y;
			_container.graphics.beginBitmapFill(_fullSnapshotData);
			_container.graphics.drawRect(0, 0, _bounds.width, _bounds.height);
			_container.graphics.endFill();
			_stage.addChild(_container);
			
			//mask
			_snapshotMask = new Sprite();
			_snapshotMask.graphics.beginFill(0, 0.5);
			_snapshotMask.graphics.drawRect(0, 0, _bounds.width, _bounds.height);
			_snapshotMask.graphics.endFill();
			_snapshotMask.blendMode = BlendMode.MULTIPLY;
			_container.addChild(_snapshotMask);
			
			//define the needed area
			_snapshotArea = new Shape();
			_snapshotMask.addChild(_snapshotArea);
			
			_container.addEventListener(MouseEvent.MOUSE_DOWN, startHandler);
		}
		
		private function startHandler(e:MouseEvent):void
		{
			_snapshotArea.graphics.clear();
			
			_snapshotArea.x = _snapshotMask.mouseX;
			_snapshotArea.y = _snapshotMask.mouseY;
			
			_container.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_container.addEventListener(MouseEvent.MOUSE_UP, endHandler);
			
			dispatchEvent(new Event(Event.OPEN));
		}
		
		private function mouseMoveHandler(e:MouseEvent):void
		{
			update();
		}
		
		private function endHandler(e:MouseEvent):void
		{
			_container.removeEventListener(MouseEvent.MOUSE_UP, endHandler);
			_container.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			var targetBounds:Rectangle = _snapshotArea.getBounds(_container);
			if (targetBounds.size.length <= 0)
				return;
			var bmd:BitmapData = new BitmapData(targetBounds.width, targetBounds.height);
			bmd.copyPixels(_fullSnapshotData, targetBounds, new Point(0, 0));
			
			//refer to https://github.com/mikechambers/as3corelib
			_data = (new JPGEncoder(80)).encode(bmd);
			_stage.removeChild(_container);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function update():void
		{
			_snapshotArea.graphics.clear();
			_snapshotArea.graphics.beginFill(0xffffff, 1);
			_snapshotArea.graphics.drawRect(0, 0, _snapshotArea.mouseX, _snapshotArea.mouseY);
			_snapshotArea.graphics.endFill();
		}
		
		public function get stage():Stage
		{
			return _stage;
		}
		
		public function set stage(value:Stage):void
		{
			_stage = value;
		}
		
		public function get bounds():Rectangle
		{
			return _bounds;
		}
		
		public function set bounds(value:Rectangle):void
		{
			_bounds = value;
			if (_fullSnapshotData)
				_fullSnapshotData.dispose();
			_fullSnapshotData = new BitmapData(value.width, value.height);
		}
		
		public function get data():*
		{
			return _data;
		}
	
	}

}