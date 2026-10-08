package com.koreab2b.mro.sample.dev.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("kepDevGroupProgressDao")
@Transactional
public class KepDevGroupProgressDaoImpl implements KepDevGroupProgressDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(KepDevGroupProgressDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 저장(견적의뢰)
	@SuppressWarnings("unchecked")
	public int updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		
		try {
		
		for(int i=0; i < gridData.size(); i++){
			formData.putAll((Map<String, String>)gridData.get(i));		
			
			if (!formData.get("GW_NO").equals("N")){
				
			} else {
				formData.put("GW_NO", "");
			}
			
			sqlSessionTemplate.insert("sample.dev.insertKepDevGroupProgress", formData);
		}
		// 두산인프라코어 전용
//		if (pMap.get("Stype").equals("RAV")){
//			sqlSessionTemplate.insert("master.mp.rq.updateMasterMpRqBuyerReq", pMap);
//		}
		// 추후 처리
		} catch (Exception e){
			LOGGER.debug("Exception : ", e);
			throw new RuntimeException( "저장에 실패하였습니다.");
		}
		return 0;
	}
	
}
