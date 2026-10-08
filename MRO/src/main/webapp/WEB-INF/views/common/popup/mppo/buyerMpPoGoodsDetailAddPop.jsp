<%--
**********************************************
* 메뉴 : 
* 화면 : 상품추가
* 기능 : 발주보류상태인 발주 상세팝업에서 상품을 추가하고자 하는 경우 상품검색하기 위한 팝업
* 프로그램 ID : PG_06_B_018_02
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-10
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
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _cartInfo = (List<Map<String,String>>) request.getAttribute("info"); // 조회된 결과 

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList1 = (List<Map<String,String>>) request.getAttribute("detail_data1"); // 조회된 결과 getCatalogDisplayMain
Map<String,String> rowData= _dataList1.get(0);

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("detail_data2"); // 조회된 결과  getItemSeries
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList3 = (List<Map<String,String>>) request.getAttribute("detail_data3"); // 조회된 결과  categoryPathViewer
 





String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),""); // 현재페이지  (필수)
String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String buyer = _sessionInfo.getComCode();

String st_px_no = CommonUtil.nvl((String) request.getParameter("st_px_no"),"");  //  (조회조건)
String st_recv_flag = CommonUtil.nvl((String) request.getParameter("st_recv_flag"),"");  //  (조회조건)
String flag = CommonUtil.nvl((String) request.getParameter("flag"),"");  //  (조회조건)
String byca_comorg_code = CommonUtil.nvl((String) request.getParameter("byca_comorg_code"),"");  //  (조회조건)
String searchText = CommonUtil.nvl((String) request.getParameter("searchText"),"");  //  (조회조건)
String st_sort_gubun = CommonUtil.nvl((String) request.getParameter("st_sort_gubun"),"");  //  (조회조건)
String st_sort_change = CommonUtil.nvl((String) request.getParameter("st_sort_change"),"");  //  (조회조건)
String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");  //  (조회조건)
String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");  //  (조회조건)
String st_maker = CommonUtil.nvl((String) request.getParameter("st_maker"),"");  //  (조회조건)
String st_categoty_name = CommonUtil.nvl((String) request.getParameter("st_categoty_name"),"");  //  (조회조건) 
String st_image_status   = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");

String st_buyer_item_no   = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String st_byca_comorg_code   = CommonUtil.nvl((String) request.getParameter("st_byca_comorg_code"),"");
String st_stdcateg_id   = CommonUtil.nvl((String) request.getParameter("st_stdcateg_id"),"");
String st_stdcatlg_id   = CommonUtil.nvl((String) request.getParameter("st_stdcatlg_id"),"");
String st_categ_code   = CommonUtil.nvl((String) request.getParameter("st_categ_code"),"");
String st_key_flag   = CommonUtil.nvl((String) request.getParameter("st_key_flag"),"");
String st_cart_status   = CommonUtil.nvl((String) request.getParameter("st_cart_status"),""); 

 
 
%>

<script type="text/javascript">
<!--

function kepSearch(curPage)
{  
	
	document.forms.buyerMpPoGoodsDetailAddPop.st_sort_gubun.value = '';
	document.forms.buyerMpPoGoodsDetailAddPop.st_sort_change.value = '0';
	document.forms.buyerMpPoGoodsDetailAddPop.curPage.value = curPage;  
  	$('#buyerMpPoGoodsDetailAddPop').attr("action", "/mppo/getBuyerMpPoGoodsAddPop.do").submit();    
}



function nowKepSearch(curPage)
{  
	 
	document.forms.buyerMpPoGoodsDetailAddPop.nowCurPage.value = curPage;  
 	$('#buyerMpPoGoodsDetailAddPop').attr("action", "/mppo/getBuyerMpPoGoodsAddDetailPop.do").submit();    
}
 
  

function setProxyByitDisplay(buyer,buyer_item_no,contract_no,contract_seq){
	
	var catalog_com_code = buyer;
	var buyer = buyer;
	var buyer_item_no = buyer_item_no;
	
	openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do","?st_buyer_code="+buyer+"&st_catalog_com_code="+catalog_com_code+"&st_buyer_item_no="+buyer_item_no,"988,768,no");
}

