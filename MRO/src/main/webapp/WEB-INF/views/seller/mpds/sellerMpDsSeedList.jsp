<%--
**********************************************
* 메뉴 : 도안관리>도안관리>종자
* 화면 : 종자
* 기능 : 관리되는 작물보호 도안목록을 조회한다.
* 프로그램 ID : PG_07_A_014_00
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-06-03
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
	<h3>종자</h3>
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
			          <th   align="right" >
			            <select  name="st_date_type"  id="st_date_type"  class="TitSelect">
					        <option value= "1" >시작일</option>
					        <option value= "2" >디자인완료일</option>
					        <option value= "3" >1차컴펌완료일</option>
					        <option value= "4" >최종확인일</option>
			            </select>
			          </th>
			          <td  colspan="3"> 
						<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""> - 
                        <input type="text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value=""> 
                        <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>	
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>								
				      <th >디자인</th>
				      <td ><select name="st_mm_status" >
				              <option value="ALL" selected>전체</option>
				              <option value="N">미완료</option>
				              <option value="ED">완료</option>
				            </select></td>
			        </tr>
			        <tr>
			          <th >품목코드</th>
			          <td  >
			            <input type="text" name="st_buyer_item_no" id="st_buyer_item_no"  style="width:87%" value=""  onKeyUp="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()">
			          </td>
				      <th  >최종확인</th>
				      <td ><select name="st_es_status" >
				              <option value="ALL" selected>전체</option>
				              <option value="RC">미확인</option>
				              <option value="ED">확인</option>
				            </select>
				       </td>
			          <th >진행상태</th>
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
			          <th  >품목명/규격</th>
			          <td  >
			            <input type="text" name="st_desc_spec" id="st_desc_spec"  value=""   style="ime-mode:active;width:87%" value=""  onKeyDown="kepEnter()">
			          </td>
				     	<th >종자구분</th>
				        <td >
								<input type="text" name="st_item_name" id="st_item_name" style="width:62%" value="" readonly onclick="javascript:doPop('masterMpDsSeedKindPop');">
								<input type="hidden" name="st_item_code" id="st_item_code" style="width:80%" value="">
								<a href="javascript:doPop('masterMpDsSeedKindPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_item_code','st_item_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
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
				        <option value= "1">시작일</option>
				        <option value= "2">디자인완료일</option>
						<option value= "3">1차컴펌완료일</option>
				        <option value= "4">최종확인일</option>
				      </select>
				      기준					
					<img src="/resources/images/icon_w.gif"  align="middle" >미처리 
					<img src="/resources/images/icon_r.gif"  align="middle">처리 
					<img src="/resources/images/icon_y.gif"  align="middle">종료 
					<img src="/resources/images/icon_b.gif"  align="middle">반려 
					<span style="color:blue">※</span>날짜에 <span style="color:red">붉은표시</span>는 완료 1일 전입니다.           	
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
	            <col width="11%" />
	            <col width="11%" />
	            <col width="11%" />
	            <col width="*" />
	            <col width="5%" />
	            <col width="5%" />
	            <col width="5%" />
	        </colgroup>
	        <thead>
			<tr>
		          <th>구분</th>
		          <th>품목코드</th>
		          <th>시작일</br>디자인완료일</th>
		          <th>1차컨펌완료일</br>최종확인일</th>
		          <th >품목명 / 규격 / 제조사</th>
		          <th>디자인</br>완료</th>
		          <th colspan="5" >1차 확인</br>PM/문안/사진/가공/영업</th>
		          <th >최종 확인</th>
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
	         <tr  bgcolor="<%=tclass%>"> 
	          <td ><%=rowData.get("USE_TEXT")%></td>
         	  <td align="center" rowspan="2"><a class="hyperLink"  href="javascript:doPop('catalogDetailPop','<%=rowData.get("BYCA_COMORG_CODE")%>', '<%=rowData.get("BUYER_ITEM_NO")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a></td>
	          <td >
				<%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%>
	
	          </td>
	          <td >
	            <%=rowData.get("EE_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(rowData.get("EE_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(rowData.get("EE_DATE"))%>
	          </td>
	          <td rowspan="2" style="text-align:left;line-height:140%" > 
	            <span style="color:#0046C5"><%=rowData.get("DESCRIPTION")%></span>
	            <br>
	            <%=rowData.get("SPECIFICATION")%> // <%=rowData.get("MAKER_NAME")%>
	          </td>
	
	          <td rowspan="2" >
			  
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignSeedBizManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("MM_STATUS")%>" width="12" height="12"></a>
	          </td>
	
	          <td rowspan="2" >
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignSeedBizManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_MK1_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" >
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignSeedBizManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_PD1_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" >
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignSeedBizManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_QA1_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" >
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignSeedBizManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_PD_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" >
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignSeedBizManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_MK_STATUS")%>" width="12" height="12"></a>
	          </td>
	          <td rowspan="2" >
	            <a href="javascript:doPop('sellerMpDsPckpaprDesignSeedBizManagePop','<%=rowData.get("PLANT")%>','<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("OPKG_SEQ")%>','<%=rowData.get("RD_DATE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><img src="/resources/images/<%=rowData.get("ES_FI_STATUS")%>" width="12" height="12"></a>
	          </td>
	        </tr>
	        <tr bgcolor="<%=tclass%>" > 
	          <td><%=rowData.get("GUBUN")%></td>
	          <td>
	            <%=rowData.get("DD_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(rowData.get("DD_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(rowData.get("DD_DATE"))%>
	          </td>
	          <td>
	            <%=rowData.get("ES_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(rowData.get("ES_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(rowData.get("ES_DATE"))%>
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
        		※ PM:마케팅팀 종자PM /문안:마케팅팀 등록 문안 담당/사진: 마케팅팀 사진기획담당 /가공: 가공팀 / 영업 : 영업관리팀&nbsp;
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
	initSearchCondition("searchForm", "st_mm_status", "${st_mm_status}");	//
	initSearchCondition("searchForm", "st_es_status", "${st_es_status}");	//최종확인
	initSearchCondition("searchForm", "st_desc_spec", "${st_desc_spec}");	//품목명/규격
	initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}");	//품목코드
	initSearchCondition("searchForm", "st_item_code", "${st_item_code}");	//종자구분
	
	initSearchCondition("searchForm", "st_date_type", "${st_date_type}");	//정렬기준
	initSearchCondition("searchForm", "st_order_by", "${st_order_by}");	//정렬순서
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch($("#curPage").val());
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
		document.forms.searchForm.action = "/mpds/excelSellerMpDsSeedList.do";
		document.forms.searchForm.submit();
		break;

	}
}

// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpds/getSellerMpDsSeedList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5, value6) {
	popupSel = str;
	switch (str) {
	case "masterMpDsSeedKindPop": //종자구분
		var item_code = document.searchForm.st_item_code.value;
		openSearchPopup('/mpds/showMasterMpDsSeedKindPop.do','?st_item_code='+item_code,'500,330,no');
		break;	
	case "catalogDetailPop": // 품목코드
		openSearchPopup('/common/catalogDetailPop.do','?BUYER='+value1+'&BUYER_ITEM_NO='+value2,'800,290,no');
		break;
	case "sellerMpDsPckpaprDesignSeedBizManagePop": // 포장지 도안 관리 상세 (종자)
		openSearchPopup('/mpds/showSellerMpDsPckpaprDesignSeedBizManagePop.do','?st_plant='+value1+'&st_byca_comorg_code='+value2+'&st_buyer='+value3+'&st_opkg_seq='+value4+'&st_rd_date='+value5+'&st_buyer_item_no='+value6+'&st_open_type=agent','720,650,1,1');
		break;			
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	//alert(popupSel +":::"+code +":::"+text);
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterMpDsSeedKindPop") {	// 종자구분
		document.searchForm.st_item_code.value = code;
		document.searchForm.st_item_name.value = text;
	}
	//팝업 조회후 재조회
	else if (popupSel == "sellerMpDsPckpaprDesignSeedBizManagePop") {	// 도안관리(종자)상세
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

</script>
</html>
