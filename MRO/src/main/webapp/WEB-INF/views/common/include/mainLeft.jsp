<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String sslurl = CommonUtil.getSslURL(request, "http");
	String sslurl2 = CommonUtil.getSslURL(request, "https");
%>
	<input type="hidden"  name="subNo" id="subNo" value="${param.subNo}"/>
	<input type="hidden"  name="pageNo" id="pageNo" value="${param.pageNo}"/>
	<div id="sub01" class="SubLeft" style="display:none;">
		<div class="SubTitle">회사소개</div>
			<div class="SubMenuList">
				<ul>
					<li><a href="javascript:MovePage('<%=sslurl%>','01', '01');">CEO메세지  <img src="/resources/images/main/br_List.gif" id="page01_01" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','01', '02');">개요  <img src="/resources/images/main/br_List.gif" id="page01_02" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','01', '03');">연혁  <img src="/resources/images/main/br_List.gif" id="page01_03" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','01', '04');">동반성장활동  <img src="/resources/images/main/br_List.gif" id="page01_04" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','01', '05');">사회공헌활동  <img src="/resources/images/main/br_List.gif" id="page01_05" alt="" style="display:none;"></a></li>
					<li><a href="http://www.ekdp.com/ethics/main/main.asp" target="_blank">윤리경영</a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','01', '06');">채용정보  <img src="/resources/images/main/br_List.gif" id="page01_06" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','01', '07');">오시는길  <img src="/resources/images/main/br_List.gif" id="page01_07" alt="" style="display:none;"></a></li>
				</ul>
			</div>
	</div>
	
	<div id="sub02" class="SubLeft" style="display:none;">
		<div class="SubTitle">사업소개</div>
			<div class="SubMenuList">
				<ul>
					<li><a href="javascript:MovePage('<%=sslurl%>','02', '01');">사업모델  <img src="/resources/images/main/br_List.gif" id="page02_01" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','02', '02');">MRO특징  <img src="/resources/images/main/br_List.gif" id="page02_02" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','02', '03');">제공가치  <img src="/resources/images/main/br_List.gif" id="page02_03" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','02', '04');">구매대행소개  <img src="/resources/images/main/br_List.gif" id="page02_04" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','02', '05');">건설MRO소개  <img src="/resources/images/main/br_List.gif" id="page02_05" alt="" style="display:none;"></a></li>
				</ul>
			</div>
	</div>
	
	<div id="sub03"  class="SubLeft" style="display:none;">
		<div class="SubTitle">이용안내</div>
			<div class="SubMenuList">
				<ul>
					<li><a href="javascript:MovePage('<%=sslurl%>','03', '01');">FAQ  <img src="/resources/images/main/br_List.gif" id="page03_01" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','03', '03');">Q&A  <img src="/resources/images/main/br_List.gif" id="page03_03" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl%>','03', '04');">계약서류다운로드  <img src="/resources/images/main/br_List.gif" id="page03_04" alt="" style="display:none;"></a></li>
					<li><a href="http://113366.com/koreab2b" target="_blank">원격지원서비스  <img src="/resources/images/main/br_List.gif" id="page03_05" alt="" style="display:none;"></a></li>
				</ul>
			</div>
	</div>
	
	<div id="sub04"  class="SubLeft" style="display:none;">
		<div class="SubTitle">정보안내</div>
			<div class="SubMenuList">
				<ul>
					<li><a href="javascript:MovePage('<%=sslurl%>','04', '01');">공지사항 <img src="/resources/images/main/br_List.gif" id="page04_01" alt="" style="display:none;"></a></li>
					<!-- <li><a href="javascript:MovePage('<%=sslurl%>','04', '02');">E-Biz뉴스  <img src="/resources/images/main/br_List.gif" id="page04_02" alt="" style="display:none;"></a></li> -->
					<!--li><a href="javascript:MovePage('<%=sslurl%>','04', '03');">품목담당자  <img src="/resources/images/main/br_List.gif" id="page04_03" alt="" style="display:none;"></a></li-->
					<!-- <li><a href="javascript:MovePage('<%=sslurl%>','04', '04');">고객회원사  <img src="/resources/images/main/br_List.gif" id="page04_04" alt="" style="display:none;"></a></li> -->
				</ul>
			</div>
	</div>
	
	<div id="sub05"  class="SubLeft" style="display:none;">
		<div class="SubTitle">ID/PW찾기</div>
			<div class="SubMenuList">
				<ul>
					<li><a href="javascript:MovePage('<%=sslurl2%>','05', '03_1');">아이디찾기  <img src="/resources/images/main/br_List.gif" id="page05_03_1" alt="" style="display:none;"></a></li>
					<li><a href="javascript:MovePage('<%=sslurl2%>','05', '03_2');">비밀번호찾기  <img src="/resources/images/main/br_List.gif" id="page05_03_2" alt="" style="display:none;"></a></li>
				</ul>
			</div>
	</div>
	
	<div id="subNone"  class="SubLeft" style="display:none;">
        	<div class="SubTitle">회원가입</div>
            <div class="SubMenuList">
                <ul>
                </ul>
            </div>
        </div>
	
	<div class="BusinessProcess"><a href="#" onClick="poptype17('<%=sslurl%>');"><img src="/resources/images/main/BusinessProcess.gif" alt="업무처리 프로세스"></a></div>
<script type="text/javascript">
var topmenu = $("#subNo").val(); 
var submenu = $("#pageNo").val(); 

//메뉴선택 함수  
function menu_select(){  
  //탑메뉴 보이기  
  
  if(topmenu != null){  
     var target = "#sub"+topmenu;
     $(target).show();
     
     if(submenu != null){
   	  var sub_target ="#page"+topmenu+"_"+submenu;
   	  //alert(sub_target);
   	  $(sub_target).show();
     }
  } 
} 
menu_select();
</script>	
