package com.koreab2b.mro.application.handler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

public class LoginCheckHandler extends HandlerInterceptorAdapter {

	/**
	 * 로그인 세션체크 예외 주소 처리
	 * 
	 * @throws ServletException
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		if (handler instanceof HandlerMethod) {
			
			NoLoginCheck usingAuth = ((HandlerMethod) handler).getMethodAnnotation(NoLoginCheck.class);
			
			if (usingAuth != null)
				return true;
		}

		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

		if (_sessionInfo != null) {
			// Edge 브라우저 쿠키 정책 SameSite = "None" 세팅, https Secure 적용 
			String flag = CommonUtil.getDevRealLocalFlag(request);			
			if ("1".equals(flag)){ // 개발
				response.addHeader("Set-Cookie", "JSESSIONID=" + request.getRequestedSessionId() + "; HttpOnly; path=/; SameSite=None");
			} else if ("2".equals(flag)) { // 운영
				response.addHeader("Set-Cookie", "JSESSIONID=" + request.getRequestedSessionId() + "; HttpOnly; Secure; path=/; SameSite=None");
			}
			return true;
		}
		
		if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
			return false;
		}
		
		request.getRequestDispatcher(request.getContextPath() + "/login/sub_login.do").forward(request, response);
		return false;
		
	}
	
}
