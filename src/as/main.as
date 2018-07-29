[Bindable]
[Embed(source="/assets/navIcons.png")]
public var navIcons:Class;
[Bindable]
[Embed(source="/assets/closeNav.png")]
public var closeNav:Class;
[Bindable]
[Embed(source="/assets/openNav.png")]
public var openNav:Class;
[Bindable]
[Embed(source="assets/Bulb On.png")]
public var bmlip:Class;

[Bindable]
public var isLeftClosed:Boolean=false;
[Bindable]
public var isRightClosed:Boolean=false;

import flash.display.StageDisplayState;
import flash.filters.GradientGlowFilter;

import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Label;
import mx.core.SpriteAsset;
import mx.events.FlexEvent;
import mx.managers.BrowserManager;
import mx.managers.ToolTipManager;

private function init():void
{
	allXML.addEventListener(AlliBilliEvent.ACC_TREE_BUILD, buildTree_in_acc);
	allXML.addEventListener(AlliBilliEvent.START_BUILD_UI, startBuildingUI);
	addEventListener(MyCustomEvent.MyFormSearchEvent, alliBilliSearchResult);
	addEventListener(AlliBilliEvent.TAB_REFRESH, refreshTab);
	//mstTimeDS.send();
	//countPlaceMyAdDS.send();
	jokeDS.send();
	ToolTipManager.showDelay=0;
	ToolTipManager.hideDelay=3000;
	systemManager.stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenHandler);
	systemManager.stage.addEventListener(MouseEvent.MOUSE_UP, identifyClick);
}

public function identifyClick(evt:MouseEvent):void
{
	var pageName:*=evt.target;
	if (evt.target is TextField)
	{
		pageName=TextField(evt.target).text;
	}
	if (evt.target is LinkBar)
	{
		pageName=LinkBar(evt.target);
	}
	if (evt.target is SpriteAsset)
	{
		pageName=SpriteAsset(evt.target).toString();
	}
	if (evt.target is Button)
	{
		pageName=Button(evt.target).label;
		if(pageName==null || pageName=="")
		{
			pageName = Button(evt.target).id;
		}
	}
	
	if(pageName is String && pageName.length > 20)
	{
		pageName = pageName.slice(0,19);
	}
	var url:String="http://services.allibilli.com/activemeterCount.jsp?pageTitle=" + pageName;
	trace(url);
	var urlReq:URLRequest=new URLRequest(url);
	var urlLdr:URLLoader=new URLLoader();
	urlLdr.load(urlReq);
	//ExternalInterface.call("gTrack",pageName);
	BrowserManager.getInstance().setTitle("Think Special - AlliBilli");
}

private function startBuildingUI(evt:AlliBilliEvent):void
{
	allXML.removeEventListener(AlliBilliEvent.START_BUILD_UI, startBuildingUI);
	trace("Start Building UI - LEFT");
	buildAccordians(allXML.getLeftAccordians(), leftAcc, "left");
	trace("Start Building UI - RIGHT");
	buildAccordians(allXML.getRightAccordians(), rightAcc, "right");

	startBuildingTrees();
	
}



private function startBuildingTrees():void
{
	for each (var objId:Object in mapperArray)
	{
		trace("-->"+objId.ID);
		var obj:*=mapperArray[objId.ID];
		allXML.loadTree(obj);
	}
}

private function creationComplete(evt:Event):void
{
	allXML.loadAccordians();
	var gradientGlow:GradientGlowFilter = new GradientGlowFilter();
	gradientGlow.distance = 1;
	gradientGlow.angle = 45;
	gradientGlow.colors = [0x68808c, 0x68808c];
	gradientGlow.alphas = [0, 1];
	gradientGlow.ratios = [0, 255];
	gradientGlow.blurX = 10;
	gradientGlow.blurY = 10;
	gradientGlow.strength = 1;
	gradientGlow.quality = BitmapFilterQuality.HIGH;
	gradientGlow.type = BitmapFilterType.OUTER;
//	gradientGlow.strength++;
	AlliBilliLogo.filters=[gradientGlow];
}

