package seed.utils.net 
{
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * 单例Model,管理放在内存中的swf缓存
	 * @author Huang Di
	 */
	public class CachePool 
	{
		private static var _instance:CachePool;
		private var _pool:Dictionary;
		private var _loaders:Dictionary;
		public function CachePool(singleton:Singleton) 
		{
			_pool = new Dictionary();
			_loaders = new Dictionary();
		}
		/**
		 * 单例
		 * @return
		 */
		public static function getInstance():CachePool
		{
			if (_instance == null)
			{
				_instance = new CachePool(new Singleton());
			}
			return _instance;
		}
		/**
		 * 加载新的文件
		 * @param	url
		 * @param	data
		 */
		public function loadFile(url:String,data:*):void
		{
			_pool[url] = data;
		}
		/**
		 * 卸载所加载的文件
		 * @param	url
		 */
		public function unLoadFile(url:String):void
		{
			if (_pool[url] != null)
			{
				delete _pool[url];
			}
		}
		/**
		 * 卸载所有的文件
		 */
		public function unLoadAll():void
		{
			for each(var url:String in _pool)
			{
				unLoadFile(url);
			}
		}
		/**
		 * 获取加载的文件
		 * @param	url
		 * @return
		 */
		public function getLoadedFile(url:String):*
		{
			if (_pool[url] != null)
				return _pool[url];
			else
				return null;
		}
		
		public function checkLoadingQueue(url:String):SeedLoaderCore
		{
			if (_loaders[url] != null)
				return _loaders[url];
			else
				return null;
		}
		public function registerLoader(loader:SeedLoaderCore):void
		{
			_loaders[loader.url] = loader;
		}
		public function unRegisterLoader(loader:SeedLoaderCore):void
		{
			if (_loaders[loader.url] != null)
			{
				delete _loaders[loader.url];
			}
		}
	}

}
class Singleton
{
}