<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<head>
<title>정보제공 동의서</title>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<% 
	String sslurl2 = CommonUtil.getSslURL(request, "https");
	List<Map<String,String>> _dataAreaList = (List<Map<String,String>>) request.getAttribute("dataDelyArea");
%>
<script type="text/javascript">
 
function nextTime(){
	/*
	if($("#infoAgreeY").is(":checked") == false && $("#infoAgreeN").is(":checked") == false){
		alert("동의여부를 확인하여 주십시요.");
		return;
	}
	*/
	//납품가능 지역 데이터 셋팅
	var tmpChoiceArea = "";
	var tot_cnt = $("#st_cmpy_dely_cnt").val();
	var chk_area = "N";
	for(var i = 0; i < tot_cnt; i++){
		var box = eval("document.forms.contentForm.st_dely_area_flag"+i);
		if(box.checked == true){
			tmpChoiceArea += "Y";
			chk_area = "Y";
		}else{
			tmpChoiceArea += "N";
		}
	}
	//납품가능지역 1개 이상 선택.
	if(chk_area =="N"){
		alert('직납 가능지역 1개 이상 선택하여 주십시오');
		return;
	}
	//납품가능지역 데이터 셋팅
	$("#delyArea").val(tmpChoiceArea);
	
	$('#loginForm').attr("method", "post");
    $('#loginForm').attr("action", "<%=sslurl2%>/login/logincertificate.do");
    $('#loginForm').submit();
}

function selectAll(){
	var tot_cnt = $("#st_cmpy_dely_cnt").val();
	
	for(var i = 0; i < tot_cnt; i++){
		var box =  eval("document.forms.contentForm.st_dely_area_flag" + i);
		box.checked = true;
	}
}

function deSelectAll(){
	var tot_cnt = $("#st_cmpy_dely_cnt").val();
	
	for(var i = 0; i < tot_cnt; i++){
		var box =  eval("document.forms.contentForm.st_dely_area_flag" + i);
		box.checked = false;
	}
}

