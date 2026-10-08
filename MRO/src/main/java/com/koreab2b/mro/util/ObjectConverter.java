package com.koreab2b.mro.util;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ObjectConverter {

	private static final Logger LOGGER = LoggerFactory.getLogger(ObjectConverter.class);

	@SuppressWarnings("unchecked")
	public static List<Map<String, String>> listObjectToListMap(Object pSource) {
		String _error = "객체 리스트 를 맵 리스트로 변환중 오류가 발생했습니다.";
		List<Map<String, String>> _listMap = new ArrayList<Map<String, String>>();

		for (Object object : (List<Object>) pSource) {
			try {
				_listMap.add(BeanUtils.describe(object));
			} catch (IllegalAccessException e) {
				LOGGER.error(_error, e);
			} catch (InvocationTargetException e) {
				LOGGER.error(_error, e);
			} catch (NoSuchMethodException e) {
				LOGGER.error(_error, e);
			}
		}
		return _listMap;
	}

	public static Map<String, String> ObjectToMap(Object pSource) {
		String _error = "객체를 맵으로 변환중 오류가 발생했습니다.";
		Map<String, String> _map = null;
		try {
			_map = BeanUtils.describe(pSource);
		} catch (IllegalAccessException e) {
			LOGGER.error(_error, e);
		} catch (InvocationTargetException e) {
			LOGGER.error(_error, e);
		} catch (NoSuchMethodException e) {
			LOGGER.error(_error, e);
		}
		return _map;
	}

	
	public static Object listMapToListObject(List<Map<String, String>> pSource, Class<?> pTarget) {
		String _error = "맵 리스트 를 객체 리스트로 변환중 오류가 발생했습니다.";
		List<Object> _targetList = new ArrayList<Object>();
		try {
			for (Map<String, String> _tmpSource : pSource) {
				Object _target = pTarget.newInstance();
				BeanUtils.populate(_target, (Map<String, ? extends Object>) _tmpSource);
				_targetList.add(_target);
			}
		} catch (InstantiationException e) {
			LOGGER.error(_error, e);
		} catch (IllegalAccessException e) {
			LOGGER.error(_error, e);
		} catch (InvocationTargetException e) {
			LOGGER.error(_error, e);
		}
		return _targetList;
	}
}
