package com.kep.monthclosing.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.kep.common.dao.UpdateIfStatus_Dao;
import com.kep.common.dao.UpdateIfStatus_DaoImpl;
import com.kep.monthclosing.dao.MonthClosingDao;

public class MonthClosingService {
	
	private MonthClosingDao dao = new MonthClosingDao();

	public void arCreate() {
		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName() + ".arCreate()" );
		// 시작시점
		Date sTime = new Date();
		bMap.put("JOB_SDATE", dFormat.format(sTime));
		// 데이터 건수 
		bMap.put("JOB_CNT", "0");
		
		dao.arCreateKepmp();
		dao.arCreateKepcon();
		// 종료시점
		Date eTime = new Date();
		bMap.put("JOB_EDATE", dFormat.format(eTime));
		if_dao.insertMroJobDate(bMap);
	}

	public void apCreate() {
		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName() + ".apCreate()" );
		// 시작시점
		Date sTime = new Date();
		bMap.put("JOB_SDATE", dFormat.format(sTime));
		// 데이터 건수 
		bMap.put("JOB_CNT", "0");
		dao.apCreateKepmp();
		dao.apCreateKepcon();
		// 종료시점
		Date eTime = new Date();
		bMap.put("JOB_EDATE", dFormat.format(eTime));
		if_dao.insertMroJobDate(bMap);
	}

	public void arCancel() {
		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName() + ".arCancel()" );
		// 시작시점
		Date sTime = new Date();
		bMap.put("JOB_SDATE", dFormat.format(sTime));
		// 데이터 건수 
		bMap.put("JOB_CNT", "0");
		dao.arCancelKepmp();
		dao.arCancelKepcon();
		// 종료시점
		Date eTime = new Date();
		bMap.put("JOB_EDATE", dFormat.format(eTime));
		if_dao.insertMroJobDate(bMap);
	}

	public void apCancel() {
		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName() + ".apCancel()" );
		// 시작시점
		Date sTime = new Date();
		bMap.put("JOB_SDATE", dFormat.format(sTime));
		// 데이터 건수 
		bMap.put("JOB_CNT", "0");
		dao.apCancelKepmp();
		dao.apCancelKepcon();
		// 종료시점
		Date eTime = new Date();
		bMap.put("JOB_EDATE", dFormat.format(eTime));
		if_dao.insertMroJobDate(bMap);
	}

	public void sendTaccount() {
		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName() + ".sendTaccount()" );
		// 시작시점
		Date sTime = new Date();
		bMap.put("JOB_SDATE", dFormat.format(sTime));
		// 데이터 건수 
		bMap.put("JOB_CNT", "0");
		dao.sendTaccount();
		// 종료시점
		Date eTime = new Date();
		bMap.put("JOB_EDATE", dFormat.format(eTime));
		if_dao.insertMroJobDate(bMap);
	}

	public void sendTbill() {
		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName() + ".sendTbill()" );
		// 시작시점
		Date sTime = new Date();
		bMap.put("JOB_SDATE", dFormat.format(sTime));
		// 데이터 건수 
		bMap.put("JOB_CNT", "0");
		dao.sendTbill();
		// 종료시점
		Date eTime = new Date();
		bMap.put("JOB_EDATE", dFormat.format(eTime));
		if_dao.insertMroJobDate(bMap);
	}

	public void sendCode() {
		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName() + ".sendCode()" );
		// 시작시점
		Date sTime = new Date();
		bMap.put("JOB_SDATE", dFormat.format(sTime));
		// 데이터 건수 
		bMap.put("JOB_CNT", "0");
		dao.sendCode();
		// 종료시점
		Date eTime = new Date();
		bMap.put("JOB_EDATE", dFormat.format(eTime));
		if_dao.insertMroJobDate(bMap);
	}
}