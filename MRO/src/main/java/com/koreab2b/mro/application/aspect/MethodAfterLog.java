package com.koreab2b.mro.application.aspect;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class MethodAfterLog {

	private static final Logger LOGGER = LoggerFactory.getLogger(MethodAfterLog.class);

	@Pointcut("within(@org.springframework.stereotype.Controller *)")
	void controllerBean() {
	}

	@Pointcut("within(@org.springframework.stereotype.Service *)")
	void serviceBean() {
	}

	@Pointcut("within(@org.springframework.stereotype.Repository *)")
	void daoBean() {
	}

	@AfterReturning(pointcut = "controllerBean() || serviceBean() || daoBean()", returning = "pReturnValue")
	public void afterReturning(JoinPoint pJoinPoint, Object pReturnValue) {

		if (LOGGER.isDebugEnabled()) {

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
			LOGGER.debug(new StringBuilder("\n>>>>>>>>>>>>>>>>>>>>>>>after log<<<<<<<<<<<<<<<<<<<<<<<<<").append("\nMethod = [")
					.append(pJoinPoint.getTarget().getClass().getName()).append(".").append(pJoinPoint.getSignature().getName()).append(" ] ")
					.append("\nReturnValues Size =  [")
					.append(FileUtils.byteCountToDisplaySize(sizeOf(pReturnValue))).append(" ]").toString());
			
//			logger.debug(new StringBuilder("\n>>>>>>>>>>>>>>>>>>>>>>>after log<<<<<<<<<<<<<<<<<<<<<<<<<").append("\nMethod = [")
//					.append(pJoinPoint.getTarget().getClass().getName()).append(".").append(pJoinPoint.getSignature().getName()).append(" ] ")
//					.append("\nReturnValues =  [")
//					.append(_prams).append(" ]").toString());
		}
	}

	public long sizeOf(Object pObject) {
		long _size = 0;
		if (pObject == null) {
			return 0;
		}

		try {
			ByteArrayOutputStream _bOut = new ByteArrayOutputStream();
			ObjectOutputStream _oOut = new ObjectOutputStream(_bOut);

			_oOut.writeObject(pObject);
			_size = _bOut.size();
			_oOut.close();

		} catch (IOException e) {
			LOGGER.debug("객체 사이즈 측정 중 에러 발생!", e);
			throw new RuntimeException(e);
		}

		return _size;
	}

}
