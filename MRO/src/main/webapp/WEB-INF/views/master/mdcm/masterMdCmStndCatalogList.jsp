<%--
**********************************************
* 메뉴 : 표준카탈로그
* 화면 : 표준카탈로그 검색
* 기능 : 표준카탈로그 검색
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2016-08-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt =CommonUtil.nvl((String)request.getAttribute("totalCnt"),"0"); // 조회된 결과
	
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String st_sort_change = CommonUtil.nvl((String) request.getParameter("st_sort_change"),"");
	String searchSort = CommonUtil.nvl((String) request.getParameter("searchSort"),"");   
	
	String SessionComCode = "";
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"IMAGE_HIDDEN");   
	String img_view_flag   = "";
	String SessionUserId = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
		SessionUserId         = sessionInfo.getUserId();
	}  
	if(image_status.equals("")){ 
        image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN"; 
    }
	String st_maker_nm = CommonUtil.nvl((String) request.getParameter("st_maker_nm"),"");
	String st_category_path = CommonUtil.nvl((String) request.getParameter("st_category_path"),""); 
	String st_categ_id = CommonUtil.nvl((String) request.getParameter("st_categ_id"),""); 
	String st_mast_check = CommonUtil.nvl((String) request.getParameter("st_mast_check"),"");
	String st_categ_name = CommonUtil.nvl((String) request.getParameter("st_categ_name"),"");
	String st_sg_nm = CommonUtil.nvl((String) request.getParameter("st_sg_nm"),""); 
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");
	String st_status = CommonUtil.nvl((String) request.getParameter("st_status"),"");
	String st_stnd_flag = CommonUtil.nvl((String) request.getParameter("st_stnd_flag"),"");
	String st_model_info = CommonUtil.nvl((String) request.getParameter("st_model_info"),"");
	String st_remark = CommonUtil.nvl((String) request.getParameter("st_remark"),"");
	String st_catlg_id = CommonUtil.nvl((String) request.getParameter("st_catlg_id"),"");
	String st_item_gubun = CommonUtil.nvl((String) request.getParameter("st_item_gubun"),"");
	String st_gpl_flag = CommonUtil.nvl((String) request.getParameter("st_gpl_flag"),"");
	
	
	boolean list = true;
	 if (_gridList == null || _gridList.size() == 0){
		 list = false;
	 }
%> 
<script src="/resources/js/common.js"></script>
<script>
var popupSel = "";

function kep_onload_view() {
}
	
// 기능함수
function doAction(str , gubun) {
	
	switch (str) {
	case "search":	 // 조회
		kepSearch(1);
		break;
	case "reload":	// 초기화
		kepReload('searchForm');
		break;
	case "confirm":	//승인
		confirmStndCatlg();
		break;
	case "excelDown":
		kepExcel(1);
		break;
	}
}

function confirmStndCatlg(){
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0; 
    var query   = "";
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" 목록에 표시된 상품이 없습니다.     ");
        return;
    }

    chk_cnt = getCheckedRowCount(tot_cnt);
    
    if(chk_cnt == "0"){
        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" ); 
            if(box.checked == true){
            	var st_c_status     = document.forms.contentForm.st_c_status.value; 
            	var st_cms_catalg_id     = document.forms.contentForm.st_cms_catalg_id.value;
                if(st_c_status != "S"){
                    alert( "미승인건이 아닙니다.");
                    return;
                } else{
					query = st_cms_catalg_id + "|";
				}
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
                if(box.checked == true){
                	var st_c_status     = document.forms.contentForm.st_c_status[i].value; 
                	var st_cms_catalg_id     = document.forms.contentForm.st_cms_catalg_id[i].value;
                	
                    if(st_c_status != "S"){
                        alert( "미승인건이 아닙니다.");
                        return;
                    } else{
    					query = st_cms_catalg_id + "|";
    				}
                }
            }
        }
    }
    if(!confirm("승인 하시겠습니까?\n승인처리 반영되는 시간은 최대5분이 소요됩니다.")){
        return;
    }
    document.forms.searchForm.st_query.value = query;
    kepAjaxFormCall("/mprq/saveMasterMpRqConfirmStndCatlg.do","searchForm","SAVE");
}
/**
 * 체크 된 수
 */
