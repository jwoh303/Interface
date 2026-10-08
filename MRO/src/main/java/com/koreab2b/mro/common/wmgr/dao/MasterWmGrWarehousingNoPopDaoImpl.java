package com.koreab2b.mro.common.wmgr.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmGrWarehousingNoPopDao")
@Transactional
public class MasterWmGrWarehousingNoPopDaoImpl implements MasterWmGrWarehousingNoPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public Map<String,String> selectList1(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.wmgr.selectMasterWmGrWarehousingNoPopList_1", formData);
	}
	public List<Map<String,String>> selectList2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrWarehousingNoPopList_2", formData);
	}
		
}
