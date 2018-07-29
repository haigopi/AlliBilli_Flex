package com
{
	import mx.controls.TextInput;
	import mx.controls.Image;
	
	
	public class TabSearch extends TextInput
	{
		[Embed(source='../assets/search.png')]
		private var searchIcon:Class;   
		private var searchImg:Image;  
		
		public function TabSearch()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			searchImg = new Image();
			searchImg.source = searchIcon;
			searchImg.width=15;
			searchImg.height=15;
			searchImg.x = 2;
			searchImg.y = 2;
			
			setStyle("borderStyle", "solid");
			setStyle("borderColor", "#FFFFFF");
			setStyle("borderThickness", "2");
			setStyle("backgroundAlpha", "0.79");
			setStyle("backgroundColor", "#DDEEDD");
			setStyle("color", "#330000");
			setStyle("paddingLeft", "4");
			setStyle("cornerRadius", 5);
			setStyle("fontSize",9);
			setStyle("paddingRight",searchImg.width+2);
			
			addChild(searchImg);
			
		}

	}
}