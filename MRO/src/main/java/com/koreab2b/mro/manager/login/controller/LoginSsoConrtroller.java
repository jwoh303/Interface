package com.koreab2b.mro.manager.login.controller;


import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.koreab2b.mro.manager.login.domain.Login;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.manager.login.service.LoginService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;

@Controller("LoginSsoConrtroller")
public class LoginSsoConrtroller {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoginSsoConrtroller.class);

	@Autowired
	private MessageSource messageSource;

	
	@Autowired
	private LoginService loginService;
	
	/**
	 * 고객사 삼기 SSO 로그인 후처리.
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/samkee_sso_login.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String samkee_sso_login(HttpServletRequest request, @ModelAttribute("login") Login pLogin,  BindingResult result, ModelMap pModel, RedirectAttributes redirectAttributes) {

		String st_key = CommonUtil.nvl((String) request.getParameter("st_key"),"");
		String st_user_Id  = CommonUtil.nvl(loginService.setSamkeeSsoId("SAMKEE", st_key),"");
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			LOGGER.debug("로그 아웃 사용자 아이디 : {}", _sessionInfo.getUserId());
			request.getSession().removeAttribute("sessionInfo");
		}
		LOGGER.debug("로그 아웃 사용자 아이디 : {}", st_user_Id);
		if(st_user_Id.equals("")|| st_user_Id == null) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:/main.do";			
		}
		
		pLogin.setUserId(st_user_Id);

		Login _afterLogin = loginService.getLogin(st_user_Id);
		if (!pLogin.comfirmUserId(_afterLogin)) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:/main.do";
		} 

		if ("S".equals(_afterLogin.getStatus())) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("승인되지 않은 ID입니다. 관리자에게 문의 바랍니다.", null, "승인되지 않은 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:/main.do";
		}
		
		if ("A".equals(_afterLogin.getStatus()) && "A".equals(_afterLogin.getUserType()) && "A".equals(_afterLogin.getChangeUserType()) ) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("관리자권한 승인 거절된 ID입니다. 관리자에게 문의 바랍니다.", null, "관리자권한 승인 거절된 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:/main.do";
		}

		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
		  //SeedCbcAlgorithmUtil 암호화
		String pszEnUserid = pLogin.getUserId();
		byte[] plainText = pszEnUserid.getBytes();
		byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
		String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);		 
		return "redirect:/securityCheck.do?userId=" + bszUserid;
	}
	
	
	@RequestMapping(value = "/login/syf_sso_login.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String syfSsoLogin() {
	    return "redirect:/saml/login.do";
	}

}
