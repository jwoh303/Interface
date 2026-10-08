package com.koreab2b.xica.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.xica.service.WsXicaSetAppStatus_PSC;
import com.koreab2b.xica.service.WsXicaSetAppStatus_PSI;
import com.koreab2b.xica.vo.xicaAppStatusVO;
import com.koreab2b.xica.vo.xicaReturnVO;


@WebService(serviceName = "WsXicaAppStatus")
public class WsXicaAppStatusImpl implements WsXicaAppStatus {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public xicaReturnVO saveApprovalStatus(xicaAppStatusVO aprList) throws Exception {
		xicaReturnVO ret = null;
		WsXicaSetAppStatus_PSI service = new WsXicaSetAppStatus_PSC();
		
		try {
			ret = service.saveAppInfo(aprList);
		} catch (Exception e) {
			log.error("WsXicaAppStatus Error !!!!  : " + CommonUtil.printStackTraceToString(e));
			ret = new xicaReturnVO();
			ret.setResultSt("F");
			ret.setErrMsg(CommonUtil.printStackTraceToString(e));
		} finally {
			try {service.saveLog(aprList, ret);} catch (Exception e2) {e2.printStackTrace();}
		}
		return ret;
	}

}
