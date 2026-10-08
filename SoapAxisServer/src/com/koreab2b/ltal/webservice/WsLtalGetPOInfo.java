package com.koreab2b.ltal.webservice;

import com.koreab2b.ltal.vo.PurchaseOrderReturn;
import com.koreab2b.ltal.vo.RequestVO;


public interface WsLtalGetPOInfo {

	public PurchaseOrderReturn getPoInfo(RequestVO requestVO);
	
}
