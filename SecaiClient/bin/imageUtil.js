
var ImageUtil = {};
ImageUtil.getImageData = function(url,callback){ 
  
  var canvas = document.createElement('canvas'); 
  var context = canvas.getContext('2d'); 
 // var showimg = document.getElementById('showimg'); 
  //var shadow = showimg.getElementsByTagName('span')[0]; 
  //var css_code = document.getElementById('css_code'); 
 
   var picimg = new Image();
	picimg.src = url;
 
    picimg.onload = function(e){ // reader onload start 
 
        var img_width = this.width; 
        var img_height = this.height; 
 
        // ���û����ߴ� 
        canvas.width = img_width; 
        canvas.height = img_height; 
 
        // ��ͼƬ������д�뻭�� 
        context.drawImage(this, 0, 0, img_width, img_height); 
 
        // ��ȡͼƬ������Ϣ 
        var imageData = context.getImageData(0, 0, img_width, img_height); 
		callback(imageData);
 
 
      } // image onload end      
  } 