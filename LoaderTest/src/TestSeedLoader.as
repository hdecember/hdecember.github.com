package  
{
	import com.bit101.components.ProgressBar;
	import com.bit101.components.VBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import seed.utils.encodeJson;
	import seed.utils.net.SeedLoaderCore;
	import seed.utils.net.SeedLoaderEvent;
	import seed.utils.net.SeedQueueLoader;
	import seed.utils.net.SeedSWFLoader;
	/**
	 * ...
	 * @author Huang Di
	 */
	public class TestSeedLoader extends Sprite
	{
		private var tf:TextField;
		private var loader:SeedQueueLoader;
		private var pb:ProgressBar;
		private var vbox:VBox;
		
		public function TestSeedLoader() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			pb = new ProgressBar();
			pb.setSize(300, 10);
			addChild(pb);
			
			vbox = new VBox(this, 0, 20);
			
			initSeedLoader();
		}
		
		private function initSeedLoader():void 
		{
			loader = new SeedQueueLoader(3);
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/componentSkin.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/bonusSkin.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/mainStage.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/EquipDefault.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/officerUi.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/shopSkin.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/friendskin1.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/Equip01.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/Equip02.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/Equip03.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/Equip04.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/Equip05.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/Equip06.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/Equip07.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/Equip08.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/Equip09.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/Equip10.swf"));
			loader.append(new SeedSWFLoader("http://superfreak.sinaapp.com/test/skin/Equip11.swf"));
			loader.addEventListener(SeedLoaderEvent.OPEN, SeedLoaderEventHandler);
			loader.addEventListener(SeedLoaderEvent.COMPLETE, SeedLoaderEventHandler);
			loader.addEventListener(SeedLoaderEvent.PROGRESS, SeedLoaderEventHandler);
			loader.addEventListener(SeedLoaderEvent.CHILD_OPEN, SeedLoaderEventHandler);
			loader.addEventListener(SeedLoaderEvent.CHILD_PROGRESS, SeedLoaderEventHandler);
			loader.addEventListener(SeedLoaderEvent.CHILD_COMPLETE, SeedLoaderEventHandler);
			loader.load();
		}
		private function SeedLoaderEventHandler(e:SeedLoaderEvent):void
		{
			trace("-----------------------------------------");
			trace(e.type, encodeJson(e.data));
			trace(e.target,e.target.name);
			trace(e.currentTarget);
			if (e.type == ProgressEvent.PROGRESS)
			{
				pb.value = (e.target as SeedLoaderCore).progress;
			}
			if (e.type == SeedLoaderEvent.CHILD_OPEN)
			{
				var progressbar:ProgressBar = new ProgressBar();
				progressbar.name = (e.target as SeedLoaderCore).name;
				progressbar.setSize(300, 10);
				vbox.addChild(progressbar);
			}
			if (e.type == SeedLoaderEvent.CHILD_PROGRESS)
			{
				(vbox.getChildByName((e.target as SeedLoaderCore).name) as ProgressBar).value = (e.target as SeedLoaderCore).progress;
			}	
			if (e.type == SeedLoaderEvent.CHILD_COMPLETE)
			{
				vbox.removeChild(vbox.getChildByName((e.target as SeedLoaderCore).name));
			}
		}
	}

}