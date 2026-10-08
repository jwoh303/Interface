package com.koreab2b.ltal.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.ltal.service.WsLtalSetResultInfo_PSC;
import com.koreab2b.ltal.service.WsLtalSetResultInfo_PSI;
import com.koreab2b.ltal.vo.ResultVO;
import com.koreab2b.ltal.vo.ReturnVO;

@WebService(serviceName="WsLtalSetResult")
public class WsLtalSetResultInfoImpl implements WsLtalSetResultInfo {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public ReturnVO setResultInfo(ResultVO[] resultVO) {

		WsLtalSetResultInfo_PSI service = new WsLtalSetResultInfo_PSC();
		ReturnVO ret = null;
		try {
			ret = service.setResultInfo(resultVO);
		} catch (Exception e) {
			log.error("WsLtalSetResult Error : " + CommonUtil.printStackTraceToString(e));
			ret = new ReturnVO();
			ret.setResult("E");
			ret.setErr_msg(e.getMessage());
		} finally {
			try {service.saveLog(resultVO, ret);} catch (Exception e2) {}
		}
		
		return ret;
	}
}
