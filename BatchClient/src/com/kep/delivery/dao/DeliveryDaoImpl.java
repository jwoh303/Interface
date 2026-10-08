/**
 * 
 */
package com.kep.delivery.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

/**
 * @author jiwon
 *
 */
public class DeliveryDaoImpl implements DeliveryDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public DeliveryDaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("####### DeliveryDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public List<Map<String, Object>> selectDeliveryItemList() throws Exception {
		return this.sqlMapper.queryForList("selectDeliveryItemList");
	}

	@Override
	public void updateDeliveryItem(List<Map<String,Object>> resultLst) throws Exception {
		String flag = "";
		String msg = "";
		log.info("####### DeliveryDaoImpl INSIDE : " + resultLst.toString());
		for(Map<String,Object> item : resultLst) {			
			flag = "Y";
			msg = "";
			if(!(boolean)item.get("success")) {
				flag = "E";
				msg = item.get("e_code") +" / "+ item.get("e_message"); 
			}
			item.put("flag", flag);
			item.put("msg", msg);
			this.sqlMapper.update("updateDeliveryItem", item);
		}	
	}

	@Override
	public void updateDeliAllFail() throws Exception {
		this.sqlMapper.update("updateDeliAllFail");
	}

}
