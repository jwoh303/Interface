package com.koreab2b.mro.master.mpif.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@SuppressWarnings("unchecked")
@Repository("masterMpIfCowayChargeDao")
@Transactional
public class MasterMpIfCowayChargeDaoImpl implements MasterMpIfCowayChargeDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfCowayChargeDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, String>> selectCowayChargeList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpif.selectMasterMpIfCowayChargeList", pMap);
	}

	@Override
	public String insertMasterMpIfCowayChargeList(List<Object> pGridData) {
		String rtnMsg	= "저장되었습니다.";
		int rtnCnt	= 0;
		
		try {
			for( int i = 0 ; i < pGridData.size() ; i++) {
				
				HashMap<String, String> tMap	= (HashMap<String, String>) pGridData.get(i);
				
				rtnCnt = sqlSessionTemplate.update("master.mpif.insertMasterMpIfCowayChargeList", tMap);
				
				if(rtnCnt == 0)
					throw new Exception("저장중 오류가 발생했습니다.");
			}
			
			rtnMsg	= "저장되었습니다.";
			
		} catch (Exception e) {
			rtnMsg	= e.getMessage();
		}
		
		return rtnMsg;
	}

	@Override
	public String deleteMasterMpIfCowayChargeList(List<Object> pGridData) {
		String rtnMsg	= "삭제되었습니다.";
		int rtnCnt	= 0;
		
		try {
			for( int i = 0 ; i < pGridData.size() ; i++) {
				
				HashMap<String, String> tMap	= (HashMap<String, String>) pGridData.get(i);
				
				rtnCnt = sqlSessionTemplate.update("master.mpif.deleteMasterMpIfCowayChargeList", tMap);
				
				if (rtnCnt == 0)
					throw new Exception("삭제중 오류가 발생했습니다.");
			}
			
			rtnMsg	= "삭제되었습니다.";
			
		} catch (Exception e) {
			rtnMsg	= e.getMessage();
		}
		
		return rtnMsg;
	}
}
