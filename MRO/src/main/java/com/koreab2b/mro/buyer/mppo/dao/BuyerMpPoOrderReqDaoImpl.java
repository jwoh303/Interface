package com.koreab2b.mro.buyer.mppo.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("buyerMpPoOrderReqDao")
@Transactional
public class BuyerMpPoOrderReqDaoImpl implements BuyerMpPoOrderReqDao { 
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	//조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getBuyerMpPoOrderReqList_v2(Map<String,Object> formData) {
		List<String> list = CommonUtil.getStringArrary((String)formData.get("st_status"), ",");
		if(list.size() != 0){
			formData.put("st_status", list);
		}
		return sqlSessionTemplate.selectList("buyer.mppo.getBuyerMpPoOrderReqList_v2", formData);
	}  
}
