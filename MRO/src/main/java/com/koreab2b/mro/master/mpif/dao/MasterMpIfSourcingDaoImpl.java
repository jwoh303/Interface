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

@SuppressWarnings("unchecked")
@Repository("masterMpIfSourcingDao")
@Transactional
public class MasterMpIfSourcingDaoImpl implements MasterMpIfSourcingDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfSourcingDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.mpif.selectMasterMpIfSourcingList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 실행되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));

				// 오류 현황 메인 update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfSourcing_IF_PROGRESS", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n- 실행 실패 -\n\n담당자에게 연락 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	
	// 삭제
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 삭제(종결)되었습니다";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				// 인터페이스 소싱(견적)내역 update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfSourcing_IF_REDT", formData);
				
				// 오류 현황 메인 update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfSourcing_IF_PROGRESS", formData);

			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n- 삭제(종결) 실패 -\n\n담당자에게 연락 바랍니다.");
		}

		return _rtnMsg;		
	}

	@Override
	public String[] negoCreateSelectedData(Map<String, String> pFormData, List<Object> pGridData) {
		String[] arrRtn	= new String[2];
		
		// 성공시 : 1 실패시 : 0
		arrRtn[0]	= "1";
		arrRtn[1]	= "정상적으로 재견적되었습니다";
		
		try {
			
			// KEPRQDT CREATE
			sqlSessionTemplate.update("master.mpif.updateMasterMpIfSourcingNegoRqdtCreate", pGridData);
			// KEPQTDT CREATE
			sqlSessionTemplate.update("master.mpif.updateMasterMpIfSourcingNegoqtdtCreate", pGridData);
			// KEPRQDT CLOSE
			sqlSessionTemplate.update("master.mpif.updateMasterMpIfSourcingNegorqdtClose", pGridData);
			// KEPQTDT CLOSE
			sqlSessionTemplate.update("master.mpif.updateMasterMpIfSourcingNegoqtdtClose", pGridData);
			
			for ( int i=0; i < pGridData.size(); i++ ) {
				pFormData.putAll((Map<String, String>)pGridData.get(i));
				// 인터페이스 소싱(견적)내역 update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfSourcing_IF_REDT", pFormData);
				// 오류 현황 메인 update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfSourcing_IF_PROGRESS", pFormData);
			}
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n- 재견적 실패 -\n\n담당자에게 연락 바랍니다.");
		}
		
		return arrRtn;
	}	

}
