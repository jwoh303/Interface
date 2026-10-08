package com.koreab2b.xica.service;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.dao.CommonCHINADao;
import com.koreab2b.common.dao.CommonCHINADaoImpl;
import com.koreab2b.common.vo.LogVo;
import com.koreab2b.xica.dao.WsXicaSetAppStatus_Dao;
import com.koreab2b.xica.dao.WsXicaSetAppStatus_DaoImpl;
import com.koreab2b.xica.vo.xicaAppStatusVO;
import com.koreab2b.xica.vo.xicaReturnVO;

public class WsXicaSetAppStatus_PSC implements WsXicaSetAppStatus_PSI {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public xicaReturnVO saveAppInfo(xicaAppStatusVO aprList) throws Exception {
		xicaReturnVO ret = new xicaReturnVO();
		WsXicaSetAppStatus_Dao dao= new WsXicaSetAppStatus_DaoImpl();
		try {
			if (aprList.getProgSt() == null || aprList.getProgSt().isEmpty()) {
				ret.setResultSt("F");
				ret.setErrMsg("문서결재상태(progSt) 값이 없습니다.");
			}else if (aprList.getAppvTpNum() == null || aprList.getAppvTpNum().isEmpty()) {
				ret.setResultSt("F");
				ret.setErrMsg("결재번호(appvTpNum) 값이 없습니다.");
			}else if (aprList.getAppDetail().get(0).getAppSeqField() == null || aprList.getAppDetail().get(0).getAppSeqField().isEmpty()) {
				ret.setResultSt("F");
				ret.setErrMsg("결재순서(appSeqField) 값이 없습니다.");
			}else {
				ret = dao.saveAppstatus(aprList);
			}
		} catch (Exception e) {
		    e.printStackTrace();
			ret.setResultSt("F");
			ret.setErrMsg(CommonUtil.printStackTraceToString(e));
		}
		return ret;
	}

	@Override
	public void saveLog(xicaAppStatusVO aprList, xicaReturnVO rtn) {
		CommonCHINADao dao2	= new CommonCHINADaoImpl();
		LogVo logVo	= new LogVo();
		StringBuffer xml	= new StringBuffer();
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.rfq.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:saveAppInfo>\n");
			
			xml.append(aprList.getXml());
			
			xml.append("    </web:saveAppInfo>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("WsXicaSetAppStatus");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG(rtn.getResultSt());
			logVo.setERROR_MSG(rtn.getErrMsg());
			dao2.getSqlMapClient().startTransaction();
			dao2.saveLog(logVo);
			dao2.getSqlMapClient().commitTransaction();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("WsXicaSetAppStatus log save Error : "+CommonUtil.printStackTraceToString(e));
		} finally {
			try {
				dao2.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

}
