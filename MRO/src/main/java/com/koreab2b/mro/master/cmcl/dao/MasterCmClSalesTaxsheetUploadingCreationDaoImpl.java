package com.koreab2b.mro.master.cmcl.dao;

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

@Repository("masterCmClSalesTaxsheetUploadingCreationDao")
@Transactional
public class MasterCmClSalesTaxsheetUploadingCreationDaoImpl implements MasterCmClSalesTaxsheetUploadingCreationDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxsheetUploadingCreationDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.cmcl.selectMasterCmClSalesTaxsheetUploadingCreationList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		try {
			String _jobKind = formData.get("job_kind");
			String _checkYn = "";
			
			// 저장 처리
			if ( "save".equals(_jobKind) ) {
				_rtnMsg = "매출세금계산서 업로드가 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					// 매출세금계산서 업로드 임시 테이블 조회
					_checkYn = (String)sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetUploadingCreationList_Check", formData);
					
					if ( "Y".equals(_checkYn) ) {
						throw new RuntimeException("\n\n임시 테이블에 이미 데이터가 존재합니다.\n\n다시 확인해 보시기 바랍니다.");
					}
					
					// 매출세금계산서 업로드 임시 테이블 저장
					sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxsheetUploadingCreation", formData);
				}
			} 
			// 생성 처리
			else if ( "create".equals(_jobKind) ) {
				_rtnMsg = "세금계산서가 생성 되었습니다.";
				
				String _issueDate = formData.get("issue_date");
				String _closeRevision = "";
				String _firstTaxSerial = "";
				String _orderNo = "";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					String _taxSerialStr = formData.get("TAX_SERIAL");
					
					if ( i == 0 || !_firstTaxSerial.equals(_taxSerialStr) ) {
						_firstTaxSerial = _taxSerialStr;
						// 세금계산서 번호 생성
						_orderNo = sqlSessionTemplate.selectOne("master.cmcl.selectOrderNoAR");
						formData.put("order_no", _orderNo);
						LOGGER.debug("order_no ==>{}<==", _orderNo);
					}
					
					// 매출세금계산서 업로드 임시 테이블 저장
					int _updateCnt = sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetUploadingCreation_KEPTEXUP", formData);
					LOGGER.debug("_updateCnt ==>{}<==", _updateCnt);
				}
				
				// 마감횟수 조회
				String _closeCnt = sqlSessionTemplate.selectOne("master.cmcl.selectCloseCnt", formData);
				LOGGER.debug("_closeCnt ==>{}<==", _closeCnt);
				
				if ( _closeCnt.equals("3") ) {
					if ( "10".equals(_issueDate.substring(6,8)) ) {
						_closeRevision = "1";
					} else if ( "20".equals(_issueDate.substring(6,8)) ) {
						_closeRevision = "2";
					} else {
						_closeRevision = "3";
					}
				} else {
					if ( "15".equals(_issueDate.substring(6,8)) ) {
						_closeRevision = "1";
					} else {
						_closeRevision = "2";
					}
				}
				
				formData.put("close_revision", _closeRevision);
				
				// 외상매출_세금계산서 저장
				int upCount = sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxsheetUploadingCreation_KEPTARDT", formData);
				
				if ( upCount == 0 ) {
					throw new RuntimeException("\n\n[ KEPTARDT 입력실패 ]");
				}
				
				// 매출세금계산서 업로드 임시 테이블 조회
				List<Map<String,Object>> _tempList = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClSalesTaxsheetUploadingCreationList_KEPTEXUP", formData);
				
				
				for ( int i = 0; i < _tempList.size(); i++ ) {
					String _keyOrderNo = "";
					String _keyGrAmt = "";
					
					Map<String,Object> _tempMap = _tempList.get(i);
					_keyOrderNo = String.valueOf(_tempMap.get("TAX_BILL_NO"));
					_keyGrAmt = String.valueOf(_tempMap.get("GR_AMT"));
					LOGGER.debug("_keyOrderNo==>>{}", _keyOrderNo);
					LOGGER.debug("_keyGrAmt==>>{}",_keyGrAmt);
					
					formData.put("key_order_no", _keyOrderNo);
					formData.put("key_gr_amt", _keyGrAmt);
					
					// 세금계산서 품목정보 저장
					sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSalesTaxsheetUploadingCreation_KEPTITEM", formData);
				}
				
				// 구매사별 입고정보 저장
				sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetUploadingCreation_ICOMGRDT", formData);
				
				// 매출세금계산서 업로드 임시 테이블 삭제
				sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClSalesTaxsheetUploadingCreation_KEPTEXUP", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			if ( "save".equals(formData.get("job_kind")) ) {
				throw new RuntimeException("\n\n[ 업로드 저장 실패 ]");
			}
			else if ( "create".equals(formData.get("job_kind")) ) {
				throw new RuntimeException("\n\n[ 세금계산서 생성 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
		}
		
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제가 정상적으로 처리되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				LOGGER.debug("BUYER ==>{}<==", formData.get("BUYER"));
				LOGGER.debug("GR_NO ==>{}<==", formData.get("GR_NO"));
				LOGGER.debug("GR_SEQ ==>{}<==", formData.get("GR_SEQ"));
				
				sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClSalesTaxsheetUploadingCreation", formData);
			}
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 삭제 요청 실패 ]");
		}

		return _rtnMsg;		
	}	

}
