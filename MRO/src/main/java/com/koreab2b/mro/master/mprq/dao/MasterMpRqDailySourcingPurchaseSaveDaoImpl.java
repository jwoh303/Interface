package com.koreab2b.mro.master.mprq.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpRqDailySourcingPurchaseSaveDao")
@Transactional
public class MasterMpRqDailySourcingPurchaseSaveDaoImpl implements MasterMpRqDailySourcingPurchaseSaveDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqDailySourcingPurchaseSaveDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@SuppressWarnings("unchecked")
	public Map<String,String> initQuotation(Map<String,String> formData, List<Object> gridData) {
		String _rtnMsg = "견적 초기화 되었습니다.";
		Map<String, String> pMap = new HashMap<String, String>();
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				int count = 0;
				count = sqlSessionTemplate.selectOne("master.mprq.selectInitKETRQDT_DSP", formData);

				if(count > 0) {
					throw new RuntimeException("견적제출된 견적건은 초기화가 불가능합니다.");
				}
				sqlSessionTemplate.update("master.mprq.inseretInitKEPQTDT_R_DSP", formData);
				sqlSessionTemplate.update("master.mprq.deleteInitKETQTDT_DSP", formData);
				sqlSessionTemplate.update("master.mprq.updateInitKEPRQDT_DSP", formData);

				formData.put("st_cancel_note", "견적초기화");
				formData.put("USR_ID", formData.get("st_user_id"));
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqQuotReceipt_3_DSP", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 초기화에 실패하였습니다.");
		}

		pMap.put("MSG", _rtnMsg);

		return pMap;
	}

	@SuppressWarnings("unchecked")
	public String updateEndTime(Map<String,String> formData, List<Object> gridData) {
		String _rtnMsg = "견적 마감시간이 변경 되었습니다.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));

				sqlSessionTemplate.update("master.mprq.saveMasterMpRqQuotationAtoSDate_DSP", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적시간 마감시간 변경 중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		return _rtnMsg;
	}

	@SuppressWarnings("unchecked")
	public String updateMsdsReq(Map<String,String> formData, List<Object> gridData) {
		String _rtnMsg = "정상적으로 MSDS 요청 되었습니다.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));

				String req_no = sqlSessionTemplate.selectOne("master.mprq.selectQuotationCmcReqNo_DSP", formData);
				formData.put("st_req_no", req_no);

				sqlSessionTemplate.update("master.mprq.updateQuotationProceState2_DSP", formData);

				formData.put("st_cancel_note", "MSDS요청(협력사)");
				formData.put("USR_ID", formData.get("st_user_id"));
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqQuotReceipt_3_DSP", formData);

				String agent_imagekey = sqlSessionTemplate.selectOne("master.mprq.selectAgentImagekey_DSP", formData);

				if(!"X".equals(agent_imagekey)) {
					formData.put("MSDS_NO_FILEKEY", agent_imagekey);
					formData.put("P_REQ_STATUS", "S");

					sqlSessionTemplate.update("master.mprq.updateQuotationProceState3_DSP", formData);
				}else{
					formData.put("MSDS_NO_FILEKEY", "");
					formData.put("P_REQ_STATUS", "Q");

					sqlSessionTemplate.update("master.mprq.updateQuotationProceState3_DSP", formData);

					sqlSessionTemplate.update("master.mprq.updateQuotationProceState4_DSP", formData);
				}
			}
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("MSDS 요청중 오류가 발생하였습니다. 시스템담당자에게 문의 바랍니다.");
		}
		return _rtnMsg;
	}

	@SuppressWarnings("unchecked")
	public String updateItemChgReq(Map<String,String> formData, List<Object> gridData) {
		String _rtnMsg = "품목정비 요청되었습니다.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqItemChgReq_DSP", formData);
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqKepItemMdReq_DSP", formData);
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqKepItemMdReq_DSP", formData);

				formData.put("ADMIN_REMARK", "[품목정비요청] " + formData.get("ITEM_CHG_REQ_NOTE"));
				formData.put("st_image_key", formData.get("ITEM_CHG_REQ_IMAGE_KEY"));
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqReqQuotAdminRemark_DSP", formData);

				sqlSessionTemplate.update("master.mprq.insertMasterMpRqKepItemMdReqKepMail_DSP", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("요청 실패하였습니다.");
		}
		return _rtnMsg;
	}

	@SuppressWarnings("unchecked")
	public String updateDbCleansingCopy(Map<String,String> formData, List<Object> gridData) {
		String _rtnMsg = "선택하신 행의 DB클랜징 정보가 복사되었습니다.";

		try{
			Map<String,String> _result = null;

			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));

				if(i==0) {
					_result = sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqDbCleansingCopy_DSP", formData);
				}else {
					if(_result != null) {
						formData.put("DESCRIPTION", CommonUtil.nvl(_result.get("DESCRIPTION")));
						formData.put("SPECIFICATION", CommonUtil.nvl(_result.get("SPECIFICATION")));
						formData.put("UNIT_MEASURE", CommonUtil.nvl(_result.get("UNIT_MEASURE")));
						formData.put("MAKER_CODE", CommonUtil.nvl(_result.get("MAKER_CODE")));
						formData.put("MAKER_NAME", CommonUtil.nvl(_result.get("MAKER_NAME")));
						formData.put("ORIGIN_CODE", CommonUtil.nvl(_result.get("ORIGIN_CODE")));
						formData.put("ORIGIN_NAME", CommonUtil.nvl(_result.get("ORIGIN_NAME")));
						formData.put("CMS_CATEG_ID", CommonUtil.nvl(_result.get("CMS_CATEG_ID")));
						formData.put("ITEM_DETAIL_DESC", CommonUtil.nvl(_result.get("ITEM_DETAIL_DESC")));
						formData.put("DESCRIPTION_ENG", CommonUtil.nvl(_result.get("DESCRIPTION_ENG")));
						formData.put("SPECIFICATION_ENG", CommonUtil.nvl(_result.get("SPECIFICATION_ENG")));
						formData.put("IMGFILE_DIR", CommonUtil.nvl(_result.get("IMGFILE_DIR")));
						formData.put("IMGFILE_NAME", CommonUtil.nvl(_result.get("IMGFILE_NAME")));
						formData.put("ATTB1_NM", CommonUtil.nvl(_result.get("ATTB1_NM")));
						formData.put("ATTB2_NM", CommonUtil.nvl(_result.get("ATTB2_NM")));
						formData.put("ATTB3_NM", CommonUtil.nvl(_result.get("ATTB3_NM")));
						formData.put("ATTB4_NM", CommonUtil.nvl(_result.get("ATTB4_NM")));
						formData.put("ATTB5_NM", CommonUtil.nvl(_result.get("ATTB5_NM")));
						formData.put("ATTB6_NM", CommonUtil.nvl(_result.get("ATTB6_NM")));
						formData.put("ATTB7_NM", CommonUtil.nvl(_result.get("ATTB7_NM")));
						formData.put("ATTB8_NM", CommonUtil.nvl(_result.get("ATTB8_NM")));
						formData.put("ATTB9_NM", CommonUtil.nvl(_result.get("ATTB9_NM")));
						formData.put("ATTB10_NM", CommonUtil.nvl(_result.get("ATTB10_NM")));
						formData.put("ATTB11_NM", CommonUtil.nvl(_result.get("ATTB11_NM")));
						formData.put("ATTB12_NM", CommonUtil.nvl(_result.get("ATTB12_NM")));
						formData.put("ATTB13_NM", CommonUtil.nvl(_result.get("ATTB13_NM")));
						formData.put("ATTB14_NM", CommonUtil.nvl(_result.get("ATTB14_NM")));
						formData.put("ATTB15_NM", CommonUtil.nvl(_result.get("ATTB15_NM")));
						formData.put("ATTB16_NM", CommonUtil.nvl(_result.get("ATTB16_NM")));
						formData.put("ATTB17_NM", CommonUtil.nvl(_result.get("ATTB17_NM")));
						formData.put("ATTB18_NM", CommonUtil.nvl(_result.get("ATTB18_NM")));
						formData.put("ATTB19_NM", CommonUtil.nvl(_result.get("ATTB19_NM")));
						formData.put("ATTB20_NM", CommonUtil.nvl(_result.get("ATTB20_NM")));
						formData.put("SG_ID", CommonUtil.nvl(_result.get("SG_ID")));
						formData.put("MAKER_PART_NO", CommonUtil.nvl(_result.get("MAKER_PART_NO")));
						sqlSessionTemplate.update("master.mprq.updateMasterMpRqDbCleansingCopy_DSP", formData);
					}
				}
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패하였습니다.");
		}
		return _rtnMsg;
	}

}
