package com.buyer.yhkb.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class YhkbPrDownDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public YhkbPrDownDao() {
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
			
			log.debug("Source Info : " + source);
			
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public int DBDispatcher() throws SQLException {
		return (Integer)this.sqlMapper.queryForObject("YhkbPrDown_DBDispatcher");
	}
	public List<Map<String, String>> PRDT_Select() throws SQLException {
		return this.sqlMapper.queryForList("YhkbPrDown_PRDT_Select");
	}
	public String PRHD_Assign() throws SQLException {
		
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMdd");
		Date time = new Date();
		String ntime = dFormat.format(time);
		
		String fData = "";
		
		String TABNAM = String.format("%-10s","EDI_DC40");
		fData = fData+TABNAM;
		String MANDT = String.format("%-3s","400");
		fData = fData+MANDT;
		String DOCNUM = String.format("%-16s"," ");
		fData = fData+DOCNUM;
		String DOCREL = String.format("%-4s"," ");
		fData = fData+DOCREL;
		String STATUS = String.format("%-2s"," ");
		fData = fData+STATUS;
		String DIRECT = String.format("%-1s"," ");
		fData = fData+DIRECT;
		String OUTMOD = String.format("%-1s"," ");
		fData = fData+OUTMOD;
		String EXPRSS = String.format("%-1s"," ");
		fData = fData+EXPRSS;
		String TEST = String.format("%-1s"," ");
		fData = fData+TEST;
		String IDOCTYP = String.format("%-30s","ZPREQCR101");
		fData = fData+IDOCTYP;
		String CIMTYP = String.format("%-30s"," ");
		fData = fData+CIMTYP;
		String MESTYP = String.format("%-30s","ZPREQCR1");
		fData = fData+MESTYP;
		String MESCOD = String.format("%-3s"," ");
		fData = fData+MESCOD;
		String MESFCT = String.format("%-3s"," ");
		fData = fData+MESFCT;
		String STD = String.format("%-1s"," ");
		fData = fData+STD;
		String STDVRS = String.format("%-6s"," ");
		fData = fData+STDVRS;
		String STDMES = String.format("%-6s"," ");
		fData = fData+STDMES;
		String SNDPOR = String.format("%-10s","PP3400GENT");
		fData = fData+SNDPOR;
		String SNDPRT = String.format("%-2s","LS");
		fData = fData+SNDPRT;
		String SNDPFC = String.format("%-2s"," ");
		fData = fData+SNDPFC;
		String SNDPRN = String.format("%-10s","PP3400");
		fData = fData+SNDPRN;
		String SNDSAD = String.format("%-21s"," ");
		fData = fData+SNDSAD;
		String SNDLAD = String.format("%-70s"," ");
		fData = fData+SNDLAD;
		String RCVPOR = String.format("%-10s","SAPPP3");
		fData = fData+RCVPOR;
		String RCVPRT = String.format("%-2s","LS");
		fData = fData+RCVPRT;
		String RCVPFC = String.format("%-2s"," ");
		fData = fData+RCVPFC;
		String RCVPRN = String.format("%-10s","PP3400");
		fData = fData+RCVPRN;
		String RCVSAD = String.format("%-21s"," ");
		fData = fData+RCVSAD;
		String RCVLAD = String.format("%-70s"," ");
		fData = fData+RCVLAD;
		String CREDAT = String.format("%-8s", ntime);
		fData = fData+CREDAT;
		String CRETIM = String.format("%-6s"," ");
		fData = fData+CRETIM;
		String REFINT = String.format("%-14s"," ");
		fData = fData+REFINT;
		String REFGRP = String.format("%-14s"," ");
		fData = fData+REFGRP;
		String REFMES = String.format("%-14s"," ");
		fData = fData+REFMES;
		String ARCKEY = String.format("%-70s"," ");
		fData = fData+ARCKEY;
		String SERIAL = String.format("%-20s"," ");
		fData = fData+SERIAL;
		
		return fData;
	}
	
	public String PRDT_Assign(Map<String, String> iMap) throws SQLException {
		String fData = "";
		
		String PR_SEGNAM = String.format("%-30s","ZE1BPMEREQITEMIMP");
		fData = fData + PR_SEGNAM;
		String PR_MANDT = String.format("%-3s"," ");
		fData = fData + PR_MANDT;
		String PR_DOCNUM = String.format("%-16s"," ");
		fData = fData + PR_DOCNUM;
		String PR_SEGNUM = String.format("%-6s","000001");
		fData = fData + PR_SEGNUM;
		String PR_PSGNUM = String.format("%-6s","000001");
		fData = fData + PR_PSGNUM;
		String PR_HLEVEL = String.format("%-2s","01");
		fData = fData + PR_HLEVEL;
		String PR_KNTTP = String.format("%-1s",iMap.get("ACCOUNT_TYPE"));
		fData = fData + PR_KNTTP;
		String PR_MATNR = String.format("%-18s",iMap.get("ITEM_NO"));
		fData = fData + PR_MATNR;
		String PR_MENGE = String.format("%-15s",iMap.get("ITEM_QTY"));
		fData = fData + PR_MENGE;
		String PR_LFDAT = String.format("%-8s",iMap.get("RD_DATE"));
		fData = fData + PR_LFDAT;
		String PR_WERKS = String.format("%-4s",iMap.get("PLANT"));
		fData = fData + PR_WERKS;
		String PR_WEMPF = String.format("%-12s",iMap.get("USER_ID1"));
		fData = fData + PR_WEMPF;
		String PR_AFNAM = String.format("%-12s",iMap.get("USER_ID2"));
		fData = fData + PR_AFNAM;
		String PR_PREIS = String.format("%-13s",iMap.get("UNIT_PRICE"));
		fData = fData + PR_PREIS;
		String PR_SAKTO = String.format("%-10s",iMap.get("ACCOUNT_CODE"));
		fData = fData + PR_SAKTO;
		String PR_PRCTR = String.format("%-10s",iMap.get("PRCTR"));
		fData = fData + PR_PRCTR;
		String PR_KNDNR = String.format("%-10s",iMap.get("PRSEG"));
		fData = fData + PR_KNDNR;
		String PR_KOSTL = String.format("%-10s",iMap.get("COCTR"));
		fData = fData + PR_KOSTL;
		
		return fData;
	}
	
	public void TRXL_Dequeue(Map<String, String> iMap) throws SQLException {
		this.sqlMapper.update("YhkbPrDown_TRXL_Dequeue", iMap);
	}
	
	/**
	 * 유한킴벌리 승인권자 로그인 이력 추가
	 * @param iMap
	 * @return
	 * @throws Exception
	 */
	public int YhkbConfirmUser_update(Map<String, String> iMap) throws Exception{
		return this.sqlMapper.update("YhkbConfirmUser_update", iMap);
	}
}
