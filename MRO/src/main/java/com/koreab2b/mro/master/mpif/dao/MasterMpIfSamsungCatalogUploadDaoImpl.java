package com.koreab2b.mro.master.mpif.dao;


import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpIfSamsungCatalogUploadDao")
@Transactional
public class MasterMpIfSamsungCatalogUploadDaoImpl implements MasterMpIfSamsungCatalogUploadDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfSamsungCatalogUploadDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	//엑셀 리스트 조회
	public List<Map<String, String>> getList(Map<String, Object> param) {
		param.put("URL","?DOC_NO=");
		param.put("IMAGE_KEY", CommonUtil.nvl((String) param.get("IMAGE_KEY"), ""));
		param.put("IMAGE_KEY2", CommonUtil.nvl((String) param.get("IMAGE_KEY2"), ""));
		
		return sqlSessionTemplate.selectList("master.mpif.selectMasterMpIfSamsungCatalogUploadList", param);
	}



	@Override
	public String batchUploadList(Map<String, String> formData, List<Object> gridData) {

		String _rtnMsg = "저장완료 되었습니다.";
		int checkFlag = 0;
		String st_buyer_code = "";
		String BUYER_ITEM_NO = "";
		String CONTRACT_NO = "";
		String CONTRACT_SEQ = "";
		String BUYER = "";
		String AFTER_LIST_PRICE = "";
		String AFTER_UNIT_PRICE = "";
		String AFTER_AGENT = "";
		String UNIT_PRICE_CHANGE_REASON = "";
		String LIST_PRICE_CHANGE_REASON = "";
		String QUOTATION_NO ="";
		String QUOTATION_SEQ ="";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("batchMasterMdCmCatalogMultiAlter formData : {} ", formData);
				
				st_buyer_code = CommonUtil.nvl(formData.get("st_buyer_code"),"");
				BUYER_ITEM_NO = CommonUtil.nvl(formData.get("BUYER_ITEM_NO"),"");
				CONTRACT_NO = CommonUtil.nvl(formData.get("CONTRACT_NO"),"");
				CONTRACT_SEQ = CommonUtil.nvl(formData.get("CONTRACT_SEQ"),"");
				AFTER_LIST_PRICE = CommonUtil.nvl(formData.get("AFTER_LIST_PRICE"),"");
				AFTER_UNIT_PRICE = CommonUtil.nvl(formData.get("AFTER_UNIT_PRICE"),""); 
				BUYER = CommonUtil.nvl(formData.get("BUYER"),"");  
				AFTER_AGENT = CommonUtil.nvl(formData.get("AFTER_AGENT"),"");
				UNIT_PRICE_CHANGE_REASON = CommonUtil.nvl(formData.get("UNIT_PRICE_CHANGE_REASON"),"");
				LIST_PRICE_CHANGE_REASON = CommonUtil.nvl(formData.get("LIST_PRICE_CHANGE_REASON"),"");
				QUOTATION_NO = CommonUtil.nvl(formData.get("QUOTATION_NO"),"");
				QUOTATION_SEQ = CommonUtil.nvl(formData.get("QUOTATION_SEQ"),"");
				
				if ("".equals(BUYER_ITEM_NO) 
					|| "".equals(CONTRACT_NO) 
					|| "".equals(CONTRACT_SEQ)  
					|| "".equals(BUYER)  
					){	
					checkFlag = 1;
					throw new RuntimeException();
				}
				//변경후 매출, 매입단가 없을 경우 공백 셋팅.
				 if ("".equals(AFTER_LIST_PRICE)) {
					 formData.put("AFTER_LIST_PRICE", " ");
				}
				 if ("".equals(AFTER_UNIT_PRICE)) {
					 formData.put("AFTER_UNIT_PRICE", " ");
				}
				
				// 견적번호, 항번 존재 시 견적 체크해서 견적 없는경우 오류 발생 시키기
				if(!QUOTATION_NO.equals("") && !QUOTATION_SEQ.equals("")) {
					// 견적  확인
					int count = 0;
					count = sqlSessionTemplate.selectOne("master.mpif.selectbatchMasterKEPRQDT", formData);
					
					if(count == 0) {
						checkFlag = 4;
						throw new RuntimeException();				
					}
				}
				 
				LOGGER.debug("batchMasterMdCmCatalogMultiAlter checkFlag : {} ", checkFlag);
				LOGGER.debug("batchMasterMdCmCatalogMultiAlter AFTER_AGENT : {} ", AFTER_AGENT);
				
				formData.put("DOC_NAME","KEPMGPDT");
				formData.put("ST_USER_ID", formData.get("st_user_id"));
				formData.put("TRXL_GUBUN", formData.get("trxl_gubun"));
				formData.put("SEQ", String.valueOf(i)); 
				formData.put("CH_PROCESS_TYPE",CommonUtil.nvl(formData.get("CH_PROCESS_TYPE")," "));
				formData.put("CH_WAREHOUSE_CODE",CommonUtil.nvl(formData.get("CH_WAREHOUSE_CODE")," "));
				formData.put("LIST_PRICE", "0");  
				formData.put("UNIT_PRICE", "0");  
				formData.put("STATUS_TEXT", "N");
				formData.put("DELIVERY_LT", " ");
				formData.put("UNIT_PRICE_CHANGE_REASON", UNIT_PRICE_CHANGE_REASON);
				formData.put("LIST_PRICE_CHANGE_REASON", LIST_PRICE_CHANGE_REASON);
				
				
				// STEP1
				// 삭제
				sqlSessionTemplate.update("master.mpif.deleteBntTrxlUploadList", formData);
				sqlSessionTemplate.update("master.mpif.setBntTrxlUploadList", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			String msg = "저장에 실패하였습니다.";
			if (checkFlag==1){
				msg = "빈 값 없이 정확한 정보로 엑셀 업로드하세요.";
			}else 	if (checkFlag==2){
				msg = "단가 입력 후 엑셀 업로드하세요.";
			}else 	if (checkFlag==3){
				msg = "조회한 고객사로 엑셀 업로드하세요.";
			}else 	if (checkFlag==4){
				msg = "견적정보가 존재하지않습니다.\n견적번호 및 항번 확인바랍니다.";
			}
				throw new RuntimeException(msg);
		}
		return _rtnMsg; 
	}



	@Override
	public String requestMasterMpIfSamsungCatalogUploadList(Map<String, String> formData, List<Object> gridData) {
		String _rtnMsg = "상신완료 되었습니다.";
		String pm_no = "";
		String dssChk = "Y";
		try{
			String IMAGE_KEY ="";
			String IMAGE_KEY2 ="";
			String com_code = "KRKORE0001";
			pm_no = buyerMpSoOrderInfoDao.getOrderNo(com_code,"PM");
			formData.put("PM_NO", pm_no);
			formData.put("DOC_NAME","KEPMGPDT");
			formData.put("REG_USER_ID", formData.get("st_user_id"));
			formData.put("REG_USER_DEPT", formData.get("st_user_dept"));
			formData.put("TRXL_GUBUN", formData.get("trxl_gubun"));
			
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				formData.put("PO_NO",formData.get("BUYER")); //PO_NO에 고객사정보 넣음				
				
				formData.put("PO_SEQ", "");  
				formData.put("PM_SEQ", String.valueOf(i+1));
						
				//제제업체 발생 시 오류 발생
				formData.put("AGENT", CommonUtil.nvl(formData.get("AFTER_AGENT"), ""));
				formData.put("BUYER", CommonUtil.nvl(formData.get("BELOW_COMORG_CODE"), ""));
				dssChk = (String) sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCatalogRegBNot", formData);
				formData.put("BUYER","KRKORE0001");//buyer에는 KRKORE0001 고정
				if(dssChk.equals("Y")) { // 제제대상 없으면	
									
					// STEP1 (계약변경 일괄수정 화면 작업과 동일)
					sqlSessionTemplate.update("master.mdcm.setSysopKepmgpCaReg1", formData);
					sqlSessionTemplate.update("master.mdcm.setSysopKepmgpCaReg3", formData);
					// 추가분
					IMAGE_KEY = CommonUtil.nvl(formData.get("IMAGE_KEY"),"");
					IMAGE_KEY2 = CommonUtil.nvl(formData.get("IMAGE_KEY2"),"");
					sqlSessionTemplate.update("master.mpif.insertSecItemUpload", formData);
					
					if (i == 0){
						sqlSessionTemplate.update("master.mdcm.setSysopKepmgpCaReg2", formData); 
					
					}
				} else {
					throw new RuntimeException((i+1) + "번째 행 제제업체(협력사) 입니다.\n"+formData.get("BELOW_COMORG_CODE") +"<->" +formData.get("AFTER_AGENT"));
				}
			}
			

			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if(dssChk.equals("Y")) {
				throw new RuntimeException("상신완료에 실패하였습니다.");
			} else {
				throw new RuntimeException(e.getMessage());
			}
				
		}
		return pm_no; 
	}



	@SuppressWarnings("unchecked")
	@Override
	public String saveList(Map<String, String> formData, List<Object> gridData) {
		String _rtnMsg = "저장하였습니다.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("AFTER_AGENT", CommonUtil.nvl(formData.get("AFTER_AGENT"),""));
				formData.put("AFTER_LIST_PRICE", CommonUtil.nvl(formData.get("AFTER_LIST_PRICE"),""));
				formData.put("AFTER_UNIT_PRICE", CommonUtil.nvl(formData.get("AFTER_UNIT_PRICE"),""));
				formData.put("AFTER_ITEM_MAKE_TYPE", CommonUtil.nvl(formData.get("AFTER_ITEM_MAKE_TYPE"),""));
				formData.put("AFTER_DELIVERY_LT", CommonUtil.nvl(formData.get("AFTER_DELIVERY_LT"),""));
				formData.put("CH_SELL_CLOSE_DATE", CommonUtil.nvl(formData.get("CH_SELL_CLOSE_DATE"),""));
				formData.put("CH_BUY_CLOSE_DATE", CommonUtil.nvl(formData.get("CH_BUY_CLOSE_DATE"),""));
				formData.put("CH_MIN_ORDER_QTY", CommonUtil.nvl(formData.get("CH_MIN_ORDER_QTY"),""));
				formData.put("CH_PUR_UNIT_QTY", CommonUtil.nvl(formData.get("CH_PUR_UNIT_QTY"),""));
				formData.put("CH_SELLER_AREA", CommonUtil.nvl(formData.get("CH_SELLER_AREA"),""));
				formData.put("CH_PROCESS_TYPE", CommonUtil.nvl(formData.get("CH_PROCESS_TYPE"),""));
				formData.put("UNIT_PRICE_CHANGE_REASON", CommonUtil.nvl(formData.get("UNIT_PRICE_CHANGE_REASON"),""));
				formData.put("LIST_PRICE_CHANGE_REASON", CommonUtil.nvl(formData.get("LIST_PRICE_CHANGE_REASON"),""));
				formData.put("CH_WAREHOUSE_CODE", CommonUtil.nvl(formData.get("CH_WAREHOUSE_CODE"),""));
				formData.put("IMAGE_KEY", CommonUtil.nvl(formData.get("IMAGE_KEY"),""));
				formData.put("IMAGE_KEY2", CommonUtil.nvl(formData.get("IMAGE_KEY2"),""));
				formData.put("QUOTATION_NO", CommonUtil.nvl(formData.get("QUOTATION_NO"),""));
				formData.put("QUOTATION_SEQ", CommonUtil.nvl(formData.get("QUOTATION_SEQ"),""));
				// STEP1
				sqlSessionTemplate.update("master.mpif.saveMasterMpIfSamsungCatalogUploadList", formData);
				
				String quotationNo = CommonUtil.nvl3(formData.get("QUOTATION_NO"), "");				
				
				if(!quotationNo.equals("") && quotationNo != null) {	// 견적번호 있는경우 업로드 테이블에 INSERT, UPDATE
					String count = "";					
					count = (String) sqlSessionTemplate.selectOne("master.mpif.selectMasterMpIfSecUploadCnt", formData);					
					if(!count.equals("0")) { // UPDATE					
						sqlSessionTemplate.update("master.mpif.updateMasterMpIfSecUpload", formData);		
					} else { // INSERT
						sqlSessionTemplate.update("master.mpif.insertMasterMpIfSecUpload", formData);
					}
					
					
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg; 
	}



	@Override
	public String delList(Map<String, String> formData, List<Object> gridData) {
		String _rtnMsg = "삭제완료 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				String quotationNo = CommonUtil.nvl3(formData.get("QUOTATION_NO"), "");
				// STEP1
				sqlSessionTemplate.update("master.mpif.delMasterMpIfSamsungCatalogUploadList", formData);
				
				if(!quotationNo.equals("") && quotationNo != null) {	// 견적번호 있는경우 업로드 테이블도 삭제				
					sqlSessionTemplate.update("master.mpif.delMasterMpIfSecUpload", formData);
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("삭제에 실패하였습니다.");
		}
		return _rtnMsg; 
	}	

}
