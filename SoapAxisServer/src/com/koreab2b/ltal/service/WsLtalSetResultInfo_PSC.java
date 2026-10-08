package com.koreab2b.ltal.service;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.common.vo.LogVo;
import com.koreab2b.ltal.dao.WsLtalSetResultInfo_Dao;
import com.koreab2b.ltal.dao.WsLtalSetResultInfo_DaoImpl;
import com.koreab2b.ltal.vo.ResultVO;
import com.koreab2b.ltal.vo.ReturnVO;

public class WsLtalSetResultInfo_PSC implements WsLtalSetResultInfo_PSI {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public ReturnVO setResultInfo(ResultVO[] resultVOList) throws Exception{
		ReturnVO ret = null;
		WsLtalSetResultInfo_Dao dao = new WsLtalSetResultInfo_DaoImpl();
		ret = dao.setResultInfo(resultVOList);
		
		return ret;
	}
	
	@Override
	public void saveLog(ResultVO[] objs, ReturnVO rtn) throws Exception {
		CommonDao dao	= new CommonDaoImpl();
		LogVo logVo	= new LogVo();
		StringBuffer xml	= new StringBuffer();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.rfq.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:setResultInfo>\n");
			
			for (int i = 0 ; i < objs.length ; i++) {
				xml.append(objs[i].getXml());	
			}
			
			xml.append("    </web:setResultInfo>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("WsLtalSetResultInfo");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG(rtn.getResult());
			logVo.setERROR_MSG(rtn.getErr_msg());
			
		} catch (Exception e) {
			log.error("Error : "+CommonUtil.printStackTraceToString(e));
		}
	}
}
