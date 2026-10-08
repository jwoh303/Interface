package com.koreab2b.ltal.webservice;

import com.koreab2b.ltal.vo.InvoiceReturn;
import com.koreab2b.ltal.vo.RequestVO;


public interface WsLtalGetINVInfo {

	public InvoiceReturn getInvInfo(RequestVO requestVO);
}