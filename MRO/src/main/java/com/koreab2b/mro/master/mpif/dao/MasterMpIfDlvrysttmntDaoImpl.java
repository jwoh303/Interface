package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpIfDlvrysttmntDao")
@Transactional
public class MasterMpIfDlvrysttmntDaoImpl implements MasterMpIfDlvrysttmntDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfDlvrysttmntDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.mpif.selectMasterMpIfDlvrysttmntList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "정상적으로 실행되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// 오류 현황 메인 update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfDlvrysttmnt_IF_PROGRESS", formData);
			}
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n- 실행 실패 -\n\n담당자에게 연락 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 삭제(종결)되었습니다";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				// 인터페이스 송장(납품)내역 update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfDlvrysttmnt_IF_IVDT", formData);

				// 오류 현황 메인 update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfDlvrysttmnt_IF_PROGRESS", formData);
			}
			
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n- 삭제(종결) 실패 -\n\n담당자에게 연락 바랍니다.");
		}

		return _rtnMsg;		
	}	

}
