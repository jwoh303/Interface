package com.koreab2b.rfq.service;

import java.util.List;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.common.dao.CommonCHINADao;
import com.koreab2b.common.dao.CommonCHINADaoImpl;
import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.common.vo.LogVo;
import com.koreab2b.rfq.dao.GRP_MM0110_CHINA_Dao;
import com.koreab2b.rfq.dao.GRP_MM0110_CHINA_DaoImpl;
import com.koreab2b.rfq.dao.GRP_MM0110_Dao;
import com.koreab2b.rfq.dao.GRP_MM0110_DaoImpl;
import com.koreab2b.rfq.vo.RfqVO;
import com.koreab2b.util.CommonUtil;

public class GRP_MM0110_PSC implements GRP_MM0110_PSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public WsPrimitiveVO saveData(List<RfqVO> objs) throws Exception {
		WsPrimitiveVO rtn	= new WsPrimitiveVO();
		WsHeaderVO wsHeader	= null;
		int rtnValue		= 0;
		GRP_MM0110_Dao dao	= new GRP_MM0110_DaoImpl();
		GRP_MM0110_CHINA_Dao daoChina	= new GRP_MM0110_CHINA_DaoImpl();

		try {
			dao.getSqlMapClient().startTransaction();
			daoChina.getSqlMapClient().startTransaction();
			
			for(RfqVO m : objs) {
				if ("5111:5112:5110:".indexOf(m.getWERKS()) > -1) {
					rtnValue = daoChina.saveData(m);
				} else {
					rtnValue = dao.saveData(m);
				}
			}
			
			if(rtnValue > 0) {
				dao.getSqlMapClient().commitTransaction();
				daoChina.getSqlMapClient().commitTransaction();
				wsHeader	= new WsResultConstants().WsResult(WS_RESULT.OK);
			} else {
				throw new Exception("데이터 처리중 오류가 발생했습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			rtn.setReturnString(e.getMessage());
			wsHeader	= new WsResultConstants().WsResult(WS_RESULT.ERROR);
		} finally {
			try {
				dao.getSqlMapClient().endTransaction();
				daoChina.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}

		rtn.setWsHeader(wsHeader);
		
		return rtn;
	}

	@Override
	public void saveLog(List<RfqVO> objs, WsPrimitiveVO rtn) throws Exception {
		CommonDao dao	= new CommonDaoImpl();
		CommonCHINADao cDao	= new CommonCHINADaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.rfq.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:saveData>\n");
			
			for(RfqVO m : objs) {
				xml.append(m.getXml());	
			}
			
			xml.append("    </web:saveData>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("GRP_MM0110");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG(rtn.getWsHeader().getzResultCd());
			logVo.setERROR_MSG(rtn.getReturnString());

			if ("5111:5112:5110:".indexOf(objs.get(0).getWERKS()) > -1) {
				cDao.getSqlMapClient().startTransaction();
				cDao.saveLog(logVo);
				cDao.getSqlMapClient().commitTransaction();
			} else {
				dao.getSqlMapClient().startTransaction();
				dao.saveLog(logVo);
				dao.getSqlMapClient().commitTransaction();
			}
			
		} catch (Exception e) {
			System.out.println(" MM0110 - WERKS : " + objs.get(0).getWERKS());
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
