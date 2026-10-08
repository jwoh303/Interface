package com.koreab2b.mro.manager;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.koreab2b.mro.application.annotation.NoLoginCheck;

@Controller("ManagerViewController")
public class ManagerViewController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ManagerViewController.class);

	@RequestMapping(value = "/include/topLoginForm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String topLoginForm() {
		return "common/include/topLoginForm";
	}
	
	@RequestMapping(value = "include/topSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String topSearch() {
		return "common/include/topSearch";
	}
	
	@RequestMapping(value = "/include/topMenu.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String topMenu() {
		return "common/include/topMenu";
	}
	
	@RequestMapping(value = "/include/leftMenu.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String leftMenu() {
		return "common/include/leftMenu";
	}
	
	@RequestMapping(value = "/include/footer.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String footer() {
		return "common/include/footer";
	}
	
	@RequestMapping(value = "/login/loginFailed.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String loginFailed() {
		return "main/main";
	}
	
	@RequestMapping(value = "/user/getUserForm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String getUserForm() {
		return "manager/user/userForm";
	}
	
	@RequestMapping(value = "/auth/getAuthForm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String getAuthForm() {
		return "manager/auth/authForm";
	}
	
	@RequestMapping(value = "/menu/getMenuForm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String getMenuForm() {
		return "manager/menu/menuForm";
	}
	
	@RequestMapping(value = "/main/mainHeader.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String mainHeader() {
		return "common/include/mainHeader";
	}
	
	@RequestMapping(value = "/main/mainFooter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String mainFooter() {
		return "common/include/mainFooter";
	}
	
	@RequestMapping(value = "/main/mainLeft.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String mainLeft() {
		return "common/include/mainLeft";
	}
	
	@RequestMapping(value = "/main/testLeft.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String testLeft() {
		return "common/include/testLeft";
	}
	
	@RequestMapping(value = "/login/sub_login.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub_login() {
		return "main/sub_login";
	}

	/* 미사용 화면 블럭 - 2026 ISMS
	@RequestMapping(value = "/main/sub01/sub01_01ceo_greeting.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_01ceo_greeting() {
		return "main/sub01/sub01_01ceo_greeting";
	}
	
	@RequestMapping(value = "/main/sub01/sub01_02summary.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_02summary() {
		return "main/sub01/sub01_02summary";
	}
	
	@RequestMapping(value = "/main/sub01/sub01_03history.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_03history() {
		return "main/sub01/sub01_03history";
	}
	
	@RequestMapping(value = "/main/sub01/sub01_04winwin_activities.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_04winwin_activities() {
		return "main/sub01/sub01_04winwin_activities";
	}
	
	@RequestMapping(value = "/main/sub01/sub01_05society_activity.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_05society_activity() {
		return "main/sub01/sub01_05society_activity";
	}
	
	@RequestMapping(value = "/main/sub01/sub01_06recruit.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_06recruit() {
		return "main/sub01/sub01_06recruit";
	}
	
	@RequestMapping(value = "/main/sub01/sub01_07map.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_07map() {
		return "main/sub01/sub01_07map";
	}
	
	@RequestMapping(value = "/main/sub02/sub02_01bmodel.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_01bmodel() {
		return "main/sub02/sub02_01bmodel";
	}
	
	@RequestMapping(value = "/main/sub02/sub02_02distinction.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_02distinction() {
		return "main/sub02/sub02_02distinction";
	}
	
	@RequestMapping(value = "/main/sub02/sub02_03value.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_03value() {
		return "main/sub02/sub02_03value";
	}
	
	@RequestMapping(value = "/main/sub02/sub02_04supply.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_04supply() {
		return "main/sub02/sub02_04supply";
	}
	
	@RequestMapping(value = "/main/sub02/sub02_05intergrated.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_05intergrated() {
		return "main/sub02/sub02_05intergrated";
	}
	
	@RequestMapping(value = "/main/sub03/sub03_01faq.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_01faq() {
		return "main/sub03/sub03_01faq";
	}
	
	@RequestMapping(value = "/main/sub03/sub03_03qna.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_03qna() {
		return "main/sub03/sub03_03qna";
	}
	
	@RequestMapping(value = "/main/sub03/sub03_04download.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_04download() {
		return "main/sub03/sub03_04download";
	}
	
	@RequestMapping(value = "/main/sub04/sub04_03pecialists.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_03pecialists() {
		return "main/sub04/sub04_03pecialists";
	}
	
	@RequestMapping(value = "/main/sub04/sub04_04customer.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_04customer() {
		return "main/sub04/sub04_04customer";
	}
	
	@RequestMapping(value = "/main/sub05/sub05_03id_search.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub05_03id_search() {
		return "main/sub05/sub05_03id_search";
	}
	
	@RequestMapping(value = "/main/sub05/sub05_03id_search_certificate.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub05_03id_search_certificate() {
		return "main/sub05/sub05_03id_search_certificate";
	}
	
	@RequestMapping(value = "/main/sub05/sub05_03id_search_find_end.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub05_03id_search_find_end() {
		return "main/sub05/sub05_03id_search_find_end";
	}
	
	@RequestMapping(value = "/main/sub05/sub05_03pw_search.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub05_03pw_search() {
		return "main/sub05/sub05_03pw_search";
	}
	*/
	@RequestMapping(value = "/main/sso_login.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sso_login() {
		return "main/sso_login";
	}
	//2016년 디자인 리뉴얼
	@RequestMapping(value = "/main/main_dev.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String main_dev() {
		return "main/main_dev";
	}
	/* 미사용 화면 블럭 - 2026 ISMS
	//신규가입안내
	@RequestMapping(value = "/main/sub04/sub04_joininfo_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_joininfo_2016() {
		return "main/2016/sub04/sub04_joininfo";
	}
	//회원가입하기
	@RequestMapping(value = "/main/sub04/sub04_join_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_join_2016() {
		return "main/2016/sub04/sub04_join";
	}
	//회원가입 > 회원사 검색 팝업
	@RequestMapping(value = "/main/sub04/sub04_comCodeListPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_comCodeListPop() {
		return "common/popup/main/comCodeListPop";
	}
	//계약서다운로드
	@RequestMapping(value = "/main/sub04/sub04_download_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_download_2016() {
		return "main/2016/sub04/sub04_download";
	}
	//ID PW찾기.
	@RequestMapping(value = "/main/sub04/sub04_idpw_search_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_idpw_search_2016() {
		return "main/2016/sub04/sub04_idpw_search";
	}
	*/
	//ID PW찾기 리뉴얼
	@RequestMapping(value = "/main/sub04/sub04_idpw_search_v2_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_idpw_search_v2_2016() {
		return "main/2016/sub04/sub04_idpw_search_v2";
	}
	//ID 확인
	@RequestMapping(value = "/main/sub04/sub04_search_certificate_id_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_search_certificate_id_2016() {
		return "main/2016/sub04/sub04_search_certificate_id";
	}
	//ID 최종확인
	@RequestMapping(value = "/main/sub04/sub04_search_find_end_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_search_find_end_2016() {
		return "main/2016/sub04/sub04_search_find_end";
	}
	/* 미사용 화면 블럭 - 2026 ISMS
	//고객사가입하기
	@RequestMapping(value = "/main/sub04/sub04_member_buyer_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_member_buyer_2016() {
		return "main/2016/sub04/sub04_member_buyer";
	}
	//협력사가입하기
	@RequestMapping(value = "/main/sub04/sub04_member_seller_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_member_seller_2016() {
		return "main/2016/sub04/sub04_member_seller";
	}
	//사용자가입하기
	@RequestMapping(value = "/main/sub04/sub04_member_user_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_member_user_2016() {
		return "main/2016/sub04/sub04_member_user";
	}
	//FAQ
	@RequestMapping(value = "/main/sub03/sub03_01faq_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_01faq_2016() {
		return "main/2016/sub03/sub03_01faq";
	}
	//업무처리프로세스
	@RequestMapping(value = "/main/sub03/sub03_03process_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_03process_2016() {
		return "main/2016/sub03/sub03_03process";
	}
	//공지사항
	@RequestMapping(value = "/main/sub03/sub03_04notice_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_04notice_2016() {
		return "main/2016/sub03/sub03_04notice";
	}
	//인재상
	@RequestMapping(value = "/main/sub03/sub03_recruit_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_recruit_2016() {
		return "main/2016/sub03/sub03_recruit";
	}
	//인사정보
	@RequestMapping(value = "/main/sub03/sub03_recruit02_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_recruit02_2016() {
		return "main/2016/sub03/sub03_recruit02";
	}
	//채용정보
	@RequestMapping(value = "/main/sub03/sub03_recruit03_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub03_recruit03_2016() {
		return "main/2016/sub03/sub03_recruit03";
	}
	*/	
	//로그인
	@RequestMapping(value = "/main/sub04/sub04_login_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_login_2016() {
		return "main/2016/sub04/sub04_login";
	}
	/* 미사용 화면 블럭 - 2026 ISMS
	//CEO메시지
	@RequestMapping(value = "/main/sub01/sub01_01ceo_greeting_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_01ceo_greeting_2016() {
		return "main/2016/sub01/sub01_01ceo_greeting";
	}
	//개요
	@RequestMapping(value = "/main/sub01/sub01_02summary_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_02summary_2016() {
		return "main/2016/sub01/sub01_02summary";
	}
	//연혁
	@RequestMapping(value = "/main/sub01/sub01_03history_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_03history_2016() {
		return "main/2016/sub01/sub01_03history";
	}
	//비전
	@RequestMapping(value = "/main/sub01/sub01_04vision_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_04vision_2016() {
		return "main/2016/sub01/sub01_04vision";
	}
	//오시는길
	@RequestMapping(value = "/main/sub01/sub01_07map_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_07map_2016() {
		return "main/2016/sub01/sub01_07map";
	}
	//공고
	@RequestMapping(value = "/main/sub01/sub01_06invest_notice.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub01_06invest_notice() {
		return "main/2016/sub01/sub01_06invest_notice";
	}
	//MRO구매대행
	@RequestMapping(value = "/main/sub02/sub02_mro_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_mro_2016() {
		return "main/2016/sub02/sub02_mro";
	}
	//부자재구매
	@RequestMapping(value = "/main/sub02/sub02_materie_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_materie_2016() {
		return "main/2016/sub02/sub02_materie";
	}
	//건설MRO소개
	@RequestMapping(value = "/main/sub02/sub02_cmro_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_cmro_2016() {
		return "main/2016/sub02/sub02_cmro";
	}
	//해외법인
	@RequestMapping(value = "/main/sub02/sub02_global_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_global_2016() {
		return "main/2016/sub02/sub02_global";
	}
	//구매시스템
	@RequestMapping(value = "/main/sub02/sub02_system_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_system_2016() {
		return "main/2016/sub02/sub02_system";
	}
	//물류시스템
	@RequestMapping(value = "/main/sub02/sub02_network_2016.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub02_network_2016() {
		return "main/2016/sub02/sub02_network";
	}
	//구매대행 도입문의
	@RequestMapping(value = "/main/sub04/sub04_newcustomer.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String sub04_newcustomer() {
		return "main/2016/sub04/sub04_newcustomer";
	}
	@RequestMapping(value = "/main/sub01/kep_map.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String kep_map() {
		return "main/2016/sub01/kep_map";
	}
	*/
	// 고객사 가입안내 (리뉴얼)
	@NoLoginCheck
	@RequestMapping(value = "/main/renewal_buyer_join.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String renewal_buyer_join() {
		return "main/renewal_buyer_join";
	}

	// 협력사 가입안내 (리뉴얼)
	@NoLoginCheck
	@RequestMapping(value = "/main/renewal_seller_join.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String renewal_seller_join() {
		return "main/renewal_partner_join";
	}
	
	@NoLoginCheck
	@RequestMapping(value = "/main/renewal_kep_manager.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String renewal_kep_manager() {
		return "common/popup/main/renewal_kep_manager";
	}

	// 고객사 사용자 등록 요청 (리뉴얼)
	@NoLoginCheck
	@RequestMapping(value = "/main/renewal_buyer_user_reg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String renewal_buyer_user_reg() {
		return "main/renewal_buyer_user_reg";
	}

	// 자주묻는질문 (리뉴얼)
	@NoLoginCheck
	@RequestMapping(value = "/main/renewal_faq.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String renewal_faq() {
		return "main/renewal_faq";
	}
}
