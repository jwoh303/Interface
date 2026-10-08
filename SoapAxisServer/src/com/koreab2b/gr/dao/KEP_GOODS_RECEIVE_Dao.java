package com.koreab2b.gr.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.koreab2b.gr.vo.GoodsReceiveVO;

public interface KEP_GOODS_RECEIVE_Dao {
	
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
	public int saveData(GoodsReceiveVO vo) throws Exception;
}