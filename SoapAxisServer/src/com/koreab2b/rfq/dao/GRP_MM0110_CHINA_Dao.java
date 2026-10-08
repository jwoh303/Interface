package com.koreab2b.rfq.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.rfq.vo.RfqVO;

public interface GRP_MM0110_CHINA_Dao {

	/**
	 * Save RFQ Data
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public int saveData(RfqVO obj) throws Exception;
	
	/**
	 * Return SqlMapClient Object
	 * @return SqlMapClient
	 */
	public SqlMapClient getSqlMapClient();
}
