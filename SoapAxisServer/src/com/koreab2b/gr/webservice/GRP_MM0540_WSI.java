package com.koreab2b.gr.webservice;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.gr.vo.GrVO;

public interface GRP_MM0540_WSI {

	/**
	 * 입고 인터페이스 데이터 저장
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public WsPrimitiveVO saveData(GrVO obj) throws Exception;
}
