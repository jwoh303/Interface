package com.koreab2b.iv.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.iv.vo.DeliveryConfirmVO;

public interface KEP_DELIVERY_CONFIRM_Dao {

	/**
	 * Return SqlMapClient Object
	 * @return SqlMapClient
	 */
	public SqlMapClient getSqlMapClient();

	/**
	 * Save GR Data
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public int saveData(DeliveryConfirmVO vo) throws Exception;
}
