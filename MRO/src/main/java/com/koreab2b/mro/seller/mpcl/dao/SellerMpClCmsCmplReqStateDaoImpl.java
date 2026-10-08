package com.koreab2b.mro.seller.mpcl.dao;


import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpClCmsCmplReqStateDao")
@Transactional
public class SellerMpClCmsCmplReqStateDaoImpl implements SellerMpClCmsCmplReqStateDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpClCmsCmplReqStateDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClCmsCmplReqStateList", formData);
	}

}
