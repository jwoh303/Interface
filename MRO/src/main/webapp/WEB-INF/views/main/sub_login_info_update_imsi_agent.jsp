<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%><head>
<title>협력사 정보 업데이트</title>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<% 
	String sslurl2 = CommonUtil.getSslURL(request, "https");
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data");
	
	Map<String,String> _rowData = null;
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
	}
%>
<script type="text/javascript">
var popupSel = "";
var popupItem = "";

function doAction(){
	if (checkSubmit()) {
		if (!confirm("사용자 정보를 입력과 같이 업데이트합니다.")) {
			return;
		}else{
			$("#st_mail_recv").val($("input[name=infoDefalut2]:checked").val());
			$("#infoImsiUpdateYn").val("Y"); // 다음 로직을 선택하는 식별자
			$('#loginForm').attr("method", "post");
		    $('#loginForm').attr("action", "<%=sslurl2%>/login/logincertificate.do");
		    $('#loginForm').submit();	
		}
	}
}

 
function checkSubmit() {
	if (isEmpty(kepTrimStr($("#st_user_nm").val()))){
		alert("사용자 이름을 입력 해주십시오");
		$("#st_user_nm").focus();
		return;
	}
	
	if (!checkPhoneNumber("st_user_mobile")) { return; }
	
	if (isEmpty(kepTrimStr($("#st_user_email").val()))){
		alert("사용자 이메일을 입력 해주십시오");
		$("#st_user_email").focus();
		return;
	}

	if (!checkemail("st_user_email")) { return; }
	
	if($("#infoAgreeY").is(":checked") == false && $("#infoAgreeN").is(":checked") == false){
		alert("동의여부를 확인하여 주십시요.");
		return;
	}
	
	return true;
}

function checkPhoneNumber(str) {
	for(var i=2; i <= 3 ; i++){
		if (isEmpty($("#"+str+i).val())) {
			alert("전화번호를 입력하여 주십시오");
			$("#"+str+i).focus();
			return false;
		}

		if (i == 2 && $("#"+str+i).val().length < 3 ) {
			alert("국번을 정확히 입력 해주세요");
			$("#"+str+i).focus();
			return false;

		} else if (i == 3 && $("#"+str+i).val().length != 4 ) {
			alert("전화번호를 정확히 입력 해주세요");
			$("#"+str+i).focus();
			return false;
		}
	}
	return true;
}
</script>
</head>