</script>
</head>
<style>
.wrap{font-family:"맑은 고딕"; font-size:16px;}
.info_txt{margin:0 auto; margin-top:80px; padding:20px 10px 20px 10px;width:740px;background-color:#3d414d; color:#fff; border:1px solid #2c303c; letter-spacing:-1.5px; text-align:center; font-size:30px; font-weight:bold;}
.info_box{ margin:0 auto; padding:10px 30px 60px 30px; width:700px; background-color:#fff; text-align:left; border:1px solid #c9c9c9 }
a{text-decoration:none}
body { margin:0;  border:0; background-color:#1b1b1b;  overflow:hidden; overflow-x:hidden;font-family:"맑은 고딕";}
#Popup{ width:100%;margin:0;  border:0;background-color:#fff; }
.red{color:#ee3212;}
.blue{color:#0068e3;}
.close{ height:30px; line-height:30px; text-align:right;font-family:"맑은 고딕"; font-size:12px; color:#FFF; background-color:#1b1b1b}
.close img{ vertical-align:middle; border:0}
.close input{ vertical-align:middle; border:0}
a:link 	  {text-decoration:none; color:#fff;}
a:visited {text-decoration:none; color:#1b1b1b;}
a:active  {text-decoration:none; color:#1b1b1b;}
a:hover   {text-decoration:none; color:#fff;}
table{ border-collapse:collapse; width:99%;border:1px solid #aaaaaa; font-size:14px; clear:both; border-top:#626262 3px solid }
table th{ position:relative; height:30px; background-color:#dcdcdc; text-align:center}
table td{ padding:5px; text-align:left;border:1px solid #aaaaaa}
.allcheck{margin:0 auto; padding:5px; width:100px;   text-align:center; background:#2770ff; font-size:16px; font-weight:bold; border-radius:5px}
.allcheck img{ display:inline-block; vertical-align:top}
.OKBtn{margin:0 auto; padding:10px; width:100px;   text-align:center; background:#2770ff; font-size:16px; font-weight:bold; border-radius:5px}
 </style>
<body style="background-color:#e5e5e5; overflow:auto;">
<div class="wrap">
<form id="loginForm" name="loginForm" method="post">
	<input type = "hidden" id="userId" name = "userId" value="${userId}"/>
	<input type = "hidden" id="password" name = "password"  value="${password}"/>
	<input type = "hidden" id="pageFlag" name = "pageFlag"  value="imsi"/>
	<input type = "hidden" id="delyArea" name = "delyArea"  value=""/>
</form>
<form id="contentForm" name="contentForm" method="post">
	<div class="info_txt">납품 가능 지역 정보 업데이트 안내</div>
    <div class="info_box">
			안녕하십니까 코리아이플랫폼(주) 전략소싱팀 입니다. <br/> <br/>
			당사는 2021년에는 협력사에 견적기회와 매출확대 제공을 위해 현재 등록되어있는 <br/>
			전체 회원사에 대한 <b><u class="blue">납품 가능 지역 정보를 새롭게 업데이트</u></b> 하고자 합니다. <br/> <br/>
			 
			이에 따라, <b class="red">최초 로그인 시 납품 가능 지역 정보 수정을 진행하셔야 하며, <br/>
			해당 정보가 수정되지  않을 경우 다음 단계 진행이 불가능</b> 합니다. <br/> <br/>
			
			납품 가능 지역 정보는 12개 지역이며 직납이 가능한 지역 기준으로 체크 부탁 드립니다. <br/>
			(전국 납품 가능의 경우 전체 지역 체크) <br/>
			체크한 지역은 견적기회 및 매출확대의 기회가 될 수 있습니다. <br/> <br/>
			
			등록된 납품 가능 지역 정보는 직접 수정이 불가하며, 정보 오류로 발생되는 불이익에 대해<br/>
			당사는 책임지지 않으니 정확한 정보로 입력 부탁 드리며, <br/>
			별도의 수정이 필요한 경우 아래 담당자에게 별도 요청 부탁 드립니다.<br/>
			또한, 중량물/부피물/위험물 등의 특수한 물품 납품의 경우 견적 진행 시 별도 협의 바랍니다. <br/> <br/>
			
			
			납품 가능 지역 정보 입력 후 수정이 필요하거나 추가 문의 사항이 있으신 경우 <br/>
			구매기획팀 박지수 선임 (02-3016-7251)에게 연락 바랍니다. <br/> <br/>
			
			감사합니다.<br/><br/>
			
			<b class="red">※ 택배, 물류센터 납품이 아닌 직납 가능지역 체크 바랍니다.</b><br/><br/>
			<table>
            	<tr>
                	<th colspan="6">납품가능지역 체크박스&nbsp;│&nbsp; <a href="javascript:selectAll();"><font color ="blue">전체선택</font></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:deSelectAll();"><font color ="red">전체해제</font></a>&nbsp;</th>
                </tr>
                
                <input type="hidden" id="st_cmpy_dely_cnt" name="st_cmpy_dely_cnt" value="<%=_dataAreaList.size()%>" />
                
                <tr>
                	<%
					for (int j=0; j<_dataAreaList.size(); j++) {
						Map<String,String> rowDataAreaList = _dataAreaList.get(j);
					%>
						<td><input id="st_dely_area_flag<%=j%>" name="st_dely_area_flag<%=j%>" type="checkbox" value="" style="vertical-align:middle"> <%=CommonUtil.nvl(rowDataAreaList.get("TEXT1"))%></td>
						<%if((j > 0) && ((j+1)%6 == 0)){%>
							</tr><tr>
						<%}%>
					<%}%>
                </tr>
            </table><br/>
       		 <a href="javascript:nextTime();"><div class="OKBtn" > 확인</div></a>
    </div>
</form>
</div>
</body>
</html>
