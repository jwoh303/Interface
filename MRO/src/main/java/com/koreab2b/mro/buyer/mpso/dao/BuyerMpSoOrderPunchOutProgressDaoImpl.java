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

@Repository("buyerMpSoOrderPunchOutProgressDao")
@Transactional
public class BuyerMpSoOrderPunchOutProgressDaoImpl implements BuyerMpSoOrderPunchOutProgressDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoOrderPunchOutProgressDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		//return sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoOrderPunchOutProgressList", formData);
		
		String pageflag = (String) formData.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("buyer.mpso.selectBuyerMpSoOrderPunchOutProgressList", formData, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoOrderPunchOutProgressList", formData);
		}
		
		return resultList;

		
	}
		
}
