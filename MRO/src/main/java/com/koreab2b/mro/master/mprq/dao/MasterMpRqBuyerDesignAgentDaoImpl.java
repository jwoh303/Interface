package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpRqBuyerDesignAgentDao")
@Transactional
public class MasterMpRqBuyerDesignAgentDaoImpl implements MasterMpRqBuyerDesignAgentDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBuyerDesignAgentDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public Map<String, String> selectInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqBuyerDesignAgentInfo", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		resultList = sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBuyerDesignAgentList", param);
		
		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		int _count = 0;
		
		
		_rtnMsg = "정상적으로 완료되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				LOGGER.debug("===>> Start <<===");
				formData.putAll((Map<String, String>)gridData.get(i));

				if ( "U".equals(formData.get("sStatus")) ) {
					LOGGER.debug("===>> U <<===");

					_count = sqlSessionTemplate.update("master.mprq.updateMasterMpRqBuyerDesignAgent", formData);
					
					if ( _count != 1 ) {
						throw new RuntimeException("수정 중 오류가 발생하였습니다. 시스템운영팀에게 문의하여 주시기 바랍니다.");
					}
				}
				else if ( "I".equals(formData.get("sStatus")) ) {
					LOGGER.debug("===>> I <<===");

					_count = sqlSessionTemplate.insert("master.mprq.insertMasterMpRqBuyerDesignAgent", formData);
					
					if ( _count != 1 ) {
						throw new RuntimeException("추가 중 오류가 발생하였습니다. 시스템운영팀에게 문의하여 주시기 바랍니다.");
					}
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("저장 중 오류가 발생하였습니다. 시스템운영팀에게 문의하여 주시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		int _count = 0;
		
		_rtnMsg = "삭제가 정상적으로 완료되었습니다";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				
				_count = sqlSessionTemplate.update("master.mprq.deleteMasterMpRqBuyerDesignAgent", formData);
				
				if ( _count != 1 ) {
					throw new RuntimeException("삭제 중 오류가 발생하였습니다. 시스템운영팀에게 문의하여 주시기 바랍니다.");
				}
			}
		} catch(Exception e ) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("삭제 중 오류가 발생하였습니다. 시스템운영팀에게 문의하여 주시기 바랍니다.");
		}

		return _rtnMsg;		
	}
	
}
