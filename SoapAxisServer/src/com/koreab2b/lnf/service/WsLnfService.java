package com.koreab2b.lnf.service;

import org.apache.log4j.Logger;

import com.koreab2b.lnf.dao.WsLnfDao;
import com.koreab2b.lnf.vo.AppData;
import com.koreab2b.lnf.vo.RtnVO;

public class WsLnfService {

	private Logger log	= Logger.getLogger(this.getClass());
	
	public RtnVO setApp(AppData iMap) {
		WsLnfDao dao = new WsLnfDao();
		RtnVO rtn = new RtnVO();
		
		rtn = dao.setApp(iMap);
		return rtn;
		
	}
	
	public RtnVO setAppRtn(AppData iMap) {
		WsLnfDao dao = new WsLnfDao();
		RtnVO rtn = new RtnVO();
		
		rtn = dao.setApp(iMap);
		return rtn;
		
	}
}
