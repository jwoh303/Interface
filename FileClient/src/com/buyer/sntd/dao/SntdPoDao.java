package com.buyer.sntd.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.kep.common.FileUtil;
import com.kep.common.service.FileService;
import com.kep.common.vo.GrdtVo;
import com.kep.common.vo.PodtVo;

import org.apache.commons.collections4.MapUtils;
import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;

@SuppressWarnings("unchecked")
public class SntdPoDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;

	public SntdPoDao() {
		try {	
			String source	= "";
			
			String dbConn = "";	// 2:운영, 0:개발
			String dbType = CommonProperty.getDB_TYPE();	// KEPMP, KEPCON

			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				dbConn = "Live";
			} else {
				dbConn = "Dev";
			}
			
			source = "conf/SqlMapConfig_"+dbType+"_"+dbConn+".xml";
			// EX) conf/SqlMapConfig_KEPMP_Live.xml, conf/SqlMapConfig_KEPCON_Dev.xml
			
			log.debug("Source Info : " + source);
			
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public boolean insertSntdPo (PodtVo vo)  {
		boolean bRtn = false;
		int Err_Flag = 1;
		
		try {
			
			if(vo.getSTATUS() != "D") {
				if(Check001(vo) == -1) {
					vo.setERROR_MSG("발주자 미등록");
					Err_Flag = -1;
				}
			} else if (Check002(vo) == -1){
				vo.setERROR_MSG("발주서없는 삭제입니다. (실행하면 SKIP됩니다.)");
				Err_Flag = -1;
			}
			
			if(Err_Flag == -1) {
				vo.setIF_FLAG("E");
			}else {
				vo.setIF_FLAG("N");
			}
	
			int vCnt = (Integer)this.sqlMapper.queryForObject("selectSntdPOEventCnt", vo);
			if (vCnt == 0) {
				this.sqlMapper.insert("mergeIfPodt", vo);
				bRtn = true;
			} else {
				log.error("Dup : " + vo.getLEGACY_PO_NO() + " / " + vo.getLEGACY_PO_SEQ());
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		}
		return bRtn;
	}
	
	public int Check001(PodtVo vo) {
		try {
			
			Map <String, String> c01Map = (Map<String, String>) this.sqlMapper.queryForObject("selectSntdPOcheck001", vo);
			
			System.out.println("c01Map 111= " + c01Map);
			
			if (MapUtils.isEmpty(c01Map)) {
				if("KRSNTD0001".equals(vo.getBUYER())) {
					vo.setPURCHASER_USER_ID("KIMOJ");
				}else {
					vo.setPURCHASER_USER_ID("00718143X");
				}
				c01Map = (Map<String, String>) this.sqlMapper.queryForObject("selectSntdPOcheck001", vo);
				if(MapUtils.isEmpty(c01Map)) {
					return -1;
				}else {
					return 1;
				}
			} else {
				vo.setPURCHASER_USER_ID(c01Map.get("USER_ID"));
				vo.setPURCHASER_USER_DEPT(c01Map.get("DEPARTMENT"));
				return 1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
			return -1;
		}
		
	}
	public int Check002(PodtVo vo) {
		
		try {
			int vCnt = (Integer)this.sqlMapper.queryForObject("selectSntdPOcheck002", vo);
			
			if(vCnt == 1) {
				return 1;
			}else {
				return -1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		}
		return 1;
	}
	
	public void logWrite(Map<String, String> pMap) throws SQLException {

		List<Map<String, String>> chkSumInfo = null;
		int TOT_CNT = 0;
		int ERR_CNT = 0;
		int DEL_CNT = 0;
		
		chkSumInfo = this.sqlMapper.queryForList("selectPoCheck", pMap);
		
		Map<String, String> iMap = chkSumInfo.get(0);
		TOT_CNT = Integer.parseInt(iMap.get("TOT_CNT"));
		ERR_CNT = Integer.parseInt(iMap.get("ERR_CNT"));
		DEL_CNT = Integer.parseInt(iMap.get("DEL_CNT"));
		if (TOT_CNT == DEL_CNT) pMap.put("STATUS", "D");
		else pMap.put("STATUS", "C");
		
		pMap.put("REMARK", pMap.get("FILE_NAME"));
		if ( pMap.get("IF_CHK_FLAG").equals("E") || TOT_CNT == 0 ) {
			pMap.put("IF_FLAG", "A");
			pMap.put("ERR_MSG", "I/F파일 오류입니다(전산실문의)!!!");
		} else {
			if (ERR_CNT == 0) {
				pMap.put("IF_FLAG", "Z");
				pMap.put("ERR_MSG", "작업중입니다!!!");
			} else {
				pMap.put("IF_FLAG", "A");
				pMap.put("ERR_MSG", "데이타에 오류가 있습니다!!!");
			}
		}
		try {
			this.sqlMapper.update("mergeIfProgress", pMap);
			this.sqlMapper.update("updateIfAdmin", pMap);
		}catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		}
	}
}