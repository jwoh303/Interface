package com.koreab2b.mro.buyer.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("buyerMpStRecinpayStateDao")
@Transactional
public class BuyerMpStRecinpayStateDaoImpl implements BuyerMpStRecinpayStateDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> formData) {
//		return sqlSessionTemplate.selectList("buyer.mpst.selectBuyerMpStRecinpayStateList", formData);
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("buyer.mpst.selectBuyerMpStRecinpayStateList", formData, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}
	
}
