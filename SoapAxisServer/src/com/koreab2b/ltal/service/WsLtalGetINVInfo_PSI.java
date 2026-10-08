package com.koreab2b.ltal.service;

import java.util.List;

import com.koreab2b.ltal.vo.InvoiceVO;
import com.koreab2b.ltal.vo.RequestVO;

public interface WsLtalGetINVInfo_PSI {

	public List<InvoiceVO> getInvInfo(RequestVO requestVO) throws Exception;
	
	public void saveLog() throws Exception;
}
