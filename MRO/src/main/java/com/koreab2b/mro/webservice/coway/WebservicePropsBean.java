package com.koreab2b.mro.webservice.coway;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.koreab2b.mro.util.CommonUtil;

@Component
public class WebservicePropsBean {

	/**
	 * Coway point webservice REAL/TEST
	 */
	@Value("#{webServiceProps['resource.webService.cls']}")
	private String webServiceCon;
	/**
	 * Coway point webservice REAL/TEST
	 */
	@Value("#{webServiceProps['resource.webService.clsDev']}")
	private String webServiceConDev;
	
	public String getWebServiceCon(HttpServletRequest req){
		// TODO 오픈시 아래주석으로 변경
		if("2".equals(CommonUtil.getDevRealLocalFlag(req)))
			return this.webServiceCon;
		else
			return this.webServiceConDev;
	}
	public String getWebServiceCon(){
		return "TEST";
	}

}
