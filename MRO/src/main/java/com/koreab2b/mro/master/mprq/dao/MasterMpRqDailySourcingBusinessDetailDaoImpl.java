package com.koreab2b.mro.master.mprq.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpRqDailySourcingBusinessDetailDao")
@Transactional
public class MasterMpRqDailySourcingBusinessDetailDaoImpl implements MasterMpRqDailySourcingBusinessDetailDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public Map<String,Object> selectDetail(Map<String,Object> formData) {
		return sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqDailySourcingBusinessDetail", formData);
	}

}
