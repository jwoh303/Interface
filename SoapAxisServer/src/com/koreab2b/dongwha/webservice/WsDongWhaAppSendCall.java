package com.koreab2b.dongwha.webservice;

import java.util.ArrayList;
import java.util.List;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.ReturnVO;
import com.koreab2b.dongwha.service.WsDongwhaService;
import com.koreab2b.dongwha.vo.AppSendCallVO;
import com.koreab2b.dongwha.vo.AppStatusVO;
import com.koreab2b.dongwha.vo.AssetVO;
import com.koreab2b.dongwha.vo.CostCenterVO;
import com.koreab2b.dongwha.vo.GrVO;
import com.koreab2b.dongwha.vo.ItemVO;
import com.koreab2b.dongwha.vo.PoVO;
import com.koreab2b.dongwha.vo.UserVO;
import com.koreab2b.util.CommonUtil;

@WebService(serviceName="WsDongWhaAppSendCall")
public class WsDongWhaAppSendCall {

	private Logger log	= Logger.getLogger(this.getClass());
	private WsDongwhaService service = new WsDongwhaService();

	public ReturnVO setAppSendCall(List<AppSendCallVO> objs) {

		AppSendCallVO appsendcallvo = new AppSendCallVO();
		ReturnVO revo = new ReturnVO();
		
		
			try {
			    service.setAppSendCallList(objs);
			    revo.setRESULT_FLAG("S");
				revo.setMESSAGE("SUCCESS");
			} catch (Exception e) {
				log.error(CommonUtil.printStackTraceToString(e));
				revo.setRESULT_FLAG("F");
				revo.setMESSAGE(e.getMessage());
			} finally {
				service.setSaveAppSendCallLog(objs);
				log.info("DONGWHA setAppSendCall : " + revo.getRESULT_FLAG());
			}

		return revo;
	}

}