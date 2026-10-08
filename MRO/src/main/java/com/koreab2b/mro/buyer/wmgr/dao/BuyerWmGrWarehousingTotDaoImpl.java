package com.koreab2b.mro.buyer.wmgr.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerWmGrWarehousingTotDao")
@Transactional
public class BuyerWmGrWarehousingTotDaoImpl implements BuyerWmGrWarehousingTotDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerWmGrWarehousingTotDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingTotList", formData);
		
		return _list;
	}
	public List<Map<String,String>> getBuyerWmGrWarehousingTotList_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingTotList_v2", formData);
	}
	
	// 팝업조회
	public List<Map<String,String>> selectPopList(Map<String,String> formData) {
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingTotPopList", formData);
		
		return _list;
	}
	public List<Map<String,String>> selectPopList_v2(Map<String,Object> formData) {
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingTotPopList", formData);
		
		return _list;
	}
}
