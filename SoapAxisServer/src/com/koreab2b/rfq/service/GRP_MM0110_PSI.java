package com.koreab2b.rfq.service;

import java.util.List;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.rfq.vo.RfqVO;

public interface GRP_MM0110_PSI {

	/**
	 * 견적 인터페이스 데이터 저장
	 * @param objs
	 * @return
	 * @throws Exception
	 */
	public WsPrimitiveVO saveData(List<RfqVO> objs) throws Exception;
	
	/**
	 * 인터페이스 로그 저장.
	 * @param objs
	 * @throws Exception
	 */
	public void saveLog(List<RfqVO> objs, WsPrimitiveVO rtn) throws Exception;
}
