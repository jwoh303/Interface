package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmCmsCatalogDao")
@Transactional
public class MasterMdCmCmsCatalogDaoImpl implements MasterMdCmCmsCatalogDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsCatalogDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsCatalogList", param);
	}

	//엑셀 리스트 조회
	public List<Map<String,String>> selecExceltList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsCatalogExcelList", param);
	}	
	
	// 카테고리 속성건수 조회
	public String getCategoriAttributeListCount(Map<String,String> formData){
		return sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCategoryAttrCount", formData);
	};
	
	// 카테고리 속성 조회
	public List<Map<String,String>> getCategoriAttributeList(Map<String,String> formData){
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsCatalogCategoriAttrList", formData);
	};

}