//품목 추가 
function setItemAdd(){

	var query			= "";
    var st_order_qty	= "0";
    var count_tmp		= $("#display_item_cnt").val();
    var count			= eval(count_tmp -1);
    var cnt				= 0;

    alert(count);
	if(count < 2){
		
		if(eval("document.forms.buyerMpPoGoodsDetailAddPop.lnCheck1.checked") == true){
			st_order_qty = document.forms.buyerMpPoGoodsDetailAddPop.st_temp_qty.value;
            cnt++;

			if(!chkDecimal(st_order_qty,3) || (eval(st_order_qty) ==0)){
				alert( "첫번째 상품 수량을 1 이상의 숫자 형식 으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    ");
				return;
			}
			
			
	        var contract_no			= document.forms.buyerMpPoGoodsDetailAddPop.temp_contract_no.value;
	        var contract_seq		= document.forms.buyerMpPoGoodsDetailAddPop.temp_contract_seq.value; 
	        var byit_comorg_code    = document.forms.buyerMpPoGoodsDetailAddPop.temp_byit_comorg_code.value;
	        var st_item_no				= document.forms.buyerMpPoGoodsDetailAddPop.temp_item_no.value;
	        query = st_item_no + "@@" + st_order_qty + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
	        
		}

    }else{
    	
		for(var j = 0; j < count; j++){
			if(eval("document.forms.buyerMpPoGoodsDetailAddPop.lnCheck" + (j+1) + ".checked") == true){
				st_order_qty = document.forms.buyerMpPoGoodsDetailAddPop.st_temp_qty[j].value;
                cnt++;
	
				if(!chkDecimal(st_order_qty,3) || (eval(st_order_qty) ==0)){
					alert( eval(j+1) + " 번째 상품 수량을 1 이상의 숫자 형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    ");
					return;
				}
				
				
		        var contract_no			= document.forms.buyerMpPoGoodsDetailAddPop.temp_contract_no[j].value;
		        var contract_seq		= document.forms.buyerMpPoGoodsDetailAddPop.temp_contract_seq[j].value; 
		        var byit_comorg_code    = document.forms.buyerMpPoGoodsDetailAddPop.temp_byit_comorg_code[j].value;
		        var st_item_no				= document.forms.buyerMpPoGoodsDetailAddPop.temp_item_no[j].value;
		        query += st_item_no + "@@" + st_order_qty + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
		        
			}
		}
	}

    if(cnt == 0){
        alert(" 상품에 대한 협력사가 선택되지 않았습니다.  협력사와 수량을 선택해 주시기 바랍니다.    ");
        return;
    }
 
     

	if(!confirm("선택한 상품을 추가 하시겠습니까?")) return;

 	document.forms.buyerMpPoGoodsDetailAddPop.st_query2.value = query;
	kepAjaxFormCall("/mppo/saveSetItemAdd.do","buyerMpPoGoodsDetailAddPop","SAVE"); 
	 
 //document.forms.buyerMpPoGoodsDetailAddPop.action = "/kr/customer/shopping_cart/buyer_new_order_item_add.jsp";
 

}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	//var sMsg = response.msg.MSG;   
    if(pMethod == "SAVE"){ 
    	
    	
	    	var px_no = "<%=st_px_no.substring(0,2)%>";	// px_no가 PR , PX로 시작하는지 체크
			//var recv_flag = "<%=st_recv_flag%>";	// 홍익대학교
			if(recv_flag ="HI"){ 
				//top.opener.document.forms.buyerMpPoGoodsDetailAddPop.st_query_cart.value = "ALL";
				//top.opener.searchSelectRow();
				
				opener.kepSearch(1);
				
			}else{
				if(px_no =="PX"){
					//top.opener.top.popbottom.setQueryFlag();
					//top.opener.top.pop_top.setQuery();
				}else{
					//top.opener.top.bottom.setQueryFlag();
					//top.opener.top.cen.setQuery();
				}
			}
			if(!confirm("상품 추가가 완료 되었습니다.\n\n계속하여 상품을 추가하시겠습니까?")){
				self.close();			
			}
		
		
		
      }else{ 
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "SAVE"){ 
		alert("상품을 추가하는중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요");		
	} 
	
} 

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}
 //-->
</script> 
<body onload="onload();">
<form name="buyerMpPoGoodsDetailAddPop" id="buyerMpPoGoodsDetailAddPop" method=post >
<input type="hidden" name="st_px_no"		   value="<%=st_px_no%>">
<input type="hidden" name="st_recv_flag"	   value="<%=st_recv_flag%>"> 
<input type="hidden" name="searchFlag"         value="">
<input type="hidden" name="st_buyer_item_no"   value=""> 
<input type="hidden" name="st_detail_search"   value="">
<input type="hidden" name="cnt_value"          value=""> 
<input type="hidden" name="flag"       value="<%=flag%>">
<input type="hidden" name="byca_comorg_code"       value="<%=byca_comorg_code%>">
<input type="hidden" name="title_search"       value="">
<input type="hidden" name="st_query2" id="st_query2" value="" />
<input type="hidden" name="openYn" id="openYn" value="N" />
<input type="hidden" name="st_image_status"  id="st_image_status"  value="<%=st_image_status%>"> 
<input type="hidden" name="st_buyer"			value="<%=com_code%>"> 
<input type="hidden" name="st_sort_gubun"	  value="<%=st_sort_gubun%>">
<input type="hidden" name="st_sort_change"	  value="<%=st_sort_change%>">
<input type="hidden" name="curPage"	id="curPage"  value="<%=curPage%>">
<input type="hidden" name="onepagerow"	id="onepagerow"  value="<%=onepagerow%>">
 
 

