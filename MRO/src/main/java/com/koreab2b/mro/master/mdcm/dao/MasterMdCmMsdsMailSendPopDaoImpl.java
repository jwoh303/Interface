package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMdCmMsdsMailSendDao")
@Transactional
public class MasterMdCmMsdsMailSendPopDaoImpl implements MasterMdCmMsdsMailSendPopDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mdcm.selectMasterMdCmMsdsMailSendPopList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	// 메일 전송
	@SuppressWarnings("unchecked")
	public String saveMasterMdcmMsdsMailSend(Map<String,String>  formData, List<Object> gridData) {
		String _seqVal = "";
		
		_rtnMsg = "메일 전송이 완료되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				_seqVal = (String)sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmMsdsEmailSendSeq", formData);
				formData.put("SEQ", _seqVal);
				
				sqlSessionTemplate.update("master.mdcm.insertMasterMdCmMsdsEmailSend1", formData); // MAILSEND
				sqlSessionTemplate.update("master.mdcm.insertMasterMdCmMsdsEmailSend2", formData); // KEP_CMC_MAILSEND
			}
			
		} catch (Exception e){
			throw new RuntimeException("메일 전송에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	// 메일 수신여부 변경
	@SuppressWarnings("unchecked")
	public String saveMailRecv(Map<String,String> formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.update("master.mdcm.updateMasterMdCmMsdsMailRecv", formData);
		} catch (Exception e) {
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
}
