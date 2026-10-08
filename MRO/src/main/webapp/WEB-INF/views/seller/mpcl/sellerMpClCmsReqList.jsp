<%--
**********************************************
* 메뉴 : 카탈로그관리 > 카탈로그정비
* 화면 : 카탈로그정비 -> 이미지 등록 요청
* 기능 : 
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2017-02-24
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
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	int grid_cnt = (_gridList != null )? _gridList.size() : 0;
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 견적일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 견적일(To)
	String pg_row = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
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
	<h3>이미지 등록 요청</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
		<span class="btn_search"><a href="javascript:kepSearch(1);">조회</a></span> 
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
				<col width="12%" />
				<col width="21%" />
				<col width="12%" />
				<col width="21%" />
				<col width="12%" />
				<col width="21%" />
				</colgroup>
				
				<tbody>
				<tr>
					<th>요청일</th>
					<td colspan="3">
						<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="<%=st_from_date%>">
						<a href="javascript:kepCalendar('st_from_date')"></a>
						-
						<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="<%=st_to_date%>">
						<a href="javascript:kepCalendar('st_to_date')"></a>
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
					</td>
					<th>품목코드</th>
					<td> 
                        <input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:90%" onKeyUp="kepToUpper('st_buyer_item_no')" onkeydown="kepEnter()" value="">
                    </td>
				</tr>
				<tr>
					<th>품목명</th>
					<td> 
                        <input type="text" class="input_type_text" id="st_description" name="st_description" style="width:90%" onkeydown="kepEnter()" value="">
                    </td>
					
					<th>규격</th>
					<td width="18%"> 
                        <input type="text" class="input_type_text" id="st_specification"  name="st_specification" style="width:90%" onkeydown="kepEnter()" value="">
                    </td>
                    <th></th><td></td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow">
					<option value = "10" >10건</option>
					<option value = "20" >20건</option>
					<option value = "30" >30건</option>
					<option value = "40" >40건</option>
					<option value = "50" >50건</option> 
				</select>
      	</span>     
       <span class="fr">총건수 <%=total_cnt %></span>
       	<br>
	</form> 
	<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
	<form name = "contentForm" id="contentForm" method = "post"  modelAttribute="uploadForm" enctype="multipart/form-data">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	<input type="hidden" name="st_g_row" id="st_g_row" value="">
		<table id="table_list"  class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="3%" />
	            <col width="8%" />
	            <col width="7%" />
	            <col width="12%" />
	            <col width="*" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="7%" />
	            <col width="7%" />
	            <col width="7%" />
	            <col width="7%" />
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col">
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="javascript:kepCheckAll('<%=grid_cnt %>',document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')">
				</th>
                <th scope="col">요청번호(차수)<br>품목코드</th>
                <th scope="col">상품<br>이미지</th>
                <th scope="col">품목명</th>
                <th scope="col">규격</th>
                <th scope="col">제조사/원산지</th>
                <th scope="col">모델번호</th>
                <th scope="col">단위</th>
                <th scope="col">요청일<br>파일첨부</th>
                <th scope="col">보완요청자<br>요청자연락처</th>
                <th scope="col">KeP비고<br>협력사 비고</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="11" align="center" height = "50"> 
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
					<td class="font1_black1"  align="center">
						<input type="checkbox" id="checkbox<%=j%>" name="checkbox<%=j%>">
						<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
					</td>
					<td title="요청번호/품목코드">
						<input type="hidden" name="st_buyer"     id="st_buyer"      value="<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER")))%>">
						<input type="hidden" name="st_req_no"     id="st_req_no"      value="<%=String.valueOf(CommonUtil.nvl(rowData.get("REQ_NO")))%>">
						<input type="hidden" name="st_revision"     id="st_revision"      value="<%=String.valueOf(CommonUtil.nvl(rowData.get("REVISION")))%>">
						<input type="hidden" name="st_buyer_item_no"     id="st_buyer_item_no"      value="<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%>">
						<input type="hidden" name="st_agent"     id="st_agent"      value="<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT")))%>">
						<input type="hidden" name="st_buyer_item_no"     id="st_buyer_item_no"      value="<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%>">
						<input type="hidden" name="st_maker_part_no_yn"     id="st_maker_part_no_yn"      value="<%=String.valueOf(CommonUtil.nvl(rowData.get("MAKER_PART_YN")))%>">
						<%=String.valueOf(CommonUtil.nvl(rowData.get("REQ_NO_R")))%><br>
						<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%>
					</td>
					<td title="상품이미지">
					<%
						if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
					%>
						<img src="/resources/images/noimage.gif" width="80" height="80" border="0">
					<%
						}else{
					%>
						<a class="hyperLink"  href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>','A');">
							<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0">
						</a>
					<%
						}
					%><br>
				        <input type="hidden" name="st_imgfile_dir"     id="st_imgfile_dir"      value="">
				        <input type="hidden" name="st_imgfile_name"     id="st_imgfile_name"      value="">
			            <a class="hyperLink" href="javascript:doPop('addImgPop','<%=j%>');"><img name="reg_select_img" id="reg_select_img" src="/resources/images/icon2.gif">이미지변경</a>
			            <input type="hidden" name="st_image_key" id="st_image_key" value="">										
					</td>
					<td title="품목명/보완" class="left">
						<%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION_LOC")))%><br>
						<input type="hidden" class="input_type_text" name="st_s_description"  id="st_s_description"  style="width:90%;"  value="" />
					</td>
					<td title="규격/보완" class="left">
						<%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION")))%><br>
						<input type="hidden" class="input_type_text" name="st_s_specification"  id="st_s_specification"  style="width:90%;"  value="" />
					</td>
					<td title="제조사원산지/보완" >
						<%=String.valueOf(CommonUtil.nvl(rowData.get("MAKER_NAME")))%>&nbsp;/&nbsp;<%=String.valueOf(CommonUtil.nvl(rowData.get("ORIGIN_NAME")))%><br>
						<input type="hidden" name="st_s_maker_code" id="st_s_maker_code" value="">
						<input type="hidden"  id="st_s_maker_name" name="st_s_maker_name" class="input_type_text" title="" style="width:55%;" value=""  readonly/>
						<!-- a href="javascript:doPop( 'itmMk', '<%=j%>');"><img src="/resources/images/btn_search03.gif" /></a -->
						<!-- a href="javascript:kepEraser('st_s_maker_code','st_s_maker_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a><br -->
						<input type="hidden" name="st_s_orign_code" id="st_s_origin_code" value="">
						<input type="hidden"  id="st_s_origin_name" name="st_s_origin_name" class="input_type_text" title="" style="width:55%;" value=""  readonly/>
						<!-- a href="javascript:doPop( 'country', '<%=j%>');"><img src="/resources/images/btn_search03.gif" /></a -->
						<!-- a href="javascript:kepEraser('st_s_orign_code','st_s_orign_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a -->
					</td>
					<td title="모델번호/보완" >
						<%=String.valueOf(CommonUtil.nvl(rowData.get("MAKER_PART_NO")))%><br>
						<input type="hidden" class="input_type_text" name=st_s_maker_part_no"  id="st_s_maker_part_no"  style="width:90%;"  value="" />
					</td>
					<td title="단위/단위보완">
						<%=String.valueOf(CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%><br>
						<select name="st_s_unit_measure" id="st_s_unit_measure" style="width:90%;display:none">
							<%= CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo","") %>
						</select>
					</td>
					<td title="MSDS/MSDS보완" style="display: none">
						<%=String.valueOf(CommonUtil.nvl(rowData.get("MSDS_YN")))%><br>
						<select id="select_msds"  name="select_msds" >
							<option value = "N" <%if ("N".equals(rowData.get("S_MSDS_YN"))) {%>selected<%} %>>N</option>
							<option value = "Y" <%if ("Y".equals(rowData.get("S_MSDS_YN"))) {%>selected<%} %>>Y</option>
						</select>
					</td>
					<td title="요청일/이미지등록">
						<%=CommonUtil.formatStrinigDate(rowData.get("REQ_ADD_DATE"))%><br>
			            <a href="javascript:doPop('attachSet',<%=j%>);"><img src="/resources/images/disk_off.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
					</td>
					<td title="요청일/요청자연락처">
						<%=String.valueOf(CommonUtil.nvl(rowData.get("ADD_USER_NAME")))%><br>
						<%=String.valueOf(CommonUtil.nvl(rowData.get("ADD_USER_TEL")))%>
					</td>
					<td title="KeP비고/협력사비고">
						<input type="hidden" name="st_atos_remark" id="st_atos_remark" value="<%=rowData.get("ATOS_REMARK") %>">
						<input type="hidden" name="st_stoa_remark" id="st_stoa_remark" value="<%=rowData.get("STOA_REMARK") %>">
						<%
						      if("".equals(rowData.get("ATOS_REMARK"))) {
						%>
							<img name = "st_atos_remark_img" id="st_atos_remark_img" src="/resources/images/but_icon02.gif" border="0"><br>
						<%
						      }else{
						%>
							<a href="javascript:doPop('remarkAtoS', '<%=j%>');"><img name = "st_atos_remark_img" id="st_atos_remark_img" src="/resources/images/but_icon01.gif" border="0"></a><br>
						<%
						      }
						%>
						<a href="javascript:doPop('remarkStoA', '<%=j%>');"><img name = "st_stoa_remark_img" id="st_stoa_remark_img" src="/resources/images/but_icon02.gif" border="0"></a><br>
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
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<!--  span class="btn_04 mr04>
					<a href="javascript:doAction('reg');">재고등록</a>
				</span-->
				<span class="btn_06 mr04">
					<a href="javascript:doAction('regItem');">품목보완 제출</a>
				</span>
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post"  modelAttribute="uploadForm" enctype="multipart/form-data">
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>
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
var btnEvent="";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var areaOn = "/resources/images/icon.gif";
var areaOff = "/resources/images/icon2.gif";
var gridIndex = 0;
// 최초 화면 함수 
function kep_onload_view(){
	//조회조건 초기화(기존값 재설정)
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	<%if("".equals(st_from_date)){%>
		$("#st_from_date").val(kepToDateAdd("31","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	<%}%>
	initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}");	//
	initSearchCondition("searchForm", "st_description", "${st_description}");	//
	initSearchCondition("searchForm", "st_specification", "${st_specification}");	//
	
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
		jspTableClean("table_list");
		break;
	case "regItem": //품목보완 제출
		reqItem();
		break;
	}
}
//품목보완.
function reqItem(){
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" 목록에 표시된 상품이 없습니다.     ");
        return;
    }
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.checkbox0");
        if(box.checked == true) chk_cnt++;
    }else{
        for(var j = 0; j < tot_cnt; j++){
             var box = eval("document.forms.contentForm.checkbox" + j);
             if(box.checked == true){
                  chk_cnt++;
             }
        }
    }
    if(chk_cnt == "0"){
        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.checkbox0" ); 
            if(box.checked == true){
        		var st_buyer     = document.forms.contentForm.st_buyer.value;
        		var st_req_no     = document.forms.contentForm.st_req_no.value;
        		var st_revision     = document.forms.contentForm.st_revision.value;
        		var st_s_description     = document.forms.contentForm.st_s_description.value;
        		var st_s_specification     = document.forms.contentForm.st_s_specification.value;
        		var st_s_maker_code     = document.forms.contentForm.st_s_maker_code.value;
        		var st_s_maker_name     = document.forms.contentForm.st_s_maker_name.value;
        		var st_s_origin_code     = document.forms.contentForm.st_s_origin_code.value;
        		var st_s_unit_measure     = document.forms.contentForm.st_s_unit_measure.value;
        		var st_imgfile_dir     = document.forms.contentForm.st_imgfile_dir.value;
        		var st_imgfile_name     = document.forms.contentForm.st_imgfile_name.value;
        		var st_stoa_remark     = document.forms.contentForm.st_stoa_remark.value;
        		var st_select_msds     = document.forms.contentForm.select_msds.value;
        		var st_image_key     = document.forms.contentForm.st_image_key.value;
        		//모델번호 추가
        		var st_s_maker_part_no     = document.forms.contentForm.st_s_maker_part_no.value;
        		//모델번호 필수값 체크 Y/N
        		var st_maker_part_no_yn     = document.forms.contentForm.st_maker_part_no_yn.value;
            	//msds 품목은 첨부파일이 필요함.
            	if(st_select_msds =="Y"&&kepIsValueNull(st_image_key)){
            		alert("MSDS 품목은 파일첨부가 필요합니다.");
            		return;
            	}
            	//모델번호 필수값 체크
            	if(st_maker_part_no_yn =="Y"&&kepIsValueNull(st_s_maker_part_no)){
            		alert("해당품목은 모델번호 입력이 필요합니다.");
            		return;
            	}
            	query = st_buyer+"@@" + st_req_no+ "@@" + st_revision +"@@" + st_s_description+ "@@" + st_s_specification +"@@" + st_s_maker_code+"@@" 
            					+ st_s_maker_name+"@@" + st_s_origin_code+"@@" + st_s_unit_measure+"@@" + st_imgfile_dir+"@@" + st_imgfile_name+"@@" + st_stoa_remark+"@@" + st_select_msds+"@@" + st_image_key+"@@" +st_s_maker_part_no;
            }
        }else{
        	for(var i = 0; i <tot_cnt; i++){
        		var box = eval("document.forms.contentForm.checkbox" + i);
        		if(box.checked == true){
            		var st_buyer     = document.forms.contentForm.st_buyer[i].value;
            		var st_req_no     = document.forms.contentForm.st_req_no[i].value;
            		var st_revision     = document.forms.contentForm.st_revision[i].value;
            		var st_s_description     = document.forms.contentForm.st_s_description[i].value;
            		var st_s_specification     = document.forms.contentForm.st_s_specification[i].value;
            		var st_s_maker_code     = document.forms.contentForm.st_s_maker_code[i].value;
            		var st_s_maker_name     = document.forms.contentForm.st_s_maker_name[i].value;
            		var st_s_origin_code     = document.forms.contentForm.st_s_origin_code[i].value;
            		var st_s_unit_measure     = document.forms.contentForm.st_s_unit_measure[i].value;
            		var st_imgfile_dir     = document.forms.contentForm.st_imgfile_dir[i].value;
            		var st_imgfile_name     = document.forms.contentForm.st_imgfile_name[i].value;
            		var st_stoa_remark     = document.forms.contentForm.st_stoa_remark[i].value;
            		var st_select_msds     = document.forms.contentForm.select_msds[i].value;
            		var st_image_key     = document.forms.contentForm.st_image_key[i].value;
            		//모델번호 추가
            		var st_s_maker_part_no     = document.forms.contentForm.st_s_maker_part_no[i].value;
            		//모델번호 필수값 체크 Y/N
            		var st_maker_part_no_yn     = document.forms.contentForm.st_maker_part_no_yn[i].value;
                	//msds 품목은 첨부파일이 필요함.
                	if(st_select_msds =="Y"&&kepIsValueNull(st_image_key)){
                		alert("MSDS 품목은 파일첨부가 필요합니다.");
                		return false;
                	}
                	//모델번호 필수값 체크
                	if(st_maker_part_no_yn =="Y"&&kepIsValueNull(st_s_maker_part_no)){
                		alert("해당품목은 모델번호 입력이 필요합니다.");
                		return;
                	}
                	query = st_buyer+"@@" + st_req_no+ "@@" + st_revision +"@@" + st_s_description+ "@@" + st_s_specification +"@@" + st_s_maker_code+"@@" 
                					+ st_s_maker_name+"@@" + st_s_origin_code+"@@" + st_s_unit_measure+"@@" + st_imgfile_dir+"@@" + st_imgfile_name+"@@" + st_stoa_remark+"@@" + st_select_msds+"@@" + st_image_key+"@@" +st_s_maker_part_no;
                	query += "|";
        		}
        	}
        }
        document.forms.processForm.st_query2.value = query;
        
        kepAjaxFormCall("/mpcl/saveSellerMpClCmsCmplReqItem.do","processForm","REQ_ITEM");
    }

 	
}
// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpcl/getSellerMpClCmsCmplReqList.do").submit();   
}
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	gridIndex = value1;
	switch (str) {
		case "itmMk":
			popupSel = "itmMk";
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;	
		case "sellerMpClGoodsDetailInfoPop": // 품목정보상세
			popupSel = "sellerMpClGoodsDetailInfoPop";
			openSearchPopup("/mpcl/getSellerMpClGoodsDetailInfoPop.do", '?st_byit_comorg_code='+value1+'&st_item_no='+value2+'&st_contract_no='+value3+'&st_contract_seq='+value4+'&st_com_type=S', "850,330,no");
			break;
		case "country":
			popupSel = "country";
			openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
			break;
		case "addImgPop":
			popupSel = "addImgPop";
			var st_buyer = $("input[name=st_buyer]").eq(gridIndex).val();
			var st_agent = $("input[name=st_agent]").eq(gridIndex).val();
			var st_buyer_item_no = $("input[name=st_buyer_item_no]").eq(gridIndex).val();
			var st_imgfile_dir = $("input[name=st_imgfile_dir]").eq(gridIndex).val();
			var st_imgfile_name = $("input[name=st_imgfile_name]").eq(gridIndex).val();
			var mod_yn = "Y"; //수정여부
			var st_type = "S"; //협력사일경우
			openSearchPopup("/common/addImagePop.do", '?st_buyer='+st_buyer+'&st_agent='+st_agent+'&st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
			break;
		case "remarkAtoS": // KeP 비고
			popupSel = "remarkAtoS";
			var remark = $("input[name=st_atos_remark]").eq(gridIndex).val();
			openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+remark+"&st_gubun=KEP", "500,230,no");
			break;
		case "remarkStoA": // 비고
			popupSel = "remarkStoA";
			var remark = $("input[name=st_stoa_remark]").eq(gridIndex).val();
			openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+remark, "500,230,no");
			break;
		case "attachSet"://파일 첨부(등록)
			popupSel = "attachSet";
			var type="RFQ";
			var viewType="VI";
			var image_key =  $("input[name=st_image_key]").eq(gridIndex).val();
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
			break;
	}
	
	
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, value1, value2){
	var tot_cnt  =  $("#display_item_cnt").val();
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "itmMk") {	// 제조사.
		 if(eval(tot_cnt) < 2){
			 document.forms.contentForm.st_s_maker_code.value = code;
			 document.forms.contentForm.st_s_maker_name.value = text;
			 document.forms.contentForm.st_s_origin_code.value = value1;
			 document.forms.contentForm.st_s_origin_name.value = value2;
		 }else{
			 document.forms.contentForm.st_s_maker_code[gridIndex].value = code;
			 document.forms.contentForm.st_s_maker_name[gridIndex].value = text;
			 document.forms.contentForm.st_s_origin_code[gridIndex].value = value1;
			 document.forms.contentForm.st_s_origin_name[gridIndex].value = value2;
		 }
	}else if(popupSel =="country"){
		 if(eval(tot_cnt) < 2){
			 document.forms.contentForm.st_s_origin_code.value = code;
			 document.forms.contentForm.st_s_origin_name.value = value1;
		 }else{
			 document.forms.contentForm.st_s_origin_code[gridIndex].value = code;
			 document.forms.contentForm.st_s_origin_name[gridIndex].value = value1;
		 }
	}else if(popupSel == "addImgPop") {	// 이미지첨부
		$("input[name=st_imgfile_dir]").eq(gridIndex).val(code);
		$("input[name=st_imgfile_name]").eq(gridIndex).val(text);
		if(code ==""){
			$("img[id=reg_select_img]").eq(gridIndex).attr("src", areaOff);
		}else{
	 		$("img[id=reg_select_img]").eq(gridIndex).attr("src", areaOn);
	 	}
	}else if(popupSel == "remarkStoA") {	// 이미지첨부
		$("input[name=st_stoa_remark]").eq(gridIndex).val(code);
	 	 if(code ==""){
		 	$("img[id=st_stoa_remark_img]").eq(gridIndex).attr("src",remarkOff);
		 }else{
		 	$("img[id=st_stoa_remark_img]").eq(gridIndex).attr("src",remarkOn);
		  }
	} else if(popupSel == "attachSet") {	//파일 첨부
		 $("input[name=st_image_key]").eq(gridIndex).val(code);
	 	 if(code ==""){
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOff);
	 	 }else{
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOn);
	 	 }
	}

}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if (msg != ""){
		alert("품목보완 요청이 완료 되었습니다.");
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
}
/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
} 


</script>
</html>