function getCheckedRowCount(tot_cnt) {
	
	var chk_cnt = 0;
	if(eval(tot_cnt) < 2){
	    var box = eval("document.forms.contentForm.lnCheck0");
	    if(box.checked == true) chk_cnt++;
	}else{
	    for(var j = 0; j < tot_cnt; j++){
	         var box = eval("document.forms.contentForm.lnCheck" + j);
	         if(box.checked == true){
	              chk_cnt++;
	         }
	    }
	}
	return chk_cnt;
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
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
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
} 
//조회
function kepSearch(curPage){
	
	var st_maker_nm = TrimCommon($("#st_maker_nm").val());
	var st_categ_id = TrimCommon($("#st_categ_id").val());
	var st_mast_check = TrimCommon($("#st_mast_check").val());
	var st_sg_nm = TrimCommon($("#st_sg_nm").val());
	var st_description = TrimCommon($("#st_description").val());
	var st_specification = TrimCommon($("#st_specification").val());
	var st_status = TrimCommon($("#st_status").val());
	var st_model_info = TrimCommon($("#st_model_info").val());
	var st_remark = TrimCommon($("#st_remark").val());
	var st_catlg_id = TrimCommon($("#st_catlg_id").val());
	var st_stnd_flag = TrimCommon($("#st_stnd_flag").val());
	

	if(st_maker_nm == "" && st_categ_id == "" && st_mast_check == "" && st_sg_nm == "" && st_description == "" && st_specification == "" &&st_status=="" &&st_model_info==""&&st_remark==""&&st_stnd_flag==""&&st_catlg_id==""){
		alert("최소 한가지의 검색조건은 입력하여 주십시요");
		return;
	}
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdcm/getStndCaltlgList.do").submit();
}
//조회
function kepExcel(curPage){
	
	var st_maker_nm = TrimCommon($("#st_maker_nm").val());
	var st_categ_id = TrimCommon($("#st_categ_id").val());
	var st_mast_check = TrimCommon($("#st_mast_check").val());
	var st_sg_nm = TrimCommon($("#st_sg_nm").val());
	var st_description = TrimCommon($("#st_description").val());
	var st_specification = TrimCommon($("#st_specification").val());
	var st_status = TrimCommon($("#st_status").val());
	var st_model_info = TrimCommon($("#st_model_info").val());
	var st_remark = TrimCommon($("#st_remark").val());
	var st_catlg_id = TrimCommon($("#st_catlg_id").val());
	var st_stnd_flag = TrimCommon($("#st_stnd_flag").val());
	

	if(st_maker_nm == "" && st_categ_id == "" && st_mast_check == "" && st_sg_nm == "" && st_description == "" && st_specification == "" &&st_status=="" &&st_model_info==""&&st_remark==""&&st_stnd_flag==""&&st_catlg_id==""){
		alert("최소 한가지의 검색조건은 입력하여 주십시요");
		return;
	}
	document.forms.searchForm.curPage.value = curPage; 
	document.forms.searchForm.action = "/mdcm/excelStndCaltlgList.do";
	document.forms.searchForm.submit();
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5){
	if (popupSel == "masterMpRqKepStndrdCategorySelPop") {	//KEP 표준카테고리 선택
		$("#st_categ_id").val(value3);
		$("#st_category_path").val(value4);
		$("#st_categ_name").val(value5);
	}
}
//회원사상세정보 팝업
function getAgentDisplayPop(agent){
	openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do", '?com_code='+agent, "800,600,no");
}

//고객사 상세정보 팝업
function getBuyerCatalogDisplay(buyer, catalog_com_code, buyer_item_no){
	/* AS-IS
	var catalog_com_code = mySheet.GetCellValue(Row,"BUYER");
	var buyer = $("#st_buyer_code").val();
	var buyer_item_no = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
	*/
	openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do", '?st_buyer_code='+buyer+'&st_catalog_com_code='+catalog_com_code+'&st_buyer_item_no='+buyer_item_no, "988,710,no");
}

