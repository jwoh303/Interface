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

@Repository("masterMpIfErrorStateMainDao")
@Transactional
public class MasterMpIfErrorStateMainDaoImpl implements MasterMpIfErrorStateMainDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfErrorStateMainDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.mpif.selectMasterMpIfErrorStateMainList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 납품요구일저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String updateSelectedDataRdDate(Map<String,String>  formData, List<Object> gridData) {
	
		try{
			for ( int i=0; i < gridData.size(); i++ ) {
				
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfErrorStateMain_RD_DATE_IF", formData);
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfErrorStateMain_RdDate_pr", formData);
			}
		}catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			_rtnMsg = "납품요구일변경 시 오류가 발생하였습니다.";
			throw new RuntimeException("납품요구일변경 시 오류가 발생하였습니다.");
		}
		return _rtnMsg;
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

					// 인터페이스 주문상세내역[발주IF 테이블] update
					sqlSessionTemplate.update("master.mpif.updateMasterMpIfErrorStateMain_Execute_IF_PODT", formData);
					
					if ( "KRDOOD0001".equals(String.valueOf(formData.get("BUYER"))) && " ".equals(String.valueOf(formData.get("BUYER_ITEM_NO"))) ) {
						// 인터페이스 두중 발주내역[두산중공업 발주IF업로드 테이블] update
						sqlSessionTemplate.update("master.mpif.updateMasterMpIfErrorStateMain_Execute_POIFLOAD_DOOS", formData);
					}
					
					// 오류 현황 메인 update
					sqlSessionTemplate.update("master.mpif.updateMasterMpIfErrorStateMain_Execute_IF_PROGRESS", formData);
				}
			} 
			// 부분발주 처리
			else if ( "partial".equals(_jobKind) ) {
				_rtnMsg = "정상적으로 부분발주되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));

					// 인터페이스 주문상세내역[발주IF 테이블] update
					sqlSessionTemplate.update("master.mpif.updateMasterMpIfErrorStateMain_Partial_Po_IF_PODT", formData);
					
					// 오류 현황 메인 update
					sqlSessionTemplate.update("master.mpif.updateMasterMpIfErrorStateMain_Partial_Po_IF_PROGRESS", formData);
				}
			}
			// 저장 처리
			else if ( "save".equals(_jobKind) ) {
				_rtnMsg = "정상적으로 저장되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					// 인터페이스 주문상세내역[발주IF 테이블] update
					sqlSessionTemplate.update("master.mpif.updateMasterMpIfErrorStateMain_Save_IF_PODT", formData);
					
					if ( "KRDOOD0001".equals(String.valueOf(formData.get("BUYER"))) && " ".equals(String.valueOf(formData.get("BUYER_ITEM_NO"))) ) {
						// 인터페이스 두중 발주내역[두산중공업 발주IF업로드 테이블] update
						sqlSessionTemplate.update("master.mpif.updateMasterMpIfErrorStateMain_Execute_POIFLOAD_DOOS", formData);
					}
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
				throw new RuntimeException("\n\n- 부분발주 실패 -\n\n담당자에게 연락 바랍니다.");
			}
			else if ( "save".equals(_jobKind) ) {
				throw new RuntimeException("\n\n- 저장 실패 -\n\n담당자에게 연락 바랍니다.");
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
				// 인터페이스 주문상세내역[발주IF 테이블] update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfErrorStateMain_Delete_IF_PODT", formData);
				
				// 오류 현황 메인 update
				sqlSessionTemplate.update("master.mpif.updateMasterMpIfErrorStateMain_Partial_Po_IF_PROGRESS", formData);
			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n- 삭제(종결) 실패 -\n\n담당자에게 연락 바랍니다.");
		}

		return _rtnMsg;		
	}

	//삼성전자 품의상신 번호 업데이트
	@Override
	public String updateIfPoListInfoApprDate(Map<String, String> formData, List<Object> gridData, String iFKey) {
		_rtnMsg = "";
		String gwIFKey = iFKey;
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				 formData.putAll((Map<String, String>)gridData.get(i)); 
				 formData.put("GW_NO", gwIFKey);
				 
				 sqlSessionTemplate.update("master.mpif.updateIfPoListInfoApprDate", formData);
			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n- 삼성전자외화단가품의 실패 -\n\n담당자에게 연락 바랍니다.");
		}
		
		return _rtnMsg;
	}

	@Override
	public String SelectBuyerIFkey(Map<String, String> formData) {
			String ifkey = sqlSessionTemplate.selectOne("master.mpif.SelectGwExIFkey", formData);
		return ifkey;
	}	

}
