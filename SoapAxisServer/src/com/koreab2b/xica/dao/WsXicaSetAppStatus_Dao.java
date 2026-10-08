package com.koreab2b.xica.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.xica.vo.xicaAppStatusVO;
import com.koreab2b.xica.vo.xicaReturnVO;

public interface WsXicaSetAppStatus_Dao {
	
	public SqlMapClient getSqlMapClient();

	public xicaReturnVO saveAppstatus(xicaAppStatusVO aprList) throws Exception;


}
