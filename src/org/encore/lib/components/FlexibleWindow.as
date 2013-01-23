package org.encore.lib.components
{
	import flash.events.MouseEvent;
	
	import mx.core.DragSource;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.filters.IBitmapFilter;
	import mx.graphics.GradientEntry;
	import mx.graphics.IFill;
	import mx.graphics.LinearGradient;
	import mx.managers.DragManager;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.supportClasses.GroupBase;
	import spark.filters.GlowFilter;
	import spark.layouts.VerticalLayout;
	import spark.primitives.Rect;
	import spark.primitives.supportClasses.GraphicElement;

	/**
	 *  <b>FlexibleWindow类</b>
	 * <p>Please describe this AS file in brief.</p>
	 * <p>Create at 2012-6-2 . SCUT Ensave.</p>
	 * @author 叶翼安
	 * */
	public class FlexibleWindow extends Group
	{
		public function FlexibleWindow()
		{
		}
		private var windowLayout:VerticalLayout;
		//Children elements
		private var titleGroup:Group;
		private var mainGroup:Group;
		
		private var titleComponentGroup:HGroup
		private var titleBackgroupRect:Rect;
		
		private var mainComponentGroup:Group;
		private var mainBackgroupRect:Rect;
		//properties
		private var _position:String="standalone";
		private var _radius:Number;
		private var _dragable:Boolean = false;
		//title properties
		private var titleHeight:Number =28;
		private var _titleLeft:Object=5;
		private var _titleRight:Object=5;
		private var _titleGap:Number=6;
		private var _titleContent:Array;
		//content properties
		private var _mainContent:Array;
		private var _mainFill:IFill; 
		private var bFillChange:Boolean=false;
		
		private var bMainContentFlag:Boolean=false;
		
		private var _container:UIComponent;
		public function get container():UIComponent
		{
			return _container;
		}

		public function set container(value:UIComponent):void
		{
			_container = value;
			if(value!=null)
			{
				value.addEventListener(DragEvent.DRAG_ENTER,acceptHandler);
				value.addEventListener(DragEvent.DRAG_DROP,acceptDropHandler);
			}
		}

		protected function acceptHandler(event:DragEvent):void
		{
			if(event.dragSource.dataForFormat("name")=="flexiableWindow")
			{
				DragManager.acceptDragDrop(container as UIComponent);
			}
		}
		protected function acceptDropHandler(event:DragEvent):void
		{
			var target:UIComponent = event.currentTarget as UIComponent;
			if(target)
			{
				var offsetx:Number = event.dragSource.dataForFormat("mouseX") as Number;
				var offsety:Number = event.dragSource.dataForFormat("mouseY") as Number;
				x = target.mouseX-offsetx;
				y = target.mouseY-offsety;
			}
		}
		protected function titleClickDragHandler(event:MouseEvent):void
		{
			if(dragable)
			{
				var dragSource:DragSource = new DragSource();
				dragSource.addData("flexiableWindow","name");
				dragSource.addData(mouseX,"mouseX");
				dragSource.addData(mouseY,"mouseY");
				var dragImage:Image = new Image();
				dragImage.source=this;
				DragManager.doDrag(this,dragSource,event,dragImage);				
			}
		}

		public function get dragable():Boolean
		{
			return _dragable;
		}
		[Bindable]
		/**
		 * 允许点击标题时候拖动窗口。但必须要先设置接受此窗口的组件。 
		 */
		public function set dragable(value:Boolean):void
		{
			_dragable = value;
		}

		public function get mainContent():Array
		{
			return _mainContent;
		}

		public function set mainContent(value:Array):void
		{
			if(value!=_mainContent)
			{
				_mainContent = value;
				contentAddHelp(mainComponentGroup,_mainContent);
				invalidateDisplayList();
				invalidateSize();
			}
		}

		public function get titleContent():Array
		{
			return _titleContent;
		}
		
		private var bTitleContentFlag:Boolean=false;
		
		public function set titleContent(value:Array):void
		{
			if(value!=_titleContent)
			{
				_titleContent = value;				
				contentAddHelp(titleComponentGroup,_titleContent);
				invalidateDisplayList();
				invalidateSize();
			}
		}

		override protected function createChildren():void
		{
			super.createChildren();
			windowLayout ||=new VerticalLayout();
			layout = windowLayout;
			windowLayout.gap = 0;
			
			titleGroup ||=new Group();
			mainGroup ||= new Group();
			addElement(titleGroup);
			addElement(mainGroup);
			//title backgroup initial
			titleComponentGroup ||= new HGroup();
			titleBackgroupRect ||= new Rect();
			titleGroup.addElement(titleBackgroupRect);
			titleGroup.addElement(titleComponentGroup);
			contentAddHelp(titleComponentGroup,titleContent);
			
			//title backgroup
			var titleFill:LinearGradient = new LinearGradient();
			var gEntry1:GradientEntry = new GradientEntry();
			var gEntry2:GradientEntry = new GradientEntry();
			var gEntry3:GradientEntry = new GradientEntry();
			gEntry1.color = 0xFFFFFF;
			gEntry1.ratio = 0;
			gEntry1.alpha =1;
			gEntry2.color = 0xFFFFFF;
			gEntry2.ratio = 0.03;
			gEntry2.alpha = 0.8;
			gEntry3.color = 0xFFFFFF;
			gEntry3.ratio = 1;
			gEntry3.alpha =1;
			
			titleFill.entries = [gEntry1,gEntry2,gEntry3];
			titleFill.rotation=90;
			titleBackgroupRect.fill = titleFill;
			//title filter
			var titleFilter:GlowFilter = new GlowFilter();
			titleFilter.color = 0x000000;
			titleFilter.alpha=0.7;
			titleBackgroupRect.filters = [titleFilter];
			titleBackgroupRect.percentWidth = 100;
			titleBackgroupRect.percentHeight = 100;			
			titleGroup.addEventListener(MouseEvent.MOUSE_DOWN,titleClickDragHandler);
			//title component group
			titleComponentGroup.percentWidth = 100;
			titleComponentGroup.percentHeight = 100;
			titleComponentGroup.verticalAlign="middle";
			
			
			
			//main backgruop initial
			mainBackgroupRect ||=new Rect();
			mainComponentGroup ||= new Group();
			mainGroup.addElement(mainBackgroupRect);
			mainGroup.addElement(mainComponentGroup);
			contentAddHelp(mainComponentGroup,mainContent);
			
			//main backgroup
			if(mainFill == null)
			{
				
				var defaultFill:LinearGradient = new LinearGradient();
				var gEntry4:GradientEntry = new GradientEntry();
				var gEntry5:GradientEntry = new GradientEntry();
				gEntry4.color = 0xe9e9e9;
				gEntry4.ratio = 0;
				gEntry5.color = 0xcccccc;
				gEntry5.ratio = 1;
				
				defaultFill.entries =[gEntry4,gEntry5];
				defaultFill.rotation=90;
				
				mainFill = defaultFill;
			}
			mainBackgroupRect.fill = mainFill;

			var mainFilter:GlowFilter = new GlowFilter();
			mainFilter.color = 0x000000;
			mainFilter.alpha=0.7;
			mainBackgroupRect.filters = [mainFilter];
			mainBackgroupRect.percentHeight=100;
			mainBackgroupRect.percentWidth=100;
			mainComponentGroup.percentHeight=100;
			mainComponentGroup.percentWidth=100;
			mainGroup.percentHeight=100;
			mainGroup.percentWidth=100;
			
			titleGroup.percentWidth=100;
			titleGroup.height = titleHeight;
		}
		
		[Bindable]
		public function get mainFill():IFill
		{
			return _mainFill;
		}
		
		public function set mainFill(value:IFill):void
		{
			if(value!=_mainFill)
			{
				_mainFill = value;
				bFillChange=true;
				invalidateDisplayList();
			}
			
		}
		protected function resetBackgroupRect(rect:Rect):void
		{
			if(titleGroup)
			{
				titleGroup.height = titleHeight;
			}
			if(titleComponentGroup)
			{
				titleComponentGroup.gap=titleGap;
				titleComponentGroup.left = titleLeft;
				titleComponentGroup.right = titleRight;
			}
			if(rect)
			{
				rect.topLeftRadiusX=0;
				rect.topLeftRadiusY=0;
				rect.topRightRadiusY=0;
				rect.topRightRadiusX=0;
				rect.bottomLeftRadiusX=0;
				rect.bottomLeftRadiusY=0;
				rect.bottomRightRadiusY=0;
				rect.bottomRightRadiusX=0;
			}
		}
		
		protected function contentAddHelp(group:Group,content:Array):void
		{
			
			if(group&&content&&content.length>0)
			{
				group.removeAllElements();
				for (var i:int=0;i<content.length;i++)
				{
					var element:IVisualElement = content[i];
					if(element!=null)
						group.addElement(element);
				}
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{			
			if(titleBackgroupRect&&mainBackgroupRect)
			{
				resetBackgroupRect(titleBackgroupRect);
				resetBackgroupRect(mainBackgroupRect);
				if(isNaN(radius))
				{
					radius = 8;
				}
				switch(position)
				{
					case "left":
						titleBackgroupRect.topLeftRadiusX = radius;
						titleBackgroupRect.topLeftRadiusY = radius;
						mainBackgroupRect.bottomLeftRadiusX =radius;
						mainBackgroupRect.bottomLeftRadiusY = radius;
						break;
					case "top":
						titleBackgroupRect.topLeftRadiusX = radius;
						titleBackgroupRect.topLeftRadiusY = radius;
						titleBackgroupRect.topRightRadiusX = radius;
						titleBackgroupRect.topRightRadiusY = radius;
						break;
					case "right":
						titleBackgroupRect.topRightRadiusX = radius;
						titleBackgroupRect.topRightRadiusY = radius;
						mainBackgroupRect.bottomRightRadiusX =radius;
						mainBackgroupRect.bottomRightRadiusY = radius;
						break;
					case "bottom":
						mainBackgroupRect.bottomLeftRadiusX =radius;
						mainBackgroupRect.bottomLeftRadiusY = radius;
						mainBackgroupRect.bottomRightRadiusX =radius;
						mainBackgroupRect.bottomRightRadiusY = radius;
						break;
					case "topLeft":
						titleBackgroupRect.topLeftRadiusX = radius;
						titleBackgroupRect.topLeftRadiusY = radius;
						break;
					case "topRight":
						titleBackgroupRect.topRightRadiusX = radius;
						titleBackgroupRect.topRightRadiusY = radius;
						break;
					case "bottomLeft":
						mainBackgroupRect.bottomLeftRadiusX =radius;
						mainBackgroupRect.bottomLeftRadiusY = radius;
						break;
					case "bottomRight":
						mainBackgroupRect.bottomRightRadiusX =radius;
						mainBackgroupRect.bottomRightRadiusY = radius;
						break;
					case "standalone":
						titleBackgroupRect.topLeftRadiusX = radius;
						titleBackgroupRect.topLeftRadiusY = radius;
						titleBackgroupRect.topRightRadiusX = radius;
						titleBackgroupRect.topRightRadiusY = radius;
						mainBackgroupRect.bottomLeftRadiusX =radius;
						mainBackgroupRect.bottomLeftRadiusY = radius;
						mainBackgroupRect.bottomRightRadiusX =radius;
						mainBackgroupRect.bottomRightRadiusY = radius;
					default:
						break;
				}
			}
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}

		[Bindable]
		[Inspectable(arrayType="String",enumeration="left,right,top,bottom,topLeft,topRight,bottomLeft,bottomRight,standalone",defaultValue="standalone")]
		public function get position():String
		{
			return _position;
		}

		public function set position(value:String):void
		{
			if(value!=_position)
			{
				_position = value;			
				invalidateDisplayList();
			}
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			if(value!=_radius)
			{
				_radius = value;
				invalidateDisplayList();
			}
		}

		public function get titleGap():Number
		{
			return _titleGap;
		}

		public function set titleGap(value:Number):void
		{
			if(value!=_titleGap)
			{
				_titleGap = value;
				invalidateDisplayList();
			}
		}

		public function get titleRight():Object
		{
			return _titleRight;
		}

		public function set titleRight(value:Object):void
		{
			if(value!=_titleRight)
			{
				_titleRight = value;
				invalidateDisplayList();
			}
		}

		public function get titleLeft():Object
		{
			return _titleLeft;
		}

		public function set titleLeft(value:Object):void
		{
			if(value!=_titleLeft)
			{
				_titleLeft = value;
				invalidateDisplayList();
			}
		}

		
			
	}
}