<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String h_sslurl = CommonUtil.getSslURL(request, "http");
	String h_sslurl2 = CommonUtil.getSslURL(request, "https");
	String h_devReal = CommonUtil.getDevRealLocalFlag(request);
	String flag = CommonUtil.getDevRealLocalFlag(request);
	String httpurl ="";
	String httpsurl ="";
	
	//메뉴
	String navi = (String)request.getAttribute("navi");
	String naviArr[] = navi.split("@");
%>
<!--TOP bar-->
<body>
<form name="loginForm" method="post">
<div class="wrap">
	<section class="header">
      <h1><a href="<%=h_sslurl%>/main.do"><img src="/resources/imgs/logo.png" /></a></h1>
      <div class="Util">
        <ul>
<%--           <li>${sessionInfo.comNameLoc} ${sessionInfo.departmentName}</li> --%>
          <c:choose>
						<c:when test="${sessionInfo != null }">
						 
            			
          <li>최종접속 ${sessionInfo.lastLoginDate}</li>
          <li><button class="ButSmall_Outline" onclick="javascript:actionLogout();">로그아웃</button> <button class="ButSmall_Outline" onclick="location.href='<%=httpsurl%>/mdam/showSellerMdAmUserInfo.do'; return false;" >정보수정</button></li>
		  				</c:when>
						<c:otherwise> 
						</c:otherwise>
		  </c:choose>
        </ul>
	  </div>
    </section>
    	<!--메뉴부분-->
        <nav id="navBar">
        <div class="navigationBar">
		  <div class="navigation" >
		  	<ul class="MainMenu" id="MainMenu"></ul>
<!--             <div class="Menubar"> -->
<%--             	<%= request.getAttribute("menu") %> --%>
<!--             </div> -->
          	<div class="Menusub-layer" id="MenusubLayer">
              <div class="Menusub-inner" id="MenusubInner">
                <!-- JavaScript로 소메뉴 삽입 -->
              </div>
            </div>
          </div>
        </div>
       	</nav>
</div>     
</form>
</body>
	<!--TOP bar-->
<c:if test="${jqueryGbn ne 'Y' }">
	<script type="text/javascript" src="/resources/libs/jquery/js/jquery.superslide.2.1.1.js" ></script>
</c:if>
<script type="text/javascript">
<!--
	function actionLogin() {
		if (document.loginForm.userId.value == "") {
			alert("아이디를 입력하세요");
			return;
		} else if (document.loginForm.password.value == "") {
			alert("비밀번호를 입력하세요");
			return;
		} else {
			document.loginForm.action = "<%=httpsurl%>/login/login.do";
			document.loginForm.submit();
		}
	}

	function actionLogout() {
		document.loginForm.action = "/login/logout.do";
		document.loginForm.submit();
	}
	
	function kep_view_link(link){
		if (link.indexOf("#")>=0){
			return;
		}
		if (link.indexOf("showSellerMdCtMbrCmpyInfo") > 0){
			window.location.href = "<%=httpsurl%>"+link;
		}else{
			window.location.href = "<%=httpurl%>"+link;	
		}
	}
// 	const MainMenu = document.getElementById("MainMenu");
//     const MenusubLayer = document.getElementById("MenusubLayer");
//     const MenusubInner = document.getElementById("MenusubInner");
// 		const MainMenuTitles = [
// 		  "회원사관리", "상품관리", "견적관리", "납품관리",
// 		  "VMI 납품관리", "정산관리", "고객센터"
// 		];
		const MainMenuTitles = [
		              		 <%=naviArr[0]%>
		              		];
		
// 		const MainMenuLinks = [
// 		  "https://www.naver.com/", "/상품관리", "/견적관리", "/납품관리",
// 		  "/VMI 납품관리", "/정산관리", "/고객센터"
// 		];
		const MainMenuLinks = [
		                       <%=naviArr[1]%>
		             		];
		
		const MainMenuId = [
		                       <%=naviArr[2]%>
		             		];
		

