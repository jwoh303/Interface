package com.koreab2b.mro.common.mdcm.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmItemDetailInfoModifyPopDao")
@Transactional
public class MasterMdCmItemDetailInfoModifyPopDaoImpl implements MasterMdCmItemDetailInfoModifyPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmItemDetailInfoModifyPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public Map<String,String> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mdcm.selectMasterMdCmItemDetailInfoModifyPopList", formData);
	}
	
	public String updateMasterMdCmItemDetailInfoDeleteNotAccept(Map<String,String> formData){

		String _rtnMsg = "";
		
		try{
			// PRMTITEM INSERT
			sqlSessionTemplate.update("common.mdcm.updateMasterMdCmItemDetailInfoDeleteNotAccept", formData);
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("판촉물 상품정보 처리중 에러가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	public String updateMasterMdCmItemDetailInfoModifyPop(Map<String,String> formData){

		String _rtnMsg = "";
		
		try{
			// PRMTITEM INSERT
			sqlSessionTemplate.update("common.mdcm.updateMasterMdCmItemDetailInfoModifyPop", formData);
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("판촉물 상품정보 수정중 에러가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
	
}
