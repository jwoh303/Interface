package com.koreab2b.mro.manager.login.valid;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ObjectError;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import com.koreab2b.mro.manager.login.domain.Login;

@Component
public class LoginValidator implements Validator {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoginValidator.class);

	private final int LOGIN_MAX = 30;
	private final int PASSWORD_MAX = 150;

	public boolean supports(Class<?> pClass) {
		return Login.class.isAssignableFrom(pClass);
	}

	public void validate(Object pObj, Errors pErrors) {
		ValidationUtils.rejectIfEmptyOrWhitespace(pErrors, "userId", null, "사용자 아이디는 필수 입니다.");
		ValidationUtils.rejectIfEmptyOrWhitespace(pErrors, "password", null, "사용자 패스워드는 필수 입니다.");

		// 로그인 값 체크
		Login _login = (Login) pObj;

		if (_login.getUserId().length() >= LOGIN_MAX)
			pErrors.rejectValue("userId", null, "사용자 아이디가 최대 크기를 넘었습니다.");
		if (_login.getPassword().length() >= PASSWORD_MAX)
			pErrors.rejectValue("userId", null, "사용자 패스워드가 최대 크기를 넘었습니다.");

		List<ObjectError> _errors = pErrors.getAllErrors();
		for (ObjectError _tmpError : _errors) {
			LOGGER.error("잘못된 값 입력 : {}", _tmpError.toString());
		}
	}
}
