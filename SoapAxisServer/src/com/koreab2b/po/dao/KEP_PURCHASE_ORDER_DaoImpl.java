package com.koreab2b.po.dao;

import java.io.Reader;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.po.vo.PurchaseOrderVO;

public class KEP_PURCHASE_ORDER_DaoImpl implements KEP_PURCHASE_ORDER_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public KEP_PURCHASE_ORDER_DaoImpl() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public SqlMapClient getSqlMapClient() {
		return this.sqlMapper;
	}

	@Override
	public int saveData(PurchaseOrderVO vo) throws Exception {
		return this.sqlMapper.update("saveDataPurchaseOrder", vo);
	}

}
