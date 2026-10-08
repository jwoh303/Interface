package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdAmInfoReferenceDao")
@Transactional
public class MasterMdAmInfoReferenceDaoImpl implements MasterMdAmInfoReferenceDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmInfoReferenceList", formData);
		
	}
	
	public Map<String,String> getDetailList(Map<String,String> formData) {
		sqlSessionTemplate.update("master.mdam.updateInfoReferenceLCount", formData);
		return sqlSessionTemplate.selectOne("board.boardDetail",formData);
	}
	
	public void updateDetailList(Map<String,String>  formData) { 
		sqlSessionTemplate.update("master.mdam.updateMasterMdAmInfoReferenceDetail", formData);
	}
	
	public void deleteDetailList(Map<String,String>  formData) { 
		sqlSessionTemplate.update("master.mdam.deleteMasterMdAmInfoReferenceDetail", formData);
	}
	
	public void insertDetailList(Map<String,String>  formData) { 
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmInfoReferenceDetail", formData);
	}
	
}
