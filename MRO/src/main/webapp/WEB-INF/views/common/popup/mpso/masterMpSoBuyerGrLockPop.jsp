<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 입고 잠금/해제
* 기능 : 마감기간에 필요 시 사용하며 고객사 시스템의 입고등록/취소 기능을 막음
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2024-12-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Locale"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

String userID = _sessionInfo.getUserId();
String st_buyer_code = CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
String st_buyer_name = CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
String st_close_month = CommonUtil.nvl((String)request.getParameter("st_close_month"));

Calendar _calendar = Calendar.getInstance();
Date _currentDate = new Date();
SimpleDateFormat _formatter = new SimpleDateFormat( "yyyyMMdd", Locale.KOREA );
String _toDay = _formatter.format ( _currentDate ); // 현재일자
_calendar.setTime( _currentDate );        

String[] _closeDate = new String[6];
int[] _closeDay = new int[6];

_calendar.add( Calendar.MONTH, -4 ); // 4개월전
_closeDate[0] = _formatter.format( _calendar.getTime() );
_closeDay[0] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );

String _closeRevisionDate_1 = _closeDate[0].substring(0, 6) + String.valueOf( _closeDay[0] );

_calendar.add( Calendar.MONTH, 1 ); // 3개월전
_closeDate[1] = _formatter.format( _calendar.getTime() );
_closeDay[1] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );

String _closeRevisionDate_2 = _closeDate[1].substring(0, 6) + String.valueOf( _closeDay[1] );

_calendar.add( Calendar.MONTH, 1 ); // 2개월전
_closeDate[2] = _formatter.format( _calendar.getTime() );
_closeDay[2] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );

String _closeRevisionDate_3 = _closeDate[2].substring(0, 6) + String.valueOf( _closeDay[2] );

_calendar.add( Calendar.MONTH, 1 ); // 1개월전
_closeDate[3] = _formatter.format( _calendar.getTime() );
_closeDay[3] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );

String _closeRevisionDate_4 = _closeDate[3].substring(0, 6) + String.valueOf( _closeDay[3] );

_calendar.add( Calendar.MONTH, 1 ); // 현재월
_closeDate[4] = _formatter.format( _calendar.getTime() );
_closeDay[4] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );

String _closeRevisionDate_5 = _closeDate[4].substring(0, 6) + String.valueOf( _closeDay[4] );

_calendar.add( Calendar.MONTH, 1 ); // 현재월+1개월
_closeDate[5] = _formatter.format( _calendar.getTime() );
_closeDay[5] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
%>

<script type="text/javascript">
var popupSel = "";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2)
{ 
	opener.setPopupReturn(value1,value2);
	this.close();
}

//팝업함수호출
function doPop(str,key) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/safetyCompanyCodePop.do", "?COM_TYPE=B&MULTI=Y", "880,450,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if(popupSel == "buyer_single"){	// 고객사
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(kepMultiName(text,"@")); 
	}
}
 
