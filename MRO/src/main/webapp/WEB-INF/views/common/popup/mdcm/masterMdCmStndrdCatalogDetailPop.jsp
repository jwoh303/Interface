<%--
**********************************************
* 메뉴 : 
* 화면 : 표준카탈로그 상세보기 
* 기능 : 
* 프로그램 ID : 
* 담당자 : 현
* 착수일 : 2016-09-09
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
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 

</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 표준카탈로그 상세 list

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_id = _sessionInfo.getUserId();
String st_user_dept = _sessionInfo.getDepartment();
String st_cms_catlg_id = CommonUtil.nvl((String) request.getParameter("st_cms_catlg_id"),"");  //  (조회조건)

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}

%>

<script type="text/javascript">
<!--
var popupSel = "";


function kep_onload_view() {
	<% if (_dataList.size() == 0) { %>
		alert("표준카탈로그 상세정보가 없습니다.\n\n관리자에게 문의 하십시요.");
		self.close();
	<% }%>
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "masterMpRqKepStndrdCategorySelPop": //표준카테고리
			openSearchPopup("/mprq/showMasterMpRqKepStndrdCategorySelPop.do", "", "721,670,no");	
			break;
			
		case "maker": //제조사
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;
			
		case "country": //원산지
			openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
			break;
			
		case 	"fileUpload": //파일업로드
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_image_key").val()+"&TYPE=CMS", "500,430,no");
			popupSel = "fileUpload";
			break;
		
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterMpRqKepStndrdCategorySelPop") {	//KEP 표준카테고리 선택
  		$("#st_category_path").val(value4);
  		$("#st_cms_categ_id").val(value3);
  		$("#st_cms_categ_change_yn").val("Y");
	
	}else if (popupSel == "maker") {	//제조사 선택
  		$("#st_maker_code").val(value1);
  		$("#st_maker_name").val(value2);
  		
	}else if (popupSel == "country") {	//원산지 선택
  		$("#st_origin_code").val(value1);
  		$("#st_origin_name").val(value3);
  		
	} 
	
	grbRow="";	//초기화
}

//기능함수
function doAction(str, flag) {
	switch (str) {
		case "save":
	        var st_category_path = document.forms.masterMdCmStndrdCatalogDetailViewPop.st_category_path.value;
	        var st_description_loc = document.forms.masterMdCmStndrdCatalogDetailViewPop.st_description_loc.value;
	        var st_description_eng = document.forms.masterMdCmStndrdCatalogDetailViewPop.st_description_eng.value;
	        var st_specification = document.forms.masterMdCmStndrdCatalogDetailViewPop.st_specification.value;
	        var st_maker_name = document.forms.masterMdCmStndrdCatalogDetailViewPop.st_maker_name.value;
	        var st_origin_name = document.forms.masterMdCmStndrdCatalogDetailViewPop.st_origin_name.value;
	        var st_std_flag = document.forms.masterMdCmStndrdCatalogDetailViewPop.st_std_flag.value;
	        var st_order_measure = document.forms.masterMdCmStndrdCatalogDetailViewPop.st_order_measure.value;
	        if(kepTrimStr(st_category_path) == ""){
	            alert("카테고리를 입력바랍니다.");
	            return;
	        }
	        if(kepTrimStr(st_description_loc) == ""){
	            alert("품목명(한글)을 입력바랍니다.");
	            return;
	        }
	        if(kepTrimStr(st_description_eng) == ""){
	            alert("품목명(영문)을 입력바랍니다.");
	            return;
	        }
	        if(kepTrimStr(st_specification) == ""){
	            alert("규격을 입력바랍니다.");
	            return;
	        }
	        if(kepTrimStr(st_maker_name) == ""){
	            alert("제조사를 입력바랍니다.");
	            return;
	        }
	        if(kepTrimStr(st_origin_name) == ""){
	            alert("원산지를 입력바랍니다.");
	            return;
	        }
	        if(kepTrimStr(st_std_flag) == ""){
	            alert("표준화여부를 입력바랍니다.");
	            return;
	        }
	        if(kepTrimStr(st_order_measure) == ""){
	            alert("단위를 입력바랍니다.");
	            return;
	        }
			if(confirm("표준 카탈로그 정보를 수정하시겠습니까?\n수정시 반영까지 최대 5분 걸립니다.")) {
				kepAjaxFormCall("/mdcm/saveMasterMdCmStndrdCatalogDetailPop.do","masterMdCmStndrdCatalogDetailViewPop","CATALOGSAVE");
			}
			break;
	}
}


