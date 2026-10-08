package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCpAgentCommunityPopService {
	
	// 협력사 커뮤니티 검색조건 조회
	public List<Map<String,String>> getMasterMdCpAgentCommunityInfoList(Map<String,Object>  param);
	
	// 협력사 커뮤니티 리스트 조회
	public List<Map<String,String>> getMasterMdCpAgentCommunityPopList(Map<String,Object>  param);	
	
	// 협력사 커뮤니티 상세팝업 내용 등록
	public String insertMasterMdCpAgentCommunityPopList(Map<String,String>  param);
	
	// 협력사 커뮤니티 상세팝업 내용 조회
	public List<Map<String,String>> selectMasterMdCpAgentCommunityPopContext(Map<String,Object>  param);

	// 협력사 커뮤니티 상세팝업 내용 삭제
	public String deleteMasterMdCpAgentCommunityPopList(Map<String,String>  param);
	
	// 협력사 커뮤니티 상세팝업 내용 수정
	public String updateMasterMdCpAgentCommunityPopList(Map<String,String>  param);
	
	// 협력사 커뮤니티 상세팝업 댓글 등록
	public String insertMasterMdCpAgentCommunityPopComment(Map<String,String>  param);
	
	// 협력사 커뮤니티 상세팝업 댓글 조회
	public List<Map<String,String>> selectMasterMdCpAgentCommunityPopComment(Map<String,Object>  param);
}