<input type="hidden" name="st_byca_comorg_code"          value="<%=st_byca_comorg_code%>"> 
<input type="hidden" name="st_stdcateg_id"          value="<%=st_stdcateg_id%>"> 
<input type="hidden" name="st_stdcatlg_id"          value="<%=st_stdcatlg_id%>"> 
<input type="hidden" name="st_item_no_content"       > 
<input type="hidden" name="st_categ_code"        value="<%=st_categ_code%>"> 
<input type="hidden" name="st_key_flag"         value="<%=st_key_flag%>"> 
<input type="hidden" name="st_cart_status"           value="<%=st_cart_status%>"> 

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:780px;">
    	<div id="popHeader">
        	<h1 class="title">상품추가</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
<div id="searchBtnA">
      <div class="fr">
       	<span class="btn_search" title="조회" ><a href="javascript:kepSearch(1)">조회</a></span> 
       	<span class="btn_reset" title="이전화면" ><a href="javascript:kepSearch(<%=curPage%>)">이전화면</a></span>
		<span class="btn_reset" title="초기화" ><a href="javascript:kepReload('buyerMpPoGoodsDetailAddPop');">초기화</a></span>
		</div>
            </div>   
            <br><br>
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>상품추가 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="*" />
							<col width="5%" />
							<col width="10%" />
							<col width="20%" />
							<col width="5%" />
							<col width="10%" />
							<col width="20%" /> 					
						</colgroup>						
						<tbody>
						<tr>
							<td>    <select name="searchType">
											<option value="ALL"   <%="ALL".equals(request.getParameter("searchType"))?"selected":""%>>전체</option>
								            <option value="BUYER_ITEM_NO" <%="BUYER_ITEM_NO".equals(request.getParameter("searchType"))?"selected":""%>>품목코드</option>
								            <option value="DESCRIPTION"   <%="DESCRIPTION".equals(request.getParameter("searchType"))?"selected":""%>>품목명</option>
								            <option value="SPECIFICATION" <%="SPECIFICATION".equals(request.getParameter("searchType"))?"selected":""%>>규격</option>
								            <option value="MAKER_NAME"    <%="MAKER_NAME".equals(request.getParameter("searchType"))?"selected":""%>>제조사</option>
								            <option value="CATEGORY_NO"    <%="CATEGORY_NO".equals(request.getParameter("searchType"))?"selected":""%>>카테고리</option>
											<option value="AGENT"		  <%="AGENT".equals(request.getParameter("searchType"))?"selected":""%>>협력사</option>
								      </select>
							</td>
							<td> 
								<input type="text" name="searchText"   size="30"  class="input_type_text" value="<%=(searchText.equals("ALL") ? "" : searchText)%>" onKeyDown="if (event.keyCode == 13) javascript:kepSearch(1)">
                            </td>
                            <td></td>
						    <td>품목명</td>						 
							<td><input type="text" name="st_description" size="30"  class="input_type_text" value="<%=st_description %>" onKeyDown="if (event.keyCode == 13) javascript:kepSearch(1)">
							</td>
                            <td></td>
						    <td>규격</td>						 
							<td><input type="text" name="st_specification" size="30"  class="input_type_text" value="<%=st_specification %>" onKeyDown="if (event.keyCode == 13) javascript:kepSearch(1)">
							</td>							
						</tr>		
						<tr>
							<td>제조사
							</td>
							<td> 
								<input type="text" name="st_maker" size="30"  class="input_type_text" value="<%=st_maker %>" onKeyDown="if (event.keyCode == 13) javascript:kepSearch(1)">
                            </td>
                            <td></td>
						    <td>카테고리</td>						 
							<td><input type="text" name="st_categoty_name"  class="input_type_text" size="30"  value="<%=st_categoty_name %>" onKeyDown="if (event.keyCode == 13) javascript:kepSearch(1)">
							</td>
                            <td></td>
						    <td></td>						 
							<td>
							</td>							
						</tr>		
					</tbody>
				</table>
            </div>          
		
		 
 <% if (_cartInfo != null) { 
	 if (_cartInfo.size()>0){
		Map<String,String> rowCart = _cartInfo.get(0);
 
 
 %>
  <div class="fr"><b>
			 장바구니 <%=CommonUtil.formatNumber(rowCart.get("CNT"),true,0,3)%> 건 ,
			 토탈금액 <%=CommonUtil.formatNumber(rowCart.get("TOT_SUM"),true,0,3)%> 원  </b></div>		      	
			 <%}
	 }%>
	 
		 
                   <br>     
            
            
            
