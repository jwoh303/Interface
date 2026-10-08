package com.koreab2b.xica.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.xica.vo.xicaAppStatusVO;
import com.koreab2b.xica.vo.xicaReturnVO;

public class WsXicaSetAppStatus_DaoImpl implements WsXicaSetAppStatus_Dao {

	private Logger log	= Logger.getLogger(this.getClass().getName());
	private SqlMapClient sqlMapper;

	public WsXicaSetAppStatus_DaoImpl() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig_KEPCON.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public SqlMapClient getSqlMapClient() {
		return this.sqlMapper;
	}
	
	@Override
	public xicaReturnVO saveAppstatus(xicaAppStatusVO aprList) throws Exception {
		xicaReturnVO ret = new xicaReturnVO();
		
		try {
			this.sqlMapper.startTransaction();
			Map<String, String> pMap = new HashMap<String, String>();
			
			pMap.put("AppNo", aprList.getAppvTpNum());  //결재번호
			pMap.put("AppStatus", aprList.getProgSt());     //문서결재상태   2	결재요청,3	결재처리중,5반려완료,6결재완료,8상신취소
			  
			sqlMapper.insert("saveXicaAppStatus", pMap);
			log.info("pMap" + pMap);
			
			for (int i = 0; i < aprList.getAppDetail().size(); i++) {
				Map<String, String> pMap2	= new HashMap<String, String>();
				
				pMap2.put("AppNo", aprList.getAppvTpNum());
				pMap2.put("AppSeqField", aprList.getAppDetail().get(i).getAppSeqField());
				pMap2.put("AppvId",aprList.getAppDetail().get(i).getAppvId());
				pMap2.put("AppUserIDField",aprList.getAppDetail().get(i).getAppUserIDField());
				pMap2.put("AppvNm",aprList.getAppDetail().get(i).getAppvNm());
				pMap2.put("AppOrgIDField",aprList.getAppDetail().get(i).getAppOrgIDField());
				pMap2.put("AppvPostnNm",aprList.getAppDetail().get(i).getAppvPostnNm());
				pMap2.put("AppDutyNmField",aprList.getAppDetail().get(i).getAppDutyNmField());
				pMap2.put("AppvSt",aprList.getAppDetail().get(i).getAppvSt());
				pMap2.put("AppvCmmt",aprList.getAppDetail().get(i).getAppvCmmt());
				
				sqlMapper.insert("saveXicaAppLine", pMap2);
				log.info("pMap2" + pMap2);
			}
			ret.setResultSt("Y");
			
			this.sqlMapper.commitTransaction();
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			ret.setResultSt("F");
			ret.setErrMsg("데이터 오류");
		} finally {
			this.sqlMapper.endTransaction();
		}
		
		return ret;
	}

}
