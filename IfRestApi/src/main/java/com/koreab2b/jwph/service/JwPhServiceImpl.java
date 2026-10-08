package com.koreab2b.jwph.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.jwph.dao.JwPhDao;


@Service("JwPhService")
public class JwPhServiceImpl implements JwPhService {
	private static final Logger LOGGER = LoggerFactory.getLogger(JwPhServiceImpl.class);
	
	@Autowired
	private JwPhDao jwPhDao;
	
	public void insertJwPhPoData(Map<String, Object> pMap) throws Exception{
		
		LOGGER.info("insertJwPhPoData 22" + pMap);
		//주문 필수 
		require(pMap, "orderNo");
		require(pMap, "orderDate");
		require(pMap, "customerName");
		require(pMap, "deliveryAddress");
		require(pMap, "items");
		
		List<Map<String, Object>> items = (List<Map<String, Object>>) pMap.get("items");
		
		if (items == null || items.isEmpty()) {
			throw new RuntimeException("items는 1건 이상 필요합니다.");
		}
		
		//품목 필수 
		for(Map<String, Object> item : items) {
			require(item, "itemNo");
			require(item, "productCode");
			require(item, "productName");
			require(item, "quantity");
			require(item, "price");
		}
		
		//DAO 실행 
		jwPhDao.insertJwPoData(pMap);
	}


	public void insertJwPhReData(Map<String, Object> pMap) throws Exception {
		require(pMap, "requestNo");
		require(pMap, "requestDate");
		require(pMap, "requesterName");
		require(pMap, "items");

        List<Map<String, Object>> items = (List<Map<String, Object>>) pMap.get("items");

        if (items == null || items.isEmpty()) {
            throw new RuntimeException("items 는 1건 이상 필요합니다.");
        }

        // ===== items 필수 =====
        for (Map<String, Object> item : items) {
        	require(item, "itemNo");
        	require(item, "productName");
        	require(item, "quantity");
        }
        
        //DAO 실행
      	jwPhDao.insertJwReData(pMap);
	}
	
	private void require(Map<String, Object> pMap, String key) {
		if(pMap.get(key) == null) {
			throw new RuntimeException("필수값 누락 " + key);
		}
		
		if(pMap.get(key) instanceof String && ((String) pMap.get(key)).trim().isEmpty()) {
			throw new RuntimeException("필수값 누락 " + key);
		}
	}
}
