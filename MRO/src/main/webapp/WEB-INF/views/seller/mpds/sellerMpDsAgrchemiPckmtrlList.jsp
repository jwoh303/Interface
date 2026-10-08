<%--
**********************************************
* 메뉴 : 도안관리>비료 포장 품질평가>농약포장재
* 화면 : 농약포장재
* 기능 : 품질검사진행 목록을 조회한다.
* 프로그램 ID : PG_07_A_011_00
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-08-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
	List<Map<String,String>> _gridListSub = (List<Map<String,String>>) request.getAttribute("dataSub"); // 조회된 결과	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	// 조회조건 E
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
	<h3>농약포장재</h3>
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
			      	<td><select id="st_date_type" name="st_date_type"  class="TitSelect">
			              <option value= "GR">입고일</option>
			              <option value= "PO">주문일</option>
		            </select>
		          	</td>
					<td colspan="3">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""> - 
                        <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value=""> 
                        <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>	
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>								
					</td>
			      <th>결과값</th>
				    <td ><select  id="st_ud_code" name="st_ud_code" >
			              <option value="ALL">전체</option>
			              <option  value="A">가용</option>
			              <option  value="AS">특채</option>
			              <option  value="R">보류</option>
			            </select>
			        </td>
				</tr>
				<tr>
				      <th>검사항목</th>
				      <td ><select  id="st_attr" name="st_attr" >
				              <option value="ALL">전체</option>
				              <option  value="APPEAR">외관 부적합</option>
				              <option  value="SIZE">사이즈 부적합</option>
				              <option  value="MATTER">재질 부적합</option>
				              <option  value="WEIGHT">중량 부적합</option>
				              <option  value="CAPACITY">용량 부적합</option>
				              <option  value="DENSITY">두께 부적합</option>
				              <option  value="COMPRESSION">압축강도 부적합</option>
				              <option  value="DISRUPTION">파열강도 부적합</option>
				              <option  value="MOISTURE">수분 부적합</option>
				            </select>
				    </td>
				     <th>발주번호</th>
				     <td ><input type="text" id="st_po_no"  name="st_po_no" maxlength="20" style="width:87%" value="" onKeyUp="kepToUpper('st_po_no')" onKeyDown="kepEnter()"></td>
					<th>고객사</th>
					<td>
			            <select  id="st_buyer_code" name="st_buyer_code" >
			              <option value="KRKEPB0004">테스트 고객사</option>
			              <option value="KRDONG0107">주식회사 동부한농 구미</option>
			              <option value="KRDONG0110">주식회사 동부한농 인천공장</option>
			              <option value="KRDONG0128">동부정밀화학(주)전주공장</option>
			            </select>
					</td>
				</tr>
				<tr>
			      <th >품목명/규격</th>
			      <td ><input type="text" id="st_desc_spec"  name="st_desc_spec" style="width:87%" value="" onKeyDown="kepEnter()"></td>
			      <th>검사로트</th>
			      <td ><input type="text" id="st_item_check_no"  name="st_item_check_no" style="width:87%" value="" onKeyDown="kepEnter()"></td>
			      <th >제품코드</th>
			      <td ><input type="text" id="st_buyer_item_no"  name="st_buyer_item_no" maxlength="50" style="width:87%" value="" onKeyUp="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()"></td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
			</select>
            <img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>부적합&nbsp;&nbsp;
            <img src="/resources/images/icon_w.gif" style="padding-top:3px;"/>적합
      	</span>
      	<span class="fr">
				<span class="btn_05"><a href="javascript:doPop('masterMpDsItemResultPop');">항목별결과</a></span>
      	</span>          
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
          <tr> 
            <th scope="col"><b>발주번호<br>구매전표</b></th>
            <th scope="col" colspan="2"><b>제품코드<br>검사로트</b></th>
            <th scope="col"><b>입고번호<br>자재문서</b></th>
            <th scope="col"><b>납기요청일<br>입고일자</b></th>
            <th scope="col"><b>입고수량<br>발주일자</b></th>
            <th scope="col" colspan="5"><b>품목명/규격</b></th>
          </tr>
          <tr > 
            <th scope="col" colspan="9"><b>검사항목</b></th>
            <th scope="col" rowspan="2" width="20%"><b>협력사</b><b></b></th>
            <th scope="col" rowspan="2" width="8%"><b>처리방법</b></th>
          </tr>
          <tr > 
            <th scope="col" width="9%"><b>외관</b></th>
            <th scope="col" width="8%"><b>사이즈</b></th>
            <th scope="col" width="8%"><b>재질</b></th>
            <th scope="col" width="9%"><b>중량</b></th>
            <th scope="col" width="9%"><b>용량</b></th>
            <th scope="col" width="8%"><b>두께</b></th>
            <th scope="col" width="7%"><b>압축</b></th>
            <th scope="col" width="7%"><b>파열강도</b></th>
            <th scope="col" width="7%"><b>수분</b></th>
          </tr>
			
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
       <tr > 
          <td ><a class="hyperLink" href="javascript:doPop('getPoDisplayPop','<%=rowData.get("PO_NO")%>');"><%=rowData.get("PO_NO")%></a><br>
            <%=rowData.get("LEGACY_PO_NO")%></td>
          <td colspan="2"><a class="hyperLink" href="javascript:doPop('getBuyerCatalogDisplayPop','<%=rowData.get("BYCA_COMORG_CODE")%>', '<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>', '<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a><br>
            <%=rowData.get("ITEM_CHECK_NO")%></td>
          <td ><%=rowData.get("GR_NO")%><br>
            <%=rowData.get("LEGACY_GR_NO")%></td>
