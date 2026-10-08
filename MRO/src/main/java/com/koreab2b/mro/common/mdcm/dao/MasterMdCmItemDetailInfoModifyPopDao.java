package com.koreab2b.mro.common.mdcm.dao;

import java.util.Map;

public interface MasterMdCmItemDetailInfoModifyPopDao {

	// 조회
	public Map<String,String> selectList(Map<String,String> formData);

	// 판촉물 삭제반려처리
	public String updateMasterMdCmItemDetailInfoDeleteNotAccept(Map<String,String> formData);
		
	public String updateMasterMdCmItemDetailInfoModifyPop(Map<String,String> formData);
		
}
