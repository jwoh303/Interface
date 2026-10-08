<%--
**********************************************
* 메뉴 : 도안관리>도안관리(동부)>작물보호
* 화면 : 작물보호
* 기능 : 도안관리 내역을 조회하고 확인현황 등을 조회 할 수 있다. 
* 프로그램 ID : PG_06_B_021_00
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-05-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
 
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
	//System.out.println("CheckDate :"+CheckDate);

%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
	<h3>작물보호</h3>
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
			      <th > <select  name="st_date_type"  class="TitSelect" id = "st_date_type" >
					        <option value= "1" >시작일</option>
					        <option value= "2" >마케팅완료일</option>
					        <option value= "3" >문안완료일</option>
					        <option value= "4" >디자인완료일</option>
					        <option value= "5" >최종확인일</option>			              
			            </select>
			      </th>
			      <td colspan="3">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""> - 
                        <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value=""> 
                        <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>	
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>	
						<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>									
					</td>
			      <th>문안</th>
			      <td ><select  name="st_dd_status" id ="st_dd_status">
			              <option value="ALL" >전체</option>
			              <option value="RC" >접수</option>
			              <option value="ED" >완료</option>
			            </select></td>
			    </tr>
			    <tr>
			      <th>품목코드</th>
			      <td ><input type="text" name="st_buyer_item_no"  id="st_buyer_item_no"  style="width:87%" value=""  onKeyUp="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()"></td>
			      <td>디자인</td>
			      <td ><select  name="st_ee_status"  id = "st_ee_status">
			              <option value="ALL" >전체</option>
			              <option value="RC" >접수</option>
			              <option value="ED" >완료</option>
			            </select></td>
			      <th >제품구분</th>
			      <td > <select  id="st_product_flag" name="st_product_flag" >
			              <option value="ALL" >전체</option>
			              <option value="HN" >한농</option>
			              <option value="AG" >아그로텍</option>
			            </select>
			       </td>
 			    </tr>
			    <tr>
			      <th >품목명/규격</th>
			      <td ><input type="text" name="st_desc_spec"  id="st_desc_spec"  style="ime-mode:active;width:87%" value=""  onKeyDown="kepEnter()"></td>
			      <th >최종확인</th>
			      <td ><select  name="st_es_status" id = "st_es_status">
			              <option value="ALL" >전체</option>
			              <option value="RC" >미확인</option>
			              <option value="ED" >확인</option>
			            </select></td>
			      <th >요청공장</th>
			      <td ><select name="st_buyer" id = "st_buyer">
			              <option value="ALL" >전체</option>
			              <option value="KRDONG0110" >동부한농(주)인천공장</option>
			              <option value="KRDONG0107" >동부한농(주)구미공장</option>
			              <option value="KRDONG0128" >동부정밀(주)전주공장</option>
			            </select>
			        </td>
			    </tr>
			    <tr>
			      <th>진행상태</th>
			      <td >
			      		<select name="st_recv_flag" id="st_recv_flag">
			              <option value="ALL" >전체</option>
			              <option value="NW" >등록</option>
			              <option value="IG" >진행중</option>
			              <option value="ED" >종료</option>
			              <option value="GB" >반려</option>
			            </select>
 			      </td>
			    <th></th>
			    <td></td>
			    <th></th>
			    <td></td>
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
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="6%" />
	            <col width="11%" />
	            <col width="11%" />
	            <col width="11%" />
	            <col width="*" />
	            <col width="50" />
	            <col width="40" />
	            <col width="4%" />
	            <col width="4%" />
	            <col width="4%" />
	            <col width="7%" />
	        </colgroup>
	        <thead>
			<tr>
	          <th scope="col" >구분</th>
	          <th scope="col" >품목코드<br>시작일</th>
	          <th scope="col" >마케팅완료일<br>문안완료일</th>
	          <th scope="col" >디자인완료일<br>최종확인일</th>
	          <th scope="col" >품목명 / 규격 / 제조사</th>
			  <th scope="col" >안전마개<br>적용여부</th> 
	          <th scope="col" >KEP<br>완료</th>
	          <th scope="col" colspan="2" >문안<br>접수/완료</th>
	          <th scope="col" colspan="2" >디자인<br>접수/완료</th>
	          <th scope="col" colspan="3" >1차 확인<br>MK/PD/QA</th>
	          <th scope="col" >최종확인</th>
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
          <td rowspan="2"  class="left"> 
            <span style="color:#0046C5"><%=rowData.get("DESCRIPTION")%></span>
            <br>
            <%=rowData.get("SPECIFICATION")%> // <%=rowData.get("MAKER_NAME")%>
          </td>
          <td rowspan="2" align="center">
		  <%
				if( "Y".equals(rowData.get("SAFETY_OPEN_FLAG")) ){
		  %>
			<img src="/resources/images/icon_bl.gif" width="12" height="12">
		  <%
			} else {
		  %> 
			<B>×</B>
		  <%
			}  
		  %>
		  </td>
          <td rowspan="2" align="center">
            <a href="javascript:doPop('buyerMpDsPckpaprDesignManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("MM_STATUS")%>" width="12" height="12"></a>
          </td>
          <td rowspan="2" align="center">
            <a href="javascript:doPop('buyerMpDsPckpaprDesignManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("DD_RECV_STATUS")%>" width="12" height="12"></a>
          </td>
          <td rowspan="2" align="center">
            <a href="javascript:doPop('buyerMpDsPckpaprDesignManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("DD_ED_STATUS")%>" width="12" height="12"></a>
          </td>
          <td rowspan="2" align="center">
            <a href="javascript:doPop('buyerMpDsPckpaprDesignManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("EE_RECV_STATUS")%>" width="12" height="12"></a>
          </td>
          <td rowspan="2" align="center">
            <a href="javascript:doPop('buyerMpDsPckpaprDesignManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("EE_ED_STATUS")%>" width="12" height="12"></a>
          </td>
          <td rowspan="2" align="center">
            <a href="javascript:doPop('buyerMpDsPckpaprDesignManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_MK_STATUS")%>" width="12" height="12"></a>
          </td>
          <td rowspan="2" align="center">
            <a href="javascript:doPop('buyerMpDsPckpaprDesignManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_PD_STATUS")%>" width="12" height="12"></a>
          </td>
          <td rowspan="2" align="center">
            <a href="javascript:doPop('buyerMpDsPckpaprDesignManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_QA_STATUS")%>" width="12" height="12"></a>
          </td>
          <td rowspan="2" align="center">
            <a href="javascript:doPop('buyerMpDsPckpaprDesignManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_FI_STATUS")%>" width="12" height="12"></a>
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
		<p id="paging" class="paging" >
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
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
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
	initSearchCondition("searchForm", "st_product_flag", "${st_product_flag}");	//제품구분
	initSearchCondition("searchForm", "st_desc_spec", "${st_desc_spec}");	//품목명/규격
	initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}");	//품목코드
	initSearchCondition("searchForm", "st_buyer", "${st_buyer}");	//요청공장
	
	initSearchCondition("searchForm", "st_date_type", "${st_date_type}");	//정렬기준
	initSearchCondition("searchForm", "st_order_by", "${st_order_by}");	//정렬순서
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
// 	initSearchCondition("searchForm", "curPage", "${curPage}");	//현재 페이지		
	
}

