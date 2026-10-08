package com.koreab2b.rfq.service;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.rfq.vo.CtrlItemVO;

public interface KEP_CTRL_ITEM_PSI {

	/**
	 * 다이렉트 소싱 정보 저장
	 * @param arrVo
	 * @return
	 * @throws Exception
	 */
	public WsPrimitiveVO saveCtrlItem(CtrlItemVO[] arrVo) throws Exception;

	/**
	 * 인터페이스 이력 저장
	 * @param arrVo
	 * @param rtn
	 * @throws Exception
	 */
	public void saveLog(CtrlItemVO[] arrVo, WsPrimitiveVO rtn) throws Exception;
}