//     const MenusubData = [
// 		  ["회원사정보", "사용자관리"],
// 		  ["상품정보관리", "이미지등록요청", "MSDS관리"],
// 		  ["견적관리", "재계약 제출", "벌크소싱"],
// 		  ["수주접수", "거래명세서", "납품현황"],
// 		  ["권고발주접수", "납품실적조회", "재고현황조회", "마감조회"],
// 		  ["정산관리"],  // 기존 children 삭제 후 일반 항목으로 변경
// 		  ["공지사항", "문의하기", "FAQ"]
// 		];
    	const MenusubData = [
								<%=naviArr[3]%>
               		];
		
// 		const MenuLinks = [
// 		  ["https://www.naver.com/", "#사용자관리"],
// 		  ["#상품정보관리", "#이미지등록요청", "#MSDS관리"],
// 		  ["#견적관리", "#재계약", "#벌크소싱"],
// 		  ["#수주접수", "#거래명세서", "#납품현황"],
// 		  ["#권고발주", "#납품실적", "#재고현황", "#마감조회"],
// 		  ["#정산관리"],
// 		  ["#공지사항", "#문의하기", "#FAQ"]
// 		];
		const MenuLinks = [
								<%=naviArr[4]%>
		         		];
		const MenuId = [
							<%=naviArr[5]%>
	         		];
		
		// 대메뉴 생성
		const MainMenu = document.getElementById("MainMenu");
		MainMenuTitles.forEach(function(title, idx){
		  const li=document.createElement("li");
		  li.dataset.index=idx;
		
		  const a=document.createElement("a");
// 		  a.href=MainMenuLinks[idx]+"?menuId="+MainMenuId[idx];
		  a.textContent=title;
		  li.appendChild(a);
		
		  MainMenu.appendChild(li);
		});
		
		// 서브메뉴 생성
		const MenusubInner=document.getElementById("MenusubInner");
		MenusubData.forEach(function(data, idx){
		  const group=document.createElement("div");
		  group.className="Menusub-group";
		  group.dataset.index=idx;
		
		  const title=document.createElement("div");
		  title.className="title";
		  title.textContent=MainMenuTitles[idx];
		  group.appendChild(title);
		
		  const ul=document.createElement("ul");
		  data.forEach(function(item, i){
			const li=document.createElement("li");
			const a=document.createElement("a");
			a.href=MenuLinks[idx][i]+"?menuId="+MenuId[idx][i];
			a.textContent=item;
			li.appendChild(a);
			ul.appendChild(li);
		  });
		  group.appendChild(ul);
		  MenusubInner.appendChild(group);
		});
		
		// 서브메뉴 열기/닫기
		const MenusubLayer=document.getElementById("MenusubLayer");
		const groups=document.querySelectorAll(".Menusub-group");
		let currentIndex=null;
		
		function openSubmenu(index){
		  groups.forEach(function(g){g.style.display="block"});
		  groups.forEach(function(g){g.querySelector("ul").classList.remove("active")});
		  groups[index].querySelector("ul").classList.add("active");
		
		  let maxHeight=0;
		  groups.forEach(function(g){if(g.scrollHeight>maxHeight) maxHeight=g.scrollHeight;});
		  MenusubLayer.style.height=maxHeight+"px";
		
		  document.querySelectorAll(".MainMenu li").forEach(function(li){li.classList.remove("active")});
		  document.querySelector('.MainMenu li[data-index=\"'+index+'\"]').classList.add("active");
		
		  currentIndex=index;
		}
		
		function closeSubmenu(){
		  MenusubLayer.style.height="0";
		  groups.forEach(function(g){g.querySelector("ul").classList.remove("active")});
		  document.querySelectorAll(".MainMenu li").forEach(function(li){li.classList.remove("active")});
		  currentIndex=null;
		}
		
		// 이벤트
		document.querySelectorAll(".MainMenu li").forEach(function(li){
		  li.addEventListener("mouseenter",function(){
			const index=li.dataset.index;
			openSubmenu(index);
		  });
		});
		
		// 서브메뉴 그룹 hover 시에도 대메뉴 active 상태 유지
		groups.forEach(function(group){
		  group.addEventListener("mouseenter", function(){
			const index = group.dataset.index;
		
			// 모든 ul 비활성화
			groups.forEach(function(g){g.querySelector("ul").classList.remove("active")});
			// 현재 그룹 ul 활성화
			group.querySelector("ul").classList.add("active");
		
			// 대메뉴 active 적용
			document.querySelectorAll(".MainMenu li").forEach(function(li){li.classList.remove("active")});
			document.querySelector('.MainMenu li[data-index=\"'+index+'\"]').classList.add("active");
		
			currentIndex = index;
		  });
		  
		  group.addEventListener("mouseleave", function(){
			if(currentIndex!==null){
			  groups[currentIndex].querySelector("ul").classList.add("active");
			}
		  });
		});	
		
		// 마우스가 서브메뉴 안에 있으면 닫지 않고 유지
		MenusubLayer.addEventListener("mouseenter", function(){
		  if(currentIndex!==null){
			groups.forEach(function(g){g.querySelector("ul").classList.remove("active")});
			groups[currentIndex].querySelector("ul").classList.add("active");
		  }
		});
		
		// 서브메뉴 영역 밖으로 벗어나면 닫기
		MenusubLayer.addEventListener("mouseleave", closeSubmenu);
		document.querySelectorAll(".MainMenu li").forEach(function(li){
		  li.addEventListener("mouseleave", function(e){
			const toElement = e.relatedTarget || e.toElement;
			if(!MenusubLayer.contains(toElement)){
			  closeSubmenu();
			}
		  });
		});
		
		