//단가변경이력 팝업
function setSysopCqepHistory(buyer, contractNo, contractSeq){ 
	openSearchPopup("/mdcm/showMasterMdCmUnitpriceAlterHistoryPop.do", '?st_buyer='+buyer+'&st_contract_no='+contractNo+'&st_contract_seq='+contractSeq, "840,250,no");
}

//상품 큰이미지
function getBigImage(file_dir, file_name){	
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

function searchSort(gubun){
	
	var st_sort_change = document.forms.searchForm.st_sort_change.value;
	
	if (st_sort_change == "" || st_sort_change == "DOWN"){
		st_sort_change = "UP";
	}else{
		st_sort_change = "DOWN";
	}
	
	document.forms.searchForm.st_sort_change.value = st_sort_change;
	document.forms.searchForm.st_sort_change.value = st_sort_change;
	document.forms.searchForm.searchSort.value = gubun + "_"+st_sort_change; 

	kepSearch(1);
}

//이미지 보이기 숨기기
function imageHideView(){ 
	
    var image_status   = document.forms.searchForm.st_image_status.value;
    if(image_status == "IMAGE_HIDDEN"){
        image_status = "IMAGE_VIEW"; 
    }else if(image_status == "IMAGE_VIEW"){
        image_status = "IMAGE_HIDDEN"; 
    }
    document.forms.searchForm.st_image_status.value = image_status;
	 // 처리후 재조회
	 kepSearch($("#curPage").val());
}
//팝업 함수호출
var gridIndex = 0;
var grbRow = "";
var popupSel = "";
function doPop(str,idx,value1, value2, value3, value4, value5) {
	popupSel = str;
	gridIndex =idx;
	switch (str) {
		case "masterMpRqKepStndrdCategorySelPop": // 표준카테고리
			popupSel = "masterMpRqKepStndrdCategorySelPop";
			openSearchPopup("/mprq/showMasterMpRqKepStndrdCategorySelPop.do", "", "721,670,no");
			break;
		case "masterMdCmStndrdCatalogDetailViewPop": //MASTER코드 선택
			var stndCategId = value1;
			var stndCatalId = value2;
			openSearchPopup("/mdcm/getMasterMdCmStndrdCatalogDetailPop.do", '?st_cms_catlg_id='+stndCatalId, "730,560,no");
			break;
		case "masterMdCmImageViewPop"://품목이미지.
			var img_no = value1;
			var cms_catlg_id = value2;
			if(img_no == "null"||img_no == null||img_no == ""||img_no == " "){
				alert("해당 이미지가 존재하지 않습니다.");
				return;
			}else{
				openSearchPopup("/mdcm/getMasterMdCmImageViewPop.do","?st_img_no="+img_no+"&st_cms_catlg_id="+cms_catlg_id,"770,575,no");
			}
			break;
		case "masterMdCmGoodsInfoDetailPop": //매핑조회
			var st_cms_categ_id = value1;
			var st_cms_catlg_id = value2;
			openSearchPopup("/mdcm/showMasterMdCmGoodsInfoDetailPop.do", '?st_cms_categ_id='+st_cms_categ_id+'&st_cms_catlg_id='+st_cms_catlg_id, "800,700,no");// 품목정보 상세보기
			break;
	}
}
function setImageView(img_dr,img_name,gbn){

	window.open('<%= CommonUtil.getURL(request) %>'+img_dr+ img_name,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');
	
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>표준 카탈로그 조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchForm" id="searchForm" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" name="searchSort" id="searchSort"  value="<%=searchSort%>" />
			<input type="hidden" name="st_sort_change" id="st_sort_change" value="<%=st_sort_change %>">  
 			<input type="hidden" name="st_image_status" id="st_image_status" value="<%=image_status %>">
 			<input type="hidden" name="st_query" id="st_query" value="">
            	<table  class="cont_t_list01" >
					<caption>표준 카탈로그 조회</caption>
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
							<th>제조사명</th>
							<td>
								<input type="text"   class="input_type_text" name="st_maker_nm" id="st_maker_nm" value="<%=st_maker_nm%>" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>표준카테고리</th>
							<td>
								<input type="text" id="st_category_path" name="st_category_path" maxlength="25"  value = "<%=st_category_path%>"  class="input_type_text"  readonly style="width:65%">
								<a href="javascript:doPop('masterMpRqKepStndrdCategorySelPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_categ_id','st_category_path');"><img src="/resources/images/btn_eraser2.gif"></a>
								<input type="hidden" id="st_categ_id" name="st_categ_id" value = "<%=st_categ_id%>">
              					<input type="hidden" id="st_mast_check" name="st_mast_check" value = "<%=st_mast_check%>">
							</td>
							<th>상태</th>
							<td>
								  <select name="st_status" id="st_status" style="width:87%">           
						        		<%= CommonUtil.getCode3ComboList("", "ALL", "CA01","", "ICOMCOD1",st_status, "") %>
						         </select>
							</td>
						</tr>
						<tr>
							<th>SG명</th>
							<td>
								<input type="text" class="input_type_text" id="st_sg_nm" name="st_sg_nm" value="<%=st_sg_nm %>"  style="width:87%"  value="" onkeydown="kepEnter()">
							</td>
							<th>품목명</th>
							<td>
								<input type="text"   class="input_type_text" name="st_description" id="st_description" value="<%=st_description %>"  style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>규격</th>
							<td>
								<input type="text"   class="input_type_text" name="st_specification" id="st_specification" value="<%=st_specification %>"  style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
						</tr>
						<tr>
							<th>모델정보</th>
							<td>
								<input type="text" class="input_type_text" id="st_model_info" name="st_model_info" value="<%=st_model_info %>"  style="width:87%"  value=""  onkeydown="kepEnter()">
							</td>
							<th>표준화여부</th>
							<td>
								<select name="st_stnd_flag" id="st_stnd_flag" style="width:87%">
									<%= CommonUtil.getCode3ComboList("", "ALL", "CA02","", "ICOMCOD1",st_stnd_flag, "") %>           
						         </select>
							</td>
							<th>비고</th>
							<td>
								<input type="text" class="input_type_text" id="st_remark" name="st_remark" value="<%=st_remark %>"  style="width:87%"  value=""  onkeydown="kepEnter()">
							</td>
						</tr>
						<tr>
							<th>카탈로그코드</th>
							<td>
								<input type="text"   class="input_type_text" name="st_catlg_id" id="st_catlg_id" value="<%=st_catlg_id %>"  style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<td>품목구분</td>						 
							<td> 
								<select name="st_item_gubun" id="st_item_gubun" style="width:87%">
									<%= CommonUtil.getCode3ComboList("", "ALL", "M118","", "ICOMCOD1",st_item_gubun, "") %>           
						         </select> 
							</td>
							<td>GPL여부</td>
							<td>
								<select name="st_gpl_flag" id="st_gpl_flag" style="width:87%">
									<%= CommonUtil.getCode3ComboList("", "ALL", "CA02","", "ICOMCOD1",st_gpl_flag, "") %>           
						         </select>
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
				<option value = "500" <%if ("500".equals(onepagerow)) {%>selected<%} %>>500건</option> 
			</select>	
			&nbsp;		
      	</span>
			<br>
		</form>
					
      	<form name = "contentForm" id="contentForm" method = "post">
		<!--grid header-->
		<table  class="cont_t_list02"  style="width:100%; margin-bottom:0px;">
			<colgroup>
				<col width="3%" />
	            <col width="5%" />
	            <col width="5%" />
	            <col width="8%" />
	            <col width="*" />
	            <col width="25%" />
	            <col width="12%" />
	            <col width="8%" />
	            <col width="5%" />
	            <col width="5%" />
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col">
				<input type="checkbox" class="input_noline" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck');">
				</th>
                <th scope="col"></th>
               <th scope="col"></th>
                <th scope="col">표준카탈로그코드/<br>품목구분</th>
                <th scope="col">품목명(영문)/<br>규격(영문)</th>
                <th scope="col">카테고리/<br>비고</th>
                <th scope="col">모델정보/<br>표준화/GPL</th>
                <th scope="col">제조사/<br>원산지</th>
                <th scope="col">단위/<br>SG</th>
                <th scope="col">매핑개수/<br>매핑정보</th>
			</tr>
			</thead>
		</table>
		
		<div style="min-height:394; height:394px; padding-bottom:10px; margin-bottom:10px; overflow-y:auto;">
		<table  class="cont_t_list02" style="width:100%; border-top:0px solid #6a98b5">
        <caption>표준 카탈로그 조회</caption>
			<colgroup>
				<col width="3%" />
	            <col width="5%" />
	            <col width="5%" />
	            <col width="8%" />
	            <col width="*" />
	            <col width="25%" />
	            <col width="12%" />
	            <col width="8%" />
	            <col width="5%" />
	            <col width="5%" />
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
                    <td>
						<input type="checkbox" class="input_noline" name="lnCheck<%=j%>" >	 
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
					%>										
					</td>
					<td title="상품상세이미지">
					<%
						if("".equals(CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_DIR")))){
					%>
						<img src="/resources/images/noimage.gif" width="80" height="80" border="0">
					<%
						}else{
					%>
						<a class="hyperLink"  href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_DIR"))+"/"%>','<%=CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_NAME"))%>','B');">
							<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0">
						</a>
					<%
						}
					%>										
					</td>                      
                    <td class="left" title="표준카탈로그코드">
                    	<input type="hidden" name="st_cms_categ_id"  id="st_cms_categ_id"  value="<%=CommonUtil.nvl(rowData.get("CMS_CATEG_ID"))%>">
                    	<input type="hidden" name="st_cms_catalg_id" id="st_cms_catalg_id"  value="<%=CommonUtil.nvl(rowData.get("CMS_CATLG_ID"))%>">
                    	<input type="hidden" name="st_c_status" id="st_c_status"  value="<%=CommonUtil.nvl(rowData.get("STATUS"))%>">
                    	&nbsp;&nbsp;
                    	<a class="hyperLink"  href="javascript:doPop('masterMdCmStndrdCatalogDetailViewPop',<%=j %>,'<%=CommonUtil.nvl(rowData.get("CMS_CATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("CMS_CATLG_ID"))%>');"><%=CommonUtil.nvl(rowData.get("CMS_CATLG_ID"))%></a><br>
                    	&nbsp;&nbsp;&nbsp;<%=CommonUtil.nvl(rowData.get("ITEM_GUBUN_TEXT"))%>
                    </td>          
                   <td class="left" title="품명/규격">
				   		<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%>(<%=CommonUtil.nvl(rowData.get("DESCRIPTION_ENG"))%>) <br>
				   		<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>(<%=CommonUtil.nvl(rowData.get("SPECIFICATION_ENG"))%>)
				   </td>
                   <td class="left" title="카테고리/비고">
                   		<%=CommonUtil.nvl(rowData.get("CATEG_PATH"))%><br>
                   		<%=CommonUtil.nvl(rowData.get("REMARK"))%>
				   </td>            
                   <td title="모델정보/표준화/GPL">
                   		<%=CommonUtil.nvl(rowData.get("MODEL_INFO"))%><br>
                   		<%=CommonUtil.nvl(rowData.get("STD_FLAG"))%> / <%=CommonUtil.nvl(rowData.get("GPL_YN"))%>
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
	<!-- 버튼영역 -->
	<!-- div class="btnArea">
		<div class="fr">
			<span class="btn_04 mr04">
				<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
			</span>
		 
		</div>
	</div -->
</form>

<!--내용 종료-->	                 

</body>
</html>
