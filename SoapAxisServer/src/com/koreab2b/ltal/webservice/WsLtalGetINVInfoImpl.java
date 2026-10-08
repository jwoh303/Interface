package com.koreab2b.ltal.webservice;

import java.util.List;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.ltal.service.WsLtalGetINVInfo_PSC;
import com.koreab2b.ltal.service.WsLtalGetINVInfo_PSI;
import com.koreab2b.ltal.vo.InvoiceReturn;
import com.koreab2b.ltal.vo.InvoiceVO;
import com.koreab2b.ltal.vo.RequestVO;

@WebService(serviceName="WsLtalGetINVInfo")
public class WsLtalGetINVInfoImpl implements WsLtalGetINVInfo {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public InvoiceReturn getInvInfo(RequestVO requestVO) {
		InvoiceReturn rtn = new InvoiceReturn();
		
		WsLtalGetINVInfo_PSI service = new WsLtalGetINVInfo_PSC();
		
		try {
			List<InvoiceVO> list = service.getInvInfo(requestVO);
			
			if (list != null && list.size() > 0)
				rtn.setInvList(list);
		} catch (Exception e) {
			log.error("WsLtalGetINVInfo Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			try {service.saveLog();} catch (Exception e2) {}
		}
		
		
		return rtn;
	}
}
