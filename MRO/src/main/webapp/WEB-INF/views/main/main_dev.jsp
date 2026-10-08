<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
</head>
<body onLoad="kep_onload_view()"> 
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <div id="ksign" style="position:absolute; left:0px; top:0px; width:0%; height:0%;display:none;" >
		<object id="CC_Object_id"
		      classid="CLSID:A099920B-630C-426B-91EC-737685CEEE17"
		      width= Document.body.clientWidth
		      height= Document.body.clientHeight>
		</object>
	</div>
<form id="loginForm" name="loginForm" method="post">
		<input type = "hidden" id="originData" name = "originData" size="40" >
		<input type = "hidden" id="pageFlag" name = "pageFlag"  value="">
 		<input type = "hidden" id="mainLogin" name = "mainLogin" value="">
    <!--베너-->
    <div class="Visual">
        <div class="MainVisual" >
            <ul class="VisualList" >
                <li >
                    <div style="position:absolute ;margin:0 auto; min-width:1080px; top:120px; z-index:2; text-align:center; color:#fff; "> 
                       <div style="left:50%;margin-left:660px;">
                           <!--div style="font-size:20px; height:40px; line-height:40px; ">PLATFORM BUSINESS LEADERS</div-->
                           <div style="font-size:45px; height:40px; line-height:40px; font-family:맑은 고딕; letter-spacing:-3px">B2B시장의 <b>플랫폼 비즈니스 리더</b></div></br></br>
                           <div style="font-size:22px; height:80px; line-height:32px; letter-spacing:-1px">
                           새로운 가치창출을 통해  </br>고객의 경쟁력 향상에 기여합니다. </div>
                           <!--img src="/resources/images/2016/vanner01.png" /-->
                       </div>
                    </div>
                    <div style="position:absolute; background:url(/resources/images/2016/dot_main01.png); width:100%; height:440px; z-index:1;background-color:transparent "  > </div>
                	<img src="/resources/images/2016/banner011.jpg" />
                </li>
                <li>
                    <div style="position:absolute ;margin:0 auto; min-width:1080px; top:120px; z-index:2; text-align:center; color:#fff; "> 
                      <div style="left:50%;margin-left:545px; ">
                       <!--div style="font-size:20px; height:40px; line-height:40px; ">MRO SPECIALIZED</div-->
                       <div style="font-size:45px; height:40px; line-height:40px; font-family:맑은 고딕; letter-spacing:-3px">온라인 기반의 투명한  <b>구매시스템/프로세스</b>운영</div></br></br>
                       <div style="font-size:22px; height:90px; line-height:32px; letter-spacing:-1px">
                       e-Sourcing 시스템을 통해 </br>투명한 구매관리 및 효율적인 조달 프로세스를 제공하고 있습니다. </div>
                       <!--img src="/resources/images/2016/vanner02.png" /-->
                        </div>
                    </div>
                    <div style="position:absolute; background:url(/resources/images/2016/dot_main01.png); width:100%; height:440px; z-index:1;background-color:transparent "  > </div>
                	<img src="/resources/images/2016/banner022.jpg" />
                </li>
                <li>
                	
                    <div style="position:absolute ;margin:0 auto; min-width:1080px; top:120px; z-index:2; text-align:center; color:#fff; "> 
                     <div style="left:50%;margin-left:760px;">
                       <!--div style="font-size:20px; height:40px; line-height:40px; ">NEW BUYING TRENDS</div-->
                       <div style="font-size:45px; height:40px; line-height:40px; font-family:맑은 고딕; letter-spacing:-3px"><b>고객맞춤형 </b>서비스 제공</div></br></br>
                       <div style="font-size:22px; height:90px; line-height:32px; letter-spacing:-1px">
                       다양한 고객의 비즈니스 환경에 적합한 </br> 최적의 솔루션을 제공합니다. </div>
                       <!--img src="/resources/images/2016/vanner02.png" /-->
                       </div>
                    </div>
                    <div style="position:absolute; background:url(/resources/images/2016/dot_main01.png); width:100%; height:440px; z-index:1;background-color:transparent "  > </div>
                	<img src="/resources/images/2016/banner033.jpg" />
                </li>
            </ul>
            <div class="num">
                <ul>
                	<li ><div style=" width:400px; height:500px; position:absolute; background-color:#FF0; color:#fff; z-index:100 ">sss</div></li>
                    <li>4</li>
                    <li>5</li>
                </ul>
            </div>
        </div>
        <script>
        $(".MainVisual").slide({ titCell:".num ul" , mainCell:".VisualList" , effect:"fold", autoPlay:true, delayTime:2000 , autoPage:true });
        </script>
    </div>
    <!--베너끝-->
    <!--컨텐츠-->
    <div class="contentsArea">
    	<div class="loginbox">
            <div class="login">
                  <input id="autoLogin" name="autoLogin" type="checkbox" style="border:0; width:15px; height:15px; margin-top:3px" onchange="saveCookieId(this.checked)" /> 아이디저장<br />
                  <input style="ime-mode:disabled;" type="text" id="userId" name="userId" title=""  onkeyup="kepToUpper('userId')" onKeyDown="if(event.keyCode == 13){actionLogin();};" placeholder="아이디" value=""  class="input_text"/>
				  <input type="password" id="password" name="password" title=""  placeholder="비밀번호"  onKeyDown="if(event.keyCode == 13){actionLogin();};" value=""  class="input_text" />/>
                  <a href="javascript:actionLogin();"><p class="loginBut">로그인</p></a> 
                  <a href="javascript:signData();"><p class="loginBut_seller">협력사(기업)인증서 로그인</p></a> 
                  <p class="seller_txt">※ <span style="color:#ee3212" >개인인증서</span>는 로그인할 수 없습니다.</p>
              </div>
        </div>
        <div class="value01">
        	<div class="valuebox">
                <a href="javascript:MovePage_2016('<%=httpurl%>','02', '05');"><p class="valuetit">구매시스템</p></a>
                <p class="valuetxt"><img src="/resources/images/2016/br06.gif" style="margin-bottom:5px"/><br />고객 요구를 반영한 다양한 <br />시스템을 통해 고객사의 구매 <br />업무를 안정적으로 지원합니다.  </p></a> 
            </div>
        </div>
        <div class="value02">
        	<div class="valuebox">
                <a href="javascript:MovePage_2016('<%=httpurl%>','02', '06');"><p class="valuetit">물류센터</p></a>
                <p class="valuetxt"><img src="/resources/images/2016/br06.gif" style="margin-bottom:5px"/><br />선진화된 물류정보시스템을 <br />통해 입고, 출고, 반품/교환 등<br />전체 프로세스를 관리하고 있습니다.  </p></a> 
            </div>
        </div>
        <div class="ethics">
        	<div class="valuebox">
                <a href="http://www.ekdp.com/ethics/main/main.asp" target="_blank"><p class="valuetit_ethics"><img src="/resources/images/2016/index_img06.png" style="margin-bottom:8px"/><br />윤리경영 제보</p></a>
                <p class="valuetxt" >모든 임직원들의 행동과 <br />가치판단의 기준이 됩니다. </p>
                <p style="position:absolute; top:5px; left:180px"><img src="/resources/images/2016/index_img05.png" style="margin-bottom:8px"/></p>
                </a> 
            </div>
        </div>
        
        <div class="recruit">
        	<div class="valuebox">
                <a href="javascript:MovePage_2016('<%=httpurl%>','03', '06');"><p class="valuetit">채용정보</p></a>
                <p class="valuetxt"><img src="/resources/images/2016/br06.gif" style="margin-bottom:5px"/><br />KeP의 문은 항상 열려있습니다.<br />진취적이고 역량 있는 인재를 <br />모집합니다.</p> 
            </div>
        </div>
        <div class="cmro">
             <div class="valuebox">
                <a href="javascript:MovePage_2016('<%=httpurl%>','02', '03');"><p class="valuetit">건설MRO</p></a> 
                <p class="valuetxt"><img src="/resources/images/2016/br06.gif" style="margin-bottom:5px"/><br />전국 네트워크 협력사를 통해  <br />가장 경쟁력 있는 서비스를 <br /> 제공합니다. </p>
            </div>    
        </div>
    </div>
