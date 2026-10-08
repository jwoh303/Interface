package com.koreab2b.ltal.service;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.common.vo.LogVo;
import com.koreab2b.ltal.dao.WsLtalSetAppStatus_Dao;
import com.koreab2b.ltal.dao.WsLtalSetAppStatus_DaoImpl;
import com.koreab2b.ltal.vo.ApprovalStatusVO;
import com.koreab2b.ltal.vo.ReturnVO;

public class WsLtalSetAppStatus_PSC implements WsLtalSetAppStatus_PSI {

	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public ReturnVO saveAppInfo(ApprovalStatusVO[] aprList) throws Exception {
		ReturnVO ret = null;
		WsLtalSetAppStatus_Dao dao = new WsLtalSetAppStatus_DaoImpl();
		ret = dao.saveAppStatus(aprList);	
		
		return ret;
	}

	@Override
	public void saveLog(ApprovalStatusVO[] objs, ReturnVO rtn) {
		CommonDao dao	= new CommonDaoImpl();
		LogVo logVo	= new LogVo();
		StringBuffer xml	= new StringBuffer();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.rfq.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:saveAppInfo>\n");
			
			for (int i = 0 ; i < objs.length ; i++) {
				xml.append(objs[i].getXml());	
			}
			
			xml.append("    </web:saveAppInfo>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("WsLtalSetAppStatus");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG(rtn.getResult());
			logVo.setERROR_MSG(rtn.getErr_msg());

			dao.saveLog(logVo);
			
		} catch (Exception e) {
			log.error("Error : "+CommonUtil.printStackTraceToString(e));
		}
	}

}
