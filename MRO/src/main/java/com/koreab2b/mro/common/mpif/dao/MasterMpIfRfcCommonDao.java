package com.koreab2b.mro.common.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfRfcCommonDao {

	/**
	 * 영풍 RFC 호출 속성치
	 * @param pMap
	 * @return
	 */
	List<Map<String, String>> getRFCYPProperties(Map<String, String> pMap);
}
