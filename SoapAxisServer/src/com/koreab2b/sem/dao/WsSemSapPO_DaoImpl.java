package com.koreab2b.sem.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.sem.vo.PcsOrdrDtlVO;
import com.koreab2b.sem.vo.PcsOrdrMasVO;
import com.koreab2b.sem.vo.ReturnVO;

public class WsSemSapPO_DaoImpl implements WsSemSapPO_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public WsSemSapPO_DaoImpl(String gubun) {
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
	public void pcsOrdrSnd(PcsOrdrMasVO pcsOrdrMasVO,
			PcsOrdrDtlVO[] pcsOrdrDtlVO) throws Exception {
		
		try {
			
			sqlMapper.startTransaction();
			Map<String, String> pMap	= null;
			
			for ( int i = 0 ; i < pcsOrdrDtlVO.length ; i++ ) {
				pMap	= new HashMap<String, String>();
				
				pMap.put("EBELN", pcsOrdrMasVO.getEbeln() );
				pMap.put("EBELP", pcsOrdrDtlVO[i].getEbelp() );
				pMap.put("LOEKZ_ITEM", pcsOrdrDtlVO[i].getLoekz_item() );
				pMap.put("MATNR", pcsOrdrDtlVO[i].getMatnr() );
				pMap.put("TXZ01", pcsOrdrDtlVO[i].getTxz01() );
				pMap.put("SPEC", pcsOrdrDtlVO[i].getSpec() );
				pMap.put("MENGE", pcsOrdrDtlVO[i].getMenge() );
				pMap.put("MEINS", pcsOrdrDtlVO[i].getMeins() );
				pMap.put("NETPR", pcsOrdrDtlVO[i].getNetpr() );
				pMap.put("WAERS", pcsOrdrDtlVO[i].getWaers() );
				pMap.put("AMT", pcsOrdrDtlVO[i].getAmt() );
				pMap.put("EINDT", pcsOrdrDtlVO[i].getEindt() );
				pMap.put("POSTAL", pcsOrdrDtlVO[i].getPostal() );
				pMap.put("ADDRESS1", pcsOrdrDtlVO[i].getAddress1() );
				pMap.put("ADDRESS2", pcsOrdrDtlVO[i].getAddress2() );
				pMap.put("PO_DATE", pcsOrdrDtlVO[i].getPo_date() );
				pMap.put("PO_TIME", pcsOrdrDtlVO[i].getPo_time() );
				pMap.put("ORDER_FLAG", pcsOrdrDtlVO[i].getOrder_flag() );
				pMap.put("GR_ID", pcsOrdrDtlVO[i].getGr_id() );
				pMap.put("GR_NAME", pcsOrdrDtlVO[i].getGr_name() );
				pMap.put("GR_TELNO", pcsOrdrDtlVO[i].getGr_telno() );
				pMap.put("GR_HPNO", pcsOrdrDtlVO[i].getGr_hpno() );
				pMap.put("G_CODE", pcsOrdrDtlVO[i].getG_code() );
				pMap.put("G_NAME", pcsOrdrDtlVO[i].getG_name() );
				pMap.put("U_CODE", pcsOrdrDtlVO[i].getU_code() );
				pMap.put("P_CODE", pcsOrdrDtlVO[i].getP_code() );
				pMap.put("ID", pcsOrdrDtlVO[i].getId() );
				pMap.put("ORDER_STEP", pcsOrdrDtlVO[i].getOrder_step() );
				pMap.put("GUBUN", pcsOrdrDtlVO[i].getGubun() );
				pMap.put("BUKRS", pcsOrdrMasVO.getBukrs() );
				pMap.put("PEINH", pcsOrdrDtlVO[i].getPeinh() );
				pMap.put("QUALITY_CLASS", pcsOrdrDtlVO[i].getQuality_class() );
				
				sqlMapper.insert("savePcsOrdrDtl", pMap);
			}
			
			pMap	= new HashMap<String, String>();
			
			pMap.put("LOEKZ", pcsOrdrMasVO.getLoekz() );
			pMap.put("REQ_SYSTEM", pcsOrdrMasVO.getReq_system() );
			pMap.put("BUKRS", pcsOrdrMasVO.getBukrs() );
			pMap.put("WERKS", pcsOrdrMasVO.getWerks() );
			pMap.put("GSBER", pcsOrdrMasVO.getGsber() );
			pMap.put("KOSTL", pcsOrdrMasVO.getKostl() );
			pMap.put("LTEXT", pcsOrdrMasVO.getLtext() );
			pMap.put("EBELN", pcsOrdrMasVO.getEbeln() );
			pMap.put("BEDAT", pcsOrdrMasVO.getBedat() );
			pMap.put("ERNAM", pcsOrdrMasVO.getErnam() );
			pMap.put("ERNAM_NM", pcsOrdrMasVO.getErnam_nm() );
			pMap.put("ERNAM_TEL", pcsOrdrMasVO.getErnam_tel() );
			pMap.put("PURCHASER_NAME", pcsOrdrMasVO.getPurchaser_name() );
			pMap.put("PURCHASER_TEL", pcsOrdrMasVO.getPurchaser_tel() );
			
			sqlMapper.insert("savePcsOrdrMas", pMap);
			
			sqlMapper.commitTransaction();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sqlMapper.endTransaction();
		}
	}

}