private function buildAccordians(xmlList:XMLList, pnl:Object, accSide:String):void
{
	var l:Label;

	trace("Building Accordians");
	xmlList=xmlList.children();
	if (xmlList != null)
	{
		for (var i:int=0; i < xmlList.length(); ++i)
		{
			myAcc=new VBox();
			//myAcc.icon=openNav;
			myAcc.id=xmlList[i].@n;
			myAcc.toolTip="Click to expand " + xmlList[i].@d;
			myAcc.percentWidth=100;
			myAcc.percentHeight=100;
			myAcc.label=xmlList[i].@l;
			l = new Label();
			l.setStyle("fontSize","18");
			l.text="Loading...";
			myAcc.addChild(l);
			pnl.addChild(myAcc);
			mapper=new Object();
			mapper.ID=myAcc.id;
			mapper.URL=xmlList[i].@u;
			mapper.ACCORDIAN=myAcc;
			mapper.ACCORDIAN_SIDE=accSide;
			mapperArray[myAcc.id]=mapper;
		}
		xmlList=null;
	}

}

public function closeRightPane():void
{
	if (isRightClosed == false)
	{
		rightAcc.visible=false;
		rightShrink.end();
		rightShrink.play();
		isRightClosed=true;
	}
}

public function closeLeftPane():void
{
	if (isLeftClosed == false)
	{
		leftShrink.end();
		leftShrink.play();
		isLeftClosed=true;
	}
}

public function openLeftPane():void
{
	if (isLeftClosed == true)
	{
		leftAcc.visible=true;
		leftGrow.end();
		leftGrow.play();
		isLeftClosed=false;
	}
}

public function openRightPane():void
{
	if (isRightClosed == true)
	{
		rightAcc.visible=true;
		rightGrow.end();
		rightGrow.play();
		isRightClosed=false;
	}
}

public function discloseLeftNav():void
{
	if (isLeftClosed == false)
	{
		leftAcc.visible=false;
		leftShrink.end();
		leftShrink.play();
		isLeftClosed=true;
	}
	else
	{
		leftAcc.visible=true;
		leftGrow.end();
		leftGrow.play();
		isLeftClosed=false;
	}
}

public function discloseRightNav(event:MouseEvent):void
{
	event.stopPropagation();
	event.preventDefault();
	if (isRightClosed == false)
	{
		closeRightPane();
	}
	else
	{
		openRightPane();
	}
}

public function expnadAllTrees(xmlTreeeData:XML, tree:Tree):void
{
	if (tree != null)
	{
		tree.validateNow();
		for each (var tempNode:XML in xmlTreeeData.children())
		{
			if (tempNode.@expandable == "true")
			{
				tree.expandItem(tempNode, true);
			}
		}
	}
}

public function handleLinkBarClick(event:ItemClickEvent):void
{
	handleExpand(null);
	if (event.label.indexOf("Suggestion Forum") != -1)
	{
		if (!checkForExistsingTabInMain("Sugesstion Forum"))
			myDataGridLoadEvent(event);
	}
	else if (event.label == "AlliBilli Search")
	{
		if (!checkForExistsingTabInMain("Search GBY"))
		{
			alliBilliSearchForm();
		}
	}
	else if (event.label == "Font Help")
	{
		if (!checkForExistsingTabInMain("Download Font"))
		{
			buildFontHelpPnl();
		}
	}
}

public function handleLeftRight(isToClose:Boolean, linkButton:LinkButton):void
{
	if (isToClose)
	{
		expandLink.label="Contract";
		linkButton.toolTip="Expand the left and right panes.";
		closeRightPane();
		closeLeftPane();
	}
	else
	{
		expandLink.label="Expand";
		linkButton.toolTip="Contract the left and right panes.";
		openRightPane();
		openLeftPane();
	}
}

public function handleExpand(event:Event):void
{
	if (event == null)
	{
		if (expandLink.label == "Expand")
		{
			expandLink.toolTip="Expand the left and right panes.";
			closeRightPane();
			closeLeftPane();
		}
		return;
	}
	if (event.target != null && event.target is LinkButton)
	{
		var linkButton:LinkButton=LinkButton(event.target);
		linkButton.toolTip="Expand the left and right panes.";
		expandLink.label == "Expand" ? handleLeftRight(true, linkButton) : handleLeftRight(false, linkButton);
	}
	else if (event is MyCustomEvent)
		handleLeftRight(true, LinkButton(linkBar.getChildAt(0)));
}

