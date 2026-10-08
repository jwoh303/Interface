<%--
**********************************************
* 메뉴 : 
* 화면 : 품목추가
* 기능 : 발주보류상태인 발주 상세팝업에서 품목을 추가하고자 하는 경우 품목검색하기 위한 팝업
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),""); // 현재페이지  (필수)
String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.



SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());


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
if(st_image_status.equals("")){
	st_image_status = "IMAGE_HIDDEN";
}
String px_no_tmp = "";
if (!"".equals(st_px_no) && st_px_no.length() > 2){
 px_no_tmp = st_px_no.substring(0,2);
}
%>

<script type="text/javascript">
<!--

function kepSearch(curPage)
{  
	
	document.forms.buyerMpPoGoodsAddPop.st_sort_gubun.value = '';
	document.forms.buyerMpPoGoodsAddPop.st_sort_change.value = '0';
	document.forms.buyerMpPoGoodsAddPop.curPage.value = curPage; 
    $('#buyerMpPoGoodsAddPop').attr("action", "/mppo/getBuyerMpPoGoodsAddPop.do").submit();    
}

//이미지 보이기 숨기기
function imageHideView(){ 
	
	 var tot_cnt  = $("#display_item_cnt").val();
	 if(typeof tot_cnt == 'undefined'){
		 return;
	 }
	
    var image_status   = $("#st_image_status").val();
    if(image_status == "IMAGE_HIDDEN"){
        image_status = "IMAGE_VIEW"; 
    }else if(image_status == "IMAGE_VIEW"){
        image_status = "IMAGE_HIDDEN"; 
    }
    $("#st_image_status").val(image_status);
    
	 // 처리후 재조회
	 kepSearch($("#curPage").val());
}


function sortChange(gubun){  
	
	
	document.forms.buyerMpPoGoodsAddPop.st_sort_gubun.value = gubun;

	if(document.forms.buyerMpPoGoodsAddPop.st_sort_change.value == '0'){
		document.forms.buyerMpPoGoodsAddPop.st_sort_change.value = '1';
	}else {
		document.forms.buyerMpPoGoodsAddPop.st_sort_change.value = '0';	
	}

	 // 처리후 재조회
	document.forms.buyerMpPoGoodsAddPop.curPage.value = '1'; 
	$('#buyerMpPoGoodsAddPop').attr("action", "/mppo/getBuyerMpPoGoodsAddPop.do").submit();    
}

 


 
function getBuyerCatalogDisplay(stdcateg_id,stdcatlg_id,byit_comorg_code,item_no, categ_code, key_flag, cart_status ){

 
    document.forms.buyerMpPoGoodsAddPop.st_stdcateg_id.value  = stdcateg_id;
    document.forms.buyerMpPoGoodsAddPop.st_stdcatlg_id.value  = stdcatlg_id;
    document.forms.buyerMpPoGoodsAddPop.st_byca_comorg_code.value  = byit_comorg_code;
    document.forms.buyerMpPoGoodsAddPop.st_buyer_item_no.value  = item_no;
    document.forms.buyerMpPoGoodsAddPop.st_categ_code.value  = categ_code;
    document.forms.buyerMpPoGoodsAddPop.st_key_flag.value  = key_flag;
    document.forms.buyerMpPoGoodsAddPop.st_cart_status.value  = cart_status;
    
	$('#buyerMpPoGoodsAddPop').attr("action", "/mppo/getBuyerMpPoGoodsAddDetailPop.do").submit();   
	
	
	/*
    alert("구현 필요???????????");
    return;

    document.forms[0].method = "POST";
    document.forms[0].action = "/kr/customer/categ_search/cate_search_item_add_detail.jsp?st_stdcateg_id="+stdcateg_id+"&st_stdcatlg_id="+stdcatlg_id+"&st_byca_comorg_code="+byit_comorg_code+"&cart_status="+cart_status+"&st_item_no="+item_no+"&st_image_status="+image_status+"&st_key_flag="+st_key_flag+"&st_px_no="+px_no;
    document.forms[0].submit();
    */
}


//품목 추가 
function setItemAdd(){
	
	
 var tot_cnt  = $("#display_item_cnt").val();

 var chk_cnt = 0; 
 var query   = "";

 if(tot_cnt == "0" || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
     alert(" 목록에 표시된 품목이 없습니다.     ");
     return;
 }

 if(eval(tot_cnt) < 2){
     var box = eval("document.forms.buyerMpPoGoodsAddPop.lnCheck0" );
     if(box.checked == true) chk_cnt++;
 }else{
     for(var j = 0; j < tot_cnt; j++){
          var box = eval("document.forms.buyerMpPoGoodsAddPop.lnCheck" + j);
          if(box.checked == true){
               chk_cnt++;
          }
     }
 }
 var st_key_flag = "";
 if(chk_cnt == "0"){
     alert(" 하나 이상의 품목이 선택되어야 합니다.   ");
     return;
 }else{
     if(eval(tot_cnt) < 2){
         var box = eval("document.forms.buyerMpPoGoodsAddPop.lnCheck0" );
         var order_qty     = document.forms.buyerMpPoGoodsAddPop.st_order_qty.value;

			if(box.checked == true){

             var st_agent_flag = document.forms.buyerMpPoGoodsAddPop.st_agent_flag.value;
             var st_dup_buyer_item_no = document.forms.buyerMpPoGoodsAddPop.st_dup_buyer_item_no.value;
             var key_flag      = st_agent_flag.substr(0,2);

             if(key_flag == "복수"){
                   st_key_flag = "Y";
             }else{
                   st_key_flag = "N";
             }
             
             if (st_dup_buyer_item_no != ""){
            	   alert( " 첫번째 품목 " + st_dup_buyer_item_no+"은 이미 장바구니에 담겨 있습니다. 확인 부탁드립니다.  "); 
                   return;
             }

             if(!chkDecimal(order_qty,3) || (eval(order_qty) ==0)){
                 alert( " 첫번째 품목 수량을 1 이상의 숫자 형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    ");
                 document.forms.buyerMpPoGoodsAddPop.st_order_qty.focus();
                 return;
             }
             if(st_key_flag == "Y"){
                 alert( " 품목구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 공급사를 선택해 주시기 바랍니다.     ");
                 box.checked = false;
                 return;
             }
         }
     }else{
         for(var i = 0; i < tot_cnt; i++){
       	  var box = eval("document.forms.buyerMpPoGoodsAddPop.lnCheck" + i );
             var order_qty     = document.forms.buyerMpPoGoodsAddPop.st_order_qty[i].value;

				if(box.checked == true){
                 var st_agent_flag = document.forms.buyerMpPoGoodsAddPop.st_agent_flag[i].value;
                 var st_dup_buyer_item_no = document.forms.buyerMpPoGoodsAddPop.st_dup_buyer_item_no[i].value;
                 var key_flag      = st_agent_flag.substr(0,2);

                 if(key_flag == "복수"){
                       st_key_flag = "Y";
                 }else{
                       st_key_flag = "N";
                 }
                 
                 if (st_dup_buyer_item_no != ""){
              	   alert( (i+1)+  "번째 품목 " + st_dup_buyer_item_no+"은 이미 장바구니에 담겨 있습니다. 확인 부탁드립니다.  "); 
                     return;
               }

					if(!chkDecimal(order_qty,3) || (eval(order_qty) ==0)){
						alert( (i+1)+  " 번째 품목 수량을 1 이상의 숫자 형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    ");
						document.forms.buyerMpPoGoodsAddPop.st_order_qty[i].focus();
                     return;
                 }
                 if(st_key_flag == "Y"){
                     alert( " 품목구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 공급사를 선택해 주시기 바랍니다.     ");
                     box.checked = false;
                     return;
                 }
             }
         }
     }
 }

 if(eval(tot_cnt) < 2){
	  var box = eval("document.forms.buyerMpPoGoodsAddPop.lnCheck0" );
      var st_item_no   = document.forms.buyerMpPoGoodsAddPop.st_item_no.value;
      var st_order_qty = document.forms.buyerMpPoGoodsAddPop.st_order_qty.value;
      //var st_agent     = document.forms.buyerMpPoGoodsAddPop.st_agent_code.value;
      var contract_no  = document.forms.buyerMpPoGoodsAddPop.st_contract_no.value;
      var contract_seq = document.forms.buyerMpPoGoodsAddPop.st_contract_seq.value;
      var byit_comorg_code = document.forms.buyerMpPoGoodsAddPop.st_byit_comorg_code.value;

      if(box.checked == true){
           query = st_item_no + "@@" + st_order_qty + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
      }
 }else{
     for(var k = 0; k < tot_cnt; k++){
    	  var box = eval("document.forms.buyerMpPoGoodsAddPop.lnCheck" + k );
          var st_item_no   = document.forms.buyerMpPoGoodsAddPop.st_item_no[k].value;
          var st_order_qty = document.forms.buyerMpPoGoodsAddPop.st_order_qty[k].value;
          //var st_agent     = document.forms.buyerMpPoGoodsAddPop.st_agent_code[k].value;
          var contract_no  = document.forms.buyerMpPoGoodsAddPop.st_contract_no[k].value;
          var contract_seq = document.forms.buyerMpPoGoodsAddPop.st_contract_seq[k].value;
          var byit_comorg_code = document.forms.buyerMpPoGoodsAddPop.st_byit_comorg_code[k].value;

          if(box.checked == true){
               query += st_item_no + "@@" + st_order_qty + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
          }
      }
 }

	if(!confirm("선택한 품목을 추가 하시겠습니까?")) return;

	document.forms.buyerMpPoGoodsAddPop.st_query2.value = query;
	kepAjaxFormCall("/mppo/saveSetItemAdd.do","buyerMpPoGoodsAddPop","SAVE"); 
	 
 //document.forms.buyerMpPoGoodsAddPop.action = "/kr/customer/shopping_cart/buyer_new_order_item_add.jsp";
 

}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	//var sMsg = response.msg.MSG;   
    if(pMethod == "SAVE"){ 
    	
    	
	    	var px_no = "<%=px_no_tmp%>";	// px_no가 PR , PX로 시작하는지 체크
			//var recv_flag = "<%=st_recv_flag%>";	// 홍익대학교
			if(recv_flag ="HI"){ 
				//top.opener.document.forms[0].st_query_cart.value = "ALL";
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
			if(!confirm("품목 추가가 완료 되었습니다.\n\n계속하여 품목을 추가하시겠습니까?")){
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
		alert("품목을 추가하는중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요");		
	} 
	
} 

//품목 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

function kepPopReload() {
	document.forms.buyerMpPoGoodsAddPop.searchType.value = "ALL";
	
	document.forms.buyerMpPoGoodsAddPop.searchText.value = "";
	document.forms.buyerMpPoGoodsAddPop.st_description.value = "";
	document.forms.buyerMpPoGoodsAddPop.st_specification.value = "";
	document.forms.buyerMpPoGoodsAddPop.st_maker.value = "";
	document.forms.buyerMpPoGoodsAddPop.st_categoty_name.value = "";
	
	kepSearch(-1);
}
 //-->
</script> 
<body onload="">
<form name="buyerMpPoGoodsAddPop" id="buyerMpPoGoodsAddPop" method=post >
<input type="hidden" name="st_px_no"		   value="<%=st_px_no%>">
<input type="hidden" name="st_verif_num"		   value="<%=st_px_no%>">
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


<input type="hidden" name="st_stdcateg_id"          value=""> 
<input type="hidden" name="st_stdcatlg_id"          value=""> 
<input type="hidden" name="st_byca_comorg_code"          value=""> 
<input type="hidden" name="st_item_no_content"          value=""> 
<input type="hidden" name="st_categ_code"          value=""> 
<input type="hidden" name="st_key_flag"          value="">
<input type="hidden" name="st_cart_status"          value="">  

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:780px;">
    	<div id="popHeader">
        	<h1 class="title">품목추가</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
     <div id="searchBtnA">
      <div class="fr">
       	<span class="btn_search" title="조회" ><a href="javascript:kepSearch(1)">조회</a></span> 
		<span class="btn_reset" title="초기화" ><a href="javascript:kepPopReload();">초기화</a></span>
		</div>
            </div>   
            <br><br>
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>품목추가 리스트</caption>
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
            <div>  
            <div class="fl">
            	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			      	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" onchange="javascript:kepSearch(1);">  
						<option <%=("10".equals(onepagerow) ? "selected" : "")%> value = "10">10건</option>
						<option <%=("15".equals(onepagerow) ? "selected" : "")%> value = "15">15건</option>
						<option <%=("20".equals(onepagerow) ? "selected" : "")%> value = "20">20건</option>
						<option <%=("25".equals(onepagerow) ? "selected" : "")%> value = "25">25건</option>
						<option <%=("50".equals(onepagerow)  ? "selected" : "")%> value = "50">50건</option> 
					</select>
		      	</span>&nbsp;
                <span class="btn_imghide">
                      <%  if(st_image_status.equals("IMAGE_HIDDEN")){   %>
      <a href="javascript:imageHideView();"  title="이미지보이기" >이미지보이기</a>
      <%  }else{   %>
      <a href="javascript:imageHideView();"  title="이미지감추기" >이미지감추기</a>
      <%  }   %> </span>		         </div>        	

 
 <% if (_cartInfo != null) { 
	 if (_cartInfo.size()>0){
		Map<String,String> rowCart = _cartInfo.get(0);
 
 
 %>
  <div class="fr"><b>
			 장바구니 <%=CommonUtil.formatNumber(rowCart.get("CNT"),true,0,3)%> 건 ,
			 토탈금액 <%=CommonUtil.formatNumber(rowCart.get("TOT_SUM"),true,0,3)%> 원  </b></div>		      	
			 <%}
	 }%>
      
                   </div>
                   <br>
           	<!--grid-->
            <div class="scrollArea" style="height:510px;width:100%">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>품목추가 리스트</caption>
                    <colgroup>
                    	<col width="5%" />
                    	<col width="10%" />  
                    	<col width="*" /> 
                        <col width="15%" /> 
                        <col width="20%" /> 
                        <col width="10%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.buyerMpPoGoodsAddPop.display_item_cnt.value,document.forms.buyerMpPoGoodsAddPop.check_status,'document.forms.buyerMpPoGoodsAddPop.lnCheck');">
                            <th scope="col"></th>  
                            <th scope="col"><a href="javascript:sortChange('BUYER_ITEM_NO')" >품목코드</a> / <a href="javascript:sortChange('DESCRIPTION')" >품목명</a> / <a href="javascript:sortChange('SPECIFICATION')" >규격</a></th> 
                            <th scope="col">원산지/<a href="javascript:sortChange('MAKER_NAME')">제조사</a></th> 
                            <th scope="col">구매수량/단위/<a href="javascript:sortChange('AGENT')">협력사</a></th>
                            <th scope="col">단가</th>  
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="15" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
	Map<String,String> rowData =  null;
for (int j=0; j<_dataList.size(); j++) {
	 rowData = _dataList.get(j);
	String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
	
%> 
              <tr bgcolor="<%=tclass%>">
          <td class="center"><input type="checkbox" name=lnCheck<%=j%> id="check"></td>
                    <td title="이미지" >
                    
<% if(st_image_status.equals("IMAGE_HIDDEN")){
       if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
           <img src="/resources/images/but_img_off.gif" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
             <img src="/resources/images/but_img_on.gif" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%> 
 
<%     }
    }else{
    	 if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>" name="image1" width="80" height="80" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }
    }
%>		 
                    </td>
          <td class="left"><div title="품목코드" ><a class="hyperLink"  href="javascript:getBuyerCatalogDisplay('<%=rowData.get("STDCATEG_ID")%>','<%=rowData.get("STDCATLG_ID")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("ORG_BUYER_ITEM_NO")%>','<%=rowData.get("CATEGORY_NO")%>', '<%=rowData.get("AGENT")%>','CATA');"><%=rowData.get("BUYER_ITEM_NO")%>
              <input type="hidden" name="st_item_no" value="<%=rowData.get("ORG_BUYER_ITEM_NO")%>" >
              <input type="hidden" name="st_dup_buyer_item_no" value="<%=rowData.get("DUP_BUYER_ITEM_NO")%>" >
              <span title="품목명" ><%=rowData.get("DESCRIPTION_LOC")%></span></a></div>
            <div title="규격" ><%=rowData.get("SPECIFICATION")%>
              <% if(rowData.get("OVER_SHORT_FLAG").equals("N")) { %>
              <% } else { %>
              <br>
              <font color="green">(재 판매일 :<%=CommonUtil.formatStrinigDate(rowData.get("HS_NO"))%>)</font>
              <% } %>
            </div></td>
          <td><div title="원산지" ><%=rowData.get("ORIGIN_NAME")%></div>
            <div title="제조사" ><%=rowData.get("MAKER_NAME")%> <%=("KRMYUN0046".equals(com_code) ? "/"+rowData.get("DELIVERY_LT") +"일"  : "")%></div></td>
          <td align="center"><div title="구매수량" >
              <input type="text"  name="st_order_qty" size="7" value="0" id="line" class="input_type_text" style="text-align:right">
              <input type="text"  name="st_unit_measure" size="4" value="<%=rowData.get("UNIT_MEASURE")%>" style="background-color:<%=tclass%>;font-size:9pt;border:<%=tclass%> 1px solid;">
            </div>
            <!-- 검색엔진 SQL문에서 한글 미지원으로 수정 , (복수공급사입니다 ==> MULTI_AGENT) , (코리아e플랫폼(주) ==> KOREAEPLATFORM)  수정함 -->
            <% if(rowData.get("AGENT").equals("복수협력사입니다")) { %>
            <div title="협력사" >&nbsp;<%=rowData.get("AGENT")%></div>
            <% }else { %>
            <div title="협력사" >&nbsp;<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT2")%>');"><%=rowData.get("AGENT")%></a>
              <% } %>
              <!-- 검색엔진 SQL문에서 한글 미지원으로 수정 , (복수공급사입니다 ==> MULTI_AGENT) , (코리아e플랫폼(주) ==> KOREAEPLATFORM)  수정함 -->
              <input type="hidden" name="st_agent_flag"   value="<%=rowData.get("AGENT")%>">
              <input type="hidden" name="st_agent_code"   value="<%=rowData.get("AGENT2")%>">
              <input type="hidden" name="st_contract_no"  value="<%=rowData.get("CONTRACT_NO")%>">
              <input type="hidden" name="st_contract_seq" value="<%=rowData.get("CONTRACT_SEQ")%>">
              <input type="hidden" name="st_byit_comorg_code" value="<%=rowData.get("BUYER")%>">
            </div></td> 
            <td class="right"  title="단가" ><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>&nbsp;&nbsp;&nbsp;</td>
 
                        </tr> 
 			<%
                        } 
        			}
            %>                           
                    </tbody>
                </table>     
<%	if (_dataList != null && _dataList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
<%	}	%>
        </div>
                        
                		<!-- 페이징 -->
		<p class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
				<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
		</p>  
			
        		<!-- 버튼영역 -->
		<div class="btnArea">
		 <span class="btn_02 mr04" title="품목추가" > <a href="javascript:setItemAdd();">확인</a></span>
		            </div>
		            
    </div>        
</div>
</form> 
</body>
</html>
