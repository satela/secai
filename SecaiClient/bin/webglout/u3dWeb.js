var Unity3dWeb = {};
var gameInstance;
var layaCaller;
Unity3dWeb.createUnity = function()
{

	 gameInstance = UnityLoader.instantiate("gameContainer", "webglout/Build/webglout.json", {onProgress: UnityProgress});

}

Unity3dWeb.closeUnity = function()
{

	gameInstance.Module.abort();

}

Unity3dWeb.onReady = function()
{
	console.log("unity load complete");	
	if(layaCaller != null)
	{
		layaCaller.unityIsReady();
	}
}
Unity3dWeb.createMesh = function(picurl)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "create3DText",picurl);

}


Unity3dWeb.createLayer = function(params)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "createFontlayer",params);

}