public function myDataGridLoadEvent(event:Event):void
{
	closeLeftPane();
	closeRightPane();
	createDataGrid();
}

public function createDataGrid():void
{
	var sugesstionForum:SugessitionForum=new SugessitionForum();
	tabNavigator.addChild(sugesstionForum);
	tabNavigator.selectedIndex=tabNavigator.getChildren().length - 1;
}

public function buildFontHelpPnl():void
{
	var fontHelp:FontHelp=new FontHelp();
	tabNavigator.addChild(fontHelp);
	tabNavigator.selectedIndex=tabNavigator.getChildren().length - 1;
}

public function alliBilliSearchForm():void
{
	var x:SearchForm=new SearchForm();
	tabNavigator.addChild(x);
	tabNavigator.selectedIndex=tabNavigator.getChildren().length - 1;
}

public function alliBilliSearchResult(event:MyCustomEvent):void
{

	var dataCollection:ArrayCollection=event.getDataCollection();
	leftShrink.duration=0;
	rightShrink.duration=0;
	handleLeftRight(true, LinkButton(linkBar.getChildAt(0)));
	var googleIFrame:IFrame=null;
	var yahooIFrame:IFrame=null;
	var bingIFrame:IFrame=null;
	var googleURL:String="http://www.google.com/search?q=" + dataCollection[0] ;
	var bingURL:String="http://www.bing.com/search?q=" + dataCollection[0] + "&form=QBLH&qs=n";
	var yahooURL:String="http://search.yahoo.com/search?p=" + dataCollection[0];
	bingIFrame=new IFrame();
	bingIFrame.label="Bing";
	bingIFrame.id="bing_id";
	bingIFrame.width=tabNavigator.width;
	bingIFrame.height=tabNavigator.height;
	tabNavigator.addChild(bingIFrame);
	yahooIFrame=new IFrame();
	yahooIFrame.label="Yahoo";
	yahooIFrame.id="yahoo_id";
	yahooIFrame.width=tabNavigator.width;
	yahooIFrame.height=tabNavigator.height;
	tabNavigator.addChild(yahooIFrame);
	googleIFrame=new IFrame();
	googleIFrame.label="Google";
	googleIFrame.id="google_id";
	googleIFrame.width=tabNavigator.width;
	googleIFrame.height=tabNavigator.height;
	googleIFrame.source=googleURL;
	tabNavigator.selectedIndex=tabNavigator.getChildren().length - 1;
	bingIFrame.source=bingURL;
	yahooIFrame.source=yahooURL;
	tabNavigator.addChild(googleIFrame);
}

public function onCompleteESTTimeSerice(event:ResultEvent):void
{
	var xml:XML=event.result as XML;
	arizonaDate.setHours(xml.hour, xml.minute, xml.second, xml.milliSecond);
	var myTimer:Timer=new Timer(1000);
	myTimer.addEventListener(TimerEvent.TIMER, tick);
	myTimer.start();
}

public function tick(event:TimerEvent):void
{
	updateTime();
}
public var estDate:Date=new Date();
public var cstDate:Date=new Date();
public var mstDate:Date=new Date();
public var pstDate:Date=new Date();
public var astDate:Date=new Date();
public var hstDate:Date=new Date();
public var indDate:Date=new Date();
public var arizonaDate:Date=new Date();

