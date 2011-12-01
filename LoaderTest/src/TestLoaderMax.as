package  
{
	import com.bit101.components.VBox;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import com.bit101.components.ProgressBar;
	import seed.utils.encodeJson;
	/**
	 * ...
	 * @author Huang Di
	 */
	public class TestLoaderMax extends Sprite
	{
		private var tf:TextField;
		private var loader:LoaderMax;
		private var pb:ProgressBar;
		private var vbox:VBox;
		
		public function TestLoaderMax() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initLoaderMax();
			pb = new ProgressBar();
			pb.setSize(300, 10);
			addChild(pb);
			
			vbox = new VBox(this, 0, 20);
			//vbox.addChild()
		}
		
		private function initLoaderMax():void 
		{
			loader = new LoaderMax();
			//loader.maxConnections = 5;
			loader.append(new SWFLoader("http://superfreak.sinaapp.com/test/skin/componentSkin.swf"));
			loader.append(new SWFLoader("http://superfreak.sinaapp.com/test/skin/bonusSkin.swf"));
			loader.append(new SWFLoader("http://superfreak.sinaapp.com/test/skin/mainStage.swf"));
			loader.append(new SWFLoader("http://superfreak.sinaapp.com/test/skin/EquipDefault.swf"));
			loader.append(new SWFLoader("http://superfreak.sinaapp.com/test/skin/officerUi.swf"));
			loader.append(new SWFLoader("http://superfreak.sinaapp.com/test/skin/shopSkin.swf"));
			loader.append(new SWFLoader("http://superfreak.sinaapp.com/test/skin/friendskin1.swf"));
			loader.append(new SWFLoader("http://superfreak.sinaapp.com/test/skin/Equip01.swf"));
			loader.append(new SWFLoader("http://superfreak.sinaapp.com/test/skin/Equip02.swf"));
			loader.append(new SWFLoader("http://superfreak.sinaapp.com/test/skin/Equip03.swf"));
			loader.addEventListener(LoaderEvent.OPEN, loaderEventHandler);
			loader.addEventListener(LoaderEvent.COMPLETE, loaderEventHandler);
			loader.addEventListener(LoaderEvent.PROGRESS, loaderEventHandler);
			loader.addEventListener(LoaderEvent.CHILD_OPEN, loaderEventHandler);
			loader.addEventListener(LoaderEvent.CHILD_PROGRESS, loaderEventHandler);
			loader.addEventListener(LoaderEvent.CHILD_COMPLETE, loaderEventHandler);
			loader.load();
		}
		private function loaderEventHandler(e:LoaderEvent):void
		{
			trace("-----------------------------------------");
			trace(e.type, encodeJson(e.data));
			trace(e.target);
			trace(e.currentTarget);
			if (e.type == ProgressEvent.PROGRESS)
			{
				pb.value = (e.target as LoaderMax).progress;
			}
			if (e.type == LoaderEvent.CHILD_OPEN)
			{
				var progressbar:ProgressBar = new ProgressBar();
				progressbar.name = (e.target as LoaderCore).name;
				progressbar.setSize(300, 10);
				vbox.addChild(progressbar);
			}
			if (e.type == LoaderEvent.CHILD_PROGRESS)
			{
				(vbox.getChildByName((e.target as LoaderCore).name) as ProgressBar).value = (e.target as LoaderCore).progress;
			}	
			if (e.type == LoaderEvent.CHILD_COMPLETE)
			{
				vbox.removeChild(vbox.getChildByName((e.target as LoaderCore).name));
			}
		}
	}

}