<table  style="width:100%">
	
 
	<tr>
	   <td height="4"></td>
	</tr>
	<tr>
	   <td height="20"><b>전체</b>&nbsp;&gt;
 <% if (_dataList3 != null) { 
	 if (_dataList3.size()>0){
		 Map<String,String> data3 = null;
		 for(int i=0; i < _dataList3.size(); i++){
		 data3 = _dataList3.get(i);
 
 
 %>
		   <b><%=data3.get("CATEG_NAME")%></b>&nbsp;&gt;&nbsp;
			 <%}
	 	}
	 }%>
	 

	   </td>
	</tr>
 



  <tr> 
    <td>



<table style="width:100%" class="cont_t_list02">
              <tr>
              <td rowspan="6" width="255">
					      <% if(rowData.get("IMGFILE_NAME").equals("")){ %>

						  <img src="/resources/images/noimage.gif" name = "image1" width="250" height="250">
							<input type="hidden" name="st_imgfile_dir" id="st_imgfile_dir"  value="">
							<input type="hidden" name="st_imgfile_name" id="st_imgfile_name"  value=""> 

						  <% }else { %>

							<img src="<%=CommonUtil.realImgS3UploadPath+"/"+rowData.get("IMGFILE_DIR")+"/"+rowData.get("IMGFILE_NAME")%>" name = "image1" width="250" height="250">
							<input type="hidden" name="st_imgfile_dir"  id="st_imgfile_dir" value="<%=rowData.get("IMGFILE_DIR")%>">
							<input type="hidden" name="st_imgfile_name" id="st_imgfile_name" value="<%=rowData.get("IMGFILE_NAME")%>">
						  <% } %>
          </td> 
          <td class="left" colspan="6">
           <b>&nbsp;&nbsp; &nbsp;&gt;&nbsp;&nbsp;&nbsp;<%=rowData.get("DESCRIPTION_LOC")%></b>
          </td>
        </tr>
        <tr> 
          <td width="9%">&nbsp;&nbsp;카테고리명</td>
          <td width="2%">:</td>
          <td class="left"  width="27%"><%=rowData.get("CATEGORY_TEXT")%></td>
          <td width="8%">단위</td>
          <td width="2%">:</td>
          <td class="left"  width="22%"><%=rowData.get("UNIT_MEASURE")%></td>	
        </tr>
        <tr>
          <td width="9%">&nbsp;&nbsp;제조사</td>
          <td width="2%">:</td> 
          <td class="left"  width="22%"><%=rowData.get("MAKER_NAME")%></td>
          <td width="8%">제조사모델No</td>
          <td width="2%">:</td>
          <td class="left"  width="22%"><%=rowData.get("MAKER_PART_NO")%></td>
        </tr>        
        <tr >
          <td width="9%">&nbsp;&nbsp;조달일수</td>
          <td width="2%">:</td>
          <td class="left"  width="27%"><%=rowData.get("DELIVERY_LT")%> 일</td>
          <td width="8%">원산지</td>
          <td width="2%">:</td>
          <td class="left"  width="22%"><%=rowData.get("ORIGIN")%></td>
        </tr>        
        <tr>
          <td width="9%">&nbsp;&nbsp;품목명</td>
          <td width="2%">:</td>
          <td colspan="4"><%=rowData.get("DESCRIPTION_LOC")%></td>
        </tr>        
        <tr >
          <td width="9%">&nbsp;&nbsp;규격</td>
          <td width="2%">:</td>
          <td class="left"  colspan="4"><%=rowData.get("SPECIFICATION")%></td>
        </tr>  
        <tr>
          <td width="26%" align="center" height="38">
              <a href="javascript:getBigImage('<%=rowData.get("IMGFILE_DIR")%>','<%=rowData.get("IMGFILE_NAME")%>')"><img src="/resources/images/zoom.gif" width="32" height="23" border="0"></a></td>
          <td width="4%">&nbsp;</td>
          <td colspan="5" align="right">&nbsp;</td>
        </tr>              
        </table>
     
     </td>
     </tr>
     </table>
     
     <br>
      <div class="scrollArea" style="height:200px;width:100%">
      
    <table  class="cont_t_list02"  style="width:100%">
 <% if (_dataList2 != null) { 
	 if (_dataList2.size()>0){
		 Map<String,String> rowData2 = null;
		 for(int i=0; i < _dataList2.size(); i++){
			  rowData2 = _dataList2.get(i);
			 
		 
       if( i == 0 ) {
%>
   
         <tr >
            <th width="2"></th>
            <th class="center" width="5%">선택</th><th width="1"></th>
            <th class="center"><%=rowData2.get("AGENT")%></th><th width="1"></th>
            <th class="center" width="10%"><%=rowData2.get("BUYER_ITEM_NO")%></th><th width="1"></th>
            <th class="center" width="10%"><%=rowData2.get("UNIT_PRICE")%></th><th width="1"></th>
            <th class="center" width="10%"><%=rowData2.get("REQ_CNT")%></th><th width="1"></th>
            <th class="center" width="10%"><%=rowData2.get("A1")%></th><th width="1"></th>
            <th class="center" width="10%"><%=rowData2.get("A2")%></th><th width="1"></th>
            <th class="center" width="10%"><%=rowData2.get("A3")%></th><th width="1"></th>
            <th class="center" width="10%"><%=rowData2.get("A4")%></th><th width="1"></th>
            <th class="center" width="10%"><%=rowData2.get("A5")%></th><th width="2"></th>
         </tr>
 
<%    } else { %>

         <tr>
            <td width="2">
                <input type="hidden" name="temp_contract_no"  value="<%=rowData2.get("CONTRACT_NO")%>">
                <input type="hidden" name="temp_contract_seq" value="<%=rowData2.get("CONTRACT_SEQ")%>">
                <input type="hidden" name="temp_agent_code"   value="<%=rowData2.get("AGENT_CODE")%>">
                <input type="hidden" name="temp_byit_comorg_code"   value="<%=rowData2.get("BYIT_COMORG_CODE")%>">
                <input type="hidden" name="temp_item_no"   value="<%=rowData2.get("BUYER_ITEM_NO")%>">
            </td>
            <td class="center"><input type="checkbox" name=lnCheck<%=i%> id="check"></td><td width="1"></td>
            <td>&nbsp;<a href="javascript:getAgentDisplayPop('<%=rowData2.get("AGENT_CODE")%>');"><%=rowData2.get("AGENT")%></a></td><td width="1"></td>
  <% if(byca_comorg_code.equals("KRDONGG004")) { %>
  <% //if(byca_comorg_code.equals("KRKEPBG001")) { %>
            <td class="center"><a href="javascript:setProxyByitDisplay('<%=buyer%>','<%=rowData2.get("BUYER_ITEM_NO")%>','<%=rowData2.get("CONTRACT_NO")%>','<%=rowData2.get("CONTRACT_SEQ")%>');"><%=rowData2.get("BUYER_ITEM_NO")%></a></td><td width="1"></td>
  <% }else { %>
            <td class="center"><%=rowData2.get("BUYER_ITEM_NO")%></td><td width="1"></td>
  <% } %>
            <td class="right"><%=CommonUtil.formatNumber(rowData2.get("UNIT_PRICE"),true,0,3)%>&nbsp;</td><td width="1"></td>
            <td class="center"><input type="text" name="st_temp_qty" size="5" class="input_type_text" id="text" value="0"></td><td width="1"></td>
            <td>&nbsp;&nbsp;<%=rowData2.get("A1")%></td> <td width="1"></td>
            <td>&nbsp;&nbsp;<%=rowData2.get("A2")%></td> <td width="1"></td>
            <td>&nbsp;&nbsp;<%=rowData2.get("A3")%></td> <td width="1"></td>
            <td>&nbsp;&nbsp;<%=rowData2.get("A4")%></td><td width="1"></td>
            <td>&nbsp;&nbsp;<%=rowData2.get("A5")%></td><td width="2"></td>
         </tr>
 
<%
 				}
     		}
     } 
	}
	 
%>  
         <tr>
          <td colspan="21" height="2"></td>
         </tr>
      </table>
<%	if (_dataList2 != null && _dataList2.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList2.size() %>" >
<%	}	%>
    </div>    
			
            		<!-- 버튼영역 -->
		<div class="btnArea">
		 <span class="btn_02 mr04" title="상품추가" > <a href="javascript:setItemAdd();">상품추가</a></span>
		            </div>
		               
  </div>
  </div>
</form> 
           

		 
</body>
</html>
