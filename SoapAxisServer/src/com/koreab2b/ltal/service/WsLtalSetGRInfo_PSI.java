package com.koreab2b.ltal.service;

import com.koreab2b.ltal.vo.GoodsReceiveVO;
import com.koreab2b.ltal.vo.ReturnVO;

public interface WsLtalSetGRInfo_PSI {

	public ReturnVO getGrInfo(GoodsReceiveVO[] goodsReceiveVOList) throws Exception;
	
	public void saveLog(GoodsReceiveVO[] objs, ReturnVO rtn) throws Exception;
}
