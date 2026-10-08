package com.koreab2b.dongwon.dao;

import java.util.List;

import com.koreab2b.dongwon.vo.POData;
import com.koreab2b.dongwon.vo.Response;

public interface WsDongwonDao {

	/**
	 * 동원그룹 발주 저장
	 * @param iMaps
	 * @return
	 */
	public Response savePO(POData iMap);
}
