<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="/resources/styles/2016_koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/2021_koreab2b.css" type="text/css">
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
 <script language="javascript"> 
function DisplayMenu(index) { 
      for (i=1; i<=7; i++) 
      if (index == i) { 
      thisMenu = eval("menu" + index + ".style"); 
      thisMenu.display = "block"; 
      } 
      else { 
      otherMenu = eval("menu" + i + ".style"); 
      otherMenu.display = "none"; 
      } 
      } 
</script> 
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f8351b36b3efadbdc48b032994eadc6a"></script>
</head>
<body> 
    <div class="sub01_01map">
         <div id="menu1" style="display:block;  position:absolute; top:0;  z-index:9; letter-spacing:0px">
          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
            <tr height="75px" bgcolor="#FFFFFF">
              <td onClick="DisplayMenu(1)" width="115" style="cursor:hand; border:1px solid #ee3212;border-bottom:1px solid #fff; border-left:1px solid #ee3212; line-height:20px; color:#ee3212" >서울 본사</td>
              <td onClick="DisplayMenu(2)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">창원<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(3)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">구미<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(4)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">대전<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(5)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">코리아이플랫폼<br/><span style="font-size:13px">중앙HUB</span></td>
              <td onClick="DisplayMenu(6)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">광주<br/><span style="font-size:13px">물류센터</span></td>
            </tr>
            <tr>
              <td colspan=6 height="400px" bgcolor="#FFFFFF" > 
                   <br/><br/>
                   <p class="subcontentTit" >서울 본사</p>
                   서울특별시 강남구 개포로 619 서울강남우체국빌딩 7층 <br/>
                    전화 : 02-3016-8989 / 팩스 : 02-569-6724. 02-569-9408 / E-Mail : master@koreab2b.com  <br/> <br/><br/>
                   <div id="map01" style="width:1080px;height:460px;">
                    <p id="btnBigmap"> <a href="http://kko.to/PahNzO8fT" target="_blank" id="aBigmap"><img src="/resources/images/2016/map_plus.png" alt="큰지도보기" ></a> </p>
                    <script>
                        var mapContainer = document.getElementById('map01'), // 지도를 표시할 div 
                            mapOption = { 
                                center: new daum.maps.LatLng(37.4936513,127.0780778), // 지도의 중심좌표
                                level: 3 // 지도의 확대 레벨
                            };
                        var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
                        var imageSrc = '/resources/images/2016/map01.png', // 마커이미지의 주소입니다    
                            imageSize = new daum.maps.Size(163, 75), // 마커이미지의 크기입니다
                            imageOption = {offset: new daum.maps.Point(80, 70)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
                        // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
                        var markerImage = new daum.maps.MarkerImage(imageSrc, imageSize, imageOption),
                            markerPosition = new daum.maps.LatLng(37.4936513,127.0780778); // 마커가 표시될 위치입니다
                        // 마커를 생성합니다
                        var marker = new daum.maps.Marker({
                            position: markerPosition, 
                            image: markerImage // 마커이미지 설정 
                        });
                        // 마커가 지도 위에 표시되도록 설정합니다
                        marker.setMap(map); 
                    </script>
                   </div>
               </td>
            </tr>
          </table>
        </div>
        <div id="menu2" style="display:block; position:absolute; top:0; z-index:8; letter-spacing:0px">
          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
             <tr height="75px" bgcolor="#FFFFFF">
                           
              <td onClick="DisplayMenu(1)" width="115" style="cursor:hand; border:1px solid #cdcdcd;border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;"" >서울 본사</td>
              <td onClick="DisplayMenu(2)" width="115" style="cursor:hand; border:1px solid #ee3212;border-bottom:1px solid #fff;line-height:20px; color:#ee3212">창원<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(3)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px;background:url(/resources/images/2016/dot07.png);background-color:#e5e5e5;" >구미<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(4)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px;background:url(/resources/images/2016/dot07.png);background-color:#e5e5e5;">대전<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(5)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px;background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >코리아이플랫폼<br/><span style="font-size:13px">중앙HUB</span></td>
              <td onClick="DisplayMenu(6)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">광주<br/><span style="font-size:13px">물류센터</span></td>
            </tr>
            <tr>
              <td colspan=6 height="400px" bgcolor="#FFFFFF" > 
                   <br/><br/>
                    <p class="subcontentTit" >창원 사무소/물류센터</p>
                    <span style="font-size:15px; line-height:19px; letter-spacing:-0.5px">[사무소] 경남 창원시 의창구 용동로 45, 현대썬앤빌 더스퀘어 A동 302호/304호 /  전화 : 055-270-6200 / 팩스 : 055-270-6230 / E-Mail : mastercw@koreab2b.com <br/>
                    [물류센터] 경남 창원시 의창구 팔용동 39-8 / 전화 : 055-270-6227~9 / 팩스 : 055-270-6222 / E-Mail : mastercw@koreab2b.com</span><br/> <br/> <br/>
                   
                   <div id="map02" style="width:1080px;height:460px;">
                    <p id="btnBigmap"> <a href="https://kko.to/kqJFIaxY8A" target="_blank" id="aBigmap"><img src="/resources/images/2016/map_plus01.png" alt="사무소" ></a>
                    <a href="https://kko.to/1JxUAzBHap" target="_blank" id="aBigmap"><img src="/resources/images/2016/map_plus02.png" alt="물류센터" ></a> </p>
                   <script>
                    var MARKER_WIDTH = 163, // 기본, 클릭 마커의 너비
                        MARKER_HEIGHT = 71, // 기본, 클릭 마커의 높이
                        OFFSET_X = 82, // 기본, 클릭 마커의 기준 X좌표
                        OFFSET_Y = MARKER_HEIGHT, // 기본, 클릭 마커의 기준 Y좌표
                        OVER_MARKER_WIDTH = 163, // 오버 마커의 너비
                        OVER_MARKER_HEIGHT = 71, // 오버 마커의 높이
                        OVER_OFFSET_X = 82, // 오버 마커의 기준 X좌표
                        OVER_OFFSET_Y = OVER_MARKER_HEIGHT, // 오버 마커의 기준 Y좌표
                        SPRITE_MARKER_URL = '/resources/images/2016/map_Changwon.png', // 스프라이트 마커 이미지 URL
                        SPRITE_WIDTH = 163, // 스프라이트 이미지 너비
                        SPRITE_HEIGHT = 142, // 스프라이트 이미지 높이
                        SPRITE_GAP = 0; // 스프라이트 이미지에서 마커간 간격
                        
                    var markerSize = new daum.maps.Size(MARKER_WIDTH, MARKER_HEIGHT), // 기본, 클릭 마커의 크기
                        markerOffset = new daum.maps.Point(OFFSET_X, OFFSET_Y), // 기본, 클릭 마커의 기준좌표
                        overMarkerSize = new daum.maps.Size(OVER_MARKER_WIDTH, OVER_MARKER_HEIGHT), // 오버 마커의 크기
                        overMarkerOffset = new daum.maps.Point(OVER_OFFSET_X, OVER_OFFSET_Y), // 오버 마커의 기준 좌표
                        spriteImageSize = new daum.maps.Size(SPRITE_WIDTH, SPRITE_HEIGHT); // 스프라이트 이미지의 크기
                    
                    var positions = [  // 마커의 위치
                            new daum.maps.LatLng(35.2366745, 128.6970475),
                            new daum.maps.LatLng(35.2421759, 128.6340923)
                        ],
                        selectedMarker = null; // 클릭한 마커를 담을 변수
                    
                    var mapContainer = document.getElementById('map02'), // 지도를 표시할 div
                        mapOption = { 
                            center: new daum.maps.LatLng(35.2395011, 128.6667034), // 지도의 중심좌표
                            level: 6 // 지도의 확대 레벨
                        };
                    
                    var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
                    
                    // 지도 위에 마커를 표시합니다
                    for (var i = 0, len = positions.length; i < len; i++) {
                        var gapX = (MARKER_WIDTH + SPRITE_GAP), // 스프라이트 이미지에서 마커로 사용할 이미지 X좌표 간격 값
                            originY = (MARKER_HEIGHT + SPRITE_GAP) * i, // 스프라이트 이미지에서 기본, 클릭 마커로 사용할 Y좌표 값
                            overOriginY = (OVER_MARKER_HEIGHT + SPRITE_GAP) * i, // 스프라이트 이미지에서 오버 마커로 사용할 Y좌표 값
                            normalOrigin = new daum.maps.Point(0, originY), // 스프라이트 이미지에서 기본 마커로 사용할 영역의 좌상단 좌표
                            clickOrigin = new daum.maps.Point(gapX, originY), // 스프라이트 이미지에서 마우스오버 마커로 사용할 영역의 좌상단 좌표
                            overOrigin = new daum.maps.Point(gapX * 2, overOriginY); // 스프라이트 이미지에서 클릭 마커로 사용할 영역의 좌상단 좌표
                            
                        // 마커를 생성하고 지도위에 표시합니다
                        addMarker(positions[i], normalOrigin, overOrigin, clickOrigin);
                    }
                    
                    // 마커를 생성하고 지도 위에 표시하고, 마커에 mouseover, mouseout, click 이벤트를 등록하는 함수입니다
                    function addMarker(position, normalOrigin, overOrigin, clickOrigin) {
                    
                        // 기본 마커이미지, 오버 마커이미지, 클릭 마커이미지를 생성합니다
                        var normalImage = createMarkerImage(markerSize, markerOffset, normalOrigin),
                            overImage = createMarkerImage(overMarkerSize, overMarkerOffset, overOrigin),
                            clickImage = createMarkerImage(markerSize, markerOffset, clickOrigin);
                        
                        // 마커를 생성하고 이미지는 기본 마커 이미지를 사용합니다
                        var marker = new daum.maps.Marker({
                            map: map,
                            position: position,
                            image: normalImage
                        });
                       
                    }
                    
                    // MakrerImage 객체를 생성하여 반환하는 함수입니다
                    function createMarkerImage(markerSize, offset, spriteOrigin) {
                        var markerImage = new daum.maps.MarkerImage(
                            SPRITE_MARKER_URL, // 스프라이트 마커 이미지 URL
                            markerSize, // 마커의 크기
                            {
                                offset: offset, // 마커 이미지에서의 기준 좌표
                                spriteOrigin: spriteOrigin, // 스트라이프 이미지 중 사용할 영역의 좌상단 좌표
                                spriteSize: spriteImageSize // 스프라이트 이미지의 크기
                            }
                        );
                        
                        return markerImage;
                    }
                    </script>
                	</p>
                    </div>
               </td>
            </tr>
          </table>
        </div>
        <div id="menu3" style="display:block; position:absolute; top:0; z-index:7; letter-spacing:0px">
          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
            <tr height="75px" bgcolor="#FFFFFF">
              <td onClick="DisplayMenu(1)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >서울 본사</td>
              <td onClick="DisplayMenu(2)" width="115" style="cursor:hand; border:1px solid #cdcdcd;border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">
              창원<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(3)" width="115" style="cursor:hand; border:1px solid #ee3212;border-bottom:1px solid #fff;border-left:1px solid #ee3212;line-height:20px;color:#ee3212">구미<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(4)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">대전<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(5)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >코리아이플랫폼<br/><span style="font-size:13px">중앙HUB</span></td>
              <td onClick="DisplayMenu(6)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">광주<br/><span style="font-size:13px">물류센터</span></td>
            </tr>
            <tr>
              <td colspan=6 height="400px" bgcolor="#FFFFFF"  > 
                   <br/><br/>
                    <p class="subcontentTit" >구미 사무소/물류센터</p>
                    [사무소] 경북 구미시 1공단로 212 한라시그마밸리 709호 / 전화 : 054-462-9134 / 팩스 : 054-462-4509 <br/>
                    [물류센터] 경북 칠곡군 석적읍 중지리 12-1 / 전화 : 054-972-5616~7 / 팩스 : 054-972-5618  / E-Mail : ckim@kmc.co.kr<br/> <br/> <br/>
                    <p id="map03" style="width:1080px;height:460px;">
                            <p id="btnBigmap"> <a href="http://kko.to/1tD-6gFDj" target="_blank" id="aBigmap"><img src="/resources/images/2016/map_plus01.png" alt="사무소" ></a>
                            <a href="http://kko.to/LSd96gFDp" target="_blank" id="aBigmap"><img src="/resources/images/2016/map_plus02.png" alt="물류센터" ></a> </p>
                           <script>
                            var MARKER_WIDTH = 163, // 기본, 클릭 마커의 너비
                                MARKER_HEIGHT = 71, // 기본, 클릭 마커의 높이
                                OFFSET_X = 82, // 기본, 클릭 마커의 기준 X좌표
                                OFFSET_Y = MARKER_HEIGHT, // 기본, 클릭 마커의 기준 Y좌표
                                OVER_MARKER_WIDTH = 163, // 오버 마커의 너비
                                OVER_MARKER_HEIGHT = 71, // 오버 마커의 높이
                                OVER_OFFSET_X = 82, // 오버 마커의 기준 X좌표
                                OVER_OFFSET_Y = OVER_MARKER_HEIGHT, // 오버 마커의 기준 Y좌표
                                SPRITE_MARKER_URL = '/resources/images/2016/map10.png', // 스프라이트 마커 이미지 URL
                                SPRITE_WIDTH = 163, // 스프라이트 이미지 너비
                                SPRITE_HEIGHT = 142, // 스프라이트 이미지 높이
                                SPRITE_GAP = 0; // 스프라이트 이미지에서 마커간 간격
                            
                            var markerSize = new daum.maps.Size(MARKER_WIDTH, MARKER_HEIGHT), // 기본, 클릭 마커의 크기
                                markerOffset = new daum.maps.Point(OFFSET_X, OFFSET_Y), // 기본, 클릭 마커의 기준좌표
                                overMarkerSize = new daum.maps.Size(OVER_MARKER_WIDTH, OVER_MARKER_HEIGHT), // 오버 마커의 크기
                                overMarkerOffset = new daum.maps.Point(OVER_OFFSET_X, OVER_OFFSET_Y), // 오버 마커의 기준 좌표
                                spriteImageSize = new daum.maps.Size(SPRITE_WIDTH, SPRITE_HEIGHT); // 스프라이트 이미지의 크기
                            
                            var positions = [  // 마커의 위치
                                    new daum.maps.LatLng(36.101497, 128.385978),
                                    new daum.maps.LatLng(36.022866, 128.424464)
                                ],
                                selectedMarker = null; // 클릭한 마커를 담을 변수
                            
                            var mapContainer = document.getElementById('map03'), // 지도를 표시할 div
                                mapOption = { 
                                    center: new daum.maps.LatLng(36.077391, 128.393190), // 지도의 중심좌표
                                    level: 8 // 지도의 확대 레벨
                                };
                            
                            var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
                            
                            // 지도 위에 마커를 표시합니다
                            for (var i = 0, len = positions.length; i < len; i++) {
                                var gapX = (MARKER_WIDTH + SPRITE_GAP), // 스프라이트 이미지에서 마커로 사용할 이미지 X좌표 간격 값
                                    originY = (MARKER_HEIGHT + SPRITE_GAP) * i, // 스프라이트 이미지에서 기본, 클릭 마커로 사용할 Y좌표 값
                                    overOriginY = (OVER_MARKER_HEIGHT + SPRITE_GAP) * i, // 스프라이트 이미지에서 오버 마커로 사용할 Y좌표 값
                                    normalOrigin = new daum.maps.Point(0, originY), // 스프라이트 이미지에서 기본 마커로 사용할 영역의 좌상단 좌표
                                    clickOrigin = new daum.maps.Point(gapX, originY), // 스프라이트 이미지에서 마우스오버 마커로 사용할 영역의 좌상단 좌표
                                    overOrigin = new daum.maps.Point(gapX * 2, overOriginY); // 스프라이트 이미지에서 클릭 마커로 사용할 영역의 좌상단 좌표
                                    
                                // 마커를 생성하고 지도위에 표시합니다
                                addMarker(positions[i], normalOrigin, overOrigin, clickOrigin);
                            }
                            
                            // 마커를 생성하고 지도 위에 표시하고, 마커에 mouseover, mouseout, click 이벤트를 등록하는 함수입니다
                            function addMarker(position, normalOrigin, overOrigin, clickOrigin) {
                            
                                // 기본 마커이미지, 오버 마커이미지, 클릭 마커이미지를 생성합니다
                                var normalImage = createMarkerImage(markerSize, markerOffset, normalOrigin),
                                    overImage = createMarkerImage(overMarkerSize, overMarkerOffset, overOrigin),
                                    clickImage = createMarkerImage(markerSize, markerOffset, clickOrigin);
                                
                                // 마커를 생성하고 이미지는 기본 마커 이미지를 사용합니다
                                var marker = new daum.maps.Marker({
                                    map: map,
                                    position: position,
                                    image: normalImage
                                });
                               
                            }
                            
                            // MakrerImage 객체를 생성하여 반환하는 함수입니다
                            function createMarkerImage(markerSize, offset, spriteOrigin) {
                                var markerImage = new daum.maps.MarkerImage(
                                    SPRITE_MARKER_URL, // 스프라이트 마커 이미지 URL
                                    markerSize, // 마커의 크기
                                    {
                                        offset: offset, // 마커 이미지에서의 기준 좌표
                                        spriteOrigin: spriteOrigin, // 스트라이프 이미지 중 사용할 영역의 좌상단 좌표
                                        spriteSize: spriteImageSize // 스프라이트 이미지의 크기
                                    }
                                );
                                
                                return markerImage;
                            }
                            </script>
                        </p>
               </td>
            </tr>
          </table>
        </div>
        <div id="menu4" style="display:block;position:absolute; top:0; z-index:5; letter-spacing:0px">
          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
            <tr height="75px" bgcolor="#FFFFFF">
              <td onClick="DisplayMenu(1)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px;background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >서울 본사</td>
              <td onClick="DisplayMenu(2)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px;background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">창원<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(3)" width="115" style="cursor:hand; border:1px solid #cdcdcd;border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >구미<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(4)" width="115" style="cursor:hand; border:1px solid #ee3212;border-bottom:1px solid #fff;border-left:1px solid #ee3212;line-height:20px;color:#ee3212" >
              대전<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(5)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >코리아이플랫폼<br/><span style="font-size:13px">중앙HUB</span></td>
              <td onClick="DisplayMenu(6)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">광주<br/><span style="font-size:13px">물류센터</span></td>
            </tr>
            <tr>
              <td colspan=6 height="400px" bgcolor="#FFFFFF"  > 
                   <br/><br/>
                    <p class="subcontentTit" >대전 사무소/물류센터</p>
                    [사무소] 대전광역시 중구 대종로 524 흥국생명빌딩 9층 /  전화 : 042-632-8922 / 팩스 : 042-632-8926 / E-Mail : masterdj@koreab2b.com <br/>
                    [물류센터] 충청북도 청주시 서원구 현도면 선동리 116-5 / 전화 : 043-264-1248 / 팩스 : 043-263-1248 <br/> <br/> <br/>
                    <p id="map05" style="width:1080px;height:460px;">
                            <p id="btnBigmap"> <a href="http://kko.to/u9l1ZMvYj" target="_blank" id="aBigmap"><img src="/resources/images/2016/map_plus01.png" alt="사무소" ></a>
                            <a href="https://kko.to/IpIBeWmFce" target="_blank" id="aBigmap"><img src="/resources/images/2016/map_plus02.png" alt="물류센터" ></a> </p>
                           <script>
                            var MARKER_WIDTH = 163, // 기본, 클릭 마커의 너비
                                MARKER_HEIGHT = 71, // 기본, 클릭 마커의 높이
                                OFFSET_X = 82, // 기본, 클릭 마커의 기준 X좌표
                                OFFSET_Y = MARKER_HEIGHT, // 기본, 클릭 마커의 기준 Y좌표
                                OVER_MARKER_WIDTH = 163, // 오버 마커의 너비
                                OVER_MARKER_HEIGHT = 71, // 오버 마커의 높이
                                OVER_OFFSET_X = 82, // 오버 마커의 기준 X좌표
                                OVER_OFFSET_Y = OVER_MARKER_HEIGHT, // 오버 마커의 기준 Y좌표
                                SPRITE_MARKER_URL = '/resources/images/2016/map044.png', // 스프라이트 마커 이미지 URL
                                SPRITE_WIDTH = 163, // 스프라이트 이미지 너비
                                SPRITE_HEIGHT = 142, // 스프라이트 이미지 높이
                                SPRITE_GAP = 0; // 스프라이트 이미지에서 마커간 간격
                                
                            var markerSize = new daum.maps.Size(MARKER_WIDTH, MARKER_HEIGHT), // 기본, 클릭 마커의 크기
                                markerOffset = new daum.maps.Point(OFFSET_X, OFFSET_Y), // 기본, 클릭 마커의 기준좌표
                                overMarkerSize = new daum.maps.Size(OVER_MARKER_WIDTH, OVER_MARKER_HEIGHT), // 오버 마커의 크기
                                overMarkerOffset = new daum.maps.Point(OVER_OFFSET_X, OVER_OFFSET_Y), // 오버 마커의 기준 좌표
                                spriteImageSize = new daum.maps.Size(SPRITE_WIDTH, SPRITE_HEIGHT); // 스프라이트 이미지의 크기
                            
                            var positions = [  // 마커의 위치
                                    new daum.maps.LatLng(36.330708, 127.423744),
                                    new daum.maps.LatLng(36.495255, 127.430494)
                                ],
                                selectedMarker = null; // 클릭한 마커를 담을 변수
                            
                            var mapContainer = document.getElementById('map05'), // 지도를 표시할 div
                                mapOption = { 
                                    center: new daum.maps.LatLng(36.431295, 127.422961), // 지도의 중심좌표
                                    level: 9// 지도의 확대 레벨
                                };
                            
                            var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
                            
                            // 지도 위에 마커를 표시합니다
                            for (var i = 0, len = positions.length; i < len; i++) {
                                var gapX = (MARKER_WIDTH + SPRITE_GAP), // 스프라이트 이미지에서 마커로 사용할 이미지 X좌표 간격 값
                                    originY = (MARKER_HEIGHT + SPRITE_GAP) * i, // 스프라이트 이미지에서 기본, 클릭 마커로 사용할 Y좌표 값
                                    overOriginY = (OVER_MARKER_HEIGHT + SPRITE_GAP) * i, // 스프라이트 이미지에서 오버 마커로 사용할 Y좌표 값
                                    normalOrigin = new daum.maps.Point(0, originY), // 스프라이트 이미지에서 기본 마커로 사용할 영역의 좌상단 좌표
                                    clickOrigin = new daum.maps.Point(gapX, originY), // 스프라이트 이미지에서 마우스오버 마커로 사용할 영역의 좌상단 좌표
                                    overOrigin = new daum.maps.Point(gapX * 2, overOriginY); // 스프라이트 이미지에서 클릭 마커로 사용할 영역의 좌상단 좌표
                                    
                                // 마커를 생성하고 지도위에 표시합니다
                                addMarker(positions[i], normalOrigin, overOrigin, clickOrigin);
                            }
                            
                            // 마커를 생성하고 지도 위에 표시하고, 마커에 mouseover, mouseout, click 이벤트를 등록하는 함수입니다
                            function addMarker(position, normalOrigin, overOrigin, clickOrigin) {
                            
                                // 기본 마커이미지, 오버 마커이미지, 클릭 마커이미지를 생성합니다
                                var normalImage = createMarkerImage(markerSize, markerOffset, normalOrigin),
                                    overImage = createMarkerImage(overMarkerSize, overMarkerOffset, overOrigin),
                                    clickImage = createMarkerImage(markerSize, markerOffset, clickOrigin);
                                
                                // 마커를 생성하고 이미지는 기본 마커 이미지를 사용합니다
                                var marker = new daum.maps.Marker({
                                    map: map,
                                    position: position,
                                    image: normalImage
                                });
                               
                            }
                            
                            // MakrerImage 객체를 생성하여 반환하는 함수입니다
                            function createMarkerImage(markerSize, offset, spriteOrigin) {
                                var markerImage = new daum.maps.MarkerImage(
                                    SPRITE_MARKER_URL, // 스프라이트 마커 이미지 URL
                                    markerSize, // 마커의 크기
                                    {
                                        offset: offset, // 마커 이미지에서의 기준 좌표
                                        spriteOrigin: spriteOrigin, // 스트라이프 이미지 중 사용할 영역의 좌상단 좌표
                                        spriteSize: spriteImageSize // 스프라이트 이미지의 크기
                                    }
                                );
                                
                                return markerImage;
                            }
                            </script>
                        </p>
               </td>
            </tr>
          </table>
        </div> 
        <div id="menu5" style="display:block;position:absolute; top:0; z-index:6; letter-spacing:0px">
          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
            <tr height="75px" bgcolor="#FFFFFF">
              <td onClick="DisplayMenu(1)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >서울 본사</td>
              <td onClick="DisplayMenu(2)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">창원<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(3)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">구미<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(4)" width="115" style="cursor:hand; border:1px solid #cdcdcd;border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">대전<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(5)" width="115" style="cursor:hand; border:1px solid #ee3212;border-bottom:1px solid #fff; border-left:1px solid #ee3212; line-height:20px; color:#ee3212" >코리아이플랫폼<br/><span style="font-size:13px">중앙HUB</span></td>
              <td onClick="DisplayMenu(6)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">광주<br/><span style="font-size:13px">물류센터</span></td>
            </tr>
            <tr>
               <td colspan=6 height="400px" bgcolor="#FFFFFF" > 
                   <br/><br/>
                   <p class="subcontentTit" >코리아이플랫폼 중앙HUB</p>
                    경기도 군포시 번영로 82-22 군포복합물류터미널 I동 1층 동관(도크 6~8)<br/>
                    전화 : 031-8061-8051~3  / 팩스 :  031-462-8612 / E-Mail : k201701@kmc.co.kr<br/> <br/> <br/>
                    <p id="map06" style="width:1080px;height:460px;">
                        <p id="btnBigmap"> <a href="http://kko.to/unWKgw60T" target="_blank" id="aBigmap"><img src="/resources/images/2016/map_plus.png" alt="큰지도보기" ></a> </p>
                        <script>
                            var mapContainer = document.getElementById('map06'), // 지도를 표시할 div 
                                mapOption = { 
                                    center: new daum.maps.LatLng(37.3333024, 126.9340697), // 지도의 중심좌표
                                    level: 4 // 지도의 확대 레벨
                                };
                            var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
                            var imageSrc = '/resources/images/2016/map12.png', // 마커이미지의 주소입니다    
                                imageSize = new daum.maps.Size(163, 75), // 마커이미지의 크기입니다
                                imageOption = {offset: new daum.maps.Point(80, 70)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
                            // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
                            var markerImage = new daum.maps.MarkerImage(imageSrc, imageSize, imageOption),
                                markerPosition = new daum.maps.LatLng(37.3333024, 126.9340697); // 마커가 표시될 위치입니다
                            // 마커를 생성합니다
                            var marker = new daum.maps.Marker({
                                position: markerPosition, 
                                image: markerImage // 마커이미지 설정 
                            });
                            // 마커가 지도 위에 표시되도록 설정합니다
                            marker.setMap(map); 
                        </script>
                    </p>
				</td>
            </tr>
          </table>
        </div> 
        <div id="menu6" style="display:block;position:absolute; top:0; z-index:6; letter-spacing:0px">
          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
            <tr height="75px" bgcolor="#FFFFFF">
              <td onClick="DisplayMenu(1)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >서울 본사</td>
              <td onClick="DisplayMenu(2)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">창원<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(3)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">구미<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(4)" width="115" style="cursor:hand; border:1px solid #cdcdcd;line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">대전<br/><span style="font-size:13px">사무소/물류센터</span></td>
              <td onClick="DisplayMenu(5)" width="115" style="cursor:hand; border:1px solid #cdcdcd;border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >코리아이플랫폼<br/><span style="font-size:13px">중앙HUB</span></td>
              <td onClick="DisplayMenu(6)" width="115" style="cursor:hand; border:1px solid #ee3212;border-bottom:1px solid #fff; border-left:1px solid #ee3212; line-height:20px; color:#ee3212">광주<br/><span style="font-size:13px">물류센터</span></td>
            </tr>
            <tr>
               <td colspan=6 height="400px" bgcolor="#FFFFFF" > 
                   <br/><br/>
                    <p class="subcontentTit" >광주물류센터</p>
                            광주광역시 광산구 하남산단 10번로 48(에이치로지스)<br/>
                            전화 : 062-955-8502 / 팩스 : 062-955-8503 / E-Mail : fevernova1@h-logis.com <br/> <br/> <br/>
                    <p id="map08" style="width:1080px;height:460px;">
                    <p id="btnBigmap"> <a href="https://kko.kakao.com/o5QY4XQ2sB" target="_blank" id="aBigmap"><img src="/resources/images/2016/map_plus.png" alt="큰지도보기" ></a> </p>
                    <script>
                        var mapContainer = document.getElementById('map08'), // 지도를 표시할 div 
                            mapOption = { 
                                center: new kakao.maps.LatLng(35.2148992349205,126.802455976057), // 지도의 중심좌표
                                level: 4 // 지도의 확대 레벨
                            };
                        var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
                        var imageSrc = '/resources/images/2016/map07.png', // 마커이미지의 주소입니다    
                            imageSize = new kakao.maps.Size(163, 75), // 마커이미지의 크기입니다
                            imageOption = {offset: new kakao.maps.Point(80, 70)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
                        // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
                        var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
                            markerPosition = new kakao.maps.LatLng(35.2148992349205,126.802455976057); // 마커가 표시될 위치입니다
                        // 마커를 생성합니다
                        var marker = new kakao.maps.Marker({
                            position: markerPosition, 
                            image: markerImage // 마커이미지 설정 
                        });
                        // 마커가 지도 위에 표시되도록 설정합니다
                        marker.setMap(map); 
                    </script>
                </p>
               </td>
            </tr>
          </table>
        </div>
    </div>
</body>
</html>

