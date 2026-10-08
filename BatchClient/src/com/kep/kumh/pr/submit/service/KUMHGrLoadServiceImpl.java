package com.kep.kumh.pr.submit.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonProperty;
import com.kep.kumh.pr.submit.dao.GrLoadDao;
import com.kep.kumh.pr.submit.dao.GrLoadDaoImpl;
import com.kkpc.KEP_MM_002.KEP_MM_002_DT_req_SOAP;
import com.kkpc.KEP_MM_002.KEP_MM_002_DT_res_SOAPROW;
import com.kkpc.KEP_MM_002.KEP_MM_002_SOProxy;

public class KUMHGrLoadServiceImpl implements KUMHGrLoadService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	@Override
	public void execute(String Budat){
		
		GrLoadDao dao = new GrLoadDaoImpl();
		Map<String, String> arrMap = new HashMap<String, String>();

		try {
			//플랜트조회
			List<Map<String,String>> plantMap = dao.selectPlantList();
			if (plantMap != null && plantMap.size() > 0) {
				for (int i = 0; i < plantMap.size(); i++) {
					KEP_MM_002_DT_req_SOAP grLoadList = new KEP_MM_002_DT_req_SOAP();
					grLoadList.setWERKS(plantMap.get(i).get("PLANT")); 			//플랜트
					grLoadList.setBUDAT(Budat); 								//입고일
					
					KEP_MM_002_SOProxy proxy = new KEP_MM_002_SOProxy(CommonProperty.getMM002_HTTP_url());
					KEP_MM_002_DT_res_SOAPROW[] arr = proxy.KEP_MM_002_SO(grLoadList);
					
					if (arr.length > 0 ) {
						for ( int k = 0 ; k < arr.length ; k++) {
							arrMap.clear();
							arrMap.put("MBLNR", arr[k].getMBLNR());				// SAP 자재문서 번호
							arrMap.put("POSNR", arr[k].getPOSNR());				// SAP 자재문서 항번
							arrMap.put("XSTAT", arr[k].getXSTAT());				// 입고 상태
							arrMap.put("WERKS", arr[k].getWERKS());				// 플랜트
							arrMap.put("EBELN", arr[k].getEBELN());				// 구매오더번호
							arrMap.put("EBELP", arr[k].getEBELP());				// 구매오더 품목 번호
							arrMap.put("MATNR", arr[k].getMATNR()); 			// 자재코드
							arrMap.put("UNIT_PRICE", arr[k].getUNIT_PRICE());	// 단가
							arrMap.put("MENGE",arr[k].getMENGE());				// 수량
							arrMap.put("GR_AMT",arr[k].getGR_AMT());			// 입고금액
							arrMap.put("BUDAT",arr[k].getBUDAT());				// 입고일(전기일)
							   
					        dao.insertKumhGr(arrMap);
					        log.info("arrMap !!!!!" + arrMap);   
						}	
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.info("KUMHGrLoadServiceImpl ERR::: " + e.getMessage());
		}
	}

}
