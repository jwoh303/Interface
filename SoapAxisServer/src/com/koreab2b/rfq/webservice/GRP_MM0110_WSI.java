package com.koreab2b.rfq.webservice;

import java.util.List;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.rfq.vo.RfqVO;

public interface GRP_MM0110_WSI {
	
	public WsPrimitiveVO saveData(List<RfqVO> obj) throws Exception;
}