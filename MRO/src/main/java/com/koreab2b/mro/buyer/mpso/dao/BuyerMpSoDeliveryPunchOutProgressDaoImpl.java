package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("buyerMpSoDeliveryPunchOutProgressDao")
@Transactional
public class BuyerMpSoDeliveryPunchOutProgressDaoImpl implements BuyerMpSoDeliveryPunchOutProgressDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoDeliveryPunchOutProgressDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		return sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoDlvryCmnPunchOutProgressList", formData);		
	}
	// 납기지연조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectDelayList(Map<String,String> formData) {
		
		return sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoDlvryDlyPunchOutProgressList", formData);		
	}
		
}
