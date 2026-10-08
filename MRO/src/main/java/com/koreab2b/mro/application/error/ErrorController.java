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
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("errorController")
public class ErrorController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ErrorController.class);

	@Autowired
	private MessageSource messageSource;

	@RequestMapping(value = "/error/error.do")
	public String handleError(HttpServletRequest pRequest, HttpServletResponse pResponse) {

		final String _key = "페이지 요청 중 오류가 발생 했습니다.";

		Integer _statusCode = (Integer) pRequest.getAttribute("javax.servlet.error.status_code");
		
		Throwable _throwable = (Throwable) pRequest.getAttribute("javax.servlet.error.exception");

		String _requestUri = (String) pRequest.getAttribute("javax.servlet.error.request_uri");
		if (_requestUri == null) {
			_requestUri = "Unknown";
		}

		Object[] _message = new Object[4];
		_message[0] = _statusCode;
		_message[1] = _requestUri;
		_message[2] = pRequest.getLocale();
		_message[3] = ("XMLHttpRequest".equals(pRequest.getHeader("X-Requested-With"))) ? pRequest.getHeader("X-Requested-With") : "Http Request";

		LOGGER.error(_key);
		LOGGER.error("내용");
		LOGGER.error("에러 코드 : {}", _message[0]);
		LOGGER.error("요청 URL : {}", _message[1]);
		LOGGER.error("언어 코드 : {}", _message[2]);
		LOGGER.error("요청 종류 : {}", _message[3]);
	
		LOGGER.error("에러 내용 : ", _throwable);

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
	
	@RequestMapping(value = "/error/notFound.do")
	public String notFound() {
		return "common/error/error";
	}

}
