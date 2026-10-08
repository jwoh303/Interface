package com.koreab2b.mro.util;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.session.ResultContext;
import org.apache.ibatis.session.ResultHandler;

public class ResultRowHandler implements ResultHandler {

	private final List<Object> list = new ArrayList<Object>();

	@SuppressWarnings("unchecked")
	@Options(fetchSize = Integer.MIN_VALUE)
	public void handleResult(ResultContext context) {

		Map<String, String> _data = (Map<String, String>) context.getResultObject();
		Iterator<String> _keys = _data.keySet().iterator();

		while (_keys.hasNext()) {
			String _key = _keys.next();
			Object _value = _data.get(_key);
			if (_value == null) {
				_data.put(_key, "");
			}
		}

		list.add(_data);

		// list.add(context.getResultObject());
	}

	public Object getList() {
		return list;
	}

}
