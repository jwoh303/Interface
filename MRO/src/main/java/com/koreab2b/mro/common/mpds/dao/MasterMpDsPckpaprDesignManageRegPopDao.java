package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpDsPckpaprDesignManageRegPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	/*등록*/
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	/*이메일발송*/
	public void replyMail(Map<String,String> formData, List<Object> gridData);
}
