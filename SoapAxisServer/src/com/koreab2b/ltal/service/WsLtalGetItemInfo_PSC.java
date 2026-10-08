package com.koreab2b.ltal.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.ltal.dao.WsLtalGetItemInfo_Dao;
import com.koreab2b.ltal.dao.WsLtalGetItemInfo_DaoImpl;
import com.koreab2b.ltal.vo.ItemVO;
import com.koreab2b.ltal.vo.RequestVO;

public class WsLtalGetItemInfo_PSC implements WsLtalGetItemInfo_PSI {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public List<ItemVO> getItemInfo(RequestVO requestVO) throws Exception{
		List<ItemVO> ret = null;
		WsLtalGetItemInfo_Dao dao = new WsLtalGetItemInfo_DaoImpl();
		ret = dao.getItemInfo(requestVO);
		
		CommonDao if_dao = new CommonDaoImpl();
		Map<String, String> tMap	= new HashMap<String, String>();
		tMap.put("COM_CODE", "KRLOTTG004");
		tMap.put("TASK_GUBUN","IT");
		tMap.put("IF_TYPE","품목-02-송신");
		if_dao.updateIfStatus(tMap);
		
		return ret;
	}
	
	@Override
	public void saveLog() throws Exception {
		Date toDay = new Date();
		log.info(toDay + " - INTERFACE_ID : " + "WsLtalGetItemInfo_PSC");
	}
}
