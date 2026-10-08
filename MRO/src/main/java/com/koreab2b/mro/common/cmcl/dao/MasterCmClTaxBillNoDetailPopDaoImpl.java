package com.koreab2b.mro.common.cmcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterCmClTaxBillNoDetailPopDao")
@Transactional
public class MasterCmClTaxBillNoDetailPopDaoImpl implements MasterCmClTaxBillNoDetailPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClTaxBillNoDetailPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.cmcl.selectMasterCmClTaxBillNoDetailPopList", formData);
	}
	
	
}
