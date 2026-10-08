package com.koreab2b.mro.application.aspect;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class MethodBeforeLog {

	private static final Logger LOGGER = LoggerFactory.getLogger(MethodBeforeLog.class);

	@Pointcut("within(@org.springframework.stereotype.Controller *)")
	void controllerBean() {
	}

	@Pointcut("within(@org.springframework.stereotype.Service *)")
	void serviceBean() {
	}

	@Pointcut("within(@org.springframework.stereotype.Repository *)")
	void daoBean() {
	}

	@Before("controllerBean() || serviceBean() || daoBean()")
	public void before(JoinPoint pJoinPoint) {

		StringBuilder _prams = null;

		Object[] _objects = pJoinPoint.getArgs();

		if (_objects != null && _objects.length > 0) {
			if (_objects[0] instanceof HttpServletRequest) {

				Enumeration<?> _paramNames = ((HttpServletRequest) _objects[0]).getParameterNames();

				if (_paramNames != null) {
					_prams = new StringBuilder();

					while (_paramNames.hasMoreElements()) {

						String sParamName = (String) _paramNames.nextElement();
						String[] saPram = ((HttpServletRequest) _objects[0]).getParameterValues(sParamName);

						_prams.append(sParamName).append("=");

						int iLength = saPram.length;
						if (iLength > 1) {
							_prams.append("{ ");
							for (int i = 0; i < iLength; i++) {
								_prams.append(saPram[i]).append(",");
							}
							_prams.append(" }");
						}
						_prams.append(saPram[0]).append(",");
					}
				}

			} else {

				_prams = new StringBuilder(_objects.length);
				int iCount = _objects.length;
				for (int i = 0; i < iCount; i++) {
					_prams.append(_objects[i]).append(",");
				}
			}
		}
		LOGGER.debug(new StringBuilder("\n>>>>>>>>>>>>>>>>>>>>>>>before log<<<<<<<<<<<<<<<<<<<<<<<<<").append("\nMethod = [")
				.append(pJoinPoint.getTarget().getClass().getName()).append(".").append(pJoinPoint.getSignature().getName())
				.append(" ] ").append("\nParameters =  [ ").append(_prams).append(" ]").toString());
	}
}
