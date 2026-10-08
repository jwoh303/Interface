package com.kep.hwDefense.gr.submit.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S;
import com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SIFSTAT;
import com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SO;
import com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SOProxy;
import com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SPAGING;
import com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_ST_GR_INFO;
import com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_R;
import com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RIFSTAT;
import com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RT_GR_RETURN;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.common.dao.UpdateIfStatus_Dao;
import com.kep.common.dao.UpdateIfStatus_DaoImpl;
import com.kep.hwDefense.gr.submit.dao.GrSubmitDao;
import com.kep.hwDefense.gr.submit.dao.GrSubmitDaoImpl;

public class HWDFGrSubmitServiceImpl implements HWDFGrSubmitService {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	@Override
	public void execute() {
		/**
		 * 입고 데이터 확인	
		 * 데이터 세팅
		 * 호출 및 처리 결과 저장 
		 */
		
		GrSubmitDao dao	= new GrSubmitDaoImpl();

		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName());
		
		try {
			// 시작시점
			Date sTime = new Date();
			bMap.put("JOB_SDATE", dFormat.format(sTime));
			
			List<Map<String, String>> grList	= dao.selectHwDefenseGrList();

			// 데이터 건수 
			bMap.put("JOB_CNT", Integer.toString( grList.size() ));
			
			if (grList.size() > 0) {
				
				int size	= grList.size();
				NE9090_KEPEH_SRMDH_ST_GR_INFO[] grSubmitList = new NE9090_KEPEH_SRMDH_ST_GR_INFO[size];
				
				for( int i = 0 ; i < size ; i++ ) {
					grSubmitList[i] = new NE9090_KEPEH_SRMDH_ST_GR_INFO(
											"506",								//java.lang.String companyCode,	506 : 한화디펜스
											grList.get(i).get("GR_NO"),			//java.lang.String grNo,
											grList.get(i).get("GR_SEQ"),		//java.lang.String grSeq,
											grList.get(i).get("STATUS"),		//java.lang.String status,
											grList.get(i).get("ITEM_NO"),		//java.lang.String itemNo,
											grList.get(i).get("DESCRIPTION"),	//java.lang.String desc,
											grList.get(i).get("SPECIFICATION"),	//java.lang.String spec,
											grList.get(i).get("PO_NO"),			//java.lang.String poNo,
											grList.get(i).get("PO_SEQ"),		//java.lang.String poSeq,
											grList.get(i).get("ACCOUNT"),		//java.lang.String account,
											grList.get(i).get("GR_QTY"),		//java.lang.String qty,
											grList.get(i).get("UNIT_MEASURE"),	//java.lang.String unit,
											grList.get(i).get("UNIT_PRICE"),	//java.lang.String unitPrice,
											grList.get(i).get("UNIT_PRICE"),	//java.lang.String grPrice,
											grList.get(i).get("CUR"),			//java.lang.String currency,
											grList.get(i).get("DOC_YEAR"),		//java.lang.String docYear,
											grList.get(i).get("GR_DATE"),		//java.lang.String grDate,
											grList.get(i).get("WORKAREA"),		//java.lang.String workArea,
											grList.get(i).get("DIV_CODE"),		//java.lang.String divCode,
											grList.get(i).get("GR_DEPT"),		//java.lang.String grDept,
											grList.get(i).get("GR_DATE"),		//java.lang.String originGrNo,
											grList.get(i).get("GR_TIME"),		//java.lang.String grTime,
											grList.get(i).get("GR_EMP_NO"),		//java.lang.String grEmpNo,
											grList.get(i).get("GR_EMP_NM"),		//java.lang.String grEmpNm,
											grList.get(i).get("GR_DEPT_DESC"),	//java.lang.String grDeptDesc,
											grList.get(i).get("ITEM_NO"),		//java.lang.String mtrlNo,
											grList.get(i).get("PLANT"),			//java.lang.String plnt
											grList.get(i).get("ITEM_GB")		//itmGb
										);
					log.info("grSubmitList["+i+"]:" + grSubmitList[i].getDesc().toString());
				}
				
				NE9090_KEPEH_SRMDH_SIFSTAT SIFSTAT  = new NE9090_KEPEH_SRMDH_SIFSTAT(
						null,
						null,
						null,
						null,
						null,
						null,
						null
				);
				
				
				NE9090_KEPEH_SRMDH_S sResult = new NE9090_KEPEH_SRMDH_S(
						SIFSTAT,
						grSubmitList
				);
				
				NE9090_KEPEH_SRMDH_SOProxy proxy = new NE9090_KEPEH_SRMDH_SOProxy("https://srm.hanwhaaerospace.co.kr:2555/XISOAPAdapter/MessageServlet?senderParty=&senderService=BS_KEPEH_P&receiverParty=&receiverService=&interface=NE9090_KEPEH_SRMDH_SO&interfaceNamespace=http%3A%2F%2Fhanwhaaerospace.com%2FKEPEH_SRMDH");
				NE9090_KEPEH_SRMDH_S_R rtn = proxy.NE9090_KEPEH_SRMDH_SO(sResult);
				NE9090_KEPEH_SRMDH_S_RT_GR_RETURN[] rtnArr = rtn.getT_GR_RETURN();

				List<Map<String, Object>> grResultList	= new ArrayList<Map<String, Object>>();
				
				for(NE9090_KEPEH_SRMDH_S_RT_GR_RETURN iObj : rtnArr) {
					Map<String, Object> iMap	= CommonUtil.convertVoToMap(iObj, "T02");
					grResultList.add(iMap);
				}
				dao.updateResultGrSubmit(grResultList);
			}
			
		} catch (Exception e) {
			log.error("GrSubmitService Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			// 종료시점
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
		}
	}
}

