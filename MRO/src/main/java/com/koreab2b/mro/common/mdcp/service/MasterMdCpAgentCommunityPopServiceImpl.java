package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpAgentCommunityPopDao;

@Service("masterMdCpAgentCommunityPopService")
public class MasterMdCpAgentCommunityPopServiceImpl implements MasterMdCpAgentCommunityPopService {
	
	@Autowired
	private MasterMdCpAgentCommunityPopDao masterMdCpAgentCommunityPopDao;

	// 협력사 커뮤니티 검색조건 조회
	public List<Map<String,String>> getMasterMdCpAgentCommunityInfoList(Map<String,Object> param) {
		return masterMdCpAgentCommunityPopDao.selectMasterMdCpAgentCommunityInfoList(param);
	}	
	// 협력사 커뮤니티 리스트 조회
	public List<Map<String,String>> getMasterMdCpAgentCommunityPopList(Map<String,Object> param) {
		return masterMdCpAgentCommunityPopDao.selectAgentCommunityList(param);
	}
	// 협력사 커뮤니티 상세팝업 내용 등록
	public String insertMasterMdCpAgentCommunityPopList(Map<String,String>  param) {
		return masterMdCpAgentCommunityPopDao.insertMasterMdCpAgentCommunityPopContext(param);
	}
	// 협력사 커뮤니티 상세팝업 내용 조회
	public List<Map<String,String>> selectMasterMdCpAgentCommunityPopContext(Map<String,Object> param) {
		return masterMdCpAgentCommunityPopDao.selectMasterMdCpAgentCommunityPopContext(param);
	}
	// 협력사 커뮤니티 상세팝업 내용 삭제
	@Override
	public String deleteMasterMdCpAgentCommunityPopList(Map<String,String>  param){
		return masterMdCpAgentCommunityPopDao.deleteMasterMdCpAgentCommunityPopContext(param);
	}	
	
	// 협력사 커뮤니티 상세팝업 내용 수정
	@Override
	public String updateMasterMdCpAgentCommunityPopList(Map<String,String>  param){
		return masterMdCpAgentCommunityPopDao.updateMasterMdCpAgentCommunityPopContext(param);
	}	
	
	// 협력사 커뮤니티 상세팝업 댓글 등록
	public String insertMasterMdCpAgentCommunityPopComment(Map<String,String>  param){
		return masterMdCpAgentCommunityPopDao.insertMasterMdCpAgentCommunityPopComment(param);
	}
	// 협력사 커뮤니티 상세팝업 댓글 조회
	public List<Map<String,String>> selectMasterMdCpAgentCommunityPopComment(Map<String,Object> param) {
		return masterMdCpAgentCommunityPopDao.selectMasterMdCpAgentCommunityPopComment(param);
	}
	
}
	
