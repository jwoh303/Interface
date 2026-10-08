package com.koreab2b.rfq.dao;

import java.io.Reader;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.rfq.vo.ItemConfirmVO;

public class KEP_ITEM_CONFIRM_DaoImpl implements KEP_ITEM_CONFIRM_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public KEP_ITEM_CONFIRM_DaoImpl() {
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
	public int saveData(ItemConfirmVO vo) throws Exception {
		return this.sqlMapper.update("saveDataItemConfirm", vo);
	}

}
