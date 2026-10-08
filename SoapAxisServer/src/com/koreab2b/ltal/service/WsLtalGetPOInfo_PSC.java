package com.koreab2b.ltal.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;


import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.ltal.dao.WsLtalGetPOInfo_Dao;
import com.koreab2b.ltal.dao.WsLtalGetPOInfo_DaoImpl;
import com.koreab2b.ltal.vo.PurchaseOrderVO;
import com.koreab2b.ltal.vo.RequestVO;

public class WsLtalGetPOInfo_PSC implements WsLtalGetPOInfo_PSI {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public List<PurchaseOrderVO> getPoInfo(RequestVO requestVO) throws Exception{
		List<PurchaseOrderVO> ret = new ArrayList<PurchaseOrderVO>();
		WsLtalGetPOInfo_Dao dao = new WsLtalGetPOInfo_DaoImpl();
		ret.addAll(dao.getPoInfo(requestVO));
		
		CommonDao if_dao = new CommonDaoImpl();
		Map<String, String> tMap	= new HashMap<String, String>();
		tMap.put("COM_CODE", "KRLOTTG004");
		tMap.put("TASK_GUBUN","PO");
		tMap.put("IF_TYPE","발주-02-송신");
		if_dao.updateIfStatus(tMap);
		
		return ret;
	}
	
	@Override
	public void saveLog() throws Exception {
		Date toDay = new Date();
		log.info(toDay + " - INTERFACE_ID : " + "WsLtalGetPOInfo_PSC");
	}
}