</form>
    <!--컨텐츠 끝-->
  
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
 </body>
<script type="text/javascript">
function saveCookieId(chk){
	var userId = $("#userId").val(); 
	if(chk == true){
		setCookie("chkLoginCookie", "Y" ,20);
		setCookie("saveCookieId", userId ,20);
	}else{
		setCookie("chkLoginCookie", "N" ,20);
		setCookie("saveCookieId", "" ,20);
	}
}
function setCookie(name,value,expiredays) {
	var todayDate = new Date();
	todayDate.setDate(todayDate.getDate() + expiredays);
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}
	
function kep_onload_view(){ 
	
	if ('${message}' != '') {
		alert('${message}');
	}
	var cookieUserId = getCookie("saveCookieId");
	var chkLoginCookie = getCookie("chkLoginCookie");
	if(chkLoginCookie == "Y" ){
		$("#userId").val(cookieUserId);
		document.getElementById("autoLogin").checked = true;
	}
} 
//자동로그인쿠키
function getCookie(name) {
	var nameOfCookie = name + "=";
	var x = 0

	while ( x <= document.cookie.length ) {
		var y = (x+nameOfCookie.length);
		if ( document.cookie.substring( x, y ) == nameOfCookie ) {
			if ( (endOfCookie=document.cookie.indexOf( ";",y )) == -1 )
				endOfCookie = document.cookie.length;
				return unescape( document.cookie.substring(y, endOfCookie ) );
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 )
		break;
	}
	return "";
}  


/**
 * 상세폼이동
 */
function kepEditForm(bid,btype){ 
	$("#BID").val(bid);
	$("#BTYPE").val(btype);
	var action = "";
	if(btype == "EB"){
		action = "/main/sub04/sub04_02ebiz_news_view.do";
	}else{
		action = "/main/sub04/sub04_01notice_view.do";
	}
	$('#board').attr("action", action).submit();
}

/* 공동인증서 로그인을 위한 처리 */
function signData()
{
	var userId = $("#userId").val().toUpperCase();
	
	if(browser == "other"){
    	 alert("공동인증서는 인터넷 익스플로러 브라우져만 사용가능합니다.");
    	 return;
     }
	
	if(userId  == null ||  userId == ""){
        alert("회원아이디를 입력하여 주십시요. \n회원아이디로 사업자등록번호를 체크합니다.");
        document.loginForm.userId.focus();
        return;
     }
     
     //object 존재여부 확인(설치가 안된 client는 수동설치 할 수 있도록 popup띄움)
     if (document.CC_Object_id.object == null) {
	    	 window.open( "<%=httpurl%>/module/crosscert/ccc-sample/Object_chk.html" ,"BicImage","width=600,height=470,toolbar=no,location=no,resizable=yes,menubar=no,status=no,scrollbars=yes");
	    	 return;
	     }else{
	     //사업자 번호 get(후 처리는 kepAjaxSuccessMain 펑션에서 수행.)
	     var pData = { st_user_id : userId };
	     kepAjaxCallMain("/login/getIRSNo.do",pData,"getIRSNo"); 
	     }
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccessMain(pMethod , response){
	
	if(pMethod == "getIRSNo"){
		//사업자 정보 체크
	     var irs_no = $.trim(eval("response.data.IRS_NO"));
    	 
    	 if( irs_no == null || irs_no == "" ){
 	        alert(" 사업자번호 정보가 없습니다.");
 	        return;
 	    }
    	 
    	 //원문data set
    	 var originData = $.trim(eval("response.data.ORIGIN_DATA"));
		 $("#originData").val(originData);
 	   
 	     var ret;
 	     var signeddata;
 	     var userdn, getR;
 	 	
	    	 // 환경설정 함수 콜
	    	 initCrosscert();
		 	// 인증서 선택창 초기화 및 선택된 인증서의 DN 추출
		 	// DN은 인증기관에서 유니크한 것임.
		 	userdn = document.CC_Object_id.GetUserDN();
		 	
		 	if( userdn == null || userdn == "" ) { 
				return;
			} else {
				signeddata = document.CC_Object_id.SignData( document.loginForm.originData.value, "SHA1", "");
				
				if( signeddata == null || signeddata == "" ){
		            errmsg = document.CC_Object_id.GetErrorContent();
		            errcode = document.CC_Object_id.GetErrorCode();
		            alert( "SignData :"+errmsg );
		            return;
		        }else{
		        	getR = document.CC_Object_id.GetRFromKey(userdn, "");
		        	
		        	if (getR == ""){
		                alert("주민/사업자번호를 확인할 수 없는 인증서입니다.");
		                return;
		            }
		            ret = CC_Object_id.ValidCert_VID(userdn, getR, irs_no); //사업자번호 체크
		            if (ret != "0"){
		                alert("본인확인에 실패했습니다. 선택한 인증서의 사업자번호와 일치하지 않습니다. \n\n해당 인증기관에 문의하시기 바랍니다.");
		                return;
		            }else{
		            	//인증서의 유효성 체크(서명된 데이터를 서버에서 처리. )
 		  		     var pData = { signedData : signeddata, getR : getR, ssn : irs_no, userId :  $("#userId").val()};
 		  		     kepAjaxCallMain("/login/certValidate.do",pData,"getCertValidate"); 
		            }
		        }
			    
			}
     
	}else if(pMethod == "getCertValidate"){
		if("0000" != response.data.errorCode) {
			alert("유효하지 않은 인증서입니다.\n"+response.data.errorMsg);
			return;
		}else{ 
			//인증성공
			var userId = $("#userId").val(); 
			if(document.getElementById("autoLogin").checked == true){
				setCookie("chkLoginCookie", "Y" ,20);
				setCookie("saveCookieId", userId ,20);
			}else{
				setCookie("chkLoginCookie", "N" ,20);
				setCookie("saveCookieId", "" ,20);
			}
			document.loginForm.userId.value =  response.data.userId;
			document.loginForm.pageFlag.value =  "CertLogin";
        	document.loginForm.action = "<%=sslurl%>/login/office_login.do";
   	     	document.loginForm.submit();
		}
     }
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxErrorMain(pMethod , response) {
	
	if (pMethod == "getIRSNo"){ 
		alert("사업자번호 조회 중 오류 발생하였습니다.");
			return;
	}else if (pMethod == "getCertValidate"){ 
		alert("인증서 검증 중 오류 발생하였습니다.");
			return;
	}
} 
</script>
</html>

