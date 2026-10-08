package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

public interface CommonMdCmStndApprovalDao {	 
	//상취소
	public String MdCmStndCancle(Map<String,String>  formData);
	//결재
	public String MdCmStndApprovalA(Map<String,String>  formData);
	//반려
	public String MdCmStndApprovalB(Map<String,String>  formData);

}
