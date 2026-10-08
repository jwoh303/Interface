package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("masterMpRqBuyerQuotationReceiptSendCntPopDao")
@Transactional
public class MasterMpRqBuyerQuotationReceiptSendCntPopDaoImpl implements MasterMpRqBuyerQuotationReceiptSendCntPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqBuyerQuotationReceiptSendCntPopList", formData);
	}
	// 품목정비 이력
	public List<Map<String,String>> selectQuotationItemMdreqHistList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqQuotationItemMdreqHistList", formData);
	}
	// 추가정비 이력
	public List<Map<String,String>> selectQuotationAfterItemMdreqHistList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqQuotationAfterItemMdreqHistList", formData);
	}
	// 견적윽이사항 조회
	public List<Map<String,String>> selectQuotationRemarkList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectQuotationRemarkList", formData);
	}
	// 견적특이사항 저장
	@SuppressWarnings("unchecked")
	public String saveMasterMpRqQuotationRemarkPop(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다.";
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				if ( "I".equals(formData.get("sStatus")) ) {
					sqlSessionTemplate.insert("common.mprq.insertMasterMpRqQuotationRemarkPop", formData);
				} else {
					sqlSessionTemplate.update("common.mprq.updateMasterMpRqQuotationRemarkPop", formData);
				}
			}
		} catch (Exception e) {
			_rtnMsg = "처리 실패 했습니다.";
			throw new RuntimeException("처리 실패 했습니다.");
		}
		
		return _rtnMsg;
	}
	// 견적특이사항 삭제
	@SuppressWarnings("unchecked")
	public String delMasterMpRqQuotationRemarkPop(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다.";
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.delete("common.mprq.delMasterMpRqQuotationRemarkPop", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "처리 실패 했습니다.";
			throw new RuntimeException("처리 실패 했습니다.");
		}
		
		return _rtnMsg;
	}
	// 네고정비 이력
	public List<Map<String,String>> selectQuotationNegoItemMdreqHistList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqQuotationNegoItemMdreqHistList", formData);
	}
	// SG지정 이력
	public List<Map<String,String>> selectQuotationSgDHistList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqQuotationSgDHistList", formData);
	}
}
