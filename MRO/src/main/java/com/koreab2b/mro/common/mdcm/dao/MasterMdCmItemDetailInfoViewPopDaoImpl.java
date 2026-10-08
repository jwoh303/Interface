package com.koreab2b.mro.common.mdcm.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmItemDetailInfoViewPopDao")
@Transactional
public class MasterMdCmItemDetailInfoViewPopDaoImpl implements MasterMdCmItemDetailInfoViewPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmItemDetailInfoViewPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public Map<String,String> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mdcm.selectMasterMdCmItemDetailInfoViewPopList", formData);
	}
	

	public String updateMasterMdCmItemDetailInfoViewPop(Map<String,String> formData) {
		
		String _rtnMsg = "";
		
		try{
			// PRMTITEM INSERT
			sqlSessionTemplate.update("common.mdcm.updateMasterMdCmItemDetailInfoViewPop", formData);
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적처리내역 저장중 에러가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	
}
