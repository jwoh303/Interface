package com.koreab2b.ltal.dao;

import com.koreab2b.ltal.vo.ResultVO;
import com.koreab2b.ltal.vo.ReturnVO;

public interface WsLtalSetResultInfo_Dao {

	public ReturnVO setResultInfo(ResultVO[] resultVOList) throws Exception;
	
}
