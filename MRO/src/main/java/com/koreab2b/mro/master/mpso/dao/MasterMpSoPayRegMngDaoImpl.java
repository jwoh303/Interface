package com.koreab2b.mro.master.mpso.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpSoPayRegMngDao")
@Transactional
public class MasterMpSoPayRegMngDaoImpl implements MasterMpSoPayRegMngDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoPayRegMngDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	private String _rtnMsg = "";
	
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> getMasterMpSoPayRegMngList(Map<String, Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		String stDate = (String) param.get("st_from_date");
		param.put("st_from_date", stDate.replaceAll("/", ""));
		// 조회 시 품의완료건에 한하여 PR정보를 갖고 최신 GR정보 갱신
		sqlSessionTemplate.update("master.mpso.updateMasterMpSoPayRegMngGrList", param);
		sqlSessionTemplate.select("master.mpso.selectMasterMpSoPayRegMngList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
	
	//저장	
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "저장하였습니다.";
		Map<String, String> PoList = null;
		String PAY_REG_TYPE = ""; // A:선지급금,B:지체상금,C:물류비,D:재고금액
		String PAY_AMT1 = ""; // 선지급금
		String PAY_AMT2 = ""; // 지체상금
		String PAY_AMT3 = ""; // 물류비
		
		try{
						
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				PAY_AMT1 = CommonUtil.nvl(formData.get("PAY_AMT1"),"");
				PAY_AMT2 = CommonUtil.nvl(formData.get("PAY_AMT2"),"");
				PAY_AMT3 = CommonUtil.nvl(formData.get("PAY_AMT3"),"");
				
				if(!PAY_AMT1.equals("")) {
					formData.put("PAY_REG_TYPE", "A");
				} else if(!PAY_AMT2.equals("")) {
					formData.put("PAY_REG_TYPE", "B");
				} else if(!PAY_AMT3.equals("")) {
					formData.put("PAY_REG_TYPE", "C");
				}
				
				PAY_REG_TYPE = CommonUtil.nvl(formData.get("PAY_REG_TYPE"),"");
				
				if(PAY_REG_TYPE.equals("A")) {
					formData.put("PAY_AMT", PAY_AMT1);
				} else if(PAY_REG_TYPE.equals("B")) {
					formData.put("PAY_AMT", PAY_AMT2);
				} else if(PAY_REG_TYPE.equals("C")) {
					formData.put("PAY_AMT", PAY_AMT3);
				}				
				formData.put("SCHD_CLOSE_MONTH", CommonUtil.nvl(formData.get("SCHD_CLOSE_MONTH").replaceAll("/", ""), ""));
				formData.put("st_buyer", CommonUtil.nvl(formData.get("BUYER"), "XX"));
				formData.put("st_po_no", CommonUtil.nvl(formData.get("PO_NO"), ""));
				formData.put("PO_SEQ", CommonUtil.nvl(formData.get("PO_SEQ"), "XX"));				
				PoList = sqlSessionTemplate.selectOne("master.mpso.masterMpSoPayRegMngUploadPopPoSearch", formData);
				if(PoList == null) { // 데이터 없는경우
					formData.put("PR_NO",  " ");
					formData.put("PR_SEQ",  " ");
					formData.put("GR_NO",  " ");
					formData.put("GR_SEQ",  " ");
					formData.put("PO_SEQ", " ");
					formData.put("BUYER",  " ");
					formData.put("AGENT",  " ");
				} else {
					formData.put("PR_NO",  CommonUtil.nvl(PoList.get("PR_NO"), " "));
					formData.put("PR_SEQ",  CommonUtil.nvl(PoList.get("PR_SEQ"), " "));
					formData.put("GR_NO",  CommonUtil.nvl(PoList.get("GR_NO"), " "));
					formData.put("GR_SEQ",  CommonUtil.nvl(PoList.get("GR_SEQ"), " "));
					formData.put("BUYER",  CommonUtil.nvl(PoList.get("BUYER"), " "));
					formData.put("AGENT",  CommonUtil.nvl(PoList.get("AGENT"), " "));
					formData.put("BUYER_NAME",  CommonUtil.nvl(PoList.get("BUYER_NAME"), " "));
					formData.put("BUYER_IRS_NO",  CommonUtil.nvl(PoList.get("BUYER_IRS_NO"), " "));
					formData.put("AGENT_NAME",  CommonUtil.nvl(PoList.get("AGENT_NAME"), " "));
					formData.put("AGENT_IRS_NO",  CommonUtil.nvl(PoList.get("AGENT_IRS_NO"), " "));
					
				}
				
				
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoPayRegMngList", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}


	// 예정일 변경 사유 저장
	public String saveRemark(Map<String, String> param) {
		_rtnMsg = "저장 되었습니다.";
		try{
			sqlSessionTemplate.update("master.mpso.savePayRegMngRemarkPop", param);
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 실패하였습니다. 관리자에게 문의바랍니다.");
		}
		
		return _rtnMsg;
	}

	//삭제	
	@SuppressWarnings("unchecked")
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "삭제하였습니다.";
				
		try{
						
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.mpso.deleteMasterMpSoPayRegMngList", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("삭제 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 품의 상신
	@SuppressWarnings("unchecked")
	public String approvalSelectedData(Map<String, String> formData, List<Object> gridData) {
		
		String gprmNo = "품의완료 하였습니다.";
		// 물류비(수기) 번호 채번
		String arlgNo = "";
		try{
			// BILL_CLOSE_MONTH UPDATE
			sqlSessionTemplate.update("master.mpso.updateMasterMpSoPayRegMngGrList", formData);	
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				if(i == gridData.size()-1) {
					gprmNo = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "GPRM"); // 지급이슈 품의번호 채번 GPRM
				}
				// BILL_CLOSE_MONTH UPDATE 이후 SELECT
				String billCloseM = (String) sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoPayRegMngGrList_BillCloseM", formData);
				formData.put("BILL_CLOSE_MONTH", CommonUtil.nvl3(billCloseM, ""));
				if(formData.get("PAY_REG_TYPE").equals("C")) { // 물류비는 품의진행 X -> 품의완료 상태로 변경
					sqlSessionTemplate.update("master.mpso.approvalMasterMpSoPayRegMngList", formData);
					arlgNo = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "ARLG"); // 지급이슈 품의번호 채번 GPRM
					formData.put("arlgNo", arlgNo);
					sqlSessionTemplate.update("master.mpso.approvalMasterMpSoPayRegMngList_insert", formData);
				} else { // 품의번호 채번					
					formData.put("gprmNo", gprmNo);
					sqlSessionTemplate.update("master.mpso.approvalMasterMpSoPayRegMngList", formData);
				}
				
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("품의 실패하였습니다.");
		}
		return gprmNo;
	}
	
}
