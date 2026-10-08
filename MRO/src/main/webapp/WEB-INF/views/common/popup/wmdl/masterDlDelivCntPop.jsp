<%--
**********************************************
* 메뉴 : wms>배송
* 화면 : 일일배송횟수
* 기능 : 
* 프로그램 ID : 
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-23
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
Map<String,String> _rowData = null;
String countValue = "";
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
	countValue = _rowData.get("CAR_DELIV_CNT");
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>

<script type="text/javascript">
<!--
function init()
{
	document.masterDlDelivCntPop.st_CAR_DELIV_CNT.focus();
}
function kepConfirm()
{  
  $('#masterDlDelivCntPop').attr("action", "/wmdl/saveMasterWmDlIntervalsProgressStatePop.do").submit();    
  var value1 = document.masterDlDelivCntPop.st_CAR_DELIV_CNT.value;
  var value2 = "";
  opener.setPopupReturn(value1,value2);
  this.close();
}

function kepAjaxSuccess(pMethod , response){
	var msg = response.Message;
	if (msg != ""){
		alert(msg);
	}
	
}
 //-->
</script> 
<body onLoad="javascript:init();" >
<form name="masterDlDelivCntPop" id="masterDlDelivCntPop" method=post >
<input type="hidden" name="st_buyer_code" id="st_buyer_code"  value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"") %>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:210px;">
    	<div id="popHeader">
        	<h1 class="title">일일배송횟수입력</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">

			<table class="cont_t_list05" >
                <tr> 
                    <th >일일배송횟수입력</th>
                    <td >
                        <input type="text"  id="st_CAR_DELIV_CNT" name="st_CAR_DELIV_CNT"   value="<%=countValue%>"  size="4"  maxLength="4"  onPropertyChange="javascript:kepNumcheck(this);"  style="text-align:right" />
                    </td>
                </tr>
            </table>
            <table >
                <tr> 
                    <td></td>
                </tr>
            </table>	
           <div class="btnArea ac mt20" style="margin-bottom:0px;"> 
		           	<span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span>
			</div> 	
        </div>
    </div>
    </form>
</body>
</html>
