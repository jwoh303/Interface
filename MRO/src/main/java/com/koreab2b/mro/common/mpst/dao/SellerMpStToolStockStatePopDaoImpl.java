package com.koreab2b.mro.common.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("sellerMpStToolStockStatePopDaoImpl")
@Transactional
public class SellerMpStToolStockStatePopDaoImpl implements SellerMpStToolStockStatePopDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("common.mpst.selectSellerMpStToolStockStatePopList", formData, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}
	
}
