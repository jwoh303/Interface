<%--
**********************************************
* 메뉴 : 표준카탈로그조회 팝업
* 화면 : 표준카탈로그조회
* 기능 :
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
</head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<%
// 공통
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String total_cnt =CommonUtil.nvl((String)request.getAttribute("totalCnt"),"0"); // 조회된 결과

String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

String st_maker_nm = CommonUtil.nvl((String) request.getParameter("st_maker_nm"),"");
String st_category_path = CommonUtil.nvl((String) request.getParameter("st_category_path"),""); 
String st_categ_id = CommonUtil.nvl((String) request.getParameter("st_categ_id"),""); 
String st_mast_check = CommonUtil.nvl((String) request.getParameter("st_mast_check"),"");
String st_categ_name = CommonUtil.nvl((String) request.getParameter("st_categ_name"),"");
String st_sg_nm = CommonUtil.nvl((String) request.getParameter("st_sg_nm"),""); 
String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");
String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");
String st_status = CommonUtil.nvl((String) request.getParameter("st_status"),"");

String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");
String st_cms_catalgid = CommonUtil.nvl((String) request.getParameter("st_cms_catalgid"),"");
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String st_catalg_yn = CommonUtil.nvl((String) request.getParameter("st_catalg_yn"),"");
String st_model_info = CommonUtil.nvl((String) request.getParameter("st_model_info"),"");
String st_remark = CommonUtil.nvl((String) request.getParameter("st_remark"),"");
String st_catlg_id = CommonUtil.nvl((String) request.getParameter("st_catlg_id"),"");
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");
String st_item_gubun = CommonUtil.nvl((String) request.getParameter("st_item_gubun"),"");
String st_stnd_flag = CommonUtil.nvl((String) request.getParameter("st_stnd_flag"),"");
String st_add_user_id = CommonUtil.nvl((String) request.getParameter("st_add_user_id"),"");
String st_row_no = CommonUtil.nvl((String) request.getParameter("st_row_no"),"");

SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String SessionDept = "";

if (sessionInfo != null){ 
	SessionDept = sessionInfo.getDepartment();
}

boolean list = true;
 if (_gridList == null || _gridList.size() == 0){
	 list = false;
 }
%>

<script>
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_add_user_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL',"<%=st_add_user_id%>"); // 조회조건 : 담당자
	
}

//기능함수
function doAction(str) {
	switch (str) {
		case "search": //조회
			kepSearch(1);
			break;
		case "reg": //표준카탈로그등록
			openSearchPopup("/mprq/showMasterMpRqStndCatalgRegPop.do", "", "920,350,no");
			break;
	}
}
//조회
function kepSearch(curPage){
	
	var st_maker_nm = TrimCommon($("#st_maker_nm").val());
	var st_categ_id = TrimCommon($("#st_categ_id").val());
	var st_mast_check = TrimCommon($("#st_mast_check").val());
	var st_sg_nm = TrimCommon($("#st_sg_nm").val());
	var st_description = TrimCommon($("#st_description").val());
	var st_specification = TrimCommon($("#st_specification").val());
	var st_model_info = TrimCommon($("#st_model_info").val());
	var st_remark = TrimCommon($("#st_remark").val());
	var st_catlg_id = TrimCommon($("#st_catlg_id").val());
	var st_add_user_id = TrimCommon($("#st_add_user_id").val());
	
	if(st_maker_nm == "" && st_categ_id == "" && st_mast_check == "" && st_sg_nm == "" && st_description == "" && st_specification == "" && st_model_info== ""&&st_remark==""&&st_catlg_id==""&&st_add_user_id==""){
		alert("최소 한가지의 검색조건은 입력하여 주십시요");
		return;
	}
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdcm/getStndCaltlgListPop.do").submit();
}
//팝업 함수호출
var gridIndex = 0;
var grbRow = "";
var popupSel = "";
var opener_row_no = "<%=st_row_no%>";

