package com.koreab2b.ltal.service;

import java.util.List;

import com.koreab2b.ltal.vo.PurchaseOrderVO;
import com.koreab2b.ltal.vo.RequestVO;

public interface WsLtalGetPOInfo_PSI {

	public List<PurchaseOrderVO> getPoInfo(RequestVO requestVO) throws Exception;

	public void saveLog() throws Exception;
	
}
