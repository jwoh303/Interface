package com.koreab2b.gr.service;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.gr.vo.GoodsReceiveVO;

public interface KEP_GOODS_RECEIVE_PSI {

	/**
	 * 발주 인터페이스 데이터 저장
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public WsPrimitiveVO saveGoodsReceive(GoodsReceiveVO[] arrVo) throws Exception;
	
	/**
	 * 발주 메세지 이력 저장.
	 * @param obj
	 * @param rtn
	 * @throws Exception
	 */
	public void saveLog(GoodsReceiveVO[] arrVo, WsPrimitiveVO rtn) throws Exception;
}
