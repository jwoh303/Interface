<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=emulateIE8;requiresActiveX=true"/>
	<style>
	</style>
	<script>
		//일단 예제에서는 IE사용자라고 가정하고 Meta를 통해 강제로 IE8로 화면을 맞춤
		
		
		//IE8 이하 스타일
		var a = opener.mySheet.GetSheetHtml();
		document.styleSheets[0].cssText = a.style;

//		//IE9 이상, 크롬등 스타일
//		var styleElement = document.createElement("style");
//		styleElement.type = "text/css";
//		styleElement.innerHTML = a.style;
		
	function init(){
		document.getElementById("sheet").outerHTML = a.body;	
		window.print();
		this.close();
		
	}
	</script>
</head>
<body onload="init()">
	<div id="sheet">
	</div>
</body>
</html>
