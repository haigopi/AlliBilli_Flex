
import com.MyCustomEvent;
import com.MyRoomMateEvent;

import flash.events.Event;

import mx.controls.Button;
import mx.rpc.http.mxml.HTTPService;

public function updateViewStack(event:Event):void
{
	if(event.currentTarget is Button)
	{
		var id:String = Button(event.currentTarget).id;
		trace(id);
		switch(id)
		{
			case "palceAd": 
			{
				updateViewStackWithPlaceAdView(0);	
				break;
			}
			case "listAd": 
			{
				
				updateViewStackWithListAdView(1);	
				break;
			}
			default:
			{
				break;
			}
		}
			
	}
}

public function updateViewStackWithPlaceAdView(selectionIndex:int): void
{
	trace(selectionIndex);
	myRoomMateViewStack.selectedIndex = selectionIndex; 
}

public function updateViewStackWithListAdView(selectionIndex:int): void
{
	trace(selectionIndex);
	myRoomMateViewStack.selectedIndex = selectionIndex;
}