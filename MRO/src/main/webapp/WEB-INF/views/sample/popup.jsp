<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%> 
<!doctype html>
<html>
<head>
<%@include file="../common/include/head.jspf" %>
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />

</head>

<body>
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!--내용 시작-->		
<!--내용 시작-->	
<!--내용 시작-->	
<script>
	function setPopupReturn(value1,value2){
		$("#value1").val(value1);
		$("#value2").val(value2);
	}
	function setPopupCalendar(value1){
		//alert(value1);
		$("#value1").val(value1); 
		$("#value2").val("");
	}
   function setZipPopupReturn(value1,value2,value3,value4,value5){  
	   $("#value1").val(value1+value2+value3+value4); 
	   $("#value2").val("");
   }
   
   function opentest(){
	 
	  var co = $.cookie('popctrl_cookie');
	   if (co == null){
		   openSearchPopup("/common/viewPop2.do", "", "500,500,no");
	   }else{
		   alert("팝업 하루만 설정되어있습니다.");
	   }
	  
   }
   
   function opentest_clear(){
		 
	   $.cookie('popctrl_cookie',null);
	   alert("팝업 하루만 설정 초기화 완료");
		  
	   }   
</script>

<div id="ContArea">
  	<h3>팝업샘플 화면</h3>
            <!--조회영역-->               
				<div>
				<table border="1">
					<tr>
						<td><a href="javascript:openSearchPopup('/common/zipCodeSearchPop.do','','500,500,no')">우편번호</a></td>
						<td><a href="javascript:openSearchPopup('/common/countryCodePop.do','','500,500,no')">원산지(국가)</a></td>
						<td><a href="javascript:alert('test')">권한</a></td>
						<td><a href="javascript:openSearchPopup('/common/deptCodeAdminPop.do','','500,500,no')">부서</a></td>
						<td><a href="javascript:openSearchPopup('/common/agentRegMakerCodePop.do','','500,500,no')">Maker</a></td>
						<td><a href="javascript:openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code=KRKOLO0031','800,550,no')">회원사정보</a></td>
						<td><a href="javascript:openSearchPopup('/common/misUserSelectAllPop.do','','500,500,no')">고객사(사용자)정보</a></td>
						<td><a href="javascript:openSearchPopup('/common/safetyCompanyCodePop.do', '?COM_TYPE=B&multi_flag=M&safety_flag=undefined&save_flag=undefined','880,450,no')">고객사 정보</a></td>
						<td><a href="javascript:openSearchPopup('/common/companyCodePop.do','','880,450,no')">협력사 정보</a></td>
						<td><a href="javascript:openSearchPopup('/common/processTypePop.do','','500,500,no')">거래유형</a></td>
						<td><a href="javascript:openSearchPopup('/common/standardcatalogidPop.do','','700,500,no')">카탈로그</a></td>
						<td></td>
					</tr> 					
				   <tr>
						<td><a href="javascript:openSearchPopup('/coco/showCommonCoCoBudgetDepartmentCodePop.do','?st_com_code=KRKEPB0004&open=Y','500,500,no')">예산부서 코드 팝업</a></td>
						<td><a href="javascript:openSearchPopup('/coco/showCommonCoCoBudgetDepartmentCodeDiffPop.do','?st_com_code=KRKEPB0004&open=Y','500,500,no')">부서별계정 선택 팝업</a></td>
						<td><a href="javascript:openSearchPopup('/coco/showCommonCoCoTermChoicePop.do','?st_row=text&st_gubun_code=year','500,300,no')">기간선택</a></td>
						<td><a href="javascript:openSearchPopup('/common/delLocationPop.do','?com_code=KRKOLO0031','500,500,no')">도착지 정보</a></td>
						<td><a href="javascript:openSearchPopup('/coco/getCommonCoCoTeamClassifyPop.do','?st_nu_i=0','500,200,no');">담당팀구분</a></td>
						<td><a href="javascript:openSearchPopup('/none/showCommonNoNeBuyerChoiceMultiPop.do','?search_opt=0&disable_yn=N','1000,500,no');">고객사 검색 (구매사 다건 선택 팝업)</a></td>
						<td><a href="javascript:openSearchPopup('/mdcp/getMasterMdCpUserChoicePop.do','?st_buyer=KRKORE0001','500,500,no');">사용자 선택 팝업</a></td>
						<td><a href="javascript:openSearchPopup('/mpvo/getMasterMpVoVocProgressStatePop.do','?st_buyer=KRKOLO0031&st_vc_no=VC14000345','800,710,no');">VOC 진행현황 상세정보</a></td>
						<td><a href="javascript:openSearchPopup('/coco/getCommonCoCoBuyerCategoryChoiceTreePop.do','?st_buyer=KRKOLO0031','400,500,no');">고객사 카테고리 선택 ( 트리 형)</a></td>
						<td></td>
						<td></td>
						<td></td>
					</tr> 					
					<tr>
						<td><a href="javascript:openSearchPopup('/common/icomcdPop.do','?table=1','500,500,no')">ICOMCOD1 공통팝업</a></td>
						<td><a href="javascript:openSearchPopup('/common/icomcdPop.do','?table=2','500,500,no')">ICOMCOD2 공통팝업</a></td>
						<td><a href="javascript:openSearchPopup('/common/icomcdPop.do','?table=3','500,500,no')">ICOMCOD3 공통팝업</a></td>
						<td><a href="javascript:openSearchPopup('/common/icomcdPop.do','?table=4','500,500,no')">ICOMCOD4 공통팝업</a></td>
						<td><a href="javascript:openSearchPopup('/common/icomcdPop.do','?table=5','500,500,no')">ICOMCOD5 공통팝업</a></td>			
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td><a href="javascript:openSearchPopup('/coco/showCommonCoCoUserChoice2Pop.do','?1=1','1000,500,no')">사용자 선택 2</a></td>
						<td><a href="javascript:openSearchPopup('/common/calendarAndHourPop.do','','130,280,no')">마감일 시간</a></td>
						<td><a href="javascript:openSearchPopup('/common/calendarPop.do','','130,240,no')">달력</a></td>
					</tr> 
					<tr>
						<td><a href="javascript:openSearchPopup('/common/fileUploadPop.do','','500,430,no')">fileUpload</a></td>
						<td><a href="javascript:openSearchPopup('/common/excelUploadPop.do','','500,200,no')">excelUpload</a></td>
						<td><a href="javascript:openSearchPopup('/common/multiSamplePop.do','','500,500,no')">multiSample</a></td>
						<td><a href="javascript:openSearchPopup('/common/remarkPop.do','','500,310,no')">비고</a></td>
						<td><a href="javascript:openSearchPopup('/common/viewPop.do','','500,500,no')">일반view</a></td>
						<td></td> 
						<td></td>
						<td><a href="javascript:openSearchPopup('/coco/showCommonCoCoCatalogAlterPop.do','?1=1','1000,600,no')">고객사 카탈로그 조회 팝업</a></td>
						<td></td>
						<td></td>
						<td></td>
						<td><a href="javascript:openSearchPopup('/common/tableinfoPop.do','','800,500,no')">TABLE 정보</a></td>
					</tr> 					
					<tr>
						<td><a href="javascript:openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=B&MULTI=Y','500,466,no')">고객사 M</a></td>
						<td><a href="javascript:openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=Y','500,466,no')">협력사 M</a></td>
						<td><a href="javascript:openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=B&MULTI=N','500,466,no')">고객사 S</a></td>
						<td><a href="javascript:openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N','500,466,no')">협력사 S</a></td>
						<td><a href="javascript:openSearchPopup('/common/catalogDetailPop.do','?BUYER=KRSYMC0001&BUYER_ITEM_NO=HB-0054&CONTRACT_NO=PC03000001&CONTRACT_SEQ=000378','800,290,no')">품목(상품)코드</a></td>
						<td><a href="javascript:openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&safety_flag=Y','500,500,no')">고객사/협력사 선택</a></td> 
						<td><a href="javascript:openSearchPopup('/coco/getCommonCoCoStndrdCatalogSearchPop.do','?1=1','1000,800,no')">표준카달로그검색(CMS)(보류)</a></td>
						<td></td>
						<td></td>
						<td></td>
						<td><a href="javascript:opentest()">공지팝업 샘플</a></td>
						<td><a href="javascript:opentest_clear()">공지팝업 쿠키 초기화</a></td>
					</tr> 					
					<tr>
						<td><a href="javascript:openSearchPopup('/common/misUserSelectAllPop2.do','','500,500,no')">관리자용 사용자조회</a></td>
						<td><a href="javascript:openSearchPopup('/common/showAdminSafetyCompanyCodePop.do','?1=1','','880,450,no')">관리 고객사지정</a></td>
						<td><a href="javascript:openSearchPopup('/mpiv/showMasterMpIvUrgentManagementPop.do','?1=1','','800,500,no')">긴급납기</a></td>
						<td></td>
						<td><a href="javascript:openSearchPopup('/coco/showCommonCoCoVocBuyerReqCreateRegPop.do','?1=1','','600,600,no')">VOC요청</a></td>
						<td></td> 
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr> 								
				</table> 				
				<table border="1">
					<tr>
						<td>
							넘어온값 : <input type="text" class="input_type_text" name="value1"  id="value1"  value=""  size="50"/>
							/<input type="text" class="input_type_text" name="value2"  id="value2"  value=""  size="50"/>
						</td>
					</tr>
				</table>
				</div>
				
				<br>
				<h3>html-css ex 화면</h3>
				<table border="1" style="width:100%">
					<tr>
						<td><a href="/publish/b_pop_up_buyerSelect.html">고객사 선택</a></td>
						<td><a href="/publish/b_pop_up.html">고객사 팝업타이틀</a></td>
						<td><a href="/publish/b_pop_up1.html">고객사 상품정보</a></td>
						<td><a href="/publish/b_sub_cart.html">고객사 장바구니</a></td>
						<td><a href="/publish/b_sub_categoriproductssearch.html">고객사 카테고리상품검색</a></td>
					</tr>
					<tr>
						<td><a href="/publish/b_sub_grid.html">고객사 주문진행현황</a></td>
						<td><a href="/publish/b_sub_products_detail.html">고객사 상품상세정보</a></td>
						<td><a href="/publish/b_sub_searchResult.html">고객사 검색결과</a></td>
						<td><a href="/publish/buyer_main.html">고객사 main</a></td>
						<td><a href="/publish/buyer_pop_up.html">고객사 팝업</a></td>
					</tr>	
					<tr>
						<td><a href="/publish/buyer_sub_grid.html">고객사 주문진행현황</a></td>
						<td><a href="/publish/buyer_sub_notice_list.html">고객사 공지사항 list</a></td>
						<td><a href="/publish/buyer_sub_notice_view.html">고객사 공지사항 view</a></td>
						<td><a href="/publish/buyer_sub_notice_write.html">고객사 공지사항 write</a></td>
						<td><a href="/publish/c_carlendar.html">달력</a></td>
					</tr>		
					<tr>
						<td><a href="/publish/c_po_detail_pop.html">공통 발주상세정보</a></td>
						<td><a href="/publish/c_pop_up.html">공통 팝업타이틀</a></td>
						<td><a href="/publish/m_index.html">운영사 메인</a></td>
						<td><a href="/publish/m_pop_up_.html">운영사 협력사선택</a></td>
						<td><a href="/publish/m_pop_up_commoncategoridetail.html">운영사 표준 카탈로그 상세보기</a></td>
					</tr>		
					<tr>
						<td><a href="/publish/m_pop_up_kep.html">운영사 KeP 표준 카테고리 선택</a></td>
						<td><a href="/publish/m_pop_up_productlistonfo.html">운영사 품목정보</a></td>
						<td><a href="/publish/m_pop_up.html">운영사 팝업타이틀</a></td>
						<td><a href="/publish/m_sub_grid1.html">운영사 고객카드관리</a></td>
						<td><a href="/publish/m_sub_grid2.html">운영사 카탈로그등록</a></td>
					</tr>		
					<tr>
						<td><a href="/publish/m_sub_helpcompanyregisterinfo.html">운영사 협력사 등록관리</a></td>
						<td><a href="/publish/m_sub_notice_list.html">운영사 공지사항 list</a></td>
						<td><a href="/인blish/m_sub_notice_view.html">운영사 공지사항 view</a></td>
						<td><a href="/publish/m_sub_notice_write.html">운영사 공지사항 write</a></td>
						<td><a href="/publish/m_sub.html">운영사 표준 카탈로그 검색</a></td>
					</tr>		
					<tr>
						<td><a href="/publish/s_index.html">협력사 메인</a></td>
						<td><a href="/publish/s_pop_up.html">협력사 팝업타이틀</a></td>
						<td><a href="/publish/s_pop_up1.html">협력사 팝업타이틀1</a></td>
						<td><a href="/publish/s_sub_grid.html">협력사 제출견적 진행조회</a></td>
						<td><a href="/publish/s_sub_notice_list.html">협력사 공지사항 list</a></td>
					</tr>		
					<tr>
						<td><a href="/publish/s_sub_notice_view.html">협력사 공지사항 view</a></td>
						<td><a href="/publish/s_sub_notice_write.html">협력사 공지사항 write</a></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td><a href="/publish/s_sub_sitemap.html">s_sub_sitemap.html</a></td>
						<td><a href="/publish/b_sub_companyInfo.html">b_sub_companyInfo.html</a></td>
						<td></td>
						<td></td>
						<td></td> 
					</tr>							
					<tr>
						<td><a href="/publish/table_style.html">table 별 css 설명</a></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td> 
					</tr>					
				</table>
</div>
<!--내용 종료-->	                  
<!--내용 종료-->	                 
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
</html>