// 		// 소메뉴 생성
// 		MenusubData.forEach(function(data, idx){
// 		  const group = document.createElement("div");
// 		  group.className = "Menusub-group";
// 		  group.dataset.index = idx;
		
// 		  const title = document.createElement("div");
// 		  title.className = "title";
		
// 		  const titleLink = document.createElement("a");
// 		  titleLink.href = MainMenuLinks[idx] || "#";
// 		  titleLink.textContent = MainMenuTitles[idx];
// 		  titleLink.className = "navigationBar";
		
// 		  title.appendChild(titleLink);
// 		  group.appendChild(title);
		
// 		  const ul = document.createElement("ul");
// 		  data.forEach(function(item, itemIdx) {
// 			const li = document.createElement("li");
// 			const a = document.createElement("a");
// 			a.href = MenuLinks[idx][itemIdx] || "#";
// 			a.textContent = item;
// 			a.className = "navigationBar";
// 			li.appendChild(a);
// 			ul.appendChild(li);
// 		  });
// 		  group.appendChild(ul);
// 		  MenusubInner.appendChild(group);
// 		});

  
//     function activateMenu(index) {
//       document.querySelectorAll("#MainMenu li").forEach(function(el){ el.classList.remove("active")});
//       document.querySelectorAll(".Menusub-group").forEach(function(el){ el.classList.remove("highlight")});
//       document.querySelectorAll(".Menusub-group .title").forEach(function(el){ el.classList.remove("active")});
  
//       document.querySelector("#MainMenu li[data-index=\""+index+"\"]").classList.add("active");
//       const group = document.querySelector(".Menusub-group[data-index=\""+index+"\"]");
//       group.classList.add("highlight");
//       group.querySelector(".title").classList.add("active");
//     }
  
//     document.querySelectorAll("#MainMenu li").forEach(function(li){
//       li.addEventListener("mouseenter", function(){
//         const index = li.dataset.index;
//         MenusubLayer.classList.add("show");
//         activateMenu(index);
//       });
//     });
  
//     document.querySelectorAll(".Menusub-group").forEach(function(group) {
//       group.addEventListener("mouseenter", function() {
//         const index = group.dataset.index;
//         activateMenu(index);
//       });
//     });
  
//     document.body.addEventListener("mouseleave", function(){
//       MenusubLayer.classList.remove("show");
//       document.querySelectorAll("#MainMenu li").forEach(function(el){el.classList.remove("active")});
//       document.querySelectorAll(".Menusub-group").forEach(function(el){el.classList.remove("highlight")});
//       document.querySelectorAll(".Menusub-group .title").forEach(function(el){el.classList.remove("active")});
//     });
  
//     MenusubLayer.addEventListener("mouseleave", function(){
//       MenusubLayer.classList.remove("show");
//       document.querySelectorAll("#MainMenu li").forEach(function(el) {el.classList.remove("active")});
//       document.querySelectorAll(".Menusub-group").forEach(function(el) {el.classList.remove("highlight")});
//       document.querySelectorAll(".Menusub-group .title").forEach(function(el) {el.classList.remove("active")});
//     });
//-->
</script>
