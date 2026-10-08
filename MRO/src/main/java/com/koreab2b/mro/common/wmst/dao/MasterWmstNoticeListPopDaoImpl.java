package com.koreab2b.mro.common.wmst.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterWmstNoticeListPopDao")
@Transactional
public class MasterWmstNoticeListPopDaoImpl implements MasterWmstNoticeListPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.wmst.selectMasterWmstNoticeList", formData);
	}
	
	// 상세
	public Map<String,String> selectDetail(Map<String,String> formData) {
		
		Map<String,String> pMap = new HashMap<String, String>();
		pMap.put("BTYPE", formData.get("st_btype"));
		pMap.put("BID", formData.get("st_bid"));
		
		// 카운트 증가
		sqlSessionTemplate.update("board.updateBoardLCount",pMap);

		// 상세 정보 조회 
		return sqlSessionTemplate.selectOne("board.boardDetail", pMap);
	}

}
