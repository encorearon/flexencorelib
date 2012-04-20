package org.encore.lib.components
{
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	import org.encore.lib.components.pagedivide.PageDivideBackButton;
	import org.encore.lib.components.pagedivide.PageDivideFontButton;
	import org.encore.lib.components.pagedivide.PageDivideNextButton;
	import org.encore.lib.components.pagedivide.PageDividePreButton;
	import org.encore.lib.components.pagedivide.PageDivideSimpleButton;
	import org.encore.lib.components.pagedivide.PageDividerEvent;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.NumericStepper;
	import spark.components.TextInput;
	
	/**
	 * 每页最多显示条数改变时候分派
	 * */
	[Event(name="recordPerpageChange", type="org.encore.lib.components.pagedivide.PageDividerEvent")]
	/**
	 * 当前选中选项被改变时分派此事件。
	 * */
	[Event(name="indexChange", type="org.encore.lib.components.pagedivide.PageDividerEvent")]
	/**
	 *  <b>PageDividerBar</b>
	 * <p>此组件允许用户绑定创建一个分页控制栏。
	 * 控制栏会自行根据用户当前指定的总记录数、每页记录数以及当前页数索引，显示不同的页码。
	 * 当用户点击页码或者指定一个当前页时候，会分派一个change事件，并更新当前页码按钮。</p>
	 * <p>版本1.0</p>
	 * <p>Create at 2012-3-5 . SCUT Ensave.</p>
	 * @author 叶翼安
	 * */
	public class PageDividerBar extends HGroup
	{
		public function PageDividerBar()
		{
			super();	
		}
		private var _totalRecord:int=0;
		private var _currentPageIndex:int = 0;
		private var _recordPerPage:int = 5;
		
		/**
		 * 总页数 
		 */
		private var _totalPages:int=0;
		/**
		 *  显示页码按钮的长度
		 */
		private var pageShowLength:int=5;
		/**
		 * 存放页码按钮的数组 
		 */
		private var pagesArray:Array;
		/**
		 * 显示页码的区域 
		 */
		private var pageButtonArea:HGroup;
		/**
		 * 当前显示页码区域下线值
		 */
		private var currentBegin:int=0;
		
		/**
		 * 当前显示页码区域上限值
		 */
		private var currentEnd:int=0;

		/**
		 * 总页数 
		 */
		public function get totalPages():int
		{
			return _totalPages;
		}


		[Bindable]
		/**
		 * 总记录数。
		 */
		public function get totalRecord():int
		{
			return _totalRecord;
		}

		/**
		 *@private 
		 */
		public function set totalRecord(value:int):void
		{
			if(_totalRecord != value )
			{
				invalidateDisplayList();
				invalidateProperties();
			}
			_totalRecord = value;
		}

		[Bindable]
		/**
		 * 每页最多显示的记录数
		 */
		public function get recordPerPage():int
		{
			return _recordPerPage;
		}
		
		/**
		 *@private 
		 */
		public function set recordPerPage(value:int):void
		{
			if(value!=_recordPerPage)
			{
				invalidateDisplayList();
				invalidateProperties();
			}
			_recordPerPage = value;
		}
		
		[Bindable]
		/**
		 * 当前显示的页数索引值
		 * <p>（注意：是index值而非页码值）。<p/>
		 */
		public function get currentPageIndex():int
		{
			return _currentPageIndex;
		}
		
		/**
		 *@private 
		 */
		public function set currentPageIndex(value:int):void
		{
			if(value!=_currentPageIndex){
			
				if(value>_totalPages-1)
				{
					return;
				}
				else
				{
					invalidateDisplayList();
				}
			}
			_currentPageIndex = value;
		}

		
		protected function createPageNumList(index:int,length:int,beganPage:int):void
		{
			var bCreate:Boolean = false;
			if(pagesArray == null)
			{
				pagesArray = new Array();
			}
			if(length!=pagesArray.length)
			{
				for(var k:int=pagesArray.length;k>length;k--)
				{					
					var removeButton:PageDivideSimpleButton = (pagesArray.pop() as PageDivideSimpleButton);
					removeButton.removeEventListener(MouseEvent.CLICK,comPageNumClickHandler);
					pageButtonArea.removeElement(removeButton);
				}
				for(var j:int=pagesArray.length;j<length;j++){
					
					var addButton:PageDivideSimpleButton = new  PageDivideSimpleButton();
					pagesArray.push(addButton);
					addButton.addEventListener(MouseEvent.CLICK,comPageNumClickHandler);
					pageButtonArea.addElement(addButton);
				}
			}
			
			for (var i:int = 0;i<length;i++)
			{
				var numButton:PageDivideSimpleButton = pagesArray[i];
				numButton.text = (beganPage + i).toString();
			}
		}		
		/*
		* Inner components.
		* **********************
		* */
		private var fontButton:PageDivideFontButton;
		private var backButton:PageDivideBackButton;
		private var nextButton:PageDivideNextButton;
		private var preButton:PageDividePreButton;
		private var lastButton:PageDivideSimpleButton;
		private var pageTransDetail:Label;
		private var totalPageLabel:Label;
		private var currentPageInput:TextInput;
		private var pageTransButton:Button;
		private var recordPerPageNumeric:NumericStepper;
		
		override protected function createChildren():void
		{
			this.verticalAlign = "middle";
			super.createChildren();
			if(!fontButton)
			{
				fontButton = new PageDivideFontButton();
				fontButton.addEventListener(MouseEvent.CLICK,comFontBtn_clickHandler);
				addElement(fontButton);
			}

			if(!preButton)
			{
				preButton = new PageDividePreButton();
				preButton.addEventListener(MouseEvent.CLICK,comPreBtn_clickHandler);
				addElement(preButton);
			}
			
			if(!pageButtonArea){
				pageButtonArea = new HGroup();
				pageButtonArea.verticalAlign = "middle";
				pageButtonArea.percentHeight = 100;
				addElement(pageButtonArea);
			}
			if(!nextButton)
			{
				nextButton = new PageDivideNextButton();
				nextButton.addEventListener(MouseEvent.CLICK,comNextBtn_clickHandler);
				addElement(nextButton);
			}
			if(!backButton)
			{
				backButton= new PageDivideBackButton();
				backButton.addEventListener(MouseEvent.CLICK,comBackBtn_clickHandler);
				addElement(backButton);
			}
			if(!totalPageLabel)
			{
				totalPageLabel = new Label();		
				addElement(totalPageLabel);
			}
			if(!recordPerPageNumeric)
			{
				recordPerPageNumeric = new NumericStepper();
				recordPerPageNumeric.stepSize=1;
				recordPerPageNumeric.snapInterval=1;
				recordPerPageNumeric.maximum=30;
				recordPerPageNumeric.minimum=5;
				addElement(recordPerPageNumeric);				
			}
			if(!pageTransDetail)
			{
				pageTransDetail = new Label();
				pageTransDetail.text = "跳转到：";
				addElement(pageTransDetail);
			}
			
			if(!currentPageInput)
			{
				currentPageInput  = new TextInput();
				currentPageInput.width=35;
				addElement(currentPageInput);
				currentPageInput.addEventListener(KeyboardEvent.KEY_UP,currentPageInputEnterHandler);
			}
			if(!pageTransButton)
			{
				pageTransButton = new Button();
				pageTransButton.label="确定";
				pageTransButton.width=60;
				addElement(pageTransButton);
				pageTransButton.addEventListener(MouseEvent.CLICK,pageTransferButtonClickHandler);
			}
			
		}
		private function transferPage():void
		{
			var newPage:int = int(currentPageInput.text);
			if(isNaN(newPage)||(newPage<1||newPage>_totalPages))
			{
				currentPageInput.text = (currentPageIndex+1).toString();
				return;
			}
			else
			{
				currentPageIndex = newPage-1;
			}
		}
		
		private function currentPageInputEnterHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				currentPageInput.setFocus();
				currentPageInput.selectAll();
				transferPage();					
			}
		}
		private function pageTransferButtonClickHandler(event:MouseEvent):void
		{
			transferPage();
		}
		
		private function recordPerpageChangeHandler(event:FlexEvent):void
		{
			if(recordPerPage==recordPerPageNumeric.value)
			{
				return;
			}
			else
			{
				recordPerPage = int(recordPerPageNumeric.value);
				dispatchEvent(new PageDividerEvent(PageDividerEvent.RECORD_PERPAGE_CHANGE,false,false,recordPerPage,currentPageIndex*recordPerPage));
			}
		}
		
		private var bRecPerpageListenHandler:Boolean =false;
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(totalRecord == 0)
			{
				_currentPageIndex = 0;
				enabled=false;
				totalPageLabel.text = "没有任何记录。每页显示：";
				return;
			}
			else
			{
				enabled =true;
				
				//_currentPageIndex = 0;
				
				if(pageShowLength == 0)
				{
					pageShowLength = 1;
				}
				
				_totalPages = Math.ceil( Number(totalRecord) / Number(recordPerPage) );	
				
				
				/*if(_totalPages >pageShowLength)
				{
					currentEnd = pageShowLength;
				}
				else
				{
					currentEnd = _totalPages;
				}*/
				
				pageButtonArea.width = 26*pageShowLength-6;
				
				//currentBegin = 1;
				
				totalPageLabel.text = "总页数:"+ _totalPages+",总记录数:" + totalRecord+",每页显示：";
				
				currentPageInput.restrict = "0-9";
				
				if(!bRecPerpageListenHandler){
					recordPerPageNumeric.addEventListener(FlexEvent.VALUE_COMMIT,recordPerpageChangeHandler);
					bRecPerpageListenHandler =true;
				}
				
				if(recordPerPage!=recordPerPageNumeric.value)
				{
					recordPerPageNumeric.value = recordPerPage;
					dispatchEvent(new PageDividerEvent(PageDividerEvent.RECORD_PERPAGE_CHANGE,false,false,recordPerPage,currentPageIndex*recordPerPage));
				}
				
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(totalRecord==0)
			{
				_currentPageIndex = 0;
				pagesArray = null;
				pageButtonArea.removeAllElements();
				return;
			}
			else 
			{
				if(_currentPageIndex>=_totalPages){
					_currentPageIndex = _totalPages-1;
				}
				if(_totalPages<pageShowLength)
				{
					currentBegin = 1;
					currentEnd = _totalPages;
				}
				else if(currentPageIndex<currentBegin||currentPageIndex>=(currentEnd-1))
				{
					//change page number showed
					currentBegin = (currentPageIndex+1)-Math.floor(Number(pageShowLength)/2.0);
					if(currentBegin<1)
					{
						currentBegin = 1;					
					}
					else if(currentBegin> _totalPages)
					{
							currentBegin = _totalPages;	
					}
					currentEnd = (currentPageIndex) +Math.ceil(Number(pageShowLength)/2.0);
					if(currentEnd > _totalPages)
					{
						//上限超出页码范围
						currentEnd = _totalPages;
					}else if(currentEnd<pageShowLength)
					{
						currentEnd = pageShowLength;
					}
					
				}
				createPageNumList(currentPageIndex-currentBegin+1,currentEnd-currentBegin+1,currentBegin);
				if(lastButton==null||lastButton.text!= (pagesArray[Math.ceil(currentPageIndex-currentBegin+1)] as PageDivideSimpleButton).text)
				{
					var oldIndex:int = -1;
					if(lastButton!=null)
					{
						lastButton.resetButton();
						oldIndex = int(lastButton.text)-1;
					}
					lastButton = (pagesArray[Math.ceil(currentPageIndex-currentBegin+1)] as PageDivideSimpleButton);
					dispatchEvent(new PageDividerEvent(PageDividerEvent.INDEX_CHANGE,false,false,recordPerPage,currentPageIndex*recordPerPage));
				}
				if(lastButton!=null){
					lastButton.setToggle();
				}
				currentPageInput.text = (currentPageIndex+1).toString();
				
			}
			
		}
		
		protected function comFontBtn_clickHandler(event:MouseEvent):void
		{
			currentPageIndex = 0;
		}
		
		protected function comPreBtn_clickHandler(event:MouseEvent):void
		{
			if(currentPageIndex>0)
			{
				currentPageIndex--;
			}
		}
		
		protected function comNextBtn_clickHandler(event:MouseEvent):void
		{
			if(currentPageIndex<_totalPages-1)
			{
				currentPageIndex++;
			}
		}
		
		protected function comBackBtn_clickHandler(event:MouseEvent):void
		{
			currentPageIndex = _totalPages-1;
		}
		protected function comPageNumClickHandler(event:MouseEvent):void
		{
			currentPageIndex = int((event.currentTarget as PageDivideSimpleButton).text)-1;
		}
	}
}