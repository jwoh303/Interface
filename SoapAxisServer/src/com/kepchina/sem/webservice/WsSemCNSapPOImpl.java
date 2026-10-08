package com.kepchina.sem.webservice;

import javax.jws.WebService;

import com.koreab2b.sem.service.WsSemSapPO_PSC;
import com.koreab2b.sem.service.WsSemSapPO_PSI;
import com.koreab2b.sem.vo.PcsOrdrDtlVO;
import com.koreab2b.sem.vo.PcsOrdrMasVO;
import com.koreab2b.sem.vo.ReturnVO;
import com.koreab2b.sem.webservice.WsSemSapPO;
import com.koreab2b.util.CommonUtil;

@WebService(serviceName="WsSemCNSapPO")
public class WsSemCNSapPOImpl implements WsSemSapPO {

	@Override
	public void pcsOrdrSnd(PcsOrdrMasVO pcsOrdrMasVO,
			PcsOrdrDtlVO[] pcsOrdrDtlVO) throws Exception {
		ReturnVO rtn = new ReturnVO();
		
		WsSemSapPO_PSI service	= new WsSemSapPO_PSC("CN");
		try {
			service.pcsOrdrSnd(pcsOrdrMasVO, pcsOrdrDtlVO);
			rtn.setResult("S");
			rtn.setErr_msg("SUCCESS");
		} catch (Exception e) {
			e.printStackTrace();
			rtn.setResult("E");
			rtn.setErr_msg(CommonUtil.printStackTraceToString(e));
		} finally {
			service.saveLog(pcsOrdrMasVO, pcsOrdrDtlVO, rtn);
		}
	}
}