/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
		this.close();
	}
	// 처리후 reload
	//location.reload();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
		this.close();
	}
	
	// 처리후 reload
	//location.reload();
} 
function setImageView(img_dr,img_name){

	if(img_name == "icon_emptyimg.gif"){
		alert("등록된 이미지가 없습니다.");
		return;		
	}else{
		window.open('<%= CommonUtil.getURL(request) %>'+img_dr+ img_name,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');	
	}
	
}

//이미지 미리보기
function preview_new(img) {
	$("#st_image_no").val(img);
	$("#image1").attr("src","");
	var dest = document.getElementById("st_image_no");
	dest.src = img;
	kepAddImage();
}

//이미지등록
function kepAddImage(){
	var fileName = $("#files").val();
	if (fileName == ""){
		alert("이미지를 선택하세요.");
		return;
	} 	
	var dot = fileName.lastIndexOf(".");
	var ext = fileName.substring(dot).toLowerCase();
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		return;
	}
	$("#masterMdCmStndrdCatalogDetailViewPop").attr("target","account_work");
	$("#masterMdCmStndrdCatalogDetailViewPop").attr("action","/mdcm/addMasterMdCmStndCatalogAlterPop.do").submit();
 	
}

//이미지 상세 미리보기
function preview_detail_new(img) {
	$("#st_detail_image_no").val(img);
	$("#imageDetail1").attr("src","");
	var dest = document.getElementById("st_detail_image_no");
	dest.src = img;
	kepAddDetailImage();
}

