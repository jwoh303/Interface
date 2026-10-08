package com.koreab2b.sem.webservice;

import javax.jws.WebService;

import com.koreab2b.sem.service.WsSemMroMall_PSC;
import com.koreab2b.sem.service.WsSemMroMall_PSI;
import com.koreab2b.sem.vo.ItmMapInfoVO;
import com.koreab2b.sem.vo.NewItmReqVO;
import com.koreab2b.sem.vo.RequotReqVO;
import com.koreab2b.sem.vo.ReturnVO;
import com.koreab2b.util.CommonUtil;

@WebService(serviceName="WsSemMroMall")
public class WsSemMroMallImpl implements WsSemMroMall {

	@Override
	public ReturnVO newItmReq(NewItmReqVO[] newItmReqVO) throws Exception {
		ReturnVO rtn	= new ReturnVO();
		WsSemMroMall_PSI service = new WsSemMroMall_PSC("KR");
		
		try {
			rtn = service.newItmReq(newItmReqVO);
		} catch (Exception e) {
			e.printStackTrace();
			rtn.setErr_msg("F");
			rtn.setResult(CommonUtil.printStackTraceToString(e));
		} finally {
			try {service.saveLogNewItmReq(newItmReqVO, rtn);} catch (Exception e2) {e2.printStackTrace();}
		}
		
		return rtn;
	}

	@Override
	public ReturnVO requotReq(RequotReqVO[] requotReqVO) throws Exception {
		ReturnVO rtn	= new ReturnVO();
		WsSemMroMall_PSI service = new WsSemMroMall_PSC("KR");
		
		try {
			rtn = service.requotReq(requotReqVO);
		} catch (Exception e) {
			e.printStackTrace();
			rtn.setErr_msg("F");
			rtn.setResult(CommonUtil.printStackTraceToString(e));
		} finally {
			try {service.saveLogRequotReq(requotReqVO, rtn);} catch (Exception e2) {e2.printStackTrace();}
		}
		
		return rtn;
	}

	@Override
	public ReturnVO itmMapInfoReg(ItmMapInfoVO[] itmMapInfoVO) throws Exception {
		ReturnVO rtn	= new ReturnVO();
		WsSemMroMall_PSI service = new WsSemMroMall_PSC("KR");
		
		try {
			rtn = service.itmMapInfoReg(itmMapInfoVO);
		} catch (Exception e) {
			e.printStackTrace();
			rtn.setErr_msg("F");
			rtn.setResult(CommonUtil.printStackTraceToString(e));
		} finally {
			try {service.saveLogItmMapInfoReg(itmMapInfoVO, rtn);} catch (Exception e2) {e2.printStackTrace();}
		}
		
		return rtn;
	}
}