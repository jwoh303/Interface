<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
</head>
<body> 
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
   <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB25.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">공고</p>
            	<p>B2B시장의 플랫폼 비즈니스 리더</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList01">
            	<ul>
            		<a href="javascript:MovePage_2016('<%=httpurl%>','01', '01');"><li>CEO메시지</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '02');"><li>개요</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '03');"><li>연혁</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '04');"><li>비전</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '06');"><li class="subtabOn">공고</li></a><a href="http://www.ekdp.com/ethics/main/main.asp" target="_blank"><li>윤리경영</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '05');"><li>오시는길</li></a>
                </ul>   
            </div>
        </div>
        
<style>
.list05_Expand, .list05_Close{ height:60px; border-bottom:1px solid #ced1d3; font-size:12px; position:relative; cursor: pointer}
.list05_Expand p, .list05_Close p{ display:inline-block; margin-left:30px; font-size:18px; line-height:60px; font-weight:700 }
.list05_Expand .downloadimg{ position:absolute; width:160px; height:36px; line-height:36px; text-align:center; font-size:15px;border:1px solid #dcdcdc; border-radius:50px;right:20px;  margin-left:0px; margin-top:12px; background-color:#eee}
.list05_Close  .downloadimg{ position:absolute; width:160px; height:36px; line-height:36px; text-align:center; font-size:15px;border:1px solid #dcdcdc; border-radius:50px;right:20px;  margin-left:0px; margin-top:12px; background-color:#fff}
.list05_Expand img, .list05_Close img{ width:27px; height:27px; padding-top:7px; }
.list05_Expand{ width:100%; height:60px; text-align:left; background-color:#fff; }
.list05_Close { width:100%; height:60px; background-color:#eee;}

.list04_Expand, .list04_Close{ height:60px; border-bottom:1px solid #ced1d3; font-size:12px; position:relative; cursor: pointer}
.list04_Expand p, .list04_Close p{ display:inline-block; margin-left:30px; font-size:18px; line-height:60px; font-weight:700 }
.list04_Expand .downloadimg{ position:absolute; width:160px; height:36px; line-height:36px; text-align:center; font-size:15px;border:1px solid #dcdcdc; border-radius:50px;right:20px;  margin-left:0px; margin-top:12px; background-color:#eee}
.list04_Close  .downloadimg{ position:absolute; width:160px; height:36px; line-height:36px; text-align:center; font-size:15px;border:1px solid #dcdcdc; border-radius:50px;right:20px;  margin-left:0px; margin-top:12px; background-color:#fff}
.list04_Expand img, .list04_Close img{ width:27px; height:27px; padding-top:7px; }
.list04_Expand{ width:100%; height:60px; text-align:left; background-color:#fff; }
.list04_Close { width:100%; height:60px; background-color:#eee;}
.list03_Expand, .list03_Close{ height:60px; border-bottom:1px solid #ced1d3; font-size:12px; position:relative; cursor: pointer}
.list03_Expand p, .list03_Close p{ display:inline-block; margin-left:30px; font-size:18px; line-height:60px; font-weight:700 }
.list03_Expand .downloadimg{ position:absolute; width:160px; height:36px; line-height:36px; text-align:center; font-size:15px;border:1px solid #dcdcdc; border-radius:50px;right:20px;  margin-left:0px; margin-top:12px; background-color:#eee}
.list03_Close  .downloadimg{ position:absolute; width:160px; height:36px; line-height:36px; text-align:center; font-size:15px;border:1px solid #dcdcdc; border-radius:50px;right:20px;  margin-left:0px; margin-top:12px; background-color:#fff}
.list03_Expand img, .list03_Close img{ width:27px; height:27px; padding-top:7px; }
.list03_Expand{ width:100%; height:60px; text-align:left; background-color:#fff; }
.list03_Close { width:100%; height:60px; background-color:#eee;}
.list02_Expand, .list02_Close{ height:60px; border-bottom:1px solid #ced1d3; font-size:12px; position:relative; cursor: pointer}
.list02_Expand p, .list02_Close p{ display:inline-block; margin-left:30px; font-size:18px; line-height:60px; font-weight:700 }
.list02_Expand .downloadimg{ position:absolute; width:160px; height:36px; line-height:36px; text-align:center; font-size:15px;border:1px solid #dcdcdc; border-radius:50px;right:20px;  margin-left:0px; margin-top:12px; background-color:#eee}
.list02_Close  .downloadimg{ position:absolute; width:160px; height:36px; line-height:36px; text-align:center; font-size:15px;border:1px solid #dcdcdc; border-radius:50px;right:20px;  margin-left:0px; margin-top:12px; background-color:#fff}
.list02_Expand img, .list02_Close img{ width:27px; height:27px; padding-top:7px; }
.list02_Expand{ width:100%; height:60px; text-align:left; background-color:#fff; }
.list02_Close { width:100%; height:60px; background-color:#eee;}
.list01_Expand, .list01_Close{ height:60px; border-bottom:1px solid #ced1d3; font-size:12px; position:relative; cursor: pointer}
.list01_Expand p, .list01_Close p{ display:inline-block; margin-left:30px; font-size:18px; line-height:60px; font-weight:700 }
.list01_Expand .downloadimg{ position:absolute; width:160px; height:36px; line-height:36px; text-align:center; font-size:15px;border:1px solid #dcdcdc; border-radius:50px;right:20px;  margin-left:0px; margin-top:12px; background-color:#eee}
.list01_Close  .downloadimg{ position:absolute; width:160px; height:36px; line-height:36px; text-align:center; font-size:15px;border:1px solid #dcdcdc; border-radius:50px;right:20px;  margin-left:0px; margin-top:12px; background-color:#fff}
.list01_Expand img, .list01_Close img{ width:27px; height:27px; padding-top:7px; }
.list01_Expand{ width:100%; height:60px; text-align:left; background-color:#fff; }
.list01_Close { width:100%; height:60px; background-color:#eee;}
</style>
<script type="text/javascript">
// list05
$(document).ready(function(){
    $('#list05_Btn').click(function(){
        if($("#list05_hidden").is(":visible")){
            $("#list05_Btn").toggleClass("list05_Expand list05_Close");
            $("#list05_hidden").slideUp();
        }else{
            $("#list05_Btn").toggleClass("list05_Close list05_Expand");
        $("#list05_hidden").slideDown();
        }
    });
});
// list04
$(document).ready(function(){
    $('#list04_Btn').click(function(){
        if($("#list04_hidden").is(":visible")){
            $("#list04_Btn").toggleClass("list04_Expand list04_Close");
            $("#list04_hidden").slideUp();
        }else{
            $("#list04_Btn").toggleClass("list04_Close list04_Expand");
        $("#list04_hidden").slideDown();
        }
    });
});
// list03
$(document).ready(function(){
    $('#list03_Btn').click(function(){
        if($("#list03_hidden").is(":visible")){
            $("#list03_Btn").toggleClass("list03_Expand list03_Close");
            $("#list03_hidden").slideUp();
        }else{
            $("#list03_Btn").toggleClass("list03_Close list03_Expand");
        $("#list03_hidden").slideDown();
        }
    });
});
// list02
$(document).ready(function(){
    $('#list02_Btn').click(function(){
        if($("#list02_hidden").is(":visible")){
            $("#list02_Btn").toggleClass("list02_Expand list02_Close");
            $("#list02_hidden").slideUp();
        }else{
            $("#list02_Btn").toggleClass("list02_Close list02_Expand");
        $("#list02_hidden").slideDown();
        }
    });
});
// list01
$(document).ready(function(){
    $('#list01_Btn').click(function(){
        if($("#list01_hidden").is(":visible")){
            $("#list01_Btn").toggleClass("list01_Expand list01_Close");
            $("#list01_hidden").slideUp();
        }else{
            $("#list01_Btn").toggleClass("list01_Close list01_Expand");
        $("#list01_hidden").slideDown();
        }
    });
});
</script> 
        
        <div class="subcontent">
            <div class="sub01_01summary">
            	<p class="subcontentTit" >공고</p>
            </div>
            <div style="border-top:2px solid #4b4948; min-height:280px ">
                  <!--2026.03.27-->
                <div id="list05_Btn" class="list05_Expand" > 
                    <p style=" width:140px; border-right:1px solid #dcdcdc">2026.03.27 </p>
                    <p> 2025년 결산 공고  </p>
                    <a href="/resources/images/2016/결산공고_코리아이플랫폼_2025년.pdf" target="_blank" class="downloadimg">PDF 다운로드 <img src="/resources/images/2016/download_file.png" /> </a>
                </div>  
                <div id="list05_hidden" style="display:none; width:100%; border-bottom:1px solid #ced1d3; text-align:center    "> 
                    <div style=" width:95%; margin:0 auto; margin-top:30px; margin-bottom:30px; text-align:center; font-size:18px;  line-height:30px; letter-spacing:-0.5px ">
                    <img src="/resources/images/2016/invest_202603.jpg" />
                    </div>
                </div>
                <!--2026.03.27 end-->              
               <!--2025.03.27-->
                <div id="list04_Btn" class="list04_Expand" > 
                    <p style=" width:140px; border-right:1px solid #dcdcdc">2025.03.27 </p>
                    <p> 2024년 결산 공고  </p>
                    <a href="/resources/images/2016/결산공고_코리아이플랫폼_2024년.pdf" target="_blank" class="downloadimg">PDF 다운로드 <img src="/resources/images/2016/download_file.png" /> </a>
                </div>  
                <div id="list04_hidden" style="display:none; width:100%; border-bottom:1px solid #ced1d3; text-align:center    "> 
                    <div style=" width:95%; margin:0 auto; margin-top:30px; margin-bottom:30px; text-align:center; font-size:18px;  line-height:30px; letter-spacing:-0.5px ">
                    <img src="/resources/images/2016/invest_202503.jpg" />
                    </div>
                </div>
                <!--2025.03.27 end-->

               <!--2024.03.27-->
                <div id="list03_Btn" class="list03_Expand" > 
                    <p style=" width:140px; border-right:1px solid #dcdcdc">2024.03.27 </p>
                    <p> 2023년 결산 공고  </p>
                    <a href="/resources/images/2016/결산공고_코리아이플랫폼_2023년.pdf" target="_blank" class="downloadimg">PDF 다운로드 <img src="/resources/images/2016/download_file.png" /> </a>
                </div>  
                <div id="list03_hidden" style="display:none; width:100%; border-bottom:1px solid #ced1d3; text-align:center    "> 
                    <div style=" width:95%; margin:0 auto; margin-top:30px; margin-bottom:30px; text-align:center; font-size:18px;  line-height:30px; letter-spacing:-0.5px ">
                    <img src="/resources/images/2016/invest_202403.jpg" />
                    </div>
                </div>
                <!--2024.03.27 end-->
                <!--2023.03.28-->
                <div id="list02_Btn" class="list02_Expand" > 
                    <p style=" width:140px; border-right:1px solid #dcdcdc">2023.03.28 </p>
                    <p> 2022년 결산 공고  </p>
                    <a href="/resources/images/2016/결산공고_코리아이플랫폼_2022년.pdf" target="_blank" class="downloadimg">PDF 다운로드 <img src="/resources/images/2016/download_file.png" /> </a>
                </div>  
                <div id="list02_hidden" style="display:none; width:100%; border-bottom:1px solid #ced1d3; text-align:center    "> 
                    <div style=" width:95%; margin:0 auto; margin-top:30px; margin-bottom:30px; text-align:center; font-size:18px;  line-height:30px; letter-spacing:-0.5px ">
                    <img src="/resources/images/2016/invest_202303.jpg" />
                    </div>
                </div>
                <!--2023.03.28 end-->
                <!--2022.02.28-->
                <div id="list01_Btn" class="list01_Expand" > 
                    <p style=" width:140px; border-right:1px solid #dcdcdc">2022.02.28 </p>
                    <p>외부감사인 선임 공고</p>
                </div>  
                <div id="list01_hidden" style="display:none; width:100%; border-bottom:1px solid #ced1d3; text-align:center     "> 
                   <div style=" width:95%; margin:0 auto; padding: 40px 0px;margin-top:30px; margin-bottom:30px; text-align:center; font-size:18px;  border:1px solid #747474; line-height:40px; letter-spacing:-0.5px ">
                        <p style="font-size:32px; font-weight:700;  ">
                        외부감사인 선임 공고
                        </p><br/><br/>
                        주식회사 등의 외부감사에 관한 법률 제12조 제1항 및 동법 시행령 제18조 제1항에 의거 아래와 같이 외부감사인 선임을 공고합니다.<br/><br/> 
                        <p style=" margin:0 auto; width:360px; text-align:left; line-height:40px">
                        ○ 외부감사인 : 삼영회계법인<br/> 
                        ○ 선임기간 : 2022.01.01 ~ 2024.12.31 (3년)</p><br/><br/>
                        코리아이플랫폼 주식회사<br/>
                        대 표 이 사 &nbsp; 황 석 동
                    </div>
                </div>
                <!--2022.02.28 end--> 
            </div>            
        </div><!--subcontent 끝-->
        
    </div>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
</body>
</html>
