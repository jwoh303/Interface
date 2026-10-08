package com.koreab2b.po.webservice;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.po.vo.PoVO;

public interface GRP_MM0660_WSI {

	/**
	 * 발주 Provider
	 * @param objs
	 * @return
	 * @throws Exception
	 */
	public WsPrimitiveVO saveData(PoVO obj) throws Exception;
}