public function updateTime():void
{
	arizonaDate.setSeconds(mstDate.getSeconds() + 1, 0);
	var secs:int=arizonaDate.getSeconds();
	var mins:int=arizonaDate.getMinutes();
	var hours:int=arizonaDate.getHours();
	arizona.text=(pad(hours) + " : " + pad(mins) + " : " + pad(secs));
	estDate.setHours(arizonaDate.getHours() + 2, arizonaDate.getMinutes(), arizonaDate.getSeconds(), arizonaDate.getMilliseconds());
	cstDate.setHours(arizonaDate.getHours() + 1, arizonaDate.getMinutes(), arizonaDate.getSeconds(), arizonaDate.getMilliseconds());
	mstDate.setHours(arizonaDate.getHours(), arizonaDate.getMinutes(), arizonaDate.getSeconds(), arizonaDate.getMilliseconds());
	pstDate.setHours(arizonaDate.getHours() - 1, arizonaDate.getMinutes(), arizonaDate.getSeconds(), arizonaDate.getMilliseconds());
	astDate.setHours(arizonaDate.getHours() - 2, arizonaDate.getMinutes(), arizonaDate.getSeconds(), arizonaDate.getMilliseconds());
	hstDate.setHours(arizonaDate.getHours() - 3, arizonaDate.getMinutes(), arizonaDate.getSeconds(), arizonaDate.getMilliseconds());
	indDate.setHours(arizonaDate.getHours() + 12, arizonaDate.getMinutes() + 30, arizonaDate.getSeconds(), arizonaDate.getMilliseconds());

	estTime.text=(pad(estDate.getHours()) + " : " + pad(mins) + " : " + pad(secs));
	cstTime.text=(pad(cstDate.getHours()) + " : " + pad(mins) + " : " + pad(secs));
	pstTime.text=(pad(pstDate.getHours()) + " : " + pad(mins) + " : " + pad(secs));
	mstTime.text=(pad(mstDate.getHours()) + " : " + pad(mins) + " : " + pad(secs));
	astTime.text=(pad(astDate.getHours()) + " : " + pad(mins) + " : " + pad(secs));
	hstTime.text=(pad(hstDate.getHours()) + " : " + pad(mins) + " : " + pad(secs));
	indTime.text=(pad(indDate.getHours()) + " : " + pad(indDate.getMinutes()) + " : " + pad(secs));
}

public function pad(number:Number):String
{
	var new_num:String=String(number);
	if (new_num.length < 2)
	{
		new_num="0" + new_num;
	}
	return new_num;
}

public function onCompleteCountPlaceMyAdSerice(event:ResultEvent):void
{
	var countPlaceMyAdService:XML=event.result as XML;
	//countRoommate.label="Search for Roommate (" + countPlaceMyAdService.rommateCount + ")";
	countForum.label="Suggestion Forum(" + countPlaceMyAdService.forumCount + ")";
	linkBar.dataProvider=optionsBar;
}

public function handleJokeDayDataXML(event:ResultEvent):void
{
	var jokeDayNavData:XML=event.result as XML;
	
	var jokeDay=jokeDayNavData..jokeDay as XMLList;
	jokeDayNavDataTxt.text=jokeDay.treeRoot[0];
	siteUpdates.text=jokeDayNavData..news as XMLList;
	jobs.text=jokeDayNavData..jobs as XMLList;
	var youTubeURL:String=jokeDayNavData..youtube as XMLList;
	var desc:String = (jokeDayNavData..youtube as XMLList).@desc;
	Security.allowDomain(youTubeURL);	
	var y:YouTubePlayer = new YouTubePlayer();
	youTubePlayBox.addChild(y);
	y.setVideoId(youTubeURL);
	youTubeCaption.text=desc;
}

public function handleReload():void
{
	trace(tabNavigator.selectedIndex);
	if (tabNavigator.getChildAt(tabNavigator.selectedIndex) is IFrame)
	{
		var iFrame:IFrame=IFrame(tabNavigator.getChildAt(tabNavigator.selectedIndex));
		var dupIFrame:IFrame=new IFrame();
		if (iFrame != null)
		{
			dupIFrame.source=iFrame.source;
			dupIFrame.label=iFrame.label;
			tabNavigator.removeChild(iFrame);
			tabNavigator.addChild(dupIFrame);
			tabNavigator.selectedIndex=tabNavigator.getChildren().length - 1;
		}
		else
		{
			Alert.show("This Tab doesn't have any content to Reload.");
		}
	}
	else
	{
		Alert.show("This Tab doesn't have any content to Reload.");
	}
}

private function fullScreenHandler(evt:FullScreenEvent):void
{
	if (evt.fullScreen)
	{
	}
	else
	{
	}
}

private function toggleFullScreen():void
{
	try
	{
		switch (systemManager.stage.displayState)
		{
			case StageDisplayState.FULL_SCREEN:
				systemManager.stage.displayState=StageDisplayState.NORMAL;
				break;
			default:
				systemManager.stage.displayState=StageDisplayState.FULL_SCREEN;
				break;
		}
	}
	catch (err:SecurityError)
	{
	}
}
