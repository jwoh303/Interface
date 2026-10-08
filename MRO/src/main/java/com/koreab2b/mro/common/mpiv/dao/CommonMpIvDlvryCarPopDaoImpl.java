package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonMpIvDlvryCarPopDao")
@Transactional
public class CommonMpIvDlvryCarPopDaoImpl implements CommonMpIvDlvryCarPopDao {
	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvDlvryCarPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvDlvryCarPopList", pMap);
	}
	
	// 배송차량정보 저장
	public String saveCommonMpIvDlvryCarPop(Map<String,String> pMap) {

		String _rtnMsg = "";
		
		try{

			// 배송차량정보 update
			sqlSessionTemplate.update("common.mpiv.updateCommonMpIvDlvryCarPopList",pMap);
				
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "배송차량 수정에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
		
	}
	
}
