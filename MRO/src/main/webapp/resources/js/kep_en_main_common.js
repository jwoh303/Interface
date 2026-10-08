/**
 * en_페이지이동
 */	
function EnMovePage(urlLink , subNo, pageNo) {	
	if(subNo == "01"){ //회사소개
		switch (pageNo) {
			case "01": //CEO메시지
				location.href = urlLink + "/main/sub01/sub01_01ceo_greeting_en.do";
				break;
			case "02": //개요
				location.href = urlLink + "/main/sub01/sub01_02summary_en.do";				
				break;
				
			case "03": //연혁
				location.href = urlLink + "/main/sub01/sub01_03history_en.do";				
				break;
				
			case "04"://비전
				location.href = urlLink + "/main/sub01/sub01_04vision_en.do";				
				break;
				
			case "05": //오시는길
				location.href = urlLink + "/main/sub01/sub01_07map_en.do";				
				break;
				

		}
	}else if(subNo == "02"){ //사업소개
		switch (pageNo) {
			case "01"://MRO구매대행
				location.href = urlLink + "/main/sub02/sub02_mro_en.do";
				break;
					 
			case "02": //부자재구매대행
				location.href = urlLink + "/main/sub02/sub02_materie_en.do";				
				break;
				
			case "03": //건설MRO소개
				location.href = urlLink + "/main/sub02/sub02_cmro_en.do";				
				break;
				
			case "04"://해외법인
				location.href = urlLink + "/main/sub02/sub02_global_en.do";				
				break;
				
			case "05"://구매시스템
				location.href = urlLink + "/main/sub02/sub02_system_en.do";				
				break;
				
			case "06"://물류센터
				location.href = urlLink + "/main/sub02/sub02_network_en.do";				
				break;
		}
		
	}else if(subNo == "03"){ //인재채용
		switch (pageNo) {
			case "01"://인재상
				location.href = urlLink + "/main/sub03/sub03_recruit_en.do";				
				break;
			case "02"://인사정보
				location.href = urlLink + "/main/sub03/sub03_recruit02_en.do";				
				break;
			case "03"://채용정보
				location.href = urlLink + "/main/sub03/sub03_recruit03_en.do";				
				break;
		}
	}else if(subNo == "04"){ //로그인
		switch (pageNo) {
			case "01"://로그인
				location.href = urlLink + "/main/sub04/sub04_login_en.do";
				break;
		}
	}
}
		
