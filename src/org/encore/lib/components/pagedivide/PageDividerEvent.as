package org.encore.lib.components.pagedivide
{
	import flash.events.Event;
	
	/**
	 *  <b>PageDividerEvent类</b>
	 * <p>Please describe this AS file in brief.</p>
	 * <p>Create at 2012-3-14 . SCUT Ensave.</p>
	 * @author 叶翼安
	 * */
	public class PageDividerEvent extends Event
	{
		public static const INDEX_CHANGE:String = "indexChange";
		public static const RECORD_PERPAGE_CHANGE:String="recordPerpageChange";
		private var _limit:int = -1;
		private var _offset:int = -1;
		
		
		public function PageDividerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,limit:int=-1,offset:int = -1)
		{
			super(type, bubbles, cancelable);
			this._limit = limit;
			this._offset = offset;
		}
		
		public function get offset():int
		{
			return _offset;
		}
		public function get limit():int
		{
			return _limit;
		}
	}
}