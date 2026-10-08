package com.koreab2b.mro.common.coco.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonCoCoScmActionDetailPopDao")
@Transactional
public class CommonCoCoScmActionDetailPopDaoImpl implements CommonCoCoScmActionDetailPopDao {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoScmActionDetailPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 
 
	public Map<String,String> getScmList(Map<String,String> _pMap){
		return sqlSessionTemplate.selectOne("common.coco.selectScmList",_pMap);
	}
	
	public String updateCommonCoCoScmActionDetailPop(Map<String,String> _pMap){
		String _rtnMsg = "";
		
		try{
			sqlSessionTemplate.update("common.coco.updateCommonCoCoScmActionDetailPop", _pMap);
			
			sqlSessionTemplate.update("common.coco.updateCommonCoCoScmActionPors", _pMap);
			
		}catch(Exception e){
			logger.debug("Exception : ", e);
			throw new RuntimeException("처리내역 저장이 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
		}
		
		return _rtnMsg;	
	}
}
