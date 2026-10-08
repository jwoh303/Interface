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

@Repository("masterMpIfWarehousingDao")
@Transactional
public class MasterMpIfWarehousingDaoImpl implements MasterMpIfWarehousingDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfWarehousingDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.mpif.selectMasterMpIfWarehousingList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		String _jobKind = formData.get("job_kind");
		
		try {
			// 실행 처리
			if ( "execute".equals(_jobKind) ) {
				_rtnMsg = "정상적으로 실행되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					// 오류 현황 메인 update
					sqlSessionTemplate.update("master.mpif.updateMasterMpIfWarehousing_Execute_IF_PROGRESS", formData);
				}
			}
			// 부분입고 처리
			else if ( "partial".equals(_jobKind) ) {
				_rtnMsg = "정상적으로 부분입고되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));

					// 인터페이스 입고내역 update
					sqlSessionTemplate.update("master.mpif.updateMasterMpIfWarehousing_Partial_IF_GRDT", formData);
					
					// 오류 현황 메인 update
					sqlSessionTemplate.update("master.mpif.updateMasterMpIfWarehousing_Partial_IF_PROGRESS", formData);
				}
			}
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
				throw new RuntimeException(e.getMessage());
			}
			
			if ( "execute".equals(_jobKind) ) {
				throw new RuntimeException("\n\n- 실행 실패 -\n\n담당자에게 연락 바랍니다.");
			}
			else if ( "partial".equals(_jobKind) ) {
				throw new RuntimeException("\n\n- 부분입고 실패 -\n\n담당자에게 연락 바랍니다.");
			}
		}
		
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 삭제(종결)되었습니다";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				// 인터페이스 입고내역 update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfWarehousing_Delete_IF_GRDT", formData);

				// 오류 현황 메인 update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfWarehousing_Partial_IF_PROGRESS", formData);
			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n- 삭제(종결) 실패 -\n\n담당자에게 연락 바랍니다.");
		}

		return _rtnMsg;		
	}	

}