function doPop(str,idx,value1, value2, value3, value4, value5) {
	popupSel = str;
	gridIndex =idx;
	switch (str) {
		case "masterMpRqKepStndrdCategorySelPop": // 표준카테고리
			popupSel = "masterMpRqKepStndrdCategorySelPop";
			openSearchPopup("/mprq/showMasterMpRqKepStndrdCategorySelPop.do", "", "721,670,no");
			break;
		case "masterMdCmGoodsInfoDetailPop": //매핑조회
			var st_cms_categ_id = value1;
			var st_cms_catlg_id = value2;
			openSearchPopup("/mdcm/showMasterMdCmGoodsInfoDetailPop.do", '?st_cms_categ_id='+st_cms_categ_id+'&st_cms_catlg_id='+st_cms_catlg_id, "800,700,no");// 품목정보 상세보기
			break;
		case "masterMdCmStndrdCatalogDetailViewPop": //MASTER코드 선택
			var stndCatalId = value1;
			openSearchPopup("/mdcm/getMasterMdCmStndrdCatalogDetailPop.do", '?st_cms_catlg_id='+stndCatalId, "730,560,no");
			break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5){
	if (popupSel == "masterMpRqKepStndrdCategorySelPop") {	//KEP 표준카테고리 선택
		$("#st_categ_id").val(value3);
		$("#st_category_path").val(value4);
		$("#st_categ_name").val(value5);
	}
}
function setReturn(value1,value2, value3, value4, value5)
{
	/*
		ST_TYPE
		1. REQ: 카탈로그 매핑관리 화면에서 표준카탈로그 조회 팝업 호출
		그외. 견적관련.
	*/
//품목구분이 삼성전자용이면 매핑 불가능 처리
 if(value5 == "B"){
	 alert("품목구분이 삼성전용건은 매핑 불가능 합니다.");
	 return;	 
 }
//미표준화건 매핑 불가능.
 if(value2 =="N"){
	 alert("미표준화건은 매핑 불가능 합니다.\n 구매기획파트 이정은 사원에게 문의 바랍니다.(02-3016-7238)");
	 return;
 }
 var st_type = document.forms.searchForm.st_type.value; 
  if(st_type =="REQ" ){
	  opener.setPopupReturn(value1, value3, value4);
	  this.close();	  
  }else if(st_type == "CATLG_REG"){
	  opener.setPopupReturn(value1, opener_row_no, 'OFFCATE');
	  this.close();
  }else{
	  document.forms.searchForm.st_cms_catalgid.value = value1;
	  document.forms.searchForm.st_imgfile_dir.value = value3;
	  document.forms.searchForm.st_imgfile_name.value = value4;
	  kepAjaxFormCall("/mprq/saveMasterMpRqStndCatalgListPop.do","searchForm","SAVE");
  }
}

function goToRcmdPop(){
	  opener.setPopupReturn("rcmd", opener_row_no);
	  this.close();	
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	  opener.setPopupReturn(document.forms.searchForm.st_cms_catalgid.value, opener_row_no, 'OFFCATE');
	  
	  this.close();	
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
} 

function setImageView(img_dr,img_name,gbn){

	window.open('<%= CommonUtil.getURL(request) %>'+img_dr+ img_name,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');
	
}
</script>

<body onload="kep_onload_view()">
<form name = "searchForm" id="searchForm" method = "post">
	<div id="popWrapper" style="height:504px;">
    	<div id="popHeader">
        	<h1 class="title">표준카탈로그 조회 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div class="fr">
            	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>  
            </div>
            <br>
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
            	<input type="hidden" name="st_status" id="st_status" value="C" />
            	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>"  />
				<input type="hidden" name="st_quotation_no" id="st_quotation_no" value="<%=st_quotation_no%>"  />
				<input type="hidden" name="st_quotation_seq" id="st_quotation_seq" value="<%=st_quotation_seq%>"  />
				<input type="hidden" name="st_revision" id="st_revision" value="<%=st_revision%>"  />
				<input type="hidden" name="st_cms_catalgid" id="st_cms_catalgid" value="<%=st_cms_catalgid%>"  />
				<input type="hidden" name="st_catalg_yn" id="st_catalg_yn" value="<%=st_catalg_yn%>"  />
				<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="<%=st_buyer_item_no%>"  />
				<input type="hidden" name="st_type" id="st_type" value="<%=st_type%>"  />
				<input type="hidden" name="st_imgfile_dir" id="st_imgfile_dir" value=""  />
				<input type="hidden" name="st_imgfile_name" id="st_imgfile_name" value=""  />
				<input type="hidden" name="st_row_no" id="st_row_no" value="<%=st_row_no%>"  />
				<input type="hidden" name="CATALOG_CHOICE_TYPE" id="CATALOG_CHOICE_TYPE" value="OFFCATE"  />
            	<table class="cont_t_list01" style="width:100%">
						<caption>표준카탈로그 조회</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
                            <col width="15%" />
                            <col width="35%" />
						</colgroup>
						<tbody>
						<tr>
							<td>제조사명</td>
							<td> 
								<input type="text"   class="input_type_text" name="st_maker_nm" id="st_maker_nm" value="<%=st_maker_nm%>" style="width:87%" value="" onKeyDown="kepEnter()">
                            </td>
						    <td>표준카테고리</td>						 
							<td> 
								<input type="text" id="st_category_path" name="st_category_path" maxlength="25"  value = "<%=st_category_path%>"  class="input_type_text"  readonly style="width:65%">
								<a href="javascript:doPop('masterMpRqKepStndrdCategorySelPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_categ_id','st_category_path');"><img src="/resources/images/btn_eraser2.gif"></a>
								<input type="hidden" id="st_categ_id" name="st_categ_id" value = "<%=st_categ_id%>">
              					<input type="hidden" id="st_mast_check" name="st_mast_check" value = "<%=st_mast_check%>"> 
							</td>
						</tr>
						<tr>
							<td>SG명</td>						 
							<td> 
								<input type="text" class="input_type_text" id="st_sg_nm" name="st_sg_nm" value="<%=st_sg_nm %>"  style="width:87%"  value="" onkeydown="kepEnter()"> 
							</td>
							<td>품목명</td>
							<td>
								<input type="text"   class="input_type_text" name="st_description" id="st_description" value="<%=st_description %>"  style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
						</tr>
						<tr>
							<td>규격</td>						 
							<td> 
								<input type="text"   class="input_type_text" name="st_specification" id="st_specification" value="<%=st_specification %>"  style="width:87%" value="" onKeyDown="kepEnter()"> 
							</td>
							<td>모델정보</td>
							<td>
								<input type="text" class="input_type_text" id="st_model_info" name="st_model_info" value="<%=st_model_info %>"  style="width:87%"  value=""  onkeydown="kepEnter()">
							</td>
						</tr>
						<tr>
							<td>비고</td>						 
							<td> 
								<input type="text"   class="input_type_text" name="st_remark" id="st_remark" value="<%=st_remark %>"  style="width:87%" value="" onKeyDown="kepEnter()"> 
							</td>
							<td>카탈로그코드</td>
							<td>
								<input type="text"   class="input_type_text" name="st_catlg_id" id="st_catlg_id" value="<%=st_catlg_id %>"  style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
						</tr>
						<tr>
							<td>품목구분</td>						 
							<td> 
								<select name="st_item_gubun" id="st_item_gubun" style="width:87%">
									<%= CommonUtil.getCode3ComboList("", "ALL", "M118","", "ICOMCOD1",st_item_gubun, "") %>           
						         </select> 
							</td>
							<td>표준화여부</td>
							<td>
								<select name="st_stnd_flag" id="st_stnd_flag" style="width:87%">
									<option value="Y" <%if(st_stnd_flag.equals("Y")) {%>selected<%}%>>Y</option>
									<option value="N" <%if(st_stnd_flag.equals("N")) {%>selected<%}%>>N</option>
						         </select>
							</td>
						</tr>
						<tr>
							<td>등록자</td>						 
							<td> 
								<select id="st_add_user_id" name="st_add_user_id" style="width:87%;height:20px"></select>
							</td>
							<td></td>
							<td>
							</td>
						</tr>
					</tbody>
				</table>
            </div>       
			<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="javascript:kepSearch(1);"> 
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "15" <%if ("15".equals(onepagerow)) {%>selected<%} %>>15건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
				<option value = "25" <%if ("25".equals(onepagerow)) {%>selected<%} %>>25건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100건</option> 
			</select>	
     		</span>
       		<table  class="cont_t_list02"  style="width:100%; margin-bottom:0px;">
			<colgroup>
				<col width="10%" />
	            <col width="14%" />
	            <col width="18%" />
	            <col width="*" />
	            <col width="14%" />
	            <col width="10%" />
	            <col width="8%" />
	            <col width="8%" />
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col"></th>
                <th scope="col">표준카탈로그코드<br>품목구분</th>
                <th scope="col">품목명(영문)<br>규격</th>
                <th scope="col">카테고리<br>등록자/표준화여부</th>
                <th scope="col">모델정보<br>비고</th>
                <th scope="col">제조사<br>원산지</th>
                <th scope="col">단위<br>SG</th>
                <th scope="col">매핑개수<br>매핑정보</th>
			</tr>
			</thead>
		</table>     
		<div style="min-height:394; height:365px; padding-bottom:10px; margin-bottom:10px; overflow-y:auto;">
		<table  class="cont_t_list02" style="width:100%; border-top:0px solid #6a98b5">
        <caption>표준 카탈로그 조회</caption>
			<colgroup>
				<col width="10%" />
	            <col width="14%" />
	            <col width="18%" />
	            <col width="*" />
	            <col width="14%" />
	            <col width="10%" />
	            <col width="8%" />
	            <col width="8%" />
	        </colgroup>
		<tbody>
<%
if (list == false){
%>
                    <tr>
                        <td colspan="5" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%
}else{
	Map<String,String> rowData = null;
	for (int j=0; j<_gridList.size(); j++) {
		rowData = _gridList.get(j);
		String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
%> 
				<tr align="center" bgcolor="<%=tclass%>">
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
					%>										
					</td>             
                    <td class="left" title="표준카탈로그코드/품목구분">
                    	<input type="hidden" name="st_cms_categ_id"  id="st_cms_categ_id"  value="<%=CommonUtil.nvl(rowData.get("CMS_CATEG_ID"))%>">
                    	<input type="hidden" name="st_cms_catalg_id" id="st_cms_catalg_id"  value="<%=CommonUtil.nvl(rowData.get("CMS_CATLG_ID"))%>">
                    	<a class="hyperLink" href="javascript:setReturn('<%=CommonUtil.nvl(rowData.get("CMS_CATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STD_FLAG"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>','<%=CommonUtil.nvl(rowData.get("ITEM_GUBUN"))%>');"><%=CommonUtil.nvl(rowData.get("CMS_CATLG_ID"))%></a>
                    	<a href="javascript:doPop('masterMdCmStndrdCatalogDetailViewPop',<%=j %>,'<%=CommonUtil.nvl(rowData.get("CMS_CATLG_ID"))%>');"><img src="/resources/images/btn_search03.gif"></a><br>
                    	<%=CommonUtil.nvl(rowData.get("ITEM_GUBUN_TEXT"))%>
                    </td>          
                   <td class="left" title="품명/규격">
				   		<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%>(<%=CommonUtil.nvl(rowData.get("DESCRIPTION_ENG"))%>) <br>
				   		<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
				   </td>
                   <td class="left" title="카테고리/표준화여부">
                   		<%=CommonUtil.nvl(rowData.get("CATEG_PATH"))%><br>
                   		<%=CommonUtil.nvl(rowData.get("ADD_USER_NAME"))%>/<%=CommonUtil.nvl(rowData.get("STD_FLAG"))%>
				   </td>            
                   <td class="left" title="모델정보/비고">
                   		<%=CommonUtil.nvl(rowData.get("MODEL_INFO"))%><br>
                   		<%=CommonUtil.nvl(rowData.get("REMARK"))%>
				   </td>
                   <td title="제조사/원산지">
                   		<%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%><br>
                   		<%=CommonUtil.nvl(rowData.get("ORIGIN_NAME"))%>
				   </td>
                   <td title="단위/SG">
                   		<%=CommonUtil.nvl(rowData.get("ORDER_MEASURE"))%><br>
                   		<%=CommonUtil.nvl(rowData.get("SG_NAME"))%>
				   </td>            
                   <td title="매핑개수/매핑정보" class="right">
                   		<%=CommonUtil.nvl(rowData.get("TOT_CNT"))%><br>
                   		<a class="hyperLink"  href="javascript:doPop('masterMdCmGoodsInfoDetailPop',<%=j %>,'<%=CommonUtil.nvl(rowData.get("CMS_CATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("CMS_CATLG_ID"))%>');"><%=CommonUtil.nvl(rowData.get("MAPPING"))%></a>
				   </td>            
				</tr>
<%
		} 
	}
%>
           		</tbody>
            </table>
<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
		<!-- 페이징 -->
		<p class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
		</p>  
		</div>
             <div class="fr">
             	<%if((st_type.equals("RCMD") || st_type.equals("CATLG_REG"))){%>
             		<span class="btn_07 mr04"><a href="javascript:goToRcmdPop();">표준카탈로그추천</a></span>
             	<%}%>
				<span class="btn_07 mr04"><a href="javascript:doAction('reg');">표준카탈로그등록</a></span>
        	 </div>
    </div>

</div>
</form>
</body>
</html>
