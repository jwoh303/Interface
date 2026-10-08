package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;


@Repository("masterMpRqQuotationUnitpriceHistoryPopDao")
@Transactional
public class MasterMpRqQuotationUnitpriceHistoryPopDaoImpl implements MasterMpRqQuotationUnitpriceHistoryPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqQuotationUnitpriceHistoryPopList", param);
	}
	
	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList2(Map<String,Object> param) {
		
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("common.mprq.selectMasterMpRqQuotationUnitpriceHistoryPopList2", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqQuotationUnitpriceHistoryPopList2", param);
		}
		return resultList;
		
	}
	
	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList3(Map<String,Object> param) {
		
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			sqlSessionTemplate.select("common.mprq.selectMasterMpRqQuotationUnitpriceHistoryPopList3", param, _resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqQuotationUnitpriceHistoryPopList3", param);
		}
		return resultList;
		
	}
	
}
