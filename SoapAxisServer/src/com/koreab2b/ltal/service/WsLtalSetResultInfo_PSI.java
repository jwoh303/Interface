package com.koreab2b.ltal.service;

import com.koreab2b.ltal.vo.ResultVO;
import com.koreab2b.ltal.vo.ReturnVO;

public interface WsLtalSetResultInfo_PSI {

	public ReturnVO setResultInfo(ResultVO[] resultVOList) throws Exception;
	
	public void saveLog(ResultVO[] resultVOList, ReturnVO rtn) throws Exception;
}
