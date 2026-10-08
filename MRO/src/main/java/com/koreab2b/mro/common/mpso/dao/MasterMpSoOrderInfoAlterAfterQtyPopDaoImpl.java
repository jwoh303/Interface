package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpSoOrderInfoAlterAfterQtyPopDao")
@Transactional
public class MasterMpSoOrderInfoAlterAfterQtyPopDaoImpl implements MasterMpSoOrderInfoAlterAfterQtyPopDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoOrderInfoAlterAfterQtyPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoOrderInfoAlterAfterQtyPopList", formData);
	}
	public List<Map<String,String>> getSysopOrderChangePoAfterHDPop(Map<String,String>  formData)	{
		return null;
	}
	public List<Map<String,String>> getSysopOrderChangePoAfterDTPop(Map<String, Object>  formData) {
		return null;
	}
	
	@SuppressWarnings("unchecked")
	public String setSysopOrderChangeAfterQtyChange(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "저장완료.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				//sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
