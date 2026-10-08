package com.koreab2b.gr.service;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.gr.vo.GrVO;

public interface GRP_MM0540_PSI {

	/**
	 * 입고 인터페이스 처리
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public WsPrimitiveVO saveData(GrVO obj) throws Exception;
	

	/**
	 * 웹서비스 메세지 저장.
	 * @param obj
	 * @throws Exception
	 */
	public void saveLog(GrVO obj, WsPrimitiveVO rtn) throws Exception;
}
