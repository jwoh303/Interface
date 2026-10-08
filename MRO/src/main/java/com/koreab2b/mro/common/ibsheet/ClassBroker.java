package com.koreab2b.mro.common.ibsheet;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ClassBroker {

	private static final Logger logger = LoggerFactory.getLogger(ClassBroker.class);

	public static Object getInstance(String className) {
		Object instance = null;

		try {
			Class<?> dsClass = Class.forName(className);
			Class<?>[] parameterTypes = new Class[] {};
			Constructor<?> constuctor = dsClass.getConstructor(parameterTypes);
			instance = constuctor.newInstance(new Object[] {});
		} catch (ClassNotFoundException e) {
			logger.error("객체 생성 중 클래스를 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (SecurityException e) {
			logger.error("객체 생성 중 보안 에러 발생!", e);
			throw new RuntimeException(e);
		} catch (NoSuchMethodException e) {
			logger.error("객체 생성 중 메소드 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (IllegalArgumentException e) {
			logger.error("객체 생성 중 잘못된 아큐먼트 입력!", e);
			throw new RuntimeException(e);
		} catch (InstantiationException e) {
			logger.error("객체 생성 중 초기화 실패!", e);
			throw new RuntimeException(e);
		} catch (IllegalAccessException e) {
			logger.error("객체 생성 중 비정상 접근 발생!", e);
			throw new RuntimeException(e);
		} catch (InvocationTargetException e) {
			logger.error("객체 생성 중 호출 에러 발생!", e);
			throw new RuntimeException(e);
		}
		return instance;
	}

	public static Object getInstance(String className, HttpServletRequest request) {
		Object instance = null;
		try {
			Class<?> dsClass = Class.forName(className);
			Class<?>[] parameterTypes = new Class[] { HttpServletRequest.class };
			Constructor<?> constuctor = dsClass.getConstructor(parameterTypes);
			instance = constuctor.newInstance(new Object[] { request });
		} catch (ClassNotFoundException e) {
			logger.error("객체 생성 중 클래스를 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (SecurityException e) {
			logger.error("객체 생성 중 보안 에러 발생!", e);
			throw new RuntimeException(e);
		} catch (NoSuchMethodException e) {
			logger.error("객체 생성 중 메소드 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (IllegalArgumentException e) {
			logger.error("객체 생성 중 잘못된 아큐먼트 입력!", e);
			throw new RuntimeException(e);
		} catch (InstantiationException e) {
			logger.error("객체 생성 중 초기화 실패!", e);
			throw new RuntimeException(e);
		} catch (IllegalAccessException e) {
			logger.error("객체 생성 중 비정상 접근 발생!", e);
			throw new RuntimeException(e);
		} catch (InvocationTargetException e) {
			logger.error("객체 생성 중 호출 에러 발생!", e);
			throw new RuntimeException(e);
		}

		return instance;
	}

	public static Object getInstance(String className, HttpServletRequest request, HttpServletResponse response) {
		Object instance = null;
		try {
			Class<?> dsClass = Class.forName(className);
			Class<?>[] parameterTypes = new Class[] { HttpServletRequest.class, HttpServletResponse.class };
			Constructor<?> constuctor = dsClass.getConstructor(parameterTypes);
			instance = constuctor.newInstance(new Object[] { request, response });
		} catch (ClassNotFoundException e) {
			logger.error("객체 생성 중 클래스를 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (SecurityException e) {
			logger.error("객체 생성 중 보안 에러 발생!", e);
			throw new RuntimeException(e);
		} catch (NoSuchMethodException e) {
			logger.error("객체 생성 중 메소드 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (IllegalArgumentException e) {
			logger.error("객체 생성 중 잘못된 아큐먼트 입력!", e);
			throw new RuntimeException(e);
		} catch (InstantiationException e) {
			logger.error("객체 생성 중 초기화 실패!", e);
			throw new RuntimeException(e);
		} catch (IllegalAccessException e) {
			logger.error("객체 생성 중 비정상 접근 발생!", e);
			throw new RuntimeException(e);
		} catch (InvocationTargetException e) {
			logger.error("객체 생성 중 호출 에러 발생!", e);
			throw new RuntimeException(e);
		}

		return instance;
	}

	public static Object getInstance(String className, HttpServletRequest request, Connection conn) {
		Object instance = null;
		try {
			Class<?> dsClass = Class.forName(className);
			Class<?>[] parameterTypes = new Class[] { Connection.class, HttpServletRequest.class };
			Constructor<?> constuctor = dsClass.getConstructor(parameterTypes);
			instance = constuctor.newInstance(new Object[] { conn, request });
		} catch (ClassNotFoundException e) {
			logger.error("객체 생성 중 클래스를 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (SecurityException e) {
			logger.error("객체 생성 중 보안 에러 발생!", e);
			throw new RuntimeException(e);
		} catch (NoSuchMethodException e) {
			logger.error("객체 생성 중 메소드 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (IllegalArgumentException e) {
			logger.error("객체 생성 중 잘못된 아큐먼트 입력!", e);
			throw new RuntimeException(e);
		} catch (InstantiationException e) {
			logger.error("객체 생성 중 초기화 실패!", e);
			throw new RuntimeException(e);
		} catch (IllegalAccessException e) {
			logger.error("객체 생성 중 비정상 접근 발생!", e);
			throw new RuntimeException(e);
		} catch (InvocationTargetException e) {
			logger.error("객체 생성 중 호출 에러 발생!", e);
			throw new RuntimeException(e);
		}

		return instance;
	}

	public static Object getInstance(String className, HttpServletRequest request, HttpServletResponse response, Connection conn) {
		Object instance = null;
		try {
			Class<?> dsClass = Class.forName(className);
			Class<?>[] parameterTypes = new Class[] { Connection.class, HttpServletRequest.class, HttpServletResponse.class };
			Constructor<?> constuctor = dsClass.getConstructor(parameterTypes);
			instance = constuctor.newInstance(new Object[] { conn, request, response });
		} catch (ClassNotFoundException e) {
			logger.error("객체 생성 중 클래스를 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (SecurityException e) {
			logger.error("객체 생성 중 보안 에러 발생!", e);
			throw new RuntimeException(e);
		} catch (NoSuchMethodException e) {
			logger.error("객체 생성 중 메소드 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (IllegalArgumentException e) {
			logger.error("객체 생성 중 잘못된 아큐먼트 입력!", e);
			throw new RuntimeException(e);
		} catch (InstantiationException e) {
			logger.error("객체 생성 중 초기화 실패!", e);
			throw new RuntimeException(e);
		} catch (IllegalAccessException e) {
			logger.error("객체 생성 중 비정상 접근 발생!", e);
			throw new RuntimeException(e);
		} catch (InvocationTargetException e) {
			logger.error("객체 생성 중 호출 에러 발생!", e);
			throw new RuntimeException(e);
		}

		return instance;
	}

	public static Object getInstance(String className, Object[] constructParameters) {
		Object instance = null;
		try {
			Class<?> dsClass = Class.forName(className);
			Constructor<?> constuctor = dsClass.getConstructor(ClassBroker.getParameterTypes(constructParameters));
			instance = constuctor.newInstance(constructParameters);
		} catch (ClassNotFoundException e) {
			logger.error("객체 생성 중 클래스를 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (SecurityException e) {
			logger.error("객체 생성 중 보안 에러 발생!", e);
			throw new RuntimeException(e);
		} catch (NoSuchMethodException e) {
			logger.error("객체 생성 중 메소드 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (IllegalArgumentException e) {
			logger.error("객체 생성 중 잘못된 아큐먼트 입력!", e);
			throw new RuntimeException(e);
		} catch (InstantiationException e) {
			logger.error("객체 생성 중 초기화 실패!", e);
			throw new RuntimeException(e);
		} catch (IllegalAccessException e) {
			logger.error("객체 생성 중 비정상 접근 발생!", e);
			throw new RuntimeException(e);
		} catch (InvocationTargetException e) {
			logger.error("객체 생성 중 호출 에러 발생!", e);
			throw new RuntimeException(e);
		}

		return instance;
	}

	public static Object invoke(Object controller, String methodName, Object[] parameters) {
		Object objReturn = null;
		try {
			Class<?> ctlClass = controller.getClass();
			Method method = ctlClass.getMethod(methodName, ClassBroker.getParameterTypes(parameters));
			objReturn = method.invoke(controller, parameters);
		} catch (SecurityException e) {
			logger.error("객체 생성 중 보안 에러 발생!", e);
			throw new RuntimeException(e);
		} catch (NoSuchMethodException e) {
			logger.error("객체 생성 중 메소드 찾을 수 없음!", e);
			throw new RuntimeException(e);
		} catch (IllegalArgumentException e) {
			logger.error("객체 생성 중 잘못된 아큐먼트 입력!", e);
			throw new RuntimeException(e);
		} catch (IllegalAccessException e) {
			logger.error("객체 생성 중 비정상 접근 발생!", e);
			throw new RuntimeException(e);
		} catch (InvocationTargetException e) {
			logger.error("객체 생성 중 호출 에러 발생!", e);
			throw new RuntimeException(e);
		}

		return objReturn;
	}

	public static Class<?>[] getParameterTypes(Object[] parameters) {
		Class<?>[] parameterTypes = null;
		try {
			parameterTypes = new Class[parameters.length];
			int size = parameters.length;
			for (int i = 0; i < size; i++) {
				parameterTypes[i] = parameters[i].getClass();
			}
		} catch (SecurityException e) {
			logger.error("객체 생성 중 보안 에러 발생!", e);
			throw new RuntimeException(e);
		} catch (IllegalArgumentException e) {
			logger.error("객체 생성 중 잘못된 아큐먼트 입력!", e);
			throw new RuntimeException(e);
		}

		return parameterTypes;
	}
}
