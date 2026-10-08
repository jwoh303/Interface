package com.kep.hancom.dao;

import java.util.Map;

public interface HanComKepIfDao {

	int insertIfCode(Map<String, Object> paramMap);

	void execProcIf();

}
