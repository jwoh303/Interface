package com.koreab2b.mro.buyer.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerMdAmGoodsLineStateDao")
@Transactional
public class BuyerMdAmGoodsLineStateDaoImpl implements BuyerMdAmGoodsLineStateDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회조건 - userList 조회
	public List<Map<String,String>> selectUserList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmGoodsLineStateUserList", formData);
	}

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		String categ_id = CommonUtil.nvl(formData.get("st_categ_id"));
		
		if("".equals(categ_id)){
			formData.put("st_categ_id", "ALL");
		}
		
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmGoodsLineStateList", formData);
		
	}
}
