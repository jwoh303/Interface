package com.koreab2b.mro.common.mpif.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpIfOrderNoSearchPopDao")
@Transactional
public class MasterMpIfOrderNoSearchPopDaoImpl implements MasterMpIfOrderNoSearchPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfOrderNoSearchPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpif.selectMasterMpIfOrderNoSearchPopList", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 반영되었습니다.";
		
		try {
			
			formData.putAll((Map<String, String>)gridData.get(0));
			
			// 인터페이스 입고내역 update
			sqlSessionTemplate.update("common.mpif.updateMasterMpIfOrderNoSearchPopList", formData);
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
				throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n- 반영 실패 -\n\n담당자에게 연락 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
}
