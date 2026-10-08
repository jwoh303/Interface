<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>SCORE PKI for OpenWeb 설치</title>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <script src="/resources/libs/jquery/js/jquery-3.6.0.min.js"></script>
	<script src="/resources/js/bs-3.3.5/js/bootstrap.js"></script>
	<script src="/resources/js/nxts/nxts.min.js"></script>
	<script src="/resources/js/nxts/nxtspki_config.js"></script>
	<script src="/resources/js/nxts/nxtspki.js"></script>
    <script>nxTSConfig.disableInstallConfirmMessage = true;</script>
	<link rel="stylesheet" href="/resources/styles/nxts/css/nxtsdemo.css" type="text/css">
	<link rel="stylesheet" href="/resources/js/bs-3.3.5/css/bootstrap.css" type="text/css">
	<link rel="stylesheet" href="/resources/js/bs-3.3.5/css/bootstrap-theme.css" type="text/css">
	<style>
		*{margin:0; padding:0}
		.wrap{width:550px; height:380px; background-color:#fff; margin:0 auto; margin-top:100px;border:2px solid #000;}
		.head{}
		.bg_img{text-indent:-1000px; overflow:hidden;width:546px; height:148px; background:url(/resources/images/nxpki_install.png) center/cover no-repeat; margin:2px auto;}
		.main{padding-left:20px; padding-right:20px; font-size:14px;}
		span{font-size:10px;}
		.main p{}
		.main a{float:left; margin-left:10px;}
		.main a:last-child{float:right;margin-left:0; margin-right:10px;}
		.main a:after {content:"";display:block;clear:both;}
		button{width:200px; height:30px;}
	</style>
</head>
<body>
	<div class="wrap">
        <div class="head">
            <div class="bg_img">배경이미지</div><br/>  
        </div>
        
        <div class="main">
          	<div id="configInfo"> </div>
          	 <font size="2" color="#333333">인증서 관리프로그램이 설치되지 않았습니다. </font><br>
          	 <font color="#333333" size="2">인증서 발급/관리를 위해서는 반드시 프로그램 설치가 필요합니다.</font><br>
          	 <font color="red" size="2">"설치파일 다운로드"를 클릭하셔서 실행시키십시오.</font><br><br>
            <a class="btn_bck" href="/main.do" ><button>처음으로</button></a>
            <a class="btn_dwl" onClick="download_setup();"><button>설치파일 다운로드</button></a>
        </div>
	</div>   
<script>
	var checkTimer;
	$(document).ready(function(){
		function installComplete(res,data) {
			$("#nxVersion").html(res.data.nx);
			$("#pkiVersion").html(res.data.tstoolkit);

			if(res.code == nxTSError.res_success) {
				checkTimer.stop();
				alert("SCORE PKI for OpenWeb 프로그램이 설치 되었습니다.")
				window.location.href = "/main.do";
			}
		}
		checkTimer = new nxTSUtil.timer(3000,function(){
			nxTSCommon.installCheck(false,{ajaxto:2500,success:installComplete,versionCheck:[nxTSConfig.TSTOOLKIT]});
		});
		checkTimer.start();

		updateConfigInfo("configInfo");
		updateBrowserInfo("browserInfo");
	});
  
	function download_setup() {
		window.location.href = "/resources/nxtspki/install/pki/down/nxtspkisetup.exe";
	}

	function updateConfigInfo(target) {
		var ul = $("<ul></ul>");
		ul.append($('<li><span class="key">NX 권장 버전 </span><span class="val uninstall">'+nxTSPKIConfig.version.nx+' ( 현재 버전 : <span id="nxVersion" class=""></span> )</span></li>'));
		ul.append($('<li><span class="key">TSPKI 권장 버전</span><span class="val uninstall">'+nxTSPKIConfig.version.tstoolkit+' ( 현재 버전 : <span id="pkiVersion" class=""></span> )</span></li>'));
		ul.append($('<li><span class="key">Platform</span><span class="val">'+navigator.platform+'</span></li>'));
		$("#"+target).append(ul);
	}

	function updateBrowserInfo(target) {
		var ul = $("<ul></ul>");
		ul.append($('<li><span class="key">Platform</span><span class="val">'+navigator.platform+'</span></li>'));
		ul.append($('<li><span class="key">AppVersion</span><span class="val">'+navigator.appVersion+'</span></li>'));
		ul.append($('<li><span class="key">UserAgent</span><span class="val">'+navigator.userAgent+'</span></li>'));
		$("#"+target).append(ul);
	}

</script>
</body>
</html>
