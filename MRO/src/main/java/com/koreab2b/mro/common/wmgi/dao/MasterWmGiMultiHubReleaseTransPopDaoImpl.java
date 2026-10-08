package com.koreab2b.mro.common.wmgi.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterWmGiMultiHubReleaseTransPopDao")
@Transactional
public class MasterWmGiMultiHubReleaseTransPopDaoImpl implements MasterWmGiMultiHubReleaseTransPopDao {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGiMultiHubReleaseTransPopDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgi.selectMasterWmGiMultiHubReleaseTransPopList", formData);
	}
	
	// 간선다중출고지시
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData){
		String rtnMsg = "OK";
		
		try{
			for(int i=0; i<gridData.size(); i++){
				formData.putAll((Map<String,String>)gridData.get(i));
				
				try {
					// ICOMIVDT.HUB_FLAG 변경
					formData.put("HUB_FLAG", "C");
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomivdt", formData);
					
					// HUBIVDT UPDATE
					sqlSessionTemplate.update("common.wmgi.updateMasterWmGiMultiHubReleaseTransPop", formData);
				}catch(Exception se){
					rtnMsg = "간선 다중출고지시(HUB UPDATE) 중 에러가 발생하였습니다.";
					throw new Exception();
				}
			} //END FOR
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(rtnMsg);
		}
		
		return rtnMsg;
	}	
}