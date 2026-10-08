package com.koreab2b.ltal.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.ltal.service.WsLtalSetGRInfo_PSC;
import com.koreab2b.ltal.service.WsLtalSetGRInfo_PSI;
import com.koreab2b.ltal.vo.GoodsReceiveVO;
import com.koreab2b.ltal.vo.ReturnVO;

@WebService(serviceName="WsLtalSetGRInfo")
public class WsLtalSetGRInfoImpl implements WsLtalSetGRInfo {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public ReturnVO getGrInfo(GoodsReceiveVO[] goodsReceiveVOList) {
		
		ReturnVO ret = null;
		
		WsLtalSetGRInfo_PSI service = new WsLtalSetGRInfo_PSC();
		
		try {
			ret = service.getGrInfo(goodsReceiveVOList);
		} catch (Exception e) {
			log.error("WsLtalSetGRInfo Error : " + CommonUtil.printStackTraceToString(e));
			ret = new ReturnVO();
			ret.setResult("E");
			ret.setErr_msg(e.getMessage());
		} finally {
			try {service.saveLog(goodsReceiveVOList,ret);} catch (Exception e2) {}
		}
		
		return ret;
	}
}