<% if(Integer.parseInt(rowData.get("RD_DATE")) < Integer.parseInt(rowData.get("GR_DATE"))) { %>
          <td ><font color="red"><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%><br>
            <%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE"))%></font></td>
<% }else { %>
          <td ><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%><br>
            <%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE"))%></td>
<% } %>
          <td ><%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%> <%=rowData.get("UNIT_MEASURE")%><br>
            <%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%></td>
          <td class="left" colspan="5"><%=rowData.get("DESCRIPTION")%> / <%=rowData.get("SPECIFICATION")%></td>
        </tr>
        <tr>
          <td ><a class="hyperLink" href="javascript:doPop('setAllRemarkDisplay02','<%=rowData.get("LEGACY_PO_NO")%>','<%=rowData.get("LEGACY_PO_SEQ")%>','<%=rowData.get("PO_NO")%>','<%=rowData.get("PO_SEQ")%>','<%=rowData.get("LEGACY_GR_NO")%>','<%=rowData.get("LEGACY_GR_SEQ")%>','<%=rowData.get("GR_NO")%>','<%=rowData.get("GR_SEQ")%>');"><%=(rowData.get("APPEAR_VAL").equals(" ") ? "" : "<img src=/resources/images/"+rowData.get("APPEAR_VAL")+" width=12 height=12 align=absmiddle border=0>")%></a></td>
          <td class="left"><a class="hyperLink" href="javascript:doPop('setAllRemarkDisplay02','<%=rowData.get("LEGACY_PO_NO")%>','<%=rowData.get("LEGACY_PO_SEQ")%>','<%=rowData.get("PO_NO")%>','<%=rowData.get("PO_SEQ")%>','<%=rowData.get("LEGACY_GR_NO")%>','<%=rowData.get("LEGACY_GR_SEQ")%>','<%=rowData.get("GR_NO")%>','<%=rowData.get("GR_SEQ")%>');"><%=(rowData.get("SIZE_VAL").equals(" ") ? "" : "<img src=/resources/images/"+rowData.get("SIZE_VAL")+" width=12 height=12 align=absmiddle border=0>")%></a></td>
          <td class="left"><a class="hyperLink" href="javascript:doPop('setAllRemarkDisplay02','<%=rowData.get("LEGACY_PO_NO")%>','<%=rowData.get("LEGACY_PO_SEQ")%>','<%=rowData.get("PO_NO")%>','<%=rowData.get("PO_SEQ")%>','<%=rowData.get("LEGACY_GR_NO")%>','<%=rowData.get("LEGACY_GR_SEQ")%>','<%=rowData.get("GR_NO")%>','<%=rowData.get("GR_SEQ")%>');"><%=(rowData.get("MATTER_VAL").equals(" ") ? "" : "<img src=/resources/images/"+rowData.get("MATTER_VAL")+" width=12 height=12 align=absmiddle border=0>")%></a></td>
          <td class="left"><a class="hyperLink" href="javascript:doPop('setAllRemarkDisplay02','<%=rowData.get("LEGACY_PO_NO")%>','<%=rowData.get("LEGACY_PO_SEQ")%>','<%=rowData.get("PO_NO")%>','<%=rowData.get("PO_SEQ")%>','<%=rowData.get("LEGACY_GR_NO")%>','<%=rowData.get("LEGACY_GR_SEQ")%>','<%=rowData.get("GR_NO")%>','<%=rowData.get("GR_SEQ")%>');"><%=(rowData.get("WEIGHT_VAL").equals(" ") ? "" : "<img src=/resources/images/"+rowData.get("WEIGHT_VAL")+" width=12 height=12 align=absmiddle border=0>")%></a></td>
          <td class="left"><a class="hyperLink" href="javascript:doPop('setAllRemarkDisplay02','<%=rowData.get("LEGACY_PO_NO")%>','<%=rowData.get("LEGACY_PO_SEQ")%>','<%=rowData.get("PO_NO")%>','<%=rowData.get("PO_SEQ")%>','<%=rowData.get("LEGACY_GR_NO")%>','<%=rowData.get("LEGACY_GR_SEQ")%>','<%=rowData.get("GR_NO")%>','<%=rowData.get("GR_SEQ")%>');"><%=(rowData.get("CAPACITY_VAL").equals(" ") ? "" : "<img src=/resources/images/"+rowData.get("CAPACITY_VAL")+" width=12 height=12 align=absmiddle border=0>")%></a></td>
          <td class="left"><a class="hyperLink" href="javascript:doPop('setAllRemarkDisplay02','<%=rowData.get("LEGACY_PO_NO")%>','<%=rowData.get("LEGACY_PO_SEQ")%>','<%=rowData.get("PO_NO")%>','<%=rowData.get("PO_SEQ")%>','<%=rowData.get("LEGACY_GR_NO")%>','<%=rowData.get("LEGACY_GR_SEQ")%>','<%=rowData.get("GR_NO")%>','<%=rowData.get("GR_SEQ")%>');"><%=(rowData.get("DENSITY_VAL").equals(" ") ? "" : "<img src=/resources/images/"+rowData.get("DENSITY_VAL")+" width=12 height=12 align=absmiddle border=0>")%></a></td>
          <td class="left"><a class="hyperLink" href="javascript:doPop('setAllRemarkDisplay02','<%=rowData.get("LEGACY_PO_NO")%>','<%=rowData.get("LEGACY_PO_SEQ")%>','<%=rowData.get("PO_NO")%>','<%=rowData.get("PO_SEQ")%>','<%=rowData.get("LEGACY_GR_NO")%>','<%=rowData.get("LEGACY_GR_SEQ")%>','<%=rowData.get("GR_NO")%>','<%=rowData.get("GR_SEQ")%>');"><%=(rowData.get("COMPRESSION_F").equals(" ") ? "" : "<img src=/resources/images/"+rowData.get("COMPRESSION_F")+" width=12 height=12 align=absmiddle border=0>")%></a></td>
          <td class="left"><a class="hyperLink" href="javascript:doPop('setAllRemarkDisplay02','<%=rowData.get("LEGACY_PO_NO")%>','<%=rowData.get("LEGACY_PO_SEQ")%>','<%=rowData.get("PO_NO")%>','<%=rowData.get("PO_SEQ")%>','<%=rowData.get("LEGACY_GR_NO")%>','<%=rowData.get("LEGACY_GR_SEQ")%>','<%=rowData.get("GR_NO")%>','<%=rowData.get("GR_SEQ")%>');"><%=(rowData.get("DISRUPTION_F").equals(" ") ? "" : "<img src=/resources/images/"+rowData.get("DISRUPTION_F")+" width=12 height=12 align=absmiddle border=0>")%></a></td>
          <td class="left"><a class="hyperLink" href="javascript:doPop('setAllRemarkDisplay02','<%=rowData.get("LEGACY_PO_NO")%>','<%=rowData.get("LEGACY_PO_SEQ")%>','<%=rowData.get("PO_NO")%>','<%=rowData.get("PO_SEQ")%>','<%=rowData.get("LEGACY_GR_NO")%>','<%=rowData.get("LEGACY_GR_SEQ")%>','<%=rowData.get("GR_NO")%>','<%=rowData.get("GR_SEQ")%>');"><%=(rowData.get("MOISTURE_F").equals(" ") ? "" : "<img src=/resources/images/"+rowData.get("MOISTURE_F")+" width=12 height=12 align=absmiddle border=0>")%></a></td>
          <td><a class="hyperLink" href="javascript:doPop('getAgentDisplayPop','<%=rowData.get("AGENT")%>');"><%=rowData.get("AGENT_TEXT")%></a></td>
          <td ><%=(rowData.get("UD_CODE").equals("R") ? "<font color=#CF2859><b>"+rowData.get("UD_TEXT")+"</b></font>" : rowData.get("UD_TEXT"))%></td>
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
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
				</span>	
            </div>
        </div>
        
		<!-- 업체별 납기 준수율 -->
		<table class="cont_t_list02" style="width:100%">
	        <tr bgcolor="E7F5FF" align="center">
	          <th rowspan="2" width="15%"><b>제조협력사<br>
	            총 감점 점수</b></th>
	          <th colspan="9"><b>검사항목</b></th>
	          <th rowspan="2" width="7%"><b>납기<br>
	            준수율</b></th>
	          <th rowspan="2" width="6%"><b>보류<br>
	            횟수</th>
	        </tr>
	        <tr bgcolor="E7F5FF" align="center">
	          <th width="8%"><b>외관</b></th>
	          <th width="8%"><b>사이즈</b></th>
	          <th width="8%"><b>재질</b></th>
	          <th width="8%"><b>중량</b></th>
	          <th width="8%"><b>용량</b></th>
	          <th width="8%"><b>두께</b></th>
	          <th width="8%"><b>압축</b></th>
	          <th width="8%"><b>파열강도</b></th>
	          <th width="8%"><b>수분</b></th>
	        </tr>
 		<%
        if (_gridListSub == null || _gridListSub.size() == 0){
        %>
		    <tr>
		      <td colspan="12" align="center" height = "50" bgcolor="#FFFFFF">
		        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="6">
		          <tr>
		            <td></td>
		          </tr>
		        </table>
		        <span >조회된 데이타가 없습니다.</span>
		      </td>
		        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="1" bgcolor="60A7E6">
		          <tr><td></td></tr>
		        </table>
		    </tr>        
		<%
        }else{
			for (int j=0; j<_gridListSub.size(); j++) {
				Map<String,String> rowDataSub = _gridListSub.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";

		String tot = CommonUtil.bnvl(rowDataSub.get("tot"));
		  String APPEAR_VAL = CommonUtil.bnvl(rowDataSub.get("APPEAR_VAL"));
		  String SIZE_VAL = CommonUtil.bnvl(rowDataSub.get("SIZE_VAL"));
		  String MATTER_VAL = CommonUtil.bnvl(rowDataSub.get("MATTER_VAL"));
		  String WEIGHT_VAL = CommonUtil.bnvl(rowDataSub.get("WEIGHT_VAL"));
		  String CAPACITY_VAL = CommonUtil.bnvl(rowDataSub.get("CAPACITY_VAL"));
		  String DENSITY_VAL = CommonUtil.bnvl(rowDataSub.get("DENSITY_VAL"));
		  String COMPRESSION_F = CommonUtil.bnvl(rowDataSub.get("COMPRESSION_F"));
		  String DISRUPTION_F = CommonUtil.bnvl(rowDataSub.get("DISRUPTION_F"));
		  String MOISTURE_F = CommonUtil.bnvl(rowDataSub.get("MOISTURE_F"));
		  String RETRUN = CommonUtil.bnvl(rowDataSub.get("RETRUN"));
			
		  double attr1    = Double.parseDouble(APPEAR_VAL) * 2;
		  double attr2    = Double.parseDouble(SIZE_VAL) * 1;
		  double attr3    = Double.parseDouble(MATTER_VAL) * 1;
		  double attr4    = Double.parseDouble(WEIGHT_VAL) * 1;
		  double attr5    = Double.parseDouble(CAPACITY_VAL) * 1;
		  double attr6    = Double.parseDouble(DENSITY_VAL) * 1;
		  double attr7    = Double.parseDouble(COMPRESSION_F) * 1;
		  double attr8    = Double.parseDouble(DISRUPTION_F) * 1;
		  double attr9    = Double.parseDouble(MOISTURE_F) * 1;
          
		%> 
         <tr bgcolor="ffffff" align="center"> 
          <td height="27"><a href="javascript:getAgentDisplayPop('<%=rowDataSub.get("AGENT")%>');"><%=rowDataSub.get("AGENT_NAME")%></a></td>
          <td ><%=(APPEAR_VAL.equals("0")? "" : APPEAR_VAL)%></td>
          <td ><%=(SIZE_VAL.equals("0")? "" : SIZE_VAL)%></td>
          <td ><%=(MATTER_VAL.equals("0")? "" : MATTER_VAL)%></td>
          <td ><%=(WEIGHT_VAL.equals("0")? "" : WEIGHT_VAL)%></td>
          <td ><%=(CAPACITY_VAL.equals("0")? "" : CAPACITY_VAL)%></td>
          <td ><%=(DENSITY_VAL.equals("0")? "" : DENSITY_VAL)%></td>
          <td ><%=(COMPRESSION_F.equals("0")? "" : COMPRESSION_F)%></td>
          <td ><%=(DISRUPTION_F.equals("0")? "" : DISRUPTION_F)%></td>
          <td ><%=(MOISTURE_F.equals("0")? "" : MOISTURE_F)%></td>
          <td rowspan="2"><%=rowDataSub.get("RATE")%></td>
          <td rowspan="2"><%=(RETRUN.equals("0")? "" : RETRUN)%></td>
        </tr>
        <tr bgcolor="ffffff" align="center"> 
          <td height="27"><b><font color="#FF6600"><%=(tot.equals("0.0")? "" : tot)%></font></b></td>
          <td ><%=(String.valueOf(attr1).equals("0.0")? "" : attr1)%></td>
          <td ><%=(String.valueOf(attr2).equals("0.0")? "" : attr2)%></td>
          <td ><%=(String.valueOf(attr3).equals("0.0")? "" : attr3)%></td>
          <td ><%=(String.valueOf(attr4).equals("0.0")? "" : attr4)%></td>
          <td ><%=(String.valueOf(attr5).equals("0.0")? "" : attr5)%></td>
          <td ><%=(String.valueOf(attr6).equals("0.0")? "" : attr6)%></td>
          <td ><%=(String.valueOf(attr7).equals("0.0")? "" : attr7)%></td>
          <td ><%=(String.valueOf(attr8).equals("0.0")? "" : attr8)%></td>
          <td ><%=(String.valueOf(attr9).equals("0.0")? "" : attr9)%></td>
        </tr>

            <%
        			}
        }
            %>
        </tr>
      </table>            

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
	initSearchCondition("searchForm", "st_date_type", "${st_date_type}");	//
	initSearchCondition("searchForm", "st_ud_code", "${st_ud_code}");	//결과값
	initSearchCondition("searchForm", "st_attr", "${st_attr}");	//검사항목
	initSearchCondition("searchForm", "st_po_no", "${st_po_no}");	//발주번호
	initSearchCondition("searchForm", "st_buyer_code", "${st_buyer_code}");	//고객사
	initSearchCondition("searchForm", "st_desc_spec", "${st_desc_spec}");	//품목명/규격
	initSearchCondition("searchForm", "st_item_check_no", "${st_item_check_no}");	//검사로트
	initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}");	//제품코드
	
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
		kepSearch("-1");
		break;

	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/mpds/excelSellerMpDsAgrchemiPckmtrlList.do";
		document.forms.searchForm.submit();
