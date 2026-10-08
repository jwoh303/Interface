package com.koreab2b.mro.common.mdcp.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMdCpAgentCommunityPopDao")
@Transactional
public class MasterMdCpAgentCommunityPopDaoImpl implements MasterMdCpAgentCommunityPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCpAgentCommunityPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 협력사 커뮤니티 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectAgentCommunityList(Map<String,Object> param) {
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			sqlSessionTemplate.select("common.mdcp.selectMasterMdCpAgentCommunityPopList", param, _resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpAgentCommunityPopList", param);
		}
		
		return resultList;
	}
	
	// 협력사 커뮤니티 검색조건 조회
	public List<Map<String, String>> selectMasterMdCpAgentCommunityInfoList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpAgentCommunityInfoList", param);
	}
	
	// 협력사 커뮤니티 상세팝업 내용 등록
	public String insertMasterMdCpAgentCommunityPopContext(Map<String,String>  param) {
		_rtnMsg = "저장했습니다.";
		
		try{
			sqlSessionTemplate.update("common.mdcp.insertMasterMdCpAgentCommunityPopContext", param);	// 내용 저장
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 협력사 커뮤니티 내용 조회
	public List<Map<String, String>> selectMasterMdCpAgentCommunityPopContext(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpAgentCommunityPopContext", param);
	}
	
	// 협력사 커뮤니티 상세팝업 내용 삭제
	public String deleteMasterMdCpAgentCommunityPopContext(Map<String,String>  param) {
		_rtnMsg = "삭제했습니다.";
			
		try{
			sqlSessionTemplate.update("common.mdcp.deleteMasterMdCpAgentCommunityPopContext", param);	// 내용 저장
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 협력사 커뮤니티 상세팝업 내용 수정
	public String updateMasterMdCpAgentCommunityPopContext(Map<String,String>  param) {
		_rtnMsg = "수정했습니다.";
			
		try{
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpAgentCommunityPopContext", param);	// 내용 저장
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("수정에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	

	// 협력사 커뮤니티 상세팝업 댓글 등록
	public String insertMasterMdCpAgentCommunityPopComment(Map<String,String>  param) {
		_rtnMsg = "저장했습니다.";
		
		try{
			sqlSessionTemplate.update("common.mdcp.insertMasterMdCpAgentCommunityPopComment", param);	// 내용 저장
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 협력사 커뮤니티 상세팝업 댓글 조회
	public List<Map<String,String>> selectMasterMdCpAgentCommunityPopComment(Map<String,Object> param) {
		
		List<Map<String, String>> resultList =  sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpAgentCommunityPopComment", param);
		return resultList;
	}
}
