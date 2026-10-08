package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;

@Repository("buyerMpSoUniformReqDao")
@Transactional
public class BuyerMpSoUniformReqDaoImpl implements BuyerMpSoUniformReqDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoUniformReqDaoImpl.class);

	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		
		resultList = sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoUniformReqList", param);
		
		return resultList;
	}
	
	// 파일업로드
	@SuppressWarnings("unchecked")
	public String uploadSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "File Upload 완료되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.insert("buyer.mpso.uploadBuyerMpSoUniformReq", formData);
				LOGGER.error("uploadSelectedData 실행 완료");

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("File Upload에 실패 했습니다.\n\n관리자에게 문의 하세요");
		}

		return _rtnMsg;		
		
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		int _count = 0;
		
		_rtnMsg = "수정이 정상적으로 완료되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				
				_count = sqlSessionTemplate.update("buyer.mpso.updateBuyerMpSoUniformReq", formData);
				
				if ( _count != 1 ) {
					throw new RuntimeException("\n\n[ 수정 실패 ]\n\n다시 확인하여 주십시요.");
				}
			}
		} catch(Exception e ) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 수정 에러 발생 ]\n\n본사 시스템운영팀으로 연락바랍니다.");
		}

		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		int _count = 0;
		
		_rtnMsg = "삭제가 정상적으로 완료되었습니다";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				
				_count = sqlSessionTemplate.update("buyer.mpso.deleteBuyerMpSoUniformReq", formData);
				
				if ( _count != 1 ) {
					throw new RuntimeException("\n\n[ 삭제 실패 ]\n\n다시 확인하여 주십시요.");
				}
			}
		} catch(Exception e ) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 삭제 에러 발생 ]\n\n본사 시스템운영팀으로 연락바랍니다.");
		}

		return _rtnMsg;		
	}
	
	// 등록
	@SuppressWarnings("unchecked")
	public String regSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		int _count_hd = 0;
		int _count_dt = 0;
		int _count = 0;
		String _st_no = "";
		int _st_seq = 1;
		
		_rtnMsg = "등록이 정상적으로 완료되었습니다.";
		
		try {
			_st_no = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"),"ST");
			
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				formData.put("ST_NO", _st_no);
				formData.put("ST_SEQ", String.valueOf(_st_seq));
				
				_count_dt = sqlSessionTemplate.update("buyer.mpso.insertBuyerMpSoUniformStPoDt", formData);

				if ( _count_dt != 1 ) {
					throw new RuntimeException("\n\n[ 등록 실패 ]\n\n다시 확인하여 주십시요.");
				}

				_count = sqlSessionTemplate.update("buyer.mpso.deleteBuyerMpSoUniformReq", formData);
				
				if ( _count != 1 ) {
					throw new RuntimeException("\n\n[ 삭제 실패 ]\n\n다시 확인하여 주십시요.");
				}
				
				_st_seq ++;
			}
			
			_count_hd = sqlSessionTemplate.update("buyer.mpso.insertBuyerMpSoUniformStPoHd", formData);
			
			if ( _count_hd != 1 ) {
				throw new RuntimeException("\n\n[ 등록 실패 ]\n\n다시 확인하여 주십시요.");
			}
			/*
			결재요청(고객사 신청자 => 고객사 결재자) : 1
			결재반려(고객사 결재자 => 고객사 신청자) : 2
			확인요청(고객사 신청자 => 운영사 담당자) : 3
			확인반려(운영사 결재자 => 고객사 신청자) : 4
			접수요청(운영사 결재자 => 협력사 결재자) : 5
			접수반려(협력사 결재자 => 운영사 담당자) : 6
			계약완료(운영사 => 고객사 신청자/운영사 담당자/협력사 결재자) : 7
			*/
			formData.put("MAIL_TYPE", "1");
			formData.put("MAIL_BUYER", formData.get("st_buyer"));
			formData.put("MAIL_ST_NO", formData.get("ST_NO"));
			sqlSessionTemplate.update("buyer.mpso.call_PKG_MAIL_REQ_PROC_INSERT_MAILSEND", formData);
			
		} catch(Exception e ) {
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n[ 등록 에러 발생 ]\n\n본사 시스템운영팀으로 연락바랍니다.");
		}

		return _rtnMsg;
	}
}
