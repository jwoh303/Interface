package com.koreab2b.mro.common.none.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("commonNoNeSendSmsPopDao")
@Transactional
public class CommonNoNeSendSmsPopDaoImpl implements CommonNoNeSendSmsPopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	/*저장*/
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "전송했습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("common.none.insertNoNeSendSms", formData);
			}
		}catch(Exception e){
			throw new RuntimeException("전송에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectList(Map<String, Object> formData) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		
		sqlSessionTemplate.select("common.none.selectNoNeSentSmsList", formData, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();

	}
}
