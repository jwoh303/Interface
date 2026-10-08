package com.koreab2b.mro.buyer.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("buyerMpStRecinpayListDao")
@Transactional
public class BuyerMpStRecinpayListDaoImpl implements BuyerMpStRecinpayListDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> formData) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("buyer.mpst.selectBuyerMpStRecinpayListList", formData, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}
	
	// 사용자 조회
	public List<Map<String,String>> selectUserList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpst.selectBuyerMpStRecinpayListList_userList", formData);
	}
	
	// 부서 조회
	public List<Map<String,String>> selectDeptList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpst.selectBuyerMpStRecinpayListList_deptList", formData);
	}
	
}
