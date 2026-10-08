package com.koreab2b.ltal.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.ltal.service.WsLtalSetAppStatus_PSC;
import com.koreab2b.ltal.service.WsLtalSetAppStatus_PSI;
import com.koreab2b.ltal.vo.ApprovalStatusVO;
import com.koreab2b.ltal.vo.ReturnVO;

@WebService(serviceName="WsLtalSetApprovalStatus")
public class WsLtalSetApprovalStatusImpl implements WsLtalSetApprovalStatus {

	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public ReturnVO saveApprovalStatus(ApprovalStatusVO[] aprList) {

		ReturnVO ret = null;
		
		WsLtalSetAppStatus_PSI service = new WsLtalSetAppStatus_PSC();
		
		try {
			ret = service.saveAppInfo(aprList);
		} catch (Exception e) {
			log.error("WsLtalSetApprovalStatus Error : " + CommonUtil.printStackTraceToString(e));
			ret = new ReturnVO();
			ret.setResult("E");
			ret.setErr_msg(e.getMessage());
		} finally {
			try {service.saveLog(aprList,ret);} catch (Exception e2) {}
		}
		return ret;
	}
}