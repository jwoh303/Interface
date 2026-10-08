package com.koreab2b.mro.master.mpso.dao;


import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.util.CommonUtil;


@Repository("masterMpSoPayRegMngUploadPopDao")
@Transactional
public class MasterMpSoPayRegMngUploadPopDaoImpl implements MasterMpSoPayRegMngUploadPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoPayRegMngUploadPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	
	// 업로드 조회
	public List<Map<String, String>> getList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.masterMpSoPayRegMngUploadPopList", param);
	}
	
	// 발주정보 조회
	public List<Map<String, String>> PoSearch(Map<String, String> param) {		
		return sqlSessionTemplate.selectList("master.mpso.masterMpSoPayRegMngUploadPopPoSearch", param);
	}

	// 엑셀 업로드 저장
	@SuppressWarnings("unchecked")
	public String saveExcelUploadData(Map<String, String> formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		_rtnMsg = "엑셀업로드 완료.";
		Map<String, String> PoList = null;		
		String BUYER = "";
		String PO_NO = "";
		String PO_SEQ = "";
		String SCHD_CLOSE_MONTH = "";
		String PAY_REG_TYPE = ""; // A:선지급금,B:지체상금,C:물류비,D:재고금액
		String PAY_AMT1 = ""; // 선지급금
		String PAY_AMT2 = ""; // 지체상금
		String PAY_AMT3 = ""; // 물류비
		String TAX_AMT = ""; // 물류비 확정세액
		
		String REMARK = "";
		
		System.out.println("gridData.size() == " + gridData.size());
		try{					
			sqlSessionTemplate.update("master.mpso.deleteMasterMpSoPayRegMngUploadPopExcel", formData);
			
			for(int i=0; i < gridData.size(); i++){								
				formData.putAll((Map<String, String>)gridData.get(i));				
				BUYER = CommonUtil.nvl(formData.get("BUYER"),"");
				PO_NO = CommonUtil.nvl(formData.get("PO_NO"),"");
				PO_SEQ = CommonUtil.nvl(formData.get("PO_SEQ"),"");
				SCHD_CLOSE_MONTH = CommonUtil.nvl(formData.get("SCHD_CLOSE_MONTH"),"");
				PAY_REG_TYPE = CommonUtil.nvl(formData.get("PAY_REG_TYPE"),"");
				PAY_AMT1 = CommonUtil.nvl(formData.get("PAY_AMT1"),"");
				PAY_AMT2 = CommonUtil.nvl(formData.get("PAY_AMT2"),"");
				PAY_AMT3 = CommonUtil.nvl(formData.get("PAY_AMT3"),"");				
				REMARK = CommonUtil.nvl(formData.get("REMARK"),"");
				TAX_AMT = CommonUtil.nvl(formData.get("TAX_AMT"),"");
				if("".equals(BUYER) || "".equals(PO_NO) || "".equals(PO_SEQ) || "".equals(SCHD_CLOSE_MONTH) || "".equals(REMARK) || "".equals(PAY_REG_TYPE)) {					
					throw new RuntimeException();
				}
				if(PAY_AMT1.equals("") && PAY_AMT2.equals("") && PAY_AMT3.equals("")) {
					throw new RuntimeException();
				}
				if(PAY_REG_TYPE.equals("A")) {
					formData.put("PAY_AMT", PAY_AMT1);
				} else if(PAY_REG_TYPE.equals("B")) {
					formData.put("PAY_AMT", PAY_AMT2);
				} else if(PAY_REG_TYPE.equals("C")) {
					formData.put("PAY_AMT", PAY_AMT3);
				}				
				PoList = sqlSessionTemplate.selectOne("master.mpso.masterMpSoPayRegMngUploadPopPoSearchExcel", formData);
				if(PoList == null) {
					throw new RuntimeException("발주정보가 존재하지 않습니다.");
				}
				formData.put("BUYER_ITEM_NO",  CommonUtil.nvl(PoList.get("BUYER_ITEM_NO"), ""));
				
				
				sqlSessionTemplate.update("master.mpso.insertMasterMpSoPayRegMngUploadPopExcel", formData);
				
				
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 지급이슈 저장
	@SuppressWarnings("unchecked")
	public String saveUploadList(Map<String, String> formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		_rtnMsg = "저장완료.";
		Map<String, String> PoList = null;		
		String prmNo = "";
		Integer PrmSeq = 1;
		
		String PAY_REG_TYPE = ""; // A:선지급금,B:지체상금,C:물류비,D:재고금액
		String PAY_AMT1 = ""; // 선지급금
		String PAY_AMT2 = ""; // 지체상금
		String PAY_AMT3 = ""; // 물류비
		
		try{					
					
			  prmNo = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PRM"); // 지급이슈 채번 PRM
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
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
				
				formData.put("PAY_REG_NO", prmNo);
				formData.put("PAY_REG_SEQ", PrmSeq.toString());
				PrmSeq++;
				
				sqlSessionTemplate.update("master.mpso.insertMasterMpSoPayRegMngUploadPopList", formData);
				
				
			}
			// 지급이슈 저장 후 업로드 데이터 삭제
			sqlSessionTemplate.update("master.mpso.deleteMasterMpSoPayRegMngUploadPopExcel", formData);	
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 삭제
	public String deleteUploadList(Map<String, String> formData, List<Object> gridData) {
		_rtnMsg = "삭제완료.";
		try{		
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.mpso.deleteMasterMpSoPayRegMngUploadPopExcel_select", formData);
			}
			
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제 실패하였습니다.");
		}
		return _rtnMsg;
	}	
	
}
