package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmCmsItemSgSelPopDao")
@Transactional
public class MasterMdCmCmsItemSgSelPopDaoImpl implements MasterMdCmCmsItemSgSelPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 카테고리(KEPSGMG) 목록 조회 - 페이징 없음
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemSgSelPopList", formData);
	}

}
