package com.koreab2b.mro.master.mprq.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("MasterMpRqQuotationBulkItemReceiptListDao")
@Transactional
public class MasterMpRqBulkQuotationReceiptListDaoImpl implements MasterMpRqBulkQuotationReceiptListDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationReceiptListDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		// 벌크견적건 상태 업데이트
		sqlSessionTemplate.update("master.mprq.updateMasterMpRqBulkQuotationRfqStatus", param);
		
		//진행상태코드
		param.put("st_receipt_status_all", CommonUtil.getStringArrary((String) param.get("st_receipt_status"), ","));
	
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationReceiptList", param);
	}

	// 임시저장
	@Override
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData) {
		_rtnMsg = "저장완료 되었습니다.";
		
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("saveMasterMpRqBulkQuotationReceiptListTemp param : {} ", formData);
				
				sqlSessionTemplate.update("master.mprq.saveMasterMpRqBulkQuotationReceiptListTemp", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg; 
	}
	
	// 견적마감
	@SuppressWarnings("unchecked")
	public String updateData(Map<String,Object> param) {
		
		try{
			String[] itemArr = ((String) param.get("st_query")).split("@@");
			for(int i = 0; i< itemArr.length;  i++) {
				param.put("ITEM_KEY_ID", itemArr[i]);
				LOGGER.debug("finishMasterMpRqBulkQuotationReceiptList param : {} ", param);
				sqlSessionTemplate.update("master.mprq.finishBulkQuotationItem", param);
			}
			
			// 프로젝트도 마감되어야 하는지 확인
			sqlSessionTemplate.update("master.mprq.finishBulkQuotationItem2", param);
			
		} catch (Exception e){
			_rtnMsg = "Error";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 하던중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		
		return _rtnMsg;
	}

	// 견적마감취소
	@SuppressWarnings("unchecked")
	public String updateData2(Map<String,Object> param) {
		
		try{
			String[] itemArr = ((String) param.get("st_query")).split("@@");
			for(int i = 0; i< itemArr.length;  i++) {
				param.put("ITEM_KEY_ID", itemArr[i]);
				LOGGER.debug(i+"th cancelfinishedBulkQuotationItem param : {} ", param);
				sqlSessionTemplate.update("master.mprq.cancelfinishedBulkQuotationItem", param);
			}

		} catch (Exception e){
			_rtnMsg = "Error";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 하던중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		
		return _rtnMsg;
	}

	// 견적요청
	@Override
	public String orderData(Map<String, String> formData, List<Object> gridData) {
		_rtnMsg = "견적 요청되었습니다.";
		try{
//			List<Map<String,String>> _list = sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationReceiptOrderList", param);
			
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug(i+"th orderBulkQuotationItem param : {} ", formData);
				
				sqlSessionTemplate.update("master.mprq.orderBulkQuotationItem", formData);
			}
			

		} catch (Exception e){
			_rtnMsg = "Error";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 하던중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		
		return _rtnMsg;
	}

	// 견적마감일 변경
	@Override
	public String updateDateData(Map<String, String> formData, List<Object> gridData) {
		_rtnMsg = "저장완료 되었습니다.";
		
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("updateMasterMpRqBulkQuotationReceiptListEndDate param : {} ", formData);
				
				sqlSessionTemplate.update("master.mprq.updateBulkQuotationEndDate", formData);
			}
			
			// 프로젝트의 견적마감일 미뤄야하는지 체크
			sqlSessionTemplate.update("master.mprq.updateBulkQuotationEndDate2", formData);
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg; 
	}

}
