package com.koreab2b.mro.common.mdcp.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcp.dao.MasterMdCpAgntcmpyApprovalRequestDaoImpl;

@Repository("masterMdCpNewRegAgntcmpyInfoPopDao")
@Transactional
public class MasterMdCpNewRegAgntcmpyInfoPopDaoImpl implements MasterMdCpNewRegAgntcmpyInfoPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpAgntcmpyApprovalRequestDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpNewRegAgntcmpyInfoPop", formData);
	}
	
	// 조회
	public String selectMdmList(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mdcp.selectMasterMdCpNewRegAgntcmpyInfoMDMList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectCmpyList(Map<String, Object> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpNewRegAgntcmpyInfoPopList", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData) {
		
		String _rtnMsg = "OK";

		try {

			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpNewRegAgntcmpyInfoPop", formData);
			
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
