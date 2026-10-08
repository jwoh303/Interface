package com.koreab2b.sem.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.sem.vo.ItmMapInfoVO;
import com.koreab2b.sem.vo.NewItmReqVO;
import com.koreab2b.sem.vo.RequotReqVO;
import com.koreab2b.sem.vo.ReturnVO;
import com.koreab2b.util.CommonUtil;

public class WsSemMroMall_DaoImpl implements WsSemMroMall_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public WsSemMroMall_DaoImpl(String gubun) {
		try {
			
			Reader reader = null;
			if(gubun.equals("KR")){
				reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			}else if(gubun.equals("CN")){
				reader = Resources.getResourceAsReader("conf/SqlMapConfig_KEPCON.xml");
			}
			
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public ReturnVO newItmReq(NewItmReqVO[] newItmReqVO) throws Exception {
		
		ReturnVO rtn	= new ReturnVO();
		
		try {
			sqlMapper.startTransaction();
			
			for(int i = 0 ; i < newItmReqVO.length ; i++) {
				
				Map<String, String> pMap	= new HashMap<String, String>();
				
				pMap.put("REQ_ID", newItmReqVO[i].getReq_id() );
				pMap.put("VND_ID", newItmReqVO[i].getVnd_id() );
				pMap.put("COMP_ITEM_ID", newItmReqVO[i].getComp_item_id() );
				pMap.put("ITEM_NM", newItmReqVO[i].getItem_nm() );
				pMap.put("STD", newItmReqVO[i].getStd() );
				pMap.put("MAKER", newItmReqVO[i].getMaker() );
				pMap.put("MODEL_NM", newItmReqVO[i].getModel_nm() );
				pMap.put("PC_UNIT", newItmReqVO[i].getPc_unit() );
				pMap.put("PC_PLAN_QUT", Integer.toString(newItmReqVO[i].getPc_plan_qut()) );
				pMap.put("REF_URL", newItmReqVO[i].getRef_url() );
				pMap.put("REQUESTER_ID", newItmReqVO[i].getRequester_id() );
				pMap.put("REQUESTER", newItmReqVO[i].getRequester() );
				pMap.put("REQUESTER_PHONE", newItmReqVO[i].getRequester_phone() );
				pMap.put("REQUESTER_MAIL", newItmReqVO[i].getRequester_mail() );
				pMap.put("REQ_COMP", newItmReqVO[i].getReq_comp() );
				pMap.put("REQ_SYSTEM", newItmReqVO[i].getReq_system() );
				pMap.put("PROD_NO", newItmReqVO[i].getProd_no() );
				pMap.put("PROD_NM", newItmReqVO[i].getProd_nm() );
				pMap.put("U_CODE", newItmReqVO[i].getU_code() );
				pMap.put("P_CODE", newItmReqVO[i].getP_code() );
				pMap.put("ID_SEQ", newItmReqVO[i].getId_seq() );
				pMap.put("INVEST_FLAG", newItmReqVO[i].getInvest_flag() );
				pMap.put("GAJASAN_CODE", newItmReqVO[i].getGajasan_code() );
				pMap.put("KYUNGBI_CODE", newItmReqVO[i].getKyungbi_code() );
				pMap.put("STATUS", newItmReqVO[i].getStatus() );
				pMap.put("ORDER_STEP", Integer.toString(newItmReqVO[i].getOrder_step()) );
				pMap.put("MDM_CODE", newItmReqVO[i].getMdm_code() );
				pMap.put("DESIGN_EMP_NO", newItmReqVO[i].getDesign_emp_no() );
				pMap.put("DESIGN_EMP_NM", newItmReqVO[i].getDesign_emp_nm() );
				pMap.put("REQUEST_MEMO", newItmReqVO[i].getRequest_memo() );
				pMap.put("GUBUN", newItmReqVO[i].getGubun() );
				pMap.put("PARTS_TYPE", newItmReqVO[i].getParts_type() );
				pMap.put("ORDER_SIDE", newItmReqVO[i].getOrder_side() );
				pMap.put("ORDER_DATE", newItmReqVO[i].getOrder_date() );
				pMap.put("SAP_SEND_DATE", newItmReqVO[i].getSap_send_date() );
				pMap.put("COMPLETE_FLAG", newItmReqVO[i].getComplete_flag() );
				pMap.put("URGENT_FLAG", newItmReqVO[i].getUrgent_flag() );
				pMap.put("MATR_NM", newItmReqVO[i].getMatr_nm() );
				pMap.put("SPEC", newItmReqVO[i].getSpec() );
				pMap.put("MATR_QUALITY_NM", newItmReqVO[i].getMatr_quality_nm() );
				pMap.put("SURFACE_TREATMENT", newItmReqVO[i].getSurface_treatment() );
				pMap.put("HEAT_TREATMENT", newItmReqVO[i].getHeat_treatment() );
				pMap.put("MAKER_CODE", newItmReqVO[i].getMaker_code() );
				pMap.put("MAKER_NAME", newItmReqVO[i].getMaker_name() );
				pMap.put("REMARK", newItmReqVO[i].getRemark() );
				pMap.put("ORDER_COUNT", Integer.toString(newItmReqVO[i].getOrder_count()) );
				pMap.put("UNIT_CODE", newItmReqVO[i].getUnit_code() );
				pMap.put("WISH_LEAD_TIME", newItmReqVO[i].getWish_lead_time() );
				pMap.put("SP_NAME", newItmReqVO[i].getSp_name() );
				pMap.put("AGCY_ORDER_DATE", newItmReqVO[i].getAgcy_order_date() );
				pMap.put("POSTAL", newItmReqVO[i].getPostal() );
				pMap.put("DELIVERY", newItmReqVO[i].getDelivery() );
				pMap.put("QUALITY_LEVEL", newItmReqVO[i].getQuality_level() );
				pMap.put("TMP1", newItmReqVO[i].getTmp1() );
				pMap.put("TMP2", newItmReqVO[i].getTmp2() );
				pMap.put("TMP3", newItmReqVO[i].getTmp3() );
				pMap.put("TMP4", newItmReqVO[i].getTmp4() );
				pMap.put("TMP5", newItmReqVO[i].getTmp5() );
				pMap.put("TMP6", newItmReqVO[i].getTmp6() );
				pMap.put("TMP7", newItmReqVO[i].getTmp7() );
				pMap.put("TMP8", newItmReqVO[i].getTmp8() );
				pMap.put("TMP9", newItmReqVO[i].getTmp9() );
				pMap.put("TMP10", newItmReqVO[i].getTmp10() );
				
				sqlMapper.insert("saveNewItmReq", pMap);
			}
			
			sqlMapper.commitTransaction();
			rtn.setResult("S");
		} catch (Exception e) {
			e.printStackTrace();
			rtn.setResult("E");
			rtn.setErr_msg(CommonUtil.printStackTraceToString(e));
		} finally {
			sqlMapper.endTransaction();
		}
		return rtn;
	}

	@Override
	public ReturnVO requotReq(RequotReqVO[] requotReqVO) throws Exception {
		ReturnVO rtn = new ReturnVO();
		
		try {
			sqlMapper.startTransaction();
			
			for ( int i = 0 ; i < requotReqVO.length ; i++) {
				Map<String, String> pMap = new HashMap<String, String>();
				
				pMap.put("RE_QT_REQ_ID", requotReqVO[i].getRe_qt_req_id() );
				pMap.put("VND_ID", requotReqVO[i].getVnd_id() );
				pMap.put("COMP_ITEM_ID", requotReqVO[i].getComp_item_id() );
				pMap.put("REQUESTER_ID", requotReqVO[i].getRequester_id() );
				pMap.put("REQUESTER", requotReqVO[i].getRequester() );
				pMap.put("REQUESTER_PHONE", requotReqVO[i].getRequester_phone() );
				pMap.put("REQUESTER_MAIL", requotReqVO[i].getRequester_mail() );
				pMap.put("REQ_SYSTEM", requotReqVO[i].getReq_system() );
				pMap.put("PROD_NO", requotReqVO[i].getProd_no() );
				pMap.put("PROD_NM", requotReqVO[i].getProd_nm() );
				pMap.put("U_CODE", requotReqVO[i].getU_code());
				pMap.put("P_CODE", requotReqVO[i].getP_code() );
				pMap.put("ID_SEQ", requotReqVO[i].getId_seq() );
				pMap.put("INVEST_FLAG", requotReqVO[i].getInvest_flag() );
				pMap.put("GAJASAN_CODE", requotReqVO[i].getGajasan_code() );
				pMap.put("KYUNGBI_CODE", requotReqVO[i].getKyungbi_code() );
				pMap.put("STATUS", requotReqVO[i].getStatus() );
				pMap.put("ORDER_STEP", Integer.toString(requotReqVO[i].getOrder_step()) );
				pMap.put("MDM_CODE", requotReqVO[i].getMdm_code() );
				pMap.put("DESIGN_EMP_NO", requotReqVO[i].getDesign_emp_no() );
				pMap.put("DESIGN_EMP_NM", requotReqVO[i].getDesign_emp_nm() );
				pMap.put("REQUEST_MEMO", requotReqVO[i].getRequest_memo() );
				pMap.put("GUBUN", requotReqVO[i].getGubun() );
				pMap.put("PARTS_TYPE", requotReqVO[i].getParts_type() );
				pMap.put("ORDER_SIDE", requotReqVO[i].getOrder_side() );
				pMap.put("ORDER_DATE", requotReqVO[i].getOrder_date() );
				pMap.put("SAP_SEND_DATE", requotReqVO[i].getSap_send_date() );
				pMap.put("COMPLETE_FLAG", requotReqVO[i].getComplete_flag() );
				pMap.put("URGENT_FLAG", requotReqVO[i].getUrgent_flag() );
				pMap.put("MATR_NM", requotReqVO[i].getMatr_nm() );
				pMap.put("SPEC", requotReqVO[i].getSpec() );
				pMap.put("MATR_QUALITY_NM", requotReqVO[i].getMatr_quality_nm() );
				pMap.put("SURFACE_TREATMENT", requotReqVO[i].getSurface_treatment() );
				pMap.put("HEAT_TREATMENT", requotReqVO[i].getHeat_treatment() );
				pMap.put("MAKER_CODE", requotReqVO[i].getMaker_code() );
				pMap.put("MAKER_NAME", requotReqVO[i].getMaker_name() );
				pMap.put("REMARK", requotReqVO[i].getRemark() );
				pMap.put("ORDER_COUNT", Integer.toString(requotReqVO[i].getOrder_count()) );
				pMap.put("UNIT_CODE", requotReqVO[i].getUnit_code() );
				pMap.put("WISH_LEAD_TIME", requotReqVO[i].getWish_lead_time() );
				pMap.put("SP_NAME", requotReqVO[i].getSp_name() );
				pMap.put("AGCY_ORDER_DATE", requotReqVO[i].getAgcy_order_date() );
				pMap.put("POSTAL", requotReqVO[i].getPostal() );
				pMap.put("DELIVERY", requotReqVO[i].getDelivery() );
				pMap.put("QUALITY_LEVEL", requotReqVO[i].getQuality_level() );
				pMap.put("TMP1", requotReqVO[i].getTmp1() );
				pMap.put("TMP2", requotReqVO[i].getTmp2() );
				pMap.put("TMP3", requotReqVO[i].getTmp3() );
				pMap.put("TMP4", requotReqVO[i].getTmp4() );
				pMap.put("TMP5", requotReqVO[i].getTmp5() );
				pMap.put("TMP6", requotReqVO[i].getTmp6() );
				pMap.put("TMP7", requotReqVO[i].getTmp7() );
				pMap.put("TMP8", requotReqVO[i].getTmp8() );
				pMap.put("TMP9", requotReqVO[i].getTmp9() );
				pMap.put("TMP10", requotReqVO[i].getTmp10() );
				
				sqlMapper.insert("saveRequotReq", pMap);
			}
			
			sqlMapper.commitTransaction();
			rtn.setResult("S");
		} catch (Exception e) {
			e.printStackTrace();
			rtn.setResult("E");
			rtn.setErr_msg(CommonUtil.printStackTraceToString(e));
		} finally {
			sqlMapper.endTransaction();
		}
		return rtn;
	}

	@Override
	public ReturnVO itmMapInfoReg(ItmMapInfoVO[] itmMapInfoVO) throws Exception {
		ReturnVO rtn = new ReturnVO();
		try {
			sqlMapper.startTransaction();
			
			for ( int i = 0 ; i < itmMapInfoVO.length ; i++) {
				Map<String, String> pMap = new HashMap<String, String>();
				
				pMap.put("REQ_ID", itmMapInfoVO[i].getReq_id() );
				pMap.put("VND_ID", itmMapInfoVO[i].getVnd_id() );
				pMap.put("COMP_ITEM_ID", itmMapInfoVO[i].getComp_item_id() );
				pMap.put("MRO_ID", itmMapInfoVO[i].getMro_id() );
				pMap.put("ITEM_NM", itmMapInfoVO[i].getItem_nm() );
				pMap.put("ITEM_NM_EN", itmMapInfoVO[i].getItem_nm_en() );
				pMap.put("ITEM_NM_CN", itmMapInfoVO[i].getItem_nm_cn() );
				pMap.put("STD", itmMapInfoVO[i].getStd() );
				pMap.put("STD_EN", itmMapInfoVO[i].getStd_en() );
				pMap.put("STD_CN", itmMapInfoVO[i].getStd_cn() );
				pMap.put("MAKER", itmMapInfoVO[i].getMaker() );
				pMap.put("MODEL_NM", itmMapInfoVO[i].getModel_nm() );
				
				sqlMapper.insert("saveItmMapInfo", pMap);
			}
			
			sqlMapper.commitTransaction();
			rtn.setResult("S");
		} catch (Exception e) {
			e.printStackTrace();
			rtn.setResult("E");
			rtn.setErr_msg(CommonUtil.printStackTraceToString(e));
		} finally {
			sqlMapper.endTransaction();
		}
		return rtn;
	}

}