// function getElName(name){
// 	alert(1)
// 	var sb = new StringBuilder();
// 	sb.Append("${");
// 	sb.Append(name);
// 	sb.Append("}");
// 	return sb.toString();
// // 	return  '"\${'+name+'}"';
// }

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));   
	
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/mpds/excelBuyerMpDsCropProtectList.do";
		document.forms.searchForm.submit();
// 		$('#searchForm').attr("action", "/mpds/excelBuyerMpDsCropProtectList.do").submit();
		break;

	case "cartCheck": // 저장	
		var btnEvent = "cartCheck";
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("이동 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mpds/saveBuyerMpDsCropProtectList.do","processForm",btnEvent); 	
		}
		break;
	
	case "printPum": // 견적서 출력
		alert("견적서 출력");
		break;
	
	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpds/getBuyerMpDsCropProtectList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5,value6) {
	popupSel = str;
	switch (str) {
		case "catalogDetailPop": // 품목코드
			openSearchPopup('/common/catalogDetailPop.do','?BUYER='+value1+'&BUYER_ITEM_NO='+value2, '800,290,no');
			break;
		case "masterMpDsProductPlanViewPop": //생산계획표
			openSearchPopup('/mpds/showMasterMpDsProductPlanViewPop.do','','830,210,no');
			break;
		case "buyerMpDsPckpaprDesignManagePop": // 포장지 도안 관리 상세 (작물보호)
			openSearchPopup('/mpds/showBuyerMpDsPckpaprDesignManagePop.do','?st_plant='+value1+'&st_byca_comorg_code='+value2+'&st_buyer='+value3+'&st_opkg_seq='+value4+'&st_rd_date='+value5+'&st_buyer_item_no='+value6+'&st_open_type=dongbu','720,650,1,1');
			break;			
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerMpDsPckpaprDesignManagePop") {	// 도안관리상세
		doAction('search');	
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


/**
 * ajax 공통 호출후 에러시 처리 함수
 */
 function  kepAjaxError(pMethod , response) {
	 alert("처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요");
 } 

</script>
</html>
