<%@page contentType="text/html;charset=utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />	
<title>IBSheet7-Product</title>
<link rel="stylesheet" href="../common/css/style.css"/>
<script type="text/javascript" src="../common/js/public.js"></script>

    
<script type="text/javascript">
	$(function() {
		$("#tree").treeview({
			collapsed: false,
			animated: "medium",
			control:"#sidetreecontrol",
			persist: "location"
		});
	})
</script>
	
</head>

<body scroll="no" style="overflow: hidden">


    
	
		<div id="navigation" class="bg_sub">
        
            <div id="leftmenu">
            

              <div class="depth2_box"  id="menu_id">
                <div class="depth2">
                
                		<h2>Chart</h2>
                        <div id="sidetree">
                        
                                <div id="sidetreecontrol"  class="function"><a href="?#">+ 접기</a>  <a href="?#">- 풀기</a></div>
                                
                                <ul id="tree">
                                    <li><a href=""><strong>차트 유형</strong></a>
                                        <ul>
                                            <li><a href="./01_chartType/chartType.jsp"  target="i_content">차트 타입</a></li>
                                        </ul>
                                    </li>
                                    <li><a href=""><strong>차트 조회</strong></a>
                                        <ul>
                                            <li><a href="./02_chartdata/chart01.jsp"  target="i_content">xml 조회</a></li>
                                            <li><a href="./02_chartdata/chart02.jsp"  target="i_content">json 조회</a></li>
                                            <li><a href="./02_chartdata/chart03.jsp"  target="i_content">Big Decimal 조회</a></li>
                                        </ul>
                                    </li>
                                    <li><a href=""><strong>시트와 연동</strong></a>
                                        <ul>
                                            <li><a href="./03_sheet2chart/sheet2chart1.jsp"  target="i_content">시트와 연동1</a></li>
                                            <li><a href="./03_sheet2chart/sheet2chart2.jsp"  target="i_content">시트와 연동2</a></li>
                                            <li><a href="./03_sheet2chart/sheet2chart3.jsp"  target="i_content">시트와 연동3</a></li>
                                            
                                        </ul>
                                    </li>
                                    <!--
                                    <li><a href=""><strong>복합유형 차트</strong></a>
                                        <ul>
                                            <li><a href="./04_multitype/multichart1.jsp"  target="i_content">막대와 꺽은선</a></li>
                                        </ul>
                                    </li>
                                    -->
                                    <li><a href=""><strong>차트개발 실습</strong></a>
                                        <ul>
                                            <li><a href="./05_practice/practice1.jsp"  target="i_content">차트생성</a></li>
                                            <li><a href="./05_practice/practice2.jsp"  target="i_content">타이틀 설정</a></li>
                                            <li><a href="./05_practice/practice3.jsp"  target="i_content">데이터 조회</a></li>
                                            <li><a href="./05_practice/practice4.jsp"  target="i_content">범례설정</a></li>
                                            <li><a href="./05_practice/practice5.jsp"  target="i_content">X,Y 축</a></li>
                                            <li><a href="./05_practice/practice6.jsp"  target="i_content">2개 Y축</a></li>
                                            <!--
                                            <li><a href="./05_practice/practice6.jsp"  target="i_content">툴팁 설정</a></li>
                                            <li><a href="./05_practice/practice7.jsp"  target="i_content">레이블 설정</a></li>
                                            <li><a href="./05_practice/practice7.jsp"  target="i_content">Grid 설정</a></li>
                                            -->
                                        </ul>
                                    </li>
                                    
                                    
                                    
                                    
                                    <li><a href=""><strong>차트 템플릿</strong></a>
                                        <ul>
                                            <li><a href="./06_template/template.jsp"  target="i_content">템플릿</a></li>
                                            
                                        </ul>
                                    </li>
                                    
                                </ul>
                           </div>
                        	<!--slidetree-->
                        </div>
                        <!--depth2-->
                    </div>
                    <!--2depth-->
                 </div>
                <!--//leftmenu-->
            </div>
            <!--//navigation-->
        
        <div id="content">
            <iframe frameborder=0 src="./01_chartType/chartType.jsp" width="100%" height="100%" name="i_content" id="i_content" scrolling="auto"></iframe> 
        </div>
    <!--content-->

</body>
</html>