// 		$('#searchForm').attr("action", "/mpds/excelSellerMpDsAgrchemiPckmtrlList.do").submit();
		break;

	}
}

// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpds/getSellerMpDsAgrchemiPckmtrlList.do").submit();   
}
  
//팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5,value6, value7, value8) {
// 	alert(str+"=="+value1+"=="+ value2+"=="+ value3+"=="+ value4+"=="+ value5+"=="+ value6+"=="+ value7+"=="+ value8);
	popupSel = str;
	switch (str) {
	case "masterMpDsItemResultPop": 
	     var buyer_code = $("#st_buyer_code").val();
         if(buyer_code == "")
         {
            alert("고객사를 선택하여 주십시요.");
            return;
         }
		openSearchPopup('/mpds/showMasterMpDsItemResultPop.do','?st_buyer_code='+buyer_code,'800,440,no');
		break;
	case "getPoDisplayPop": // 발주번호 
		var BUYER = $("#st_buyer_code").val();
		var PO_NO = value1;
		openSearchPopup('/mpiv/getCommonMpIvOrderDetailPop.do','?buyer='+BUYER+'&po_no='+PO_NO,'820,550,no');		
		break;
	case "getBuyerCatalogDisplayPop": // 제품코드 
		var byca_comorg_code = value1;
		var buyerItemNo = value2;
		var contractNo = value3;
		var contractSeq = value4;
		openSearchPopup('/common/catalogDetailPop.do','?BUYER='+byca_comorg_code+'&BUYER_ITEM_NO='+buyerItemNo+'&CONTRACT_NO='+contractNo+'&CONTRACT_SEQ='+contractSeq,'800,290,no');
		break;
	case "setAllRemarkDisplay02": // 검사항목 
		var buyer = $("#st_buyer_code").val();
		var legacy_po_no = value1;
		var legacy_po_seq = value2;
		var po_no = value3;
		var po_seq = value4;
		var legacy_gr_no = value5;
		var legacy_gr_seq = value6;
		var gr_no = value7;
		var gr_seq = value8;
		openSearchPopup('/mpds/getMasterMpDsInspDetailItemPop.do','?st_buyer='+buyer+'&st_legacy_po_no='+legacy_po_no+'&st_legacy_po_seq='+legacy_po_seq+'&st_po_no='+po_no+'&st_po_seq='+po_seq+'&st_legacy_gr_no='+legacy_gr_no+'&st_legacy_gr_seq='+legacy_gr_seq+'&st_gr_no='+gr_no+'&st_gr_seq='+gr_seq,'630,716,no' );
		break;
	case "getAgentDisplayPop": // 협력사
		var agent = value1;
	alert(agent);return;
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,'800,550,no');
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

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
 function  kepAjaxError(pMethod , response) {
	 alert("처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요");
 } 

</script>
</html>
