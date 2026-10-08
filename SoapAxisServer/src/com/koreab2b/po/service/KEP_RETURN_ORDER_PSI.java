package com.koreab2b.po.service;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.po.vo.ReturnOrderVO;

public interface KEP_RETURN_ORDER_PSI {

	/**
	 * 교환/반품 인터페이스 데이터 저장
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public WsPrimitiveVO saveReturnOrder(ReturnOrderVO[] arrVo) throws Exception;
	
	/**
	 * 교환/반품 메세지 이력 저장.
	 * @param obj
	 * @param rtn
	 * @throws Exception
	 */
	public void saveLog(ReturnOrderVO[] arrVo, WsPrimitiveVO rtn) throws Exception;

}
