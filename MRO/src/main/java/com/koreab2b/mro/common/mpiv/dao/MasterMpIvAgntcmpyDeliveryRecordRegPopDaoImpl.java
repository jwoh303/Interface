package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpIvAgntcmpyDeliveryRecordRegPopDao")
@Transactional
public class MasterMpIvAgntcmpyDeliveryRecordRegPopDaoImpl implements MasterMpIvAgntcmpyDeliveryRecordRegPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.selectMasterMpIvAgntcmpyDeliveryRecordRegPopList", formData);
	}
	
	
	// 긴급납기
	public List<Map<String,String>> selectMasterMpIvUrgentManagementPop(Map<String,Object>  formData)  {
		return sqlSessionTemplate.selectList("common.mpiv.selectMasterMpIvUrgentManagementPop", formData);
	}
	
}
