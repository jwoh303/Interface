<%--
**********************************************
* 메뉴 : 
* 화면 : 검사 세부 항목
* 기능 : 해당 제품의 검사 세부항목을 조회할 수 있다.
* 프로그램 ID : PG_07_M_006_03
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-07-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
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

</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	Map<String,String> formData = new HashMap<String,String>();
	
	if (_gridList != null &&  _gridList.size() > 0){
		formData = (Map<String,String>)_gridList.get(0);
	}

%>
<script>
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsInspDetailItemPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	}

}

//팝업함수호출
function doPop(str,value1,value2,value3,value4) {
	popupSel = str;
	switch (str) {
		case "catalogDetailPop":
			openSearchPopup('/common/catalogDetailPop.do','?BUYER='+value1+'&BUYER_ITEM_NO='+value2+'&CONTRACT_NO='+value3+'&CONTRACT_SEQ='+value4,'800,290,no');
			break;
		case "poDetailPop":
			openSearchPopup('/common/mpso/poDetailPop.do','?st_buyer='+value1+'&st_po_no='+value2,'900,550,no');
			break;
		case "agent":
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "catalogDetailPop") {	// 
	
	}else	if (popupSel == "poDetailPop") {	//

	}else	if (popupSel == "agent") {	//
		
	}
	grbRow="";	//초기화
}


//확인
function kepConfirm()
{ 
 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 opener.setPopupReturn(value1,value2);
 
 this.close();
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	


	if (msg != "") {
		alert(msg);
	}
}

