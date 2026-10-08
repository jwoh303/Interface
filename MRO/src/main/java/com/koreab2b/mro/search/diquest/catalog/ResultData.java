package com.koreab2b.mro.search.diquest.catalog;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.diquest.ir.common.msg.protocol.query.SelectSet;
import com.diquest.ir.common.msg.protocol.result.Result;

public class ResultData {

	public List<Map<String, String>> getTotalList(SelectSet[] pGetselectSet, Result[] pResultList) {

		List<Map<String, String>> _totalList = new ArrayList<Map<String, String>>();
		Result _result = null;
		String _selectFieldName = null;
		
		for (int m = 0; pResultList != null && m < pResultList.length; m++) {
			_result = pResultList[m];
			if (_result.getRealSize() != 0) {
				for (int k = 0; k < _result.getRealSize(); k++) {
					Map<String, String> _tempMap = new HashMap<String, String>();
					for (int j = 0; j < _result.getNumField(); j++) {
						_selectFieldName = new String(pGetselectSet[j].getField());
						String temp = new String(_result.getResult(k, j));
						if (_selectFieldName.equals("AGENT")) {
							//if (temp.equals("MULTI_AGENT"))
								//temp = "복수공급사입니다";
							//if (temp.equals("KOREAEPLATFORM"))
								//temp = "코리아e플랫폼(주)";
						}
						_tempMap.put(_selectFieldName, temp);
					}
					_totalList.add(_tempMap);
				}
			}
		}
		return _totalList;
	}

}
