package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCmChemicalMatMngDao")
@Transactional
public class MasterMdCmChemicalMatMngDaoImpl implements MasterMdCmChemicalMatMngDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmChemicalMatMngDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmChemicalMatMngList", param);
	}
	// 협력사 반려처리
	@SuppressWarnings("unchecked")
	public String returnMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다.";
		try {
			List<Map<String,String>>_list = null;
			_list = sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtKepCmcReqStatus",formData);
			String reqStatus = CommonUtil.getListKeyValue(_list,"REQ_STATUS","");
			//진행상태
			String stStatus = formData.get("st_status");
			if(stStatus.equals("R")){
				// 반려처리 가능 상태 : S-협력사제출, P-협력사제출(오분류), M-검토요청, A-발주후제출(협력사)
				if(!reqStatus.equals("S")&&!reqStatus.equals("P")&&!reqStatus.equals("M")&&!reqStatus.equals("A")){
					_rtnMsg = "반려처리는 협력사 제출상태만 처리 가능 합니다.";
					throw new RuntimeException(_rtnMsg);
				}				
			}
			//진행상태 및 물질정보 업데이트
			sqlSessionTemplate.update("master.mdcm.returnMasterrMdCtChemicalMat", formData);
			// 협력사 물질정보 등록 요청 메일 발송
			sqlSessionTemplate.update("master.mdcm.insertMsdsAgentRejtMail", formData);
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// 검토요청
	@SuppressWarnings("unchecked")
	public String reqMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다.";
		try {
			List<Map<String,String>>_list = null;
			_list = sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtKepCmcReqStatus",formData);
			//유해화학물질 여부
			String stHarmfulYn = formData.get("st_harmful_yn");
			//진행상태
			String stStatus = formData.get("st_status");
			//검토요청일 경우
			if(stStatus.equals("M")){
				//제출자 정보 업데이트
				sqlSessionTemplate.update("master.mdcm.saveMasterrMdCtAtobChemicalMat", formData);	
			}
			//진행상태 및 물질정보 업데이트
			sqlSessionTemplate.update("master.mdcm.reqMasterrMdCtChemicalMat", formData);
			//조성정보 삭제
			sqlSessionTemplate.update("seller.mdct.deleteSellerMdCmChemicalMatMakeSend", formData);
			//조성정보 신규insert
			if(stHarmfulYn.equals("Y")){//유해확물질 여부
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					LOGGER.debug("saveSellerMdCmChemicalMatMakeSend 요청 파라미터 : formData {}", formData.get("sStatus"));
					//조성정보 INSERT
					sqlSessionTemplate.update("seller.mdct.saveSellerMdCmChemicalMatMakeSend", formData);
				}				
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	// 상태변경
	public String updateStatusMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다.";
		
		try {
			LOGGER.debug("formData ==== : {}", formData);
			
			if("T".equals(formData.get("st_status"))) { // 오분류(종결)
				// KEP_CMC_REQ 업데이트
				formData.put("st_msds_no", "MS99999999");
				sqlSessionTemplate.update("master.mdcm.afterMasterrMdCtChemicalMat1", formData);
				// KEPRQDT 업데이트
				sqlSessionTemplate.update("master.mdcm.afterMasterrMdCtChemicalMat2", formData);
				
				String quotation_no = CommonUtil.nvl(formData.get("st_quotation_no"), "");
				String quotation_seq = CommonUtil.nvl(formData.get("st_quotation_seq"), "");
				String revision = CommonUtil.nvl(formData.get("st_revision"), "");
				
				if(!"".equals(quotation_no) && !"".equals(quotation_seq) && !"".equals(revision)) { // 견적 정보로 조회
					// KEP_CMC_REQ 동일 요청 품목에 대해서 취소 처리(견적)
					sqlSessionTemplate.update("master.mdcm.afterMasterrMdCtChemicalMat3", formData);	
				}else{
					// KEP_CMC_REQ 동일 요청 품목에 대해서 취소 처리(카탈로그)
					sqlSessionTemplate.update("master.mdcm.afterMasterrMdCtChemicalMat4", formData);
				}
			}else { // 이 외 진행상태 변경
				sqlSessionTemplate.update("master.mdcm.updateStatusMasterrMdCtChemicalMat", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "처리에 실패했습니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패했습니다.");
		}
		return _rtnMsg;
	}
	// 최종승인
	@SuppressWarnings("unchecked")
	public String confirmMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "최종승인 처리 되었습니다.";
		
		try {
			LOGGER.debug("formData ==== : {}", formData);
			
			List<Map<String,String>>_list = null;
			_list = sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtKepCmcReqStatus",formData);
			String reqStatus = CommonUtil.getListKeyValue(_list,"REQ_STATUS","");
			//유해화학물질 여부
			String stHarmfulYn = formData.get("st_harmful_yn");
			if(reqStatus.equals("C")){
				_rtnMsg = "최종승인 처리가 된건이므로 처리 불가능 합니다..";
				throw new RuntimeException(_rtnMsg);
			}				
			//승인자 정보 업데이트
			sqlSessionTemplate.update("master.mdcm.confirmMasterrMdCtChemicalMat", formData);	
			//진행상태 및 물질정보 업데이트
			sqlSessionTemplate.update("master.mdcm.reqMasterrMdCtChemicalMat", formData);
			List<Map<String,String>>_list2 = null;
			_list2 = sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmKepCmcSeq",formData);
			String stSep = CommonUtil.getListKeyValue(_list2,"CMC_SEQ","1");
			formData.put("CMC_SEQ", stSep);
			//기존정보 물질정보 삭제처리STATUS = 'D'처리.
			sqlSessionTemplate.update("master.mdcm.deleteMasterrMdCtChemicalMat1", formData);
			sqlSessionTemplate.update("master.mdcm.deleteMasterrMdCtChemicalMat2", formData);
			//물질정보 등록 - 추후 불필요 판단시 삭제 가능
			//sqlSessionTemplate.update("master.mdcm.confirmMasterrMdCtChemicalMat1", formData);
			//조성정보 삭제
			sqlSessionTemplate.update("seller.mdct.deleteSellerMdCmChemicalMatMakeSend", formData);
			//조성정보 신규insert
			if(stHarmfulYn.equals("Y")){//유해화학물질 여부
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					LOGGER.debug("saveSellerMdCmChemicalMatMakeSend 요청 파라미터 : formData {}", formData.get("sStatus"));
					//조성정보 INSERT - 추후 불필요 판단시 삭제 가능
					//sqlSessionTemplate.update("seller.mdct.saveSellerMdCmChemicalMatMakeSend", formData);
					//물질 조성정보 등록 - 추후 불필요 판단시 삭제 가능
					//sqlSessionTemplate.update("master.mdcm.confirmMasterrMdCtChemicalMat2", formData);
				}				
			}else{
				//물질 조성정보 등록 - 추후 불필요 판단시 삭제 가능
				//sqlSessionTemplate.update("master.mdcm.confirmMasterrMdCtChemicalMat3", formData);				
			}
			
			String quotation_no = CommonUtil.nvl(formData.get("st_quotation_no"), "");
			String quotation_seq = CommonUtil.nvl(formData.get("st_quotation_seq"), "");
			String revision = CommonUtil.nvl(formData.get("st_revision"), "");
			
			if(!"".equals(quotation_no) && !"".equals(quotation_seq) && !"".equals(revision)) { // 견적 정보로 조회
				//MSDS KEPRQDT 업데이트
				sqlSessionTemplate.update("master.mdcm.confirmMasterrMdCtChemicalMat5", formData);
				// KEP_CMC_REQ 동일 요청 품목에 대해서 취소 처리(견적)
				sqlSessionTemplate.update("master.mdcm.afterMasterrMdCtChemicalMat3", formData);
			}else { // 카탈로그 정보로 조회
				//MSDS ICOMBYIT 업데이트
				sqlSessionTemplate.update("master.mdcm.confirmMasterrMdCtChemicalMat4", formData);
				// KEP_CMC_REQ 동일 요청 품목에 대해서 취소 처리(카탈로그)
				sqlSessionTemplate.update("master.mdcm.afterMasterrMdCtChemicalMat4", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "최종승인 처리에 실패했습니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("최종승인 처리에 실패했습니다.");
		}
		return _rtnMsg;
	}
	// 발주 후 제출
	@SuppressWarnings("unchecked")
	public String afterMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "발주 후 제출 처리 되었습니다.";
		
		try {
			LOGGER.debug("formData ==== : {}", formData);
			// KEP_CMC_REQ 업데이트
			formData.put("st_msds_no", "MS88888888");
			sqlSessionTemplate.update("master.mdcm.afterMasterrMdCtChemicalMat1", formData);
			// KEPRQDT 업데이트
			sqlSessionTemplate.update("master.mdcm.afterMasterrMdCtChemicalMat2", formData);
			
			String quotation_no = CommonUtil.nvl(formData.get("st_quotation_no"), "");
			String quotation_seq = CommonUtil.nvl(formData.get("st_quotation_seq"), "");
			String revision = CommonUtil.nvl(formData.get("st_revision"), "");
			
			if(!"".equals(quotation_no) && !"".equals(quotation_seq) && !"".equals(revision)) { // 견적 정보로 조회
				// KEP_CMC_REQ 동일 요청 품목에 대해서 취소 처리(견적)
				sqlSessionTemplate.update("master.mdcm.afterMasterrMdCtChemicalMat3", formData);	
			}else{
				// KEP_CMC_REQ 동일 요청 품목에 대해서 취소 처리(카탈로그)
				sqlSessionTemplate.update("master.mdcm.afterMasterrMdCtChemicalMat4", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "발주 후 제출 처리에 실패했습니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("발주 후 제출 처리 실패했습니다.");
		}
		return _rtnMsg;
	}
}
