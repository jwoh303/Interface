<%--
**********************************************
* 메뉴 : 견적관리 > 신규상품견적의뢰 > 카탈로그 등록여부 
* 화면 : 카탈로그 등록여부 
* 기능 : 고객사 카탈로그 등록여부 조회 팝업
* 프로그램 ID : PG_04_B_003_02
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-08-27
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
String img_view_flag   = "";
String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");
String st_maker_name = CommonUtil.nvl((String) request.getParameter("st_maker_name"),"");
String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");
String st_categ_name = CommonUtil.nvl((String) request.getParameter("st_categ_name"),"");
String st_image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");
if(st_image_status.equals(""))
{ 
    st_image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN";
}

String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
String tot_cnt_string   = "";
int tot_cnt = 0;                                    //전체데이타row수
int rec_cnt = 0;
int page_display_cnt = 0;
%>

<script type="text/javascript">
function kepSearch(curPage)
{  
  document.forms.buyerMpRqCatalogRegYnPop.curPage.value = curPage; 
  $('#buyerMpRqCatalogRegYnPop').attr("action", "/mprq/getBuyerMpRqCatalogRegYnPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch('1');
	}
}
function reload(){
	kepReload("buyerMpRqCatalogRegYnPop");
	kepSearch(-1); 
}
//이미지 보이기 숨기기
function imageHideView(){ 
	
    var image_status   = $("#st_image_status").val();
    if(image_status == "IMAGE_HIDDEN"){
        image_status = "IMAGE_VIEW"; 
    }else if(image_status == "IMAGE_VIEW"){
        image_status = "IMAGE_HIDDEN"; 
    }
    $("#st_image_status").val(image_status);
	 // 처리후 재조회
	 if ($('#display_item_cnt').val() > 0){
	 	kepSearch($("#curPage").val());
	 }
}
//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}
</script> 
<body onload="">
<form name="buyerMpRqCatalogRegYnPop" id="buyerMpRqCatalogRegYnPop" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type="hidden" name="st_image_status" id="st_image_status" value="<%=st_image_status %>">
<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:602px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE33") %><!-- 카탈로그 등록여부 --> </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:527px;">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch(1);"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
            	<span class="btn_reset"><a href="javascript:reload();"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>카탈로그 등록여부  리스트</caption>
						<colgroup>
							<col width="12%" /> 
	                        <col width="38%" /> 
	                        <col width="12%" /> 
	                        <col width="38%" /> 
						</colgroup>						
						<tbody>
						<tr>
							<th><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>
							<td> 
								<input type=text name=st_description id="st_description" style="width:90%;" value="<%=st_description %>" onkeydown="kepEnter()"> 
                            </td>
							<th><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></th>
							<td> 
								<input type=text name=st_maker_name id="st_maker_name" style="width:90%;" value="<%=st_maker_name %>" onkeydown="kepEnter()"> 
                            </td>
                         </tr>
                         <tr>
							<th><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
							<td> 
								<input type=text name=st_specification id="st_specification" style="width:90%;" value="<%=st_specification %>" onkeydown="kepEnter()"> 
                            </td>
							<th><%=CommonLang.get("HTITLE512") %><!-- 카테고리명 --></th>
							<td> 
								<input type=text name=st_categ_name id="st_categ_name" style="width:90%;" value="<%=st_categ_name %>" onkeydown="kepEnter()"> 
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>      
            <div class="fl">   
	            <span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
		       	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow">
						<option <%=(pg_row.equals("10")  ? "selected" : "")%> value = "10">10</option>
						<option <%=(pg_row.equals("20")  ? "selected" : "")%> value = "20">20</option>
						<option <%=(pg_row.equals("30")  ? "selected" : "")%> value = "30">30</option>
						<option <%=(pg_row.equals("40")  ? "selected" : "")%> value = "40">40</option>
						<option <%=(pg_row.equals("50")  ? "selected" : "")%> value = "50">50</option>
					</select>
					
					<span class="btn_imghide">
						<%  if(st_image_status.equals("IMAGE_HIDDEN")){   %>
						<a href="javascript:imageHideView();"  title="이미지보이기" ><%=CommonLang.get("HTITLE9") %><!-- 이미지보이기 --></a>
						<%  }else{   %>
						<a href="javascript:imageHideView();"  title="이미지감추기" ><%=CommonLang.get("HTITLE167") %><!-- 이미지감추기 --></a>
						<%  }   %> 
					</span>
		       	</span>
	       	</div>
	        <div class="fr"><%=CommonLang.get("HTITLE608") %><!-- 총건수 --> <%=total_cnt %></div> 
           	<!--grid-->
            <div class="scrollArea" style="height:372px;width:100%">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>카탈로그 등록여부  리스트</caption>
                    <colgroup>
                        <col width="5%" /> 
                        <col width="10%" /> 
                        <col width="15%" /> 
                        <col width="55%" /> 
                        <col width="15%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">No.</th> 
                            <th scope="col"><%=CommonLang.get("HTITLE514") %><!-- 사진 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --><br><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --><br><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE52") %><!-- 단위 --><br><%=CommonLang.get("HTITLE174") %><!-- 단가 --></th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="5" align="center" height = "280">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
							<td rowspan="2">
								<%=j+1%>
								<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
							</td>
							<td rowspan="2">
							  	<% if(st_image_status.equals("IMAGE_HIDDEN")){
								       if("".equals(CommonUtil.nvl(_tmp.get("IMGFILE_DIR")))){
								%>
								           <img src="/resources/images/but_img_off.gif" border="0">
								          <%=(CommonUtil.nvl(_tmp.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
								          <%=(CommonUtil.nvl(_tmp.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
								 
								<%     }else{ %> 
								             <a href="javascript:getBigImage('<%=CommonUtil.nvl(_tmp.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(_tmp.get("IMGFILE_NAME"))%>');">
								             <img src="/resources/images/but_img_on.gif" border="0"></a>
								          <%=(CommonUtil.nvl(_tmp.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
								          <%=(CommonUtil.nvl(_tmp.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%> 
								 
								<%     }
								    }else{
								    	 if("".equals(CommonUtil.nvl(_tmp.get("IMGFILE_DIR")))){
								%>
								          <img src="/resources/images/noimage.gif" width="80" height="80" border="0">
								          <%=(CommonUtil.nvl(_tmp.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
								          <%=(CommonUtil.nvl(_tmp.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
								 
								<%     }else{ %> 
								             <a href="javascript:getBigImage('<%=CommonUtil.nvl(_tmp.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(_tmp.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(_tmp.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(_tmp.get("IMGFILE_NAME"))%>" name="image1" width="80" height="80" border="0"></a>
								          <%=(CommonUtil.nvl(_tmp.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
								          <%=(CommonUtil.nvl(_tmp.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
								 
								<%     }
								    }
								%>
						   </td>
							<td>
								<%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%>
							</td>
							<td>
								<%=CommonUtil.nvl(_tmp.get("DESCRIPTION"))%>
							</td>
							<td>
								<%=CommonUtil.nvl(_tmp.get("UNIT_MEASURE"))%>
							</td>
                        </tr> 
                        <tr>
							<td class="center">
								<%=CommonUtil.nvl(_tmp.get("MAKER_NAME"))%>
							</td>
							<td>
								<%=CommonUtil.nvl(_tmp.get("SPECIFICATION"))%>
							</td>
							<td class="right">
								<%=CommonUtil.formatNumber(_tmp.get("TARGET_PRICE"),true,0,3)%>
							</td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table> 
        </div>
    <!-- 페이징 -->
	<p class="paging">
		<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
	</p>                   
    </div>        
</div>
</form> 
</body>
</html>
