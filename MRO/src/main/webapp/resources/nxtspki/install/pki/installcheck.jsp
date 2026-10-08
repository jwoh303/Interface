<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <link rel="stylesheet" href="../js/bs-3.3.5/css/bootstrap.css" type="text/css">
  <link rel="stylesheet" href="../js/bs-3.3.5/css/bootstrap-theme.css" type="text/css">
  <link rel="stylesheet" href="../css/common.css" type="text/css">
  <script src="../../js/jquery/jquery-1.11.3.js"></script>
  <script src="../../js/bs-3.3.5/js/bootstrap.js"></script>
  <script src="../../js/nxts/nxts.min.js"></script>
  <script src="../../js/nxts/nxtspki_config.js"></script>
  <script src="../../js/nxts/nxtspki.js"></script>

</head>
<body>
<script>
	//초기화 함수 필수
    $(document).ready(function(){
        nxTSPKI.onInit(function(){ 
			// nxTSPKI.init 함수 완료 후 실행해야 하는 함수나 기능 작성 위치
			//alert("Init 완료");
		});
		nxTSPKI.installCheck(true);
		//nxTSPKI.init(true);
    });	
</script>
</body>
</html>
