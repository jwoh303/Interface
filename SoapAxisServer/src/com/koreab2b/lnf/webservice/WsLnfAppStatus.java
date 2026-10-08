package com.koreab2b.lnf.webservice;

import javax.jws.WebParam;
import javax.jws.WebService;

import com.koreab2b.lnf.service.WsLnfService;
import com.koreab2b.lnf.vo.AppData;
import com.koreab2b.lnf.vo.RtnVO;
import com.koreab2b.util.CommonUtil;
import org.apache.log4j.Logger;

@WebService(serviceName="WsLnfAppStatus")
public class WsLnfAppStatus {
	
	private Logger log	= Logger.getLogger(this.getClass());
	
	
	public RtnVO setApp(
			@WebParam(name="BUYER") String BUYER,
			@WebParam(name="DOC_NO") String DOC_NO) {
		
		WsLnfService service = new WsLnfService();
		RtnVO rtn = new RtnVO();
		AppData iMap = new AppData();
		
		try {
			iMap.setBUYER(BUYER);
			iMap.setDOC_NO(DOC_NO);
			
			//rtn = service.setApp(iMap);
			
		} catch (Exception e) {
			
		}
		
		return null;
	}
}
