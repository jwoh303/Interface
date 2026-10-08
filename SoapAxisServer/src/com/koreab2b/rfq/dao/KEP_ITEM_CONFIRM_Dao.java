package com.koreab2b.rfq.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.rfq.vo.ItemConfirmVO;

public interface KEP_ITEM_CONFIRM_Dao {
	
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
	public int saveData(ItemConfirmVO vo) throws Exception;
}
