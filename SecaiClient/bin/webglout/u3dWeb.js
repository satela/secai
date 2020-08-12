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

Unity3dWeb.UnityIsReady = function()
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

Unity3dWeb.changefontSize = function(size)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "setFontSize",size);
}

Unity3dWeb.changebackground = function(texurl)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "changeBackGround",texurl);
}

Unity3dWeb.changelayerAlpha = function(texurl)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "changeLayerAlpha",texurl);
}

Unity3dWeb.changeligthIntensity = function(texurl)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "changeLightIntensity",texurl);
}

Unity3dWeb.changeCausticUVX = function(uvx)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "changeCausticUVX",uvx);
}

Unity3dWeb.changeCausticUVY = function(uvx)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "changeCausticUVY",uvx);
}
Unity3dWeb.changeCausticStrength = function(strength)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "changeCausticItrate",strength);
}

Unity3dWeb.changeCameraFov = function(fov)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "changeReflectCameraFov",fov);
}

Unity3dWeb.moveCamera = function(offset)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "moveCamera",offset);
}

Unity3dWeb.setSceneActive = function(active)
{
	if(gameInstance != null)
	gameInstance.SendMessage("Main Camera", "setSceneActive",active);
}

