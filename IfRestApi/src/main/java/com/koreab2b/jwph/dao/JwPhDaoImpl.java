package com.koreab2b.jwph.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.io.Resources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;


@Repository("jwPhDao")
@Transactional
public class JwPhDaoImpl implements JwPhDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(JwPhDaoImpl.class);	
	private SqlMapClient sqlMapper;	
	private String _rtnMsg = "";
	
	public JwPhDaoImpl() {
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
			LOGGER.error("####### JwDaoImpl Error : "+ e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public void insertJwPoData(Map<String, Object> pMap) throws Exception {

        List<Map<String, Object>> items = (List<Map<String, Object>>) pMap.get("items");

        for (Map<String, Object> item : items) {
            item.put("orderNo",  pMap.get("orderNo"));
            item.put("orderDate", pMap.get("orderDate"));
            item.put("customerName", pMap.get("customerName"));
            item.put("customerCode", pMap.get("customerCode"));
            item.put("deliveryAddress",  pMap.get("deliveryAddress"));
            item.put("contactName", pMap.get("contactName"));
            item.put("contactPhone",  pMap.get("contactPhone"));
            item.put("contactEmpNo",  pMap.get("contactEmpNo"));
            item.put("totalAmount",  pMap.get("totalAmount"));
            item.put("remarks", pMap.get("remarks"));

            LOGGER.info("insertJwPhPoData 33" + item);
            this.sqlMapper.insert("insertJwPoData", item);
        }

	}

	public void insertJwReData(Map<String, Object> pMap) throws Exception {
		
		List<Map<String, Object>> items = (List<Map<String, Object>>) pMap.get("items");
		
		for (Map<String, Object> item : items) {
            item.put("requestNo", pMap.get("requestNo"));
            item.put("requestDate", pMap.get("requestDate"));
            item.put("requesterName", pMap.get("requesterName"));
            item.put("requesterEmail", pMap.get("requesterEmail"));
            item.put("requesterPhone", pMap.get("requesterPhone"));
            item.put("department", pMap.get("department"));
            item.put("title", pMap.get("title"));
            item.put("file", pMap.get("file"));
            item.put("hdRemarks", pMap.get("remarks"));
            item.put("customerName", pMap.get("customerName"));
            item.put("customerCode", pMap.get("customerCode"));

            LOGGER.info("insertJwReData 33" + item);
            this.sqlMapper.insert("insertJwReData", item);
	     }
	}
}
