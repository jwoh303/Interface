<%--
**********************************************
* 메뉴 : 도안관리>도안관리>작물보호
* 화면 : 작물보호
* 기능 : 관리되는 작물보호 도안목록을 조회한다.
* 프로그램 ID : PG_07_A_013_00
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/kep_common.js"></script>
 
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	// 조회조건 E
	String CheckDate = CommonUtil.addDate(new Date(), "D", 1, 1);

%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>작물보호</h3><br/>
	<c:set var="userId" value="${sessionInfo.userId}"/>
	<c:choose>
		<c:when test="${sessionInfo.userId == 'KEPSE02'}" >
			<a href="/mpiv/showSellerMpIvMkImScheduleRegList.do">제작품/수입품 일정 등록 및 조회</a>
		</c:when>
	</c:choose>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
	                    <col width="8%" />
	                    <col width="25%" />
	                    <col width="8%" />
	                    <col width="25%" />
	                    <col width="8%" />
	                    <col width="25%" />
				</colgroup>
				
				<tbody>
			       <tr>
			          <td   align="right" >
			            <select  name="st_date_type" id="st_date_type"  class="TitSelect">
					        <option value= "1" >시작일</option>
					        <option value= "2" >마케팅완료일</option>
					        <option value= "3" >문안완료일</option>
					        <option value= "4" >디자인완료일</option>
					        <option value= "5" >최종확인일</option>
			            </select>
			          </td>
			          <td  colspan="3"> 
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""> - 
	                        <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value=""> 
	                        <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>	
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>								
						</td>
			          <td >진행상태</td>
			          <td >
			            <select name="st_recv_flag" >
			              <option value="ALL" >전체</option>
			              <option value="IG" >진행중</option>
			              <option value="ED" >종료</option>
			              <option value="GB" >반려</option>
			            </select>
			          </td>
			        </tr>
			        <tr>
			          <td   >문안</td>
			          <td  >
			            <select name="st_dd_status" >
			              <option value="ALL" >전체</option>
			              <option value="RC" >접수</option>
			              <option value="ED" >완료</option>
			            </select>
			          </td>
			          <td  >디자인</td>
			          <td  >
			            <select name="st_ee_status"  >
			              <option value="ALL" >전체</option>
			              <option value="RC" >접수</option>
			              <option value="ED" >완료</option>
			            </select>
			          </td>
			          <td  >최종확인</td>
			          <td >
			            <select name="st_es_status" >
			              <option value="ALL" >전체</option>
			              <option value="RC" >미확인</option>
			              <option value="ED" >확인</option>
			            </select>
			          </td>
			        </tr>
			        <tr>
			          <td  >품목명/규격</td>
			          <td >
			            <input type="text" name="st_desc_spec" id="st_desc_spec"  value=""   style="ime-mode:active;width:87%" value="" onKeyDown="kepEnter()">
			          </td>
			          <td >품목코드</td>
			          <td >
			            <input type="text" name="st_buyer_item_no" id="st_buyer_item_no"  style="width:87%" value=""  onKeyUp="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()">
			          </td>
			          <td >요청공장</td>
			          <td >
			            <select name="st_buyer" >
			              <option value="ALL" >전체</option>
			              <option value="KRDONG0110" >동부한농(주)인천공장</option>
			              <option value="KRDONG0107" >동부한농(주)구미공장</option>
			              <option value="KRDONG0128" >동부정밀(주)전주공장</option>
			            </select>
			          </td>
			        </tr>
				</tbody>
			</table>
		</div>
 
 		<table style="width:100%;">
			<tr>
				<td align="left">
	           		<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			      	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow">
						<option value = "10" >10건</option>
						<option value = "20" >20건</option>
						<option value = "30" >30건</option>
						<option value = "40" >40건</option>
						<option value = "50" >50건</option> 
					</select>
				      <select name="st_order_by" id="st_order_by">
				        <option value= "1" >시작일</option>
				        <option value= "2" >마케팅완료일</option>
				        <option value= "3" >문안완료일</option>
				        <option value= "4" >디자인완료일</option>
				        <option value= "5" >최종확인일</option>
				      </select>
				      기준					
					<img src="/resources/images/icon_w.gif"  align="middle" >미처리 
					<img src="/resources/images/icon_r.gif"  align="middle">처리 
					<img src="/resources/images/icon_y.gif"  align="middle">종료 
					<img src="/resources/images/icon_b.gif"  align="middle">반려 
					<img src="/resources/images/icon_bl.gif" align="middle">안전마개적용&nbsp;
					<span style="color:blue">※</span>날짜에 <span style="color:red">붉은표시</span>는 완료 1일 전입니다.           	
				</td>
		        <td align="right">
					<span class="btn_05"><a href="javascript:doPop('masterMpDsProductPlanViewPop');">생산계획표</a></span>
		        </td>
	   		</tr>
		</table>       	
 		
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />

		<table id="table_list"  class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="6%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="*" />
	            <col width="55" />
	            <col width="6%" />
	            <col width="4%" />
	            <col width="4%" />
	            <col width="4%" />
	            <col width="8%" />
	        </colgroup>
	        <thead>
			<tr>
		          <th  rowspan="2" >구분</th>
		          <th >품목코드<br>시작일</th>
		          <th >마케팅완료일<br>문안완료일</th>
		          <th >디자인완료일<br>최종확인일</th>
		          <th  rowspan="2">품목명//규격//제조사</th>
				  <th  rowspan="2" >안전마개<BR>적용여부</th> 
		          <th >KEP<br>완료</th>
		          <th  colspan="2">문안<br>접수/완료</th>
		          <th  colspan="2">디자인<br>접수/완료</th>
		          <th  colspan="3">1차 확인<br>MK/PD/QA</th>
		          <th  rowspan="2">최종확인</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="15" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 
        <tr align="center" bgcolor="<%=tclass%>"> 
	          <td align="center"><%=rowData.get("USE_TEXT")%></td>
	          <td align="center"><a class="hyperLink"  href="javascript:doPop('catalogDetailPop','<%=rowData.get("BYCA_COMORG_CODE")%>', '<%=rowData.get("BUYER_ITEM_NO")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a></td>
	          <td align="center">
	            <%=(rowData.get("MM_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(rowData.get("MM_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(rowData.get("MM_DATE")))%>
	          </td>
	          <td align="center">
	            <%=(rowData.get("EE_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(rowData.get("EE_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(rowData.get("EE_DATE")))%>
	          </td>
	          <td rowspan="2"  align="center"> 
	            <span style="color:#0046C5"><%=rowData.get("DESCRIPTION")%></span>
	            <br>
	            <%=rowData.get("SPECIFICATION")%> // <%=rowData.get("MAKER_NAME")%>
	          </td>
	          <td rowspan="2" align="center">
			  <%
					if( "Y".equals(rowData.get("SAFETY_OPEN_FLAG")) ){
			  %>
				<img src="/resources/images/icon_bl.gif" width="12" height="12"></a>	
			  <%
				} else {
			  %> 
				<B>×</B>
			  <%
				}  
			  %>
			  </td>
	          <td rowspan="2" align="center">
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignCropProtectManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("MM_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" align="center">
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignCropProtectManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("DD_RECV_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" align="center">
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignCropProtectManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("DD_ED_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" align="center">
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignCropProtectManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("EE_RECV_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" align="center">
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignCropProtectManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("EE_ED_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" align="center">
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignCropProtectManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_MK_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" align="center">
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignCropProtectManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_PD_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" align="center">
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignCropProtectManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_QA_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" align="center">
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignCropProtectManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_FI_STATUS")%>" width="12" height="12"></a>
	          </td>
        </tr>
        <tr align="center" bgcolor="<%=tclass%>"> 
	          <td ><%=rowData.get("GUBUN")%></td>
	          <td ><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
	          <td >
	            <%=(rowData.get("DD_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(rowData.get("DD_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(rowData.get("DD_DATE")))%>
	          </td>
	          <td >
	            <%=(rowData.get("ES_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(rowData.get("ES_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(rowData.get("ES_DATE")))%>
	          </td>
        </tr>
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span>
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
        	<div class="fl">
        		※ MK:마케팅팀, PD:상품개발팀, QA:품질보증팀&nbsp;
			</div>
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
				</span>	
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_from_date", "${st_from_date}");	//시작일(FROM)
	initSearchCondition("searchForm", "st_to_date", "${st_to_date}");	//시작일(TO)
	initSearchCondition("searchForm", "st_recv_flag", "${st_recv_flag}");	//진행상태
	initSearchCondition("searchForm", "st_dd_status", "${st_dd_status}");	//문안
	initSearchCondition("searchForm", "st_ee_status", "${st_ee_status}");	//디자인
	initSearchCondition("searchForm", "st_es_status", "${st_es_status}");	//최종확인
// 	initSearchCondition("searchForm", "st_product_flag", "${st_product_flag}");	//제품구분
	initSearchCondition("searchForm", "st_desc_spec", "${st_desc_spec}");	//품목명/규격
	initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}");	//품목코드
	initSearchCondition("searchForm", "st_buyer", "${st_buyer}");	//요청공장
	
	initSearchCondition("searchForm", "st_date_type", "${st_date_type}");	//정렬기준
	initSearchCondition("searchForm", "st_order_by", "${st_order_by}");	//정렬순서
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위

}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch("1");
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		// 조회일 초기 셋팅
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/mpds/excelSellerMpDscropProtectList.do";
		document.forms.searchForm.submit();
// 		$('#searchForm').attr("action", "/mpds/excelSellerMpDscropProtectList.do").submit();
		break;

	case "cartCheck": // 저장	
		var btnEvent = "cartCheck";
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("이동 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mpds/saveSellerMpDscropProtectList.do","processForm",btnEvent); 	
		}
		break;
	
	case "printPum": // 견적서 출력
		alert("견적서 출력");
		break;
	
	}
}

// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpds/getSellerMpDscropProtectList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5, value6) {
	switch (str) {
		case "catalogDetailPop": // 품목코드
			openSearchPopup('/common/catalogDetailPop.do','?BUYER='+value1+'&BUYER_ITEM_NO='+value2,'800,290,no');
			break;
		case "masterMpDsProductPlanViewPop": //생산계획표
			openSearchPopup('/mpds/showMasterMpDsProductPlanViewPop.do','','830,210,no');
			popupSel = "productPlan";
			break;
		case "sellerMpDsPckpaprDesignCropProtectManagePop": // 포장지 도안 관리 등록 (작물보호)
			openSearchPopup('/mpds/showSellerMpDsPckpaprDesignCropProtectManagePop.do','?st_plant='+value1+'&st_byca_comorg_code='+value2+'&st_buyer='+value3+'&st_opkg_seq='+value4+'&st_rd_date='+value5+'&st_buyer_item_no='+value6+'&st_open_type=agent','720,650,1,1');
			break;			
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	if (popupSel = "dept") {
		$("#st_btoa_user_dept_code").val(code);
		$("#st_btoa_user_dept_name").val(text);
	}
}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;

	var chkGridValue = {
			keys : ["st_status"] ,
			value0 : ["합의완료", "장바구니"],
			msg0 : ["합의완료된 상품들만 장바구니에 담을수 있습니다."]
	};

	var formArr = getFormToArr("document.forms.contentForm",true, chkGridValue );
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}

	return returnValue;
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
}

</script>
</html>
