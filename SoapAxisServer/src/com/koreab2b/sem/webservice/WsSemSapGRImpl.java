package com.koreab2b.sem.webservice;

import javax.jws.WebService;

import com.koreab2b.sem.service.WsSemSapGR_PSC;
import com.koreab2b.sem.service.WsSemSapGR_PSI;
import com.koreab2b.sem.vo.GdRcptVO;
import com.koreab2b.sem.vo.ReturnVO;
import com.koreab2b.util.CommonUtil;

@WebService(serviceName="WsSemSapGR")
public class WsSemSapGRImpl implements WsSemSapGR {

	@Override
	public ReturnVO gdRcptSnd(GdRcptVO[] gdRcptVO) throws Exception {
		ReturnVO rtn	= new ReturnVO();
		WsSemSapGR_PSI service	= new WsSemSapGR_PSC("KR");
		
		try {
			rtn = service.gdRcptSnd(gdRcptVO);
		} catch (Exception e) {
			e.printStackTrace();
			rtn.setErr_msg("F");
			rtn.setResult(CommonUtil.printStackTraceToString(e));
		} finally {
			service.saveLog(gdRcptVO,rtn);
		}
		
		return rtn;
	}

}
