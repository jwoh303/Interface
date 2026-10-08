package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpSoClosingMoveDao")
@Transactional
public class MasterMpSoClosingMoveDaoImpl implements MasterMpSoClosingMoveDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoClosingMoveDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> searchMasterMpSoClosingMoveList(Map<String,Object> param) {
		
		//진행상태코드
		List<String> statusList = CommonUtil.getStringArrary((String) param.get("st_status"), ",");
		param.put("st_status_all", statusList);	
		 
		//고객사
		List<String> st_buyer_codeList = CommonUtil.getStringArrary((String) param.get("st_buyer_code"), "@");
		param.put("st_buyer_codeList", st_buyer_codeList);	
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpso.selectMasterMpSoClosingMoveList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
}
