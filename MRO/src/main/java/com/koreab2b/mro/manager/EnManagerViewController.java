package com.koreab2b.mro.manager;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller("EnManagerViewController")
public class EnManagerViewController {
	//영문메인
	@RequestMapping(value = "/main/main_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String main_en() {
		return "main/en/main_en";
	}
	//신규가입안내
	@RequestMapping(value = "/main/sub04/sub04_joininfo_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_joininfo_en() {
		return "main/en/sub04/sub04_joininfo";
	}
	//회원가입하기
	@RequestMapping(value = "/main/sub04/sub04_join_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_join_en() {
		return "main/en/sub04/sub04_join";
	}
	//계약서다운로드
	@RequestMapping(value = "/main/sub04/sub04_download_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_download_en() {
		return "main/en/sub04/sub04_download";
	}
	//ID PW찾기.
	@RequestMapping(value = "/main/sub04/sub04_idpw_search_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_idpw_search_en() {
		return "main/en/sub04/sub04_idpw_search";
	}
	//ID 확인
	@RequestMapping(value = "/main/sub04/sub04_search_certificate_id_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_search_certificate_id_en() {
		return "main/en/sub04/sub04_search_certificate_id";
	}
	//ID 최종확인
	@RequestMapping(value = "/main/sub04/sub04_search_find_end_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_search_find_end_en() {
		return "main/en/sub04/sub04_search_find_end";
	}
	//고객사가입하기
	@RequestMapping(value = "/main/sub04/sub04_member_buyer_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_member_buyer_en() {
		return "main/en/sub04/sub04_member_buyer";
	}
	//협력사가입하기
	@RequestMapping(value = "/main/sub04/sub04_member_seller_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_member_seller_en() {
		return "main/en/sub04/sub04_member_seller";
	}
	//사용자가입하기
	@RequestMapping(value = "/main/sub04/sub04_member_user_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_member_user_en() {
		return "main/en/sub04/sub04_member_user";
	}
	//FAQ
	@RequestMapping(value = "/main/sub03/sub03_01faq_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_01faq_en() {
		return "main/en/sub03/sub03_01faq";
	}
	//업무처리프로세스
	@RequestMapping(value = "/main/sub03/sub03_03process_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_03process_en() {
		return "main/en/sub03/sub03_03process";
	}
	//공지사항
	@RequestMapping(value = "/main/sub03/sub03_04notice_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_04notice_en() {
		return "main/en/sub03/sub03_04notice";
	}
	//인재상
	@RequestMapping(value = "/main/sub03/sub03_recruit_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_recruit_en() {
		return "main/en/sub03/sub03_recruit";
	}
	//인사정보
	@RequestMapping(value = "/main/sub03/sub03_recruit02_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_recruit02_en() {
		return "main/en/sub03/sub03_recruit02";
	}
	//채용정보
	@RequestMapping(value = "/main/sub03/sub03_recruit03_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_recruit03_en() {
		return "main/en/sub03/sub03_recruit03";
	}
	//로그인
	@RequestMapping(value = "/main/sub04/sub04_login_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_login_en() {
		return "main/en/sub04/sub04_login";
	}
	//CEO메시지
	@RequestMapping(value = "/main/sub01/sub01_01ceo_greeting_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_01ceo_greeting_en() {
		return "main/en/sub01/sub01_01ceo_greeting";
	}
	//개요
	@RequestMapping(value = "/main/sub01/sub01_02summary_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_02summary_en() {
		return "main/en/sub01/sub01_02summary";
	}
	//연혁
	@RequestMapping(value = "/main/sub01/sub01_03history_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_03history_en() {
		return "main/en/sub01/sub01_03history";
	}
	//비전
	@RequestMapping(value = "/main/sub01/sub01_04vision_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_04vision_en() {
		return "main/en/sub01/sub01_04vision";
	}
	//오시는길
	@RequestMapping(value = "/main/sub01/sub01_07map_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_07map_en() {
		return "main/en/sub01/sub01_07map";
	}
	//MRO구매대행
	@RequestMapping(value = "/main/sub02/sub02_mro_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_mro_en() {
		return "main/en/sub02/sub02_mro";
	}
	//부자재구매
	@RequestMapping(value = "/main/sub02/sub02_materie_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_materie_en() {
		return "main/en/sub02/sub02_materie";
	}
	//건설MRO소개
	@RequestMapping(value = "/main/sub02/sub02_cmro_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_cmro_en() {
		return "main/en/sub02/sub02_cmro";
	}
	//해외법인
	@RequestMapping(value = "/main/sub02/sub02_global_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_global_en() {
		return "main/en/sub02/sub02_global";
	}
	//구매시스템
	@RequestMapping(value = "/main/sub02/sub02_system_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_system_en() {
		return "main/en/sub02/sub02_system";
	}
	//물류시스템
	@RequestMapping(value = "/main/sub02/sub02_network_en.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_network_en() {
		return "main/en/sub02/sub02_network";
	}
}
