package com.koreab2b.po.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.po.vo.ReturnOrderVO;

public interface KEP_RETURN_ORDER_Dao {
	
	/**
	 * Return SqlMapClient Object
	 * @return SqlMapClient
	 */
	public SqlMapClient getSqlMapClient();

	/**
	 * 교환/반품  Data
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public int saveData(ReturnOrderVO vo) throws Exception;

}
