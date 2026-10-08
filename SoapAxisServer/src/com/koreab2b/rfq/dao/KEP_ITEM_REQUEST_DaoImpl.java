/**
 * 
 */
package com.koreab2b.rfq.dao;

import java.io.Reader;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.rfq.vo.ItemRequestVO;

/**
 * @author jinsoo97
 *
 */
public class KEP_ITEM_REQUEST_DaoImpl implements KEP_ITEM_REQUEST_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;
	
	/**
	 * 
	 */
	public KEP_ITEM_REQUEST_DaoImpl() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	/* (non-Javadoc)
	 * @see com.koreab2b.rfq.dao.KEP_ITEM_REQUEST_Dao#getSqlMapClient()
	 */
	@Override
	public SqlMapClient getSqlMapClient() {
		return this.sqlMapper;
	}

	/* (non-Javadoc)
	 * @see com.koreab2b.rfq.dao.KEP_ITEM_REQUEST_Dao#saveData(com.koreab2b.rfq.vo.ItemRequestVO)
	 */
	@Override
	public int saveData(ItemRequestVO vo) throws Exception {
		return this.sqlMapper.update("saveDataItemRequest", vo);
	}

}
