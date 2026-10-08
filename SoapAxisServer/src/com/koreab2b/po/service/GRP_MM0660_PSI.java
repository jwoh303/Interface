package com.koreab2b.po.service;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.po.vo.PoVO;

public interface GRP_MM0660_PSI {

	/**
	 * 발주 인터페이스 데이터 저장
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public WsPrimitiveVO saveData(PoVO obj) throws Exception;
	
	/**
	 * 발주 메세지 이력 저장.
	 * @param obj
	 * @param rtn
	 * @throws Exception
	 */
	public void saveLog(PoVO obj, WsPrimitiveVO rtn) throws Exception;
}
