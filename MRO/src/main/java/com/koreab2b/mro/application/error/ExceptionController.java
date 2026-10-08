package com.koreab2b.mro.application.error;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class ExceptionController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ExceptionController.class);

	@Autowired
	private MessageSource messageSource;

	@ExceptionHandler(Throwable.class)
	public String handleThrowable(HttpServletRequest pRequest, HttpServletResponse pResponse, Throwable pE) {

		final String _key = "시스템 처리 중 오류가 발생 했습니다.";

		String servletName = (String) pRequest.getAttribute("javax.servlet.error.servlet_name");
		if (servletName == null) {
			servletName = "Unknown";
		}

		String _requestUri = (String) pRequest.getAttribute("javax.servlet.error.request_uri");
		if (_requestUri == null) {
			_requestUri = "Unknown";
		}

		Object[] _message = new Object[5];
		_message[0] = pE.getMessage();
		_message[1] = servletName;
		_message[2] = _requestUri;
		_message[3] = pRequest.getLocale();
		_message[4] = ("XMLHttpRequest".equals(pRequest.getHeader("X-Requested-With"))) ? pRequest.getHeader("X-Requested-With") : "Http Request";

		LOGGER.error(_key);
		LOGGER.error("내용");
		LOGGER.error("에러 메시지 : {}", _message[0]);
		LOGGER.error("요청 서블릿 : {}", _message[1]);
		LOGGER.error("요청 URL : {}", _message[2]);
		LOGGER.error("언어 코드 : {}", _message[3]);
		LOGGER.error("요청 종류 : {}", _message[4]);
		
		LOGGER.error("에러 내용 : ", pE);
		
		if ("XMLHttpRequest".equals(pRequest.getHeader("X-Requested-With"))) {
			Map<String, String> _error = new HashMap<String, String>();
			_error.put("Message", messageSource.getMessage(_key, _message, _key, pRequest.getLocale()));
			try {
				JSONObject.writeJSONString(_error, pResponse.getWriter());
			} catch (IOException e) {
				LOGGER.error("알수 없는 에러 발생", e);
			}

			return null;
		} else {
			pRequest.setAttribute("error", messageSource.getMessage(_key, _message, _key, pRequest.getLocale()));

			return "common/error/error";
		}
	}

}
