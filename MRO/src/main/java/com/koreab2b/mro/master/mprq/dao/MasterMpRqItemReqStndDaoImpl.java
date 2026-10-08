package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpRqItemReqStndDao")
@Transactional
public class MasterMpRqItemReqStndDaoImpl implements MasterMpRqItemReqStndDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqItemReqStndDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mp.rq.selectMasterMpRqItemReqStndList", formData);
	}
	
	// 저장(FeedBack)
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		
		String _flag = "0";
		try{
			
		for(int i=0; i < gridData.size(); i++){
			formData.putAll((Map<String, String>)gridData.get(i));		

			if(formData.get("KEP_RAV_SEQ").equals("1")){
				// 운영사 FeedBack insert
				sqlSessionTemplate.update("master.mp.rq.insertMasterMpRqItemReqStnd", formData);
				// 고객사 요청내역 완료 update
				sqlSessionTemplate.update("master.mp.rq.updateMasterMpRqItemReqStnd1", formData);
			} else {
				// 운영사 FeedBack update
				sqlSessionTemplate.update("master.mp.rq.updateMasterMpRqItemReqStnd2", formData);
				// 고객사 요청내역 완료 update
				sqlSessionTemplate.update("master.mp.rq.updateMasterMpRqItemReqStnd1", formData);
			}
		}
		
		_flag = "1";
		
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장(FeedBack)에 실패하였습니다.");
		}
		
		return _flag;
		
	}
	
	@SuppressWarnings("unchecked")
	public void replyMail(Map<String,String> formData, List<Object> gridData) {
		/*메일링 로직 있음*/
		List<Map<String,String>>_list = null;
		for(int i=0; i < gridData.size(); i++){
			formData.putAll((Map<String, String>)gridData.get(i));
			
			_list = sqlSessionTemplate.selectList("master.mp.rq.mailMasterMpRqItemReqStndCnt", formData);
			String check_flag = CommonUtil.getListKeyValue(_list,"CNT","0");
			if(check_flag.equals("0")){	
				// MAILSEND INSERT
				sqlSessionTemplate.update("master.mp.rq.mailMasterMpRqItemReqStndMail", formData);
			}
		}
	}
}
