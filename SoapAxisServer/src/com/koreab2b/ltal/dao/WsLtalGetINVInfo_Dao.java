package com.koreab2b.ltal.dao;

import java.util.List;

import com.koreab2b.ltal.vo.InvoiceVO;
import com.koreab2b.ltal.vo.RequestVO;

public interface WsLtalGetINVInfo_Dao {

	public List<InvoiceVO> getInvInfo(RequestVO requestVO) throws Exception;
}