<style>
body { margin:0;  border:0; overflow:hidden; overflow-x:hidden;font-family:"맑은 고딕"; background-color:#eee}
.wrap{ width:900px; margin:0 auto; margin-top:40px; border:1px solid #d2dae8; background-color:#fff}
.seller_big_tit{ height:70px; line-height:75px; font-weight:bold; font-size:25px; text-align:center; color:#fff; background-color:#0d3c91;letter-spacing:-1px; }
.seller_info_txt{position:relative; margin:30px 40px;font-size:14px;text-align:left; line-height:18px; letter-spacing:-0.5px;  }
.seller_info_txt img{position:absolute; top:100px; right:0px}
.seller_info_box{position:relative; margin:20px 40px; font-size:12px; letter-spacing:-1px; line-height:17px;}
.seller_info_tit01   {position:absolute;width:100px; height:30px; line-height:30px; font-size:16px; font-weight:bold; word-spacing:-4px; text-align:center; color:#fff; background-color:#0d3c91; z-index:1}
.seller_info_tit01BOX{position:relative; top:15px; height:70px;  width:460px; padding:25px 20px 15px 25px; display:table-cell;vertical-align:middle; font-size:15px; line-height:22px; font-weight:bold; background-color:#eaeff8; border-radius:15px;}
.seller_info_tit01BOX span{font-size:12px; font-weight:normal;}
.seller_info_tit02{ font-size:18px; font-weight:bold; margin-top:50px; margin-bottom:5px; word-spacing:-4px;}
table{border-collapse:collapse; width:100%; border-top:2px solid #0d3c91; margin-bottom:10px;  }
table th{ height:35px; padding-left:5px;  border-bottom:1px solid #d2dae8;   color:#fff; background-color:#eaeff8; font-size:14px; color:#273651; letter-spacing:-1px;}
table td{ height:35px; padding-left:5px; border-bottom:1px solid #d2dae8;  font-size:14px; }
input{border:1px solid #d2dae8; padding:4px; font-size:100%}
select{ border:1px solid #d2dae8; padding:4px; font-size:100%}
a{text-decoration:none}
.ok{margin:0 auto; width:200px; height:40px; line-height:40px; background-color:#182a4c; color:#fff;  margin-top:30px; text-align:center; font-size:16px }
.post{cursor:pointer; width:18%; font-weight:bold; word-spacing:-2px; background:#4b4948; color:#fff}
.blue{ color:#034bce; font-weight:bold}
</style>
<body>
<div class="wrap">
	<form id="loginForm"   name="loginForm" method="post">
		<input type = "hidden" id="userId" name = "userId" value="${userId}"/>
		<input type = "hidden" id="password" name = "password"  value="${password}"/>
		<input type = "hidden" id="pageFlag" name = "pageFlag"  value="imsi"/>
		<input type = "hidden" id="infoImsiUpdateYn" name = "infoImsiUpdateYn"  value=""/>
		<input type = "hidden" id="comCode" name = "comCode"  value="<%=CommonUtil.nvl(_rowData.get("COM_CODE"))%>"/>
		<input type = "hidden" id="businessCond" name = "businessCond"  value="<%=CommonUtil.nvl(_rowData.get("BUSINESS_COND"))%>"/>
		<input type = "hidden" id="st_mail_recv" name = "st_mail_recv"  value=""/>
		<div class="seller_big_tit" >코리아이플랫폼 정보 업데이트 안내</div>
		<div class="seller_info_txt">
			안녕하세요. 코리아이플랫폼입니다.<br/><br/>
			회원사와의 원활한 업무소통과 보다 효율적인 주문정보 제공을 위해 사이트 업데이트를 진행합니다.<br/>
			<span class="blue">신규 수주 안내 및 요청 건에 대한 처리정보 등을 알림으로 제공해드릴 예정이오니, 정확한 정보 입력을 부탁 드립니다.</span>
			<img src="/resources/images/main/seller_info_txt.gif" />
	    </div>
	    
    	<div class="seller_info_box">
    		<div class="seller_info_tit01">안&nbsp; &nbsp; 내</div>
            <div class="seller_info_tit01BOX">
    			※ 개선사항 : 수주접수 기능 추가(수주거부 요청, 선입고 건 처리,<br/>
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 거래유형 변경 요청), 기 등록 납품예정일 변경 요청<br/>
    			※ 적용일시 : 2023년 12월 중&nbsp; 
				<span>※ 진행과정에 따라 변경 될 수 있습니다.</span>
			</div>
   			<div class="seller_info_tit02">알림 수신자 정보</div>
			<table>
				<tr>
					<th width="15%">담당자명</th>
              		<td width="35%">
		              	<input type="text" id="st_user_nm" name="st_user_nm" title="" value="" style="width:98%"/>
              		</td>
              		<th width="15%">알림수신여부</th>
              		<td width="35%">
              			<b>
              				<input type="radio" name="infoDefalut2" id="infoAgreeY" value="Y"/>동의 
              				&nbsp; &nbsp; &nbsp;   
             				<input type="radio" name="infoDefalut2" id="infoAgreeN" value="N"/>미동의
             			</b>
              		</td>
          		</tr>
	            
            	<tr>
                	<th>휴대폰번호</th>
                	<td>
						<select id="st_user_mobile1" name="st_user_mobile1" style="width:30%">
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
						</select>
						- 
						<input type="text" id="st_user_mobile2" name="st_user_mobile2" title="" style="width:25%" value="" maxlength="4" onKeyUp="kepNumcheck(this);" onChange="kepNumcheck(this);"/>
						- 
						<input type="text" id="st_user_mobile3" name="st_user_mobile3" title="" style="width:25%" value="" maxlength="4" onKeyUp="kepNumcheck(this);" onChange="kepNumcheck(this);"/>
                	</td>
                	
                	<th>이메일</th>
                	<td>
	                	<input type="text" id="st_user_email" name="st_user_email" title="" style="width:99%" value=""  maxlength="100" onKeyUp="fnCheckInputByte(this, 100);" onChange="fnCheckInputByte(this, 100);"/>
                	</td>
            	</tr>
        	</table>
			문의 : 구매기획팀 박지수 선임 (musenh@koreab2b.com | 02-3016-7251)
      		<div style="margin:0 auto; width:200px;">
      			<a href="javascript:doAction();"><p class="ok">업데이트</p></a>
            </div>
		</div>
	</form>
</div>
</body>
</html>
