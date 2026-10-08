package com.koreab2b.po.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.po.vo.PurchaseOrderVO;

public interface KEP_PURCHASE_ORDER_Dao {
	
	/**
	 * Return SqlMapClient Object
	 * @return SqlMapClient
	 */
	public SqlMapClient getSqlMapClient();

	/**
	 * Save PO Data
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public int saveData(PurchaseOrderVO vo) throws Exception;
}
