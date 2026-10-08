package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("commonCoCoIssueRegPopDao")
@Transactional
public class CommonCoCoIssueRegPopDaoImpl implements CommonCoCoIssueRegPopDao {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoIssueRegPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 
 	
	public String insertCommonCoCoIssueRegPop(Map<String,String> _pMap){
		String _rtnMsg = "";
		
		try{
			sqlSessionTemplate.update("common.coco.insertCommonCoCoIssueReg", _pMap);
		}catch(Exception e){
			logger.debug("Exception : ", e);
			_rtnMsg = "이슈 등록에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;	
	}
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getCommonCoCoIssueHistHistList(Map<String,Object> param) {
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("common.coco.selectCommonCoCoIssueHistList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

}
