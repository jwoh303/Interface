/**
 * Service1Soap.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.coway;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Service1Soap extends Remote {
	public String getPoint(String emp_no, String flag) throws RemoteException;

	public String usePoint(String trans_no, String id, String prodname,
			String useamount, String flag) throws RemoteException;

	public String usePointOK(String result, String trans_no, String flag)
			throws RemoteException;

	public String cancelPoint(String trans_no, String useamount, String id,
			String flag) throws RemoteException;

	public String getPointCW(String emp_no, String flag) throws RemoteException;

	public String setPointCW(String emp_no, String use_point, String ac_sid,
			String ac_status, String ac_add_rea, String wj_order_no, String flag)
			throws RemoteException;

	public String ZMM_GSYS_REQ_STATUS_DISPLAY(String request_id, String flag)
			throws RemoteException;

	public String ZMM_GSYS_GIREQUEST_CHECK(String i_Afnam, String i_Mblnr,
			String i_Status, String xmlData, String flag) throws RemoteException;

	public String ZMM_GSYS_REREQUEST_DISPLAY(String i_BUDAT_FROM, String i_BUDAT_TO,
			String i_BUKRS, String i_ENAME, String i_MBLNR, String i_ORGEH,
			String i_PERNR, String i_STEXT, String i_ZCODE, String flag)
			throws RemoteException;

	public String ZMM_GSYS_REREQUEST_CHECK(String i_Afnam, String i_Remblnr,
			String i_Status, String xmlData, String flag) throws RemoteException;

	public String ZMM_GSYS_REREQUEST_IV_CHECK(String i_Bukrs, String i_Mblnr,
			String i_Orgeh, String i_Pernr, String i_Matnr, String flag)
			throws RemoteException;

	public String ZMM_GSYS_GIREQUEST_DISPLAY(String i_Maktx, String i_Matnr,
			String i_Orgeh, String i_Zcode, String flag) throws RemoteException;

	public String ZMM_GSYS_ZCODE_DISPLAY(String flag) throws RemoteException;

	public String fnc(String xmlData1) throws RemoteException;
}
