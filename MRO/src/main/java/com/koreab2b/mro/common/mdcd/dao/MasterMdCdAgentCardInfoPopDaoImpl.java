package com.koreab2b.mro.common.mdcd.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCdAgentCardInfoPopDao")
@Transactional
public class MasterMdCdAgentCardInfoPopDaoImpl implements MasterMdCdAgentCardInfoPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCdAgentCardInfoPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcd.selectMasterMdCdAgentCardInfoPopList", formData);
	}

	//주요활동내용 조회
	public List<Map<String,String>> selectVisitList(Map<String, Object> formData) {
		return sqlSessionTemplate.selectList("common.mdcd.selectMasterMdCdAgentCardInfoPopVisit", formData);
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제가 완료 되었습니다.";
		
		try {
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));		

				sqlSessionTemplate.update("common.mdcd.deleteMasterMdCdAgentCardInfoPop", formData);
			}
		} catch(Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("고객관리(UPDATE KEP_AGENT_VISIT) UPDATE 에러가 발생하였습니다.");
		}

		return _rtnMsg;
		
	}	
	
}
