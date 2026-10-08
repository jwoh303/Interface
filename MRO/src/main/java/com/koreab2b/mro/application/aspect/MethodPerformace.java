package com.koreab2b.mro.application.aspect;

import java.util.Calendar;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class MethodPerformace {

	private static final Logger LOGGER = LoggerFactory.getLogger(MethodPerformace.class);

	@Pointcut("within(@org.springframework.stereotype.Controller *)")
	void controllerBean() {
	}

	@Pointcut("within(@org.springframework.stereotype.Service *)")
	void serviceBean() {
	}

	@Pointcut("within(@org.springframework.stereotype.Repository *)")
	void daoBean() {
	}

	@Around("controllerBean() || serviceBean() || daoBean()")
	public Object performace(ProceedingJoinPoint pJoinPoint) {
		Object _object = null;
		Calendar _cal = Calendar.getInstance();
		long _start = _cal.getTimeInMillis();
		
		try {
			_object = pJoinPoint.proceed();
		} catch (Throwable e) {
			LOGGER.error("메소드 실행 중 에러!",e);
			throw new  RuntimeException(e.getMessage());
		}
		
		_cal = Calendar.getInstance();
		long _end = _cal.getTimeInMillis();
		LOGGER.debug(new StringBuilder("\n>>>>>>>>>>>>>>>>>>>>>>>performace log<<<<<<<<<<<<<<<<<<<<<<<<<").append("\nMethod = [")
				.append(pJoinPoint.getTarget().getClass().getName()).append(".").append(pJoinPoint.getSignature().getName())
				.append("\nMthod Performace Time = [ ")
				.append((_end - _start) / 1000)
				.append("  second ]").toString());

		return _object;

	}
}
