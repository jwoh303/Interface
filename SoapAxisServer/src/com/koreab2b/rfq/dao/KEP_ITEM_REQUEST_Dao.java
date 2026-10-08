package com.koreab2b.rfq.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.rfq.vo.ItemRequestVO;

public interface KEP_ITEM_REQUEST_Dao {
	
	/**
	 * Return SqlMapClient Object
	 * @return SqlMapClient
	 */
	public SqlMapClient getSqlMapClient();

	/**
	 * Save RFQ Data
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public int saveData(ItemRequestVO vo) throws Exception;
}
