package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpSoTranStatementDetailPopDao")
@Transactional
public class MasterMpSoTranStatementDetailPopDaoImpl implements MasterMpSoTranStatementDetailPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 상세정보
	public Map<String,String> selectInfo(Map<String,String> formData){
		return sqlSessionTemplate.selectOne("common.mpso.selectMasterMpSoTranStatementDetailPopInfo", formData);
	}
	public Map<String,String> selectInfo_v2(Map<String,String> formData){
		return sqlSessionTemplate.selectOne("common.mpso.selectMasterMpSoTranStatementDetailPopInfo_v2", formData);
	}

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoTranStatementDetailPopList", formData);
	}

	// 물류센터 고객사 체크
	@Override	
	public String getW001Flag(Map<String, String> pMap) {
		
		String flag = "N";
		int cnt = 0;
		cnt = (Integer)sqlSessionTemplate.selectOne("common.mpso.getW001Flag", pMap);
		
		if(cnt > 0) {
			flag = "Y";
		}
		
		return flag;
	}
	
}