</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="st_com_code" id="st_com_code"  value="${sessionInfo.comCode}">
	
	<div id="popWrapper" style="height:710px;">
    	<div id="popHeader">
        	<h1 class="title">검사 세부 항목</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<table class="cont_t_list06" style="width:100%">
					<colgroup>
						<col width="22%" />
						<col width="28%" />
						<col width="24%" />
						<col width="26%" />
					</colgroup>
					<tbody>
				        <tr> 
				          <th  class="right"  height="27"><b>제품코드<br>(검사로트)</b></th>
				          <td><a class="hyperLink" href="javascript:doPop('catalogDetailPop','<%=formData.get("BYCA_COMORG_CODE")%>', '<%=formData.get("BUYER_ITEM_NO")%>','<%=formData.get("CONTRACT_NO")%>', '<%=formData.get("CONTRACT_SEQ")%>');"><%=formData.get("BUYER_ITEM_NO")%></a><br>(<%=formData.get("ITEM_CHECK_NO")%>)<br>
				          </td>
				          <th align="right"><b>발주일자<br>(납기요청일)</b> 
				          </th>
				          <td><%=CommonUtil.formatStrinigDate(formData.get("PO_CREATE_DATE"))%><br> (<%=CommonUtil.formatStrinigDate(formData.get("RD_DATE"))%>)</td>
				        </tr>
				        <tr> 
				          <th class="right"  height="27"><b>입고번호<br>자재문서</b> 
				          </th>
				          <td><%=formData.get("GR_NO")%><br> (<%=formData.get("LEGACY_GR_NO")%>)<br>
				          </td>
				          <th   align="right"><b>입고일자<br>입고수량</b> 
				          </th>
				          <td><%=CommonUtil.formatStrinigDate(formData.get("GR_DATE"))%> <br>(<%=CommonUtil.formatNumber(formData.get("ITEM_QTY"),true,0,3)%> <%=formData.get("UNIT_MEASURE")%>)</td>
				        </tr>
				        <tr> 
				          <th  class="right"  height="27"><b>발주번호<br>구매전표</b> 
				          </th>
				          <td><a class="hyperLink"  href="javascript:doPop('poDetailPop',' ${st_buyer}','<%=formData.get("PO_NO")%>');"><%=formData.get("PO_NO")%></a><br>(<%=formData.get("LEGACY_PO_NO")%>)</td>
				          <th   align="right"><b>협력사</b> 
				          </th>
				          <td><a class="hyperLink"  href="javascript:doPop('agent','<%=formData.get("AGENT")%>');"><%=formData.get("AGENT_TEXT")%></a></td>
				        </tr>
				        <tr> 
				          <th  class="right"  height="27"><b>품목명/규격</b> 
				          </th>
				          <td colspan="3"><%=formData.get("DESCRIPTION")%> / <%=formData.get("SPECIFICATION")%></td>
				        </tr>
				</tbody>
			</table>
	      <table>
	        <tr>
	          <td height="20">
		            <img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>부적합&nbsp;&nbsp;
		            <img src="/resources/images/icon_w.gif" style="padding-top:3px;"/>적합
	         </td>
	        </tr>
	      </table>            
            	<table class="cont_t_list06" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="18%" />
							<col width="12%" />
							<col width="70%" />
						</colgroup>
						<tbody>
				<tr> 
				          <th height="25" colspan="3"><b>검사항목</b></th>
				        </tr>
				        <tr> 
				          <th height="25"><b>항목</b></th>
				          <th><b>유무</b></th>
		                    <th><b>내역</b></th>
				        </tr>
				        <tr> 
				          <th height="25" width="18%"><b>외관</b></th>
				          <td width="12%"><%=(formData.get("APPEAR_VAL").equals(" ") ? "" : "<img src=/resources/images/"+formData.get("APPEAR_VAL")+" width=12 height=12 align=absmiddle border=0>")%></td>
				          <td width="70%"><textarea style="width:100%;border:1px solid #FFFFFF" rows="2" READONLY><%=formData.get("APPEAR_REJT").replace("<br>","\r\n")%></textarea></td>
				        </tr>
				        <tr> 
				          <th height="25"><b>사이즈</b></th>
				          <td><%=(formData.get("SIZE_VAL").equals(" ") ? "" : "<img src=/resources/images/"+formData.get("SIZE_VAL")+" width=12 height=12 align=absmiddle border=0>")%></td>
				          <td><textarea style="width:100%;border:1px solid #FFFFFF" rows="2" READONLY><%=formData.get("SIZE_REJT").replace("<br>","\r\n")%></textarea></td>
				        </tr>
				        <tr> 
				          <th height="25"><b>재질</b></th>
				          <td ><%=(formData.get("MATTER_VAL").equals(" ") ? "" : "<img src=/resources/images/"+formData.get("MATTER_VAL")+" width=12 height=12 align=absmiddle border=0>")%></td>
				          <td><textarea style="width:100%;border:1px solid #FFFFFF" rows="2" READONLY><%=formData.get("MATTER_REJT").replace("<br>","\r\n")%></textarea></td>
				        </tr>
				        <tr> 
				          <th height="25"><b>중량</b></th>
				          <td><%=(formData.get("WEIGHT_VAL").equals(" ") ? "" : "<img src=/resources/images/"+formData.get("WEIGHT_VAL")+" width=12 height=12 align=absmiddle border=0>")%></td>
				          <td><textarea style="width:100%;border:1px solid #FFFFFF" rows="2" READONLY><%=formData.get("WEIGHT_REJT").replace("<br>","\r\n")%></textarea></td>
				        </tr>
				        <tr> 
				          <th height="25"><b>용량</b></th>
				          <td><%=(formData.get("CAPACITY_VAL").equals(" ") ? "" : "<img src=/resources/images/"+formData.get("CAPACITY_VAL")+" width=12 height=12 align=absmiddle border=0>")%></td>
				          <td><textarea style="width:100%;border:1px solid #FFFFFF" rows="2" READONLY><%=formData.get("CAPACITY_REJT").replace("<br>","\r\n")%></textarea></td>
				        </tr>
				        <tr> 
				          <th height="25"><b>두께</b></th>
				          <td><%=(formData.get("DENSITY_VAL").equals(" ") ? "" : "<img src=/resources/images/"+formData.get("DENSITY_VAL")+" width=12 height=12 align=absmiddle border=0>")%></td>
				          <td><textarea style="width:100%;border:1px solid #FFFFFF" rows="2" READONLY><%=formData.get("DENSITY_REJT").replace("<br>","\r\n")%></textarea></td>
				        </tr>
				
				        <tr> 
				          <th height="25"><b>압축강도</b></th>
				          <td><%=(formData.get("COMPRESSION_F").equals(" ") ? "" : "<img src=/resources/images/"+formData.get("COMPRESSION_F")+" width=12 height=12 align=absmiddle border=0>")%></td>
				          <td><textarea style="width:100%;border:1px solid #FFFFFF" rows="2" READONLY><%=formData.get("COMPRESSION_REJT").replace("<br>","\r\n")%></textarea></td>
				        </tr>
				        <tr> 
				          <th height="25"><b>파열강도</b></th>
				          <td><%=(formData.get("DISRUPTION_F").equals(" ") ? "" : "<img src=/resources/images/"+formData.get("DISRUPTION_F")+" width=12 height=12 align=absmiddle border=0>")%></td>
				          <td><textarea style="width:100%;border:1px solid #FFFFFF" rows="2" READONLY><%=formData.get("DISRUPTION_REJT").replace("<br>","\r\n")%></textarea></td>
				        </tr>
				        <tr> 
				          <th height="25"><b>수분</b></th>
				          <td><%=(formData.get("MOISTURE_F").equals(" ") ? "" : "<img src=/resources/images/"+formData.get("MOISTURE_F")+" width=12 height=12 align=absmiddle border=0>")%></td>
				          <td><textarea style="width:100%;border:1px solid #FFFFFF" rows="2" READONLY><%=formData.get("MOISTURE_REJT").replace("<br>","\r\n")%></textarea></td>
				        </tr>
				        <tr> 
				          <th height="25"><b>처리방법</b></th>
				          <td align="left" colspan="2"><%=(formData.get("UD_CODE").equals("R") ? "<font color=#CF2859><b>"+formData.get("UD_TEXT")+"</b></font>" : formData.get("UD_TEXT"))%>(<%=formData.get("UD_CODE")%>)</td>
				        </tr>
				        <tr> 
				          <th height="25"><b>비고</b></th>
				          <td align="left" colspan="2"><textarea style="width:100%;border:1px solid #FFFFFF" rows="2" READONLY><%=formData.get("REMARK").replace("<br>","\r\n")%></textarea></td>
				        </tr>
					</tbody>
				</table>
		</div>	
        
    </div>
</form> 
</body>
</html>
