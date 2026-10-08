package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqItemReqStndDao;

@Service("masterMpRqItemReqStndService")
public class MasterMpRqItemReqStndServiceImpl implements MasterMpRqItemReqStndService {
	
	@Autowired
	private MasterMpRqItemReqStndDao masterMpRqItemReqStndDao;

	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqItemReqStndDao.selectList(formData);
	}	
	
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		String flag = masterMpRqItemReqStndDao.updateSelectedData(formData, gridData);
		
		if(flag.equals("1")){
			replyMail(formData, gridData);
		}
		return flag;
	}
	
	public void replyMail(Map<String,String> formData, List<Object> gridData)  {
		masterMpRqItemReqStndDao.replyMail(formData, gridData);
	}	

	
}
