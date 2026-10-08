package com.koreab2b.mro.manager.login.saml;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.koreab2b.mro.manager.login.domain.Login;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;

public class SyfSamlSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
		if (!(authentication.getPrincipal() instanceof Login)) {
			throw new ServletException("SAML 인증 사용자 정보가 올바르지 않습니다.");
		}

		Login afterLogin = (Login) authentication.getPrincipal();
		String userId = afterLogin.getUserId();

		if (userId == null || "".equals(userId.trim())) {
			throw new ServletException("사용자 ID가 없습니다.");
		}

		if (request.getSession().getAttribute("sessionInfo") != null) {
			request.getSession().removeAttribute("sessionInfo");
		}

		CommonUtil.setSESSION_PASS_FLAG("Y");
		request.getSession().setAttribute("session_st_gw_no", "");

		byte[] plainText = userId.getBytes();
		byte[] bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText, 0, plainText.length);
		String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);

		response.sendRedirect(request.getContextPath() + "/securityCheck.do?userId=" + bszUserid);
	}
}