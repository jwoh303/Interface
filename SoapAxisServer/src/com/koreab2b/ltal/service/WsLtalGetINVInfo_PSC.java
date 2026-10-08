package com.koreab2b.ltal.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.ltal.dao.WsLtalGetINVInfo_Dao;
import com.koreab2b.ltal.dao.WsLtalGetINVInfo_DaoImpl;
import com.koreab2b.ltal.vo.InvoiceVO;
import com.koreab2b.ltal.vo.RequestVO;

public class WsLtalGetINVInfo_PSC implements WsLtalGetINVInfo_PSI {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public List<InvoiceVO> getInvInfo(RequestVO requestVO) throws Exception{
		List<InvoiceVO> ret = new ArrayList<InvoiceVO>();
		WsLtalGetINVInfo_Dao dao = new WsLtalGetINVInfo_DaoImpl();
		ret.addAll(dao.getInvInfo(requestVO));
		
		CommonDao if_dao = new CommonDaoImpl();
		Map<String, String> tMap	= new HashMap<String, String>();
		tMap.put("COM_CODE", "KRLOTTG004");
		tMap.put("TASK_GUBUN","IV");
		tMap.put("IF_TYPE","납품-02-송신");
		if_dao.updateIfStatus(tMap);
		
		return ret;
	}
	
	@Override
	public void saveLog() throws Exception {
		Date toDay = new Date();
		log.info(toDay + " - INTERFACE_ID : " + "WsLtalGetINVInfo_PSC");
	}
}
