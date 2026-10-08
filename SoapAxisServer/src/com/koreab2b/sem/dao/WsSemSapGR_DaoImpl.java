package com.koreab2b.sem.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.sem.vo.GdRcptVO;
import com.koreab2b.sem.vo.ReturnVO;
import com.koreab2b.util.CommonUtil;

public class WsSemSapGR_DaoImpl implements WsSemSapGR_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public WsSemSapGR_DaoImpl(String gubun) {
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
	public ReturnVO gdRcptSnd(GdRcptVO[] gdRcptVO) throws Exception {
		
		ReturnVO rtn	= new ReturnVO();
		
		try {
			sqlMapper.startTransaction();
			
			Map<String, String> pMap	= null;
			
			for( int i = 0 ; i < gdRcptVO.length ; i++) {
				pMap	= new HashMap<String, String>();
				
				pMap.put("LOEKZ", gdRcptVO[i].getLoekz() );
				pMap.put("BUKRS", gdRcptVO[i].getBukrs() );
				pMap.put("DIVISION", gdRcptVO[i].getDivision() );
				pMap.put("ZSECTCD", gdRcptVO[i].getZsectcd() );
				pMap.put("LTEXT", gdRcptVO[i].getLtext() );
				pMap.put("MJAHR", gdRcptVO[i].getMjahr() );
				pMap.put("MBLNR", gdRcptVO[i].getMblnr() );
				pMap.put("ZEILE", gdRcptVO[i].getZeile() );
				pMap.put("EBELN", gdRcptVO[i].getEbeln() );
				pMap.put("EBELP", gdRcptVO[i].getEbelp() );
				pMap.put("MATNR", gdRcptVO[i].getMatnr() );
				pMap.put("MAKTX", gdRcptVO[i].getMaktx() );
				pMap.put("SPEC", gdRcptVO[i].getSpec() );
				pMap.put("MENGE", gdRcptVO[i].getMenge() );
				pMap.put("MEINS", gdRcptVO[i].getMeins() );
				pMap.put("NETPR", gdRcptVO[i].getNetpr() );
				pMap.put("WAERS", gdRcptVO[i].getWaers() );
				pMap.put("DMBTR", gdRcptVO[i].getDmbtr() );
				pMap.put("ZBUDAT", gdRcptVO[i].getZbudat() );
				pMap.put("LFBNR", gdRcptVO[i].getLfbnr() );
				
				sqlMapper.insert("saveGdRcpt", pMap);
			}
			
			sqlMapper.commitTransaction();
			rtn.setResult("S");
		} catch (Exception e) {
			e.printStackTrace();
			rtn.setErr_msg("F");
			rtn.setResult(CommonUtil.printStackTraceToString(e));
		} finally {
			sqlMapper.endTransaction();
		}
		
		return rtn;
	}

}
