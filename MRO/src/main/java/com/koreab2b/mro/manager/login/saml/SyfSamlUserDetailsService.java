package com.koreab2b.mro.manager.login.saml;

import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.saml.SAMLCredential;
import org.springframework.security.saml.userdetails.SAMLUserDetailsService;
import org.springframework.util.StringUtils;

import com.koreab2b.mro.manager.login.domain.Login;
import com.koreab2b.mro.manager.login.service.LoginService;

public class SyfSamlUserDetailsService implements SAMLUserDetailsService {

	private LoginService loginService;

	public void setLoginService(LoginService loginService) {
		this.loginService = loginService;
	}

	@Override
	public Object loadUserBySAML(SAMLCredential credential) throws UsernameNotFoundException {
		if (credential == null) {
			throw new UsernameNotFoundException("SAML 인증정보가 없습니다.");
		}

		String attributeEmail = credential.getAttributeAsString("email");
		String nameIdEmail = credential.getNameID() == null ? null : credential.getNameID().getValue();

		if (StringUtils.hasText(attributeEmail)) {
			attributeEmail = attributeEmail.trim();
		}

		if (StringUtils.hasText(nameIdEmail)) {
			nameIdEmail = nameIdEmail.trim();
		}

		if (StringUtils.hasText(attributeEmail) && StringUtils.hasText(nameIdEmail) && !attributeEmail.equalsIgnoreCase(nameIdEmail)) {
			throw new UsernameNotFoundException("SAML 이메일 정보가 일치하지 않습니다.");
		}

		String email = StringUtils.hasText(attributeEmail) ? attributeEmail : nameIdEmail;

		if (!StringUtils.hasText(email)) {
			throw new UsernameNotFoundException("SAML 응답에 이메일 정보가 없습니다.");
		}

		String userId = loginService.setIkenSsoId("KRSAMYG001", email);

		if (!StringUtils.hasText(userId)) {
			throw new UsernameNotFoundException("등록되지 않은 사용자입니다.");
		}

		Login afterLogin = loginService.getLogin(userId);

		if (afterLogin == null) {
			throw new UsernameNotFoundException("등록되지 않은 사용자입니다.");
		}

		if ("S".equals(afterLogin.getStatus())) {
			throw new UsernameNotFoundException("승인되지 않은 사용자입니다.");
		}

		if ("A".equals(afterLogin.getStatus()) && "A".equals(afterLogin.getUserType()) && "A".equals(afterLogin.getChangeUserType())) {
			throw new UsernameNotFoundException("관리자권한 승인 거절 사용자입니다.");
		}

		return afterLogin;
	}
}