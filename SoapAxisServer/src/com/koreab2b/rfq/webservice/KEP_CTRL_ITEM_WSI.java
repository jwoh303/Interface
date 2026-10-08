package com.koreab2b.rfq.webservice;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.rfq.vo.CtrlItemVO;

public interface KEP_CTRL_ITEM_WSI {
	/**
	 * 다이렉트 품목 정보 저장
	 * @param arrVo
	 * @return
	 */
	public WsPrimitiveVO saveCtrlItem(CtrlItemVO[] arrVo);
}