package com.koreab2b.mro.master.mpiv.dao;

import java.util.List;


import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpIvDeliveryDelayListDao")
@Transactional
public class MasterMpIvDeliveryDelayListDaoImpl implements MasterMpIvDeliveryDelayListDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpiv.selectMasterMpIvDeliveryDelayList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
		
	}
}
