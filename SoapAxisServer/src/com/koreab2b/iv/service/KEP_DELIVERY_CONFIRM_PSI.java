package com.koreab2b.iv.service;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.iv.vo.DeliveryConfirmVO;

public interface KEP_DELIVERY_CONFIRM_PSI {

	/**
	 * 발주 인터페이스 데이터 저장
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public WsPrimitiveVO saveDeliveryConfirm(DeliveryConfirmVO[] arrVo) throws Exception;
	
	/**
	 * 발주 메세지 이력 저장.
	 * @param obj
	 * @param rtn
	 * @throws Exception
	 */
	public void saveLog(DeliveryConfirmVO[] arrVo, WsPrimitiveVO rtn) throws Exception;
}
