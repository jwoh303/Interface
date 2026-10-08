package com.koreab2b.mro.common.mpif.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpIfOrderStatusPopDao")
@Transactional
public class MasterMpIfOrderStatusPopDaoImpl implements MasterMpIfOrderStatusPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {

		if ( "".equals(CommonUtil.nvl((String) formData.get("st_gubun"))) ) {
			return sqlSessionTemplate.selectList("common.mpif.selectMasterMpIfOrderStatusPopList", formData);
		} else {
			return sqlSessionTemplate.selectList("common.mpif.selectMasterMpIfOrderStatusPopList2", formData);
		}
	}
	
}
