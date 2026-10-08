package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpClTaxsheetIssueStateDao")
@Transactional
public class SellerMpClTaxsheetIssueStateDaoImpl implements SellerMpClTaxsheetIssueStateDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회 (레거시)
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClTaxsheetIssueStateList", formData);
	}

	// 조회 (리뉴얼)
	public List<Map<String,String>> selectList_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClTaxsheetIssueStateList_v2", formData);
	}

}
