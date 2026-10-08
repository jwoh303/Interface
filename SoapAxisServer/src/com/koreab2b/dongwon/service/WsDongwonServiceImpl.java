package com.koreab2b.dongwon.service;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.common.vo.LogVo;
import com.koreab2b.dongwon.dao.WsDongwonDao;
import com.koreab2b.dongwon.dao.WsDongwonDaoImpl;
import com.koreab2b.dongwon.vo.POData;
import com.koreab2b.dongwon.vo.Response;

public class WsDongwonServiceImpl implements WsDongwonService {
	
	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public Response savePO(POData iMap) throws Exception {
		WsDongwonDao dao	= new WsDongwonDaoImpl();
		Response rtn	= new Response();

		rtn	= dao.savePO(iMap);
		return rtn;
	}

	@Override
	public void saveLog(POData iMap, Response rtn) throws Exception {
		CommonDao dao	= new CommonDaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.rfq.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:savePO>\n");
			
			xml.append(iMap.getXml());	
			
			xml.append("    </web:savePO>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("WsDongwon");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG(rtn.getTYPE());
			logVo.setERROR_MSG(rtn.getMESSAGE());

			dao.saveLog(logVo);

		} catch (Exception e) {
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			try {
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
}