//이미지등록
function kepAddDetailImage(){
	var fileName = $("#files2").val();
	if (fileName == ""){
		alert("이미지를 선택하세요.");
		return;
	} 	
	
	var dot = fileName.lastIndexOf(".");
	var ext = fileName.substring(dot).toLowerCase();
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		return;
	}
	
	$("#masterMdCmStndrdCatalogDetailViewPop").attr("target","account_work");
	$("#masterMdCmStndrdCatalogDetailViewPop").attr("action","/mdcm/addMasterMdCmStndCatalogAlterDetailPop.do").submit();
 	
}
//이미지처리완료.
function upSet(error){
	if(error == "ERROR"){
		alert("이미지 등록에 실패 하였습니다.");
	}else{
		alert("이미지가 등록/수정되었습니다.");	
	}
	loader_obj("N");
	location.reload();
	return;
}
//-->
</script> 
<body onload="kep_onload_view();">
<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
<form name="masterMdCmStndrdCatalogDetailViewPop" id="masterMdCmStndrdCatalogDetailViewPop" method=post  modelAttribute="uploadForm" enctype="multipart/form-data">
<input type="hidden"	id="st_cms_catlg_id"				name="st_cms_catlg_id"				value="<%=st_cms_catlg_id%>" />
<input type="hidden"	id="st_cms_categ_change_yn"				name="st_cms_categ_change_yn"				value="N" />
<input type="hidden"	id="st_user_id"				name="st_user_id"				value="<%=st_user_id%>" />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:760px;">
    	<div id="popHeader">
        	<h1 class="title">표준카탈로그 수정 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<div id="ContArea" style="width:700px;margin-left:0;" >
           	<!--grid-->
            <% if (_rowData != null) {  %>
            <br>
				<table   style="width:100%">
					<caption>표준카탈로그 상세보기</caption>
                    <colgroup>
                    	<col width="320px" />
	                    <col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<td align="center">
							<table  class="cont_t_list06"  style="width:100%">
								<colgroup>
				                    <col width="18%" />
				                    <col width="32%" />
				                    <col width="18%" />
				                    <col width="32%" />
				                </colgroup>
				                <tbody>
				                	<tr>
				                        <th  scope="row" colspan="4" class="center"  style="font-weight:bold; font-size:15px;"><%=_rowData.get("DESCRIPTION_LOC")%></th>
				                    </tr>
				                	<tr>
				                        <th  scope="row">상품이미지</th>
				                      	<td>
												<%
													if("".equals(CommonUtil.nvl(_rowData.get("IMGFILE_DIR")))){
												%>
													<img src="/resources/images/noimage.gif" id="image1" name="image1" width="80" height="80" border="0">
												<%
													}else{
												%>
													<a class="hyperLink"  href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(_rowData.get("IMGFILE_DIR"))+"/"%>','<%=CommonUtil.nvl(_rowData.get("IMGFILE_NAME"))%>','A');">
														<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(_rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(_rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'" id="image1" name="image1" width="80" height="80" border="0">
													</a>
												<%
													}
												%>
												<br>
												<input type="hidden" name="st_image_no" id="st_image_no" value="" />
												<input name="files" id="files" type="file" size="18" onchange="preview_new(this.value);" value=""  style="width:200px;"/>										
												<br><br>
												<font color="red"><b>*</b> 이미지 선택 & 열기 시 등록/수정</font>
				                      	</td>
				                        <th  scope="row">상세이미지</th>
				                      	<td>
												<%
													if("".equals(CommonUtil.nvl(_rowData.get("IMGFILE_DIR")))){
												%>
													<img src="/resources/images/noimage.gif" id="imageDetail1" name="imageDetail1" width="80" height="80" border="0">
												<%
													}else{
												%>
													<a class="hyperLink"  href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(_rowData.get("IMGFILE_DIR"))+"/"%>','<%=CommonUtil.nvl(_rowData.get("IMGFILE_NAME"))%>','A');">
														<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(_rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(_rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'" id="imageDetail1" name="imageDetail1" width="80" height="80" border="0">
													</a>
												<%
													}
												%>
												<br>
												<input type="hidden" name="st_detail_image_no" id="st_detail_image_no" value="" />
												<input name="files2" id="files2" type="file" size="18" onchange="preview_detail_new(this.value);" value=""  style="width:200px;"/>										
												<br><br>
												<font color="red"><b>*</b> 이미지 선택 & 열기 시 등록/수정</font>
				                      	</td>
				                      </tr>
				                      <tr>
				                        <th  scope="row">카테고리</th>
				                      	<td colspan="3">
				                      		<input id="st_category_path" name="st_category_path" type="text" class="input_type_text"  style="width:89%;" value = "<%=_rowData.get("CATEG_PATH")%>" readonly>
				                      		<a href="javascript:doPop('masterMpRqKepStndrdCategorySelPop');"><img src="/resources/images/btn_search03.gif"></a>
				                      		<input type="hidden" id="st_cms_categ_id" name="st_cms_categ_id" value="<%=_rowData.get("CMS_CATEG_ID")%>">
				                      	</td>
				                    </tr>
					                <tr>
				                        <th  scope="row">품목코드</th>
				                      	<td colspan="3">
				                      		<b><%=_rowData.get("CMS_CATLG_ID")%></b>
				                      		<input type="hidden" id="st_cms_catgl_id" name="st_cms_catgl_id" value="<%=_rowData.get("CMS_CATLG_ID")%>">
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">품목명(한글)</th>
				                      	<td colspan="3">
				                      		<input type="text" id="st_description_loc" name="st_description_loc" class="input_type_text" style="width:93%;" value="<%=_rowData.get("DESCRIPTION_LOC")%>">
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">품목명(영문)</th>
				                      	<td colspan="3">
				                      		<input type="text" id="st_description_eng" name="st_description_eng" class="input_type_text" style="width:93%;" value="<%=_rowData.get("DESCRIPTION_ENG")%>">
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">규격</th>
				                      	<td colspan="3">
				                      		<input type="text" id="st_specification" name="st_specification" class="input_type_text" style="width:93%;" value="<%=_rowData.get("SPECIFICATION")%>">
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">제조사</th>
				                      	<td>
				                      		<input type="text" id="st_maker_name" name="st_maker_name" value="<%=_rowData.get("MAKER_NAME")%>" class="input_type_text"  readonly>
				                      		<a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
				                      		<input type="hidden" id="st_maker_code" name="st_maker_code" value="<%=_rowData.get("MAKER_CODE")%>">
				                      	</td>
				                        <th  scope="row">원산지</th>
				                      	<td>
				                      		<input type="text" id="st_origin_name" name="st_origin_name" value="<%=_rowData.get("ORIGIN_NAME")%>" class="input_type_text" readonly>
				                      		<a href="javascript:doPop('country');"><img src="/resources/images/btn_search03.gif"></a>
				                      		<input type="hidden" id="st_origin_code" name="st_origin_code" value="<%=_rowData.get("ORIGIN_CODE")%>">
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">표준화여부</th>
				                      	<td>
				                      		<select id="st_std_flag" name="st_std_flag">
												<option value="Y" <%if(_rowData.get("STD_FLAG").equals("Y")) {%>selected<%}%>>Y</option>
												<option value="N" <%if(_rowData.get("STD_FLAG").equals("N")) {%>selected<%}%>>N</option>
											</select>
				                      	</td>
				                        <th  scope="row">단위</th>
				                      	<td>
				                      		<select id="st_order_measure" name="st_order_measure" >
				                      		<%
				                      			Map<String, String> _map = new HashMap<String, String>();
									 			_map.put("TYPE","M007");
									 			_map.put("FLAG","Y");
									 			_map.put("TEXT","CODE");
									 			_map.put("ORDERBY","NUMBER");
											%>
											<%= CommonUtil.getCodeComboQueryIdList("common.mdcm.getMdcmICOMCOD1","NO",_map,_rowData.get("ORDER_MEASURE")) %>
											</select>
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">품목구분</th>
				                      	<td>
				                      		<select id="st_item_gubun" name="st_item_gubun" >
				                      		<%
				                      			Map<String, String> _map2 = new HashMap<String, String>();
				                      			_map2.put("TYPE","M118");
				                      			_map2.put("FLAG","Y");
				                      			_map2.put("ORDERBY","NUMBER");
											%>
											<%= CommonUtil.getCodeComboQueryIdList("common.mdcm.getMdcmICOMCOD1","NO",_map2,_rowData.get("ITEM_GUBUN")) %>
											</select>
				                      	</td>
				                        <th  scope="row">모델정보</th>
				                      	<td>
				                      		<input type="text" id="st_model_info" name="st_model_info" class="input_type_text" style="width:93%;" value="<%=_rowData.get("MODEL_INFO")%>">
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">비고</th>
				                      	<td colspan="3">
				                      		<input type="text" id="st_remark" name="st_remark" class="input_type_text" style="width:93%;" value="<%=_rowData.get("REMARK")%>">
				                      	</td>
				                    </tr>
				                </tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
				<% }  %>
        	</div>
<% 
		// 강수미 or 박지수 
		if(st_user_id.equals("KEP2239041") || st_user_id.equals("KEP2129083")){ %>
            <div class="btnArea">
            	<span class="fr">
            		<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
            	</span>
            </div>
<%}%>
        	</div>
        	</div>
        	<!--버튼영역-->
</form> 
</body>
</html>
