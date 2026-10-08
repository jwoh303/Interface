package com.koreab2b.ltal.service;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.common.vo.LogVo;
import com.koreab2b.ltal.dao.WsLtalSetGRInfo_Dao;
import com.koreab2b.ltal.dao.WsLtalSetGRInfo_DaoImpl;
import com.koreab2b.ltal.vo.GoodsReceiveVO;
import com.koreab2b.ltal.vo.ReturnVO;

public class WsLtalSetGRInfo_PSC implements WsLtalSetGRInfo_PSI {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public ReturnVO getGrInfo(GoodsReceiveVO[] goodsReceiveVOList) throws Exception{
		ReturnVO ret = null;
		WsLtalSetGRInfo_Dao dao = new WsLtalSetGRInfo_DaoImpl();
		ret = dao.setGrInfo(goodsReceiveVOList);	
		
		return ret;
	}
	
	@Override
	public void saveLog(GoodsReceiveVO[] objs, ReturnVO rtn) throws Exception {
		CommonDao dao	= new CommonDaoImpl();
		LogVo logVo	= new LogVo();
		StringBuffer xml	= new StringBuffer();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.rfq.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:getGrInfo>\n");
			
			for (int i = 0 ; i < objs.length ; i++) {
				xml.append(objs[i].getXml());	
			}
			
			xml.append("    </web:getGrInfo>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("WsLtalSetGRInfo");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG(rtn.getResult());
			logVo.setERROR_MSG(rtn.getErr_msg());

			dao.saveLog(logVo);
			
		} catch (Exception e) {
			log.error("Error : "+CommonUtil.printStackTraceToString(e));
		}
	}
}
