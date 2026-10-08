package com.koreab2b.mro.buyer.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("buyerMpRqQuotaProceStateAdminDao")
@Transactional
public class BuyerMpRqQuotaProceStateAdminDaoImpl implements BuyerMpRqQuotaProceStateAdminDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		String pageflag = (String) formData.get("paging");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("buyer.mp.rq.selectBuyerMpRqQuotaProceStateAdminList", formData, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqQuotaProceStateAdminList", formData);
		}
		return resultList;
	}
	// 신규품목등록조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectSourcList(Map<String,String> formData) {
		List<Map<String, String>> resultList = null;
		resultList =  sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqQuotaSourcAdminList", formData);
		return resultList;
	}
	// 신규발주조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectNewPoList(Map<String,String> formData) {
		List<Map<String, String>> resultList = null;
		resultList =  sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqQuotaNewPoAdminList", formData);
		return resultList;
	}
}
