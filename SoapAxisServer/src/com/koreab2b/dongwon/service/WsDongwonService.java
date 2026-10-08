package com.koreab2b.dongwon.service;

import com.koreab2b.dongwon.vo.POData;
import com.koreab2b.dongwon.vo.Response;

public interface WsDongwonService {

	/**
	 * 동원 발주 인터페이스 처리.
	 * @param iMaps
	 * @return
	 */
	public Response savePO(POData iMap) throws Exception;
	
	/**
	 * 인터페이스 로그 저장
	 * @param iMap
	 * @param rtn
	 * @throws Exception
	 */
	public void saveLog(POData iMap, Response rtn) throws Exception;
}
