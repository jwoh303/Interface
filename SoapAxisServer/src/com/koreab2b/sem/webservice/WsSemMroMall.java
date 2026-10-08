package com.koreab2b.sem.webservice;

import com.koreab2b.sem.vo.ItmMapInfoVO;
import com.koreab2b.sem.vo.NewItmReqVO;
import com.koreab2b.sem.vo.RequotReqVO;
import com.koreab2b.sem.vo.ReturnVO;

public interface WsSemMroMall {
	
	/**
	 * SEM RFQ Recv Provider
	 * @param newItmReqVO
	 * @return
	 * @throws Exception
	 */
	public ReturnVO newItmReq(NewItmReqVO[] newItmReqVO) throws Exception;
	
	/**
	 * SEM Nego RFQ Recv Provider
	 * @param requotReqVO
	 * @return
	 * @throws Exception
	 */
	public ReturnVO requotReq(RequotReqVO[] requotReqVO) throws Exception;
	
	/**
	 * SEM Item Mapping Recv Provider
	 * @param itmMapInfoVO
	 * @return
	 * @throws Exception
	 */
	public ReturnVO itmMapInfoReg(ItmMapInfoVO[] itmMapInfoVO) throws Exception;
}