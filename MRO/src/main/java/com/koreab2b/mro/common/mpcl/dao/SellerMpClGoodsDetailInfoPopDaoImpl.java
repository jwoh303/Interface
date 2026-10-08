package com.koreab2b.mro.common.mpcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("sellerMpClGoodsDetailInfoPopDao")
@Transactional
public class SellerMpClGoodsDetailInfoPopDaoImpl implements SellerMpClGoodsDetailInfoPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		String comType = formData.get("st_com_type").toString();
		
		//com_type에 따른 쿼리 분기 
		if("B".equals(comType)){
			return sqlSessionTemplate.selectList("common.mpcl.selectBuyerMpClGoodsDetailInfoPopList", formData);
		}else{
			return sqlSessionTemplate.selectList("common.mpcl.selectSellerMpClGoodsDetailInfoPopList", formData);
		}
		
		
	}
	
}