//기능함수
function doAction(str, flag) {
	switch (str) {
		case "search": // 조회
			if(kepIsEmpty("st_buyer_code")==true){
				alert("고객사를 입력하세요.");
				return;
			}
			var st_close_month = $('#st_close_month').val();
			$('#st_sub_close_month').val(st_close_month.substr(0,6));
			$('#st_p_close_month').val(st_close_month.substr(0,6)+"@"); // 조회시 서버에서 리스트화 위하여 구분자 추가
			
			$('#searchForm').attr("action", "/mpso/getMasterMpSoBuyerGrLockPop.do").submit();
			break;
			
		case "reload": // 초기화
			kepReload('searchForm');
			$('#st_buyer_code').val("");
			$('#st_close_month').val("<%=_closeRevisionDate_4%>");
			jspTableClean("table_list","6");
			break;
			
		case "gr_lock": // 입고잠금
			if(kepIsEmpty("st_buyer_code")==true){
				alert("고객사를 입력하세요.");
				return;
			}
			var st_close_month = $('#st_close_month').val();
			$('#st_sub_close_month').val(st_close_month.substr(0,6));
			$('#st_p_close_month').val(st_close_month.substr(0,6)+"@"); // 조회시 서버에서 리스트화 위하여 구분자 추가
			$('#GR_FLAG').val(flag);
			
			if(flag == "Y"){
				if (!confirm('선택된 고객사 모두 선택 마감월로 입고 잠금하시겠습니까?'))
					return;
			}else{
				if (!confirm('선택된 고객사 모두 선택 마감월로 입고 잠금해제하시겠습니까?'))
					return;
			}
			
			kepAjaxPopFormCall("/mpso/updatMasterMpSoBuyerGrLockPop.do","searchForm","gr_lock");
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxPopSuccess(pMethod , response) {
	var sMsg = response.msg;    
	if (pMethod == "gr_lock"){
		alert("저장이 완료되었습니다.");
		doAction("search");
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}

</script> 
<body onload="kep_onload_view();">
<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="st_user_id" name="st_user_id" value="<%=userID%>"/>
	<input type="hidden" id="GR_FLAG" name="GR_FLAG" value=""/>
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:500px;">
    	<div id="popHeader">
    		<h1 class="title">고객사 입고 잠금/해제</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>
            	<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
            </div>
            
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>검색 리스트</caption>
						<colgroup>
							<col width="10%"/>
							<col width="40%"/>
							<col width="10%"/>
                            <col width="40%"/>
						</colgroup>
						<tbody>
							<tr>
								<td><font color="#FF6600">*</font>고객사</td>
								<td>
									<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;" value = "<%=st_buyer_name%>" onclick="javascript:doPop('buyer_single');" READONLY>
									<input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="<%=st_buyer_code%>">
									<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
									<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                            </td>
								<td>마감월</td>						
								<td>
									<span id="grMonth">
										<select id="st_close_month" name="st_close_month" style="width:40%;">
											<option value='<%=_closeRevisionDate_1%>' <%=st_close_month.equals(_closeRevisionDate_1)?"selected":""%>><%=_closeRevisionDate_1.substring(0,4)%>년 <%=_closeRevisionDate_1.substring(4,6)%>월</option>
											<option value='<%=_closeRevisionDate_2%>' <%=st_close_month.equals(_closeRevisionDate_2)?"selected":""%>><%=_closeRevisionDate_2.substring(0,4)%>년 <%=_closeRevisionDate_2.substring(4,6)%>월</option>
											<option value='<%=_closeRevisionDate_3%>' <%=st_close_month.equals(_closeRevisionDate_3)?"selected":""%>><%=_closeRevisionDate_3.substring(0,4)%>년 <%=_closeRevisionDate_3.substring(4,6)%>월</option>
											<option value='<%=_closeRevisionDate_4%>' <%=st_close_month.equals(_closeRevisionDate_4)?"selected":st_close_month.equals("")?"selected":""%>><%=_closeRevisionDate_4.substring(0,4)%>년 <%=_closeRevisionDate_4.substring(4,6)%>월</option>
											<option value='<%=_closeRevisionDate_5%>' <%=st_close_month.equals(_closeRevisionDate_5)?"selected":""%>><%=_closeRevisionDate_5.substring(0,4)%>년 <%=_closeRevisionDate_5.substring(4,6)%>월</option>
										</select>
										<input type="hidden" name="st_sub_close_month" id="st_sub_close_month" value ="">
										<input type="hidden" name="st_p_close_month" id="st_p_close_month" value ="">
									</span>  
	                            </td>
							</tr> 
						</tbody>
				</table>
			</div>
            
            <div id="searchBtnA02">
            	* 고객사 화면의 입고 등록 처리 기능에 한함.(고객사 업무대행 가능)
            	<span class="btn_04"><a href="javascript:doAction('gr_lock', 'Y');">입고잠금</a></span>
            	<span class="btn_04"><a href="javascript:doAction('gr_lock', 'N');">잠금해제</a></span>
            </div>

            <div>
            <!--grid-->
                <table id="table_list" class="cont_t_list02" style="width:100%">
                    <caption>검색 리스트</caption>
                    <colgroup>
						    <col width="20%"/>
						    <col width="*"/>
						    <col width="10%"/>
						    <col width="10%"/>
						    <col width="15%"/>
						    <col width="10%"/>
                    </colgroup>
                    <thead>
                    	<tr>
                    		<th scope="col">고객사코드</th>
                    		<th scope="col">고객사명</th>
                    		<th scope="col">마감월</th>
                    		<th scope="col">입고잠금</th>
                    		<th scope="col">최종변경자</th>
                    		<th scope="col">최종변경일자</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if(_dataList == null || _dataList.size() == 0){
%>
               			<tr bgcolor="#FFFFFF">
                        	<td colspan="6" align="center" height="50px">
                        		<span class="font1">조회된 데이타가 없습니다.</span>
                        	</td>
                        </tr>
						
						
<%
}else{
%>
						<input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>">	
<%
	for (int j=0; j<_dataList.size(); j++) {
		Map<String,String> rowData = _dataList.get(j);
%>
						
                        	<tr>
                        		<td><%=CommonUtil.nvl(rowData.get("BUYER"))%></td>
                        		<td class="left"><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%></td>
								<td><%=CommonUtil.nvl(rowData.get("GR_MONTH"))%></td>
								<td><%=CommonUtil.nvl(rowData.get("LOCK_YN"))%></td>
								<td><%=CommonUtil.nvl(rowData.get("CHANGE_USER_NAME"))%></td>
								<td><%=CommonUtil.nvl(rowData.get("CHANGE_DATE"))%></td>
							</tr>
<%
	}
}
%>
					</table>  	                                  
			</div>
		</div>
	</div>
</div>
</form> 
</body>
</html>