package com.koreab2b.mro.common.mpiv.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonMpIvDlvryNoticePopDao")
@Transactional
public class CommonMpIvDlvryNoticePopDaoImpl implements CommonMpIvDlvryNoticePopDao {
	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvDlvryNoticePopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 저장
	public String updateCommonMpIvDlvryNoticePop(Map<String,String> pMap) {
		String _rtnMsg = "";
		
		try{
			sqlSessionTemplate.update("common.mpiv.updateCommonMpIvDlvryNoticePop", pMap);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 중 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
}
