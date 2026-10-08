package com.koreab2b.mro.buyer.mppo.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("buyerMpPoOrderProgressDao")
@Transactional
public class BuyerMpPoOrderProgressDaoImpl implements BuyerMpPoOrderProgressDao { 
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> formData) {
	//	return sqlSessionTemplate.selectList("buyer.mppo.getBuyerProxybuyTrackingListSql_New", formData);
		
		String pageflag = (String) formData.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null; 
		 sqlSessionTemplate.select("buyer.mppo.getBuyerProxybuyTrackingListSql_New", formData, _resultHander);
		 resultList = (List<Map<String, String>>)_resultHander.getList();
		 
		
		return resultList;
		
	}  
	// 부서별 집계
	public List<Map<String,String>> selectDeptTotalList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mppo.selectDeptTotalList", formData);
	}
	
	// 협력사별 집계
	public List<Map<String,String>> selectSuplTotalList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mppo.selectSuplTotalList", formData);
	}
	
	// 관리번호별 집계
	public List<Map<String,String>> selectRefTotalList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mppo.selectRefTotalList", formData);
	}
}
