package com.koreab2b.mro.webservice.coway;

import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;
import javax.xml.rpc.Stub;

import org.springframework.stereotype.Service;

@Service("service1SoapProxy")
public class Service1SoapProxy implements Service1Soap {
	private String _endpoint = null;
	private Service1Soap service1Soap = null;

	public Service1SoapProxy() {
		_initService1SoapProxy();
	}

	public Service1SoapProxy(String endpoint) {
		_endpoint = endpoint;
		_initService1SoapProxy();
	}

	private void _initService1SoapProxy() {
		try {
			service1Soap = (new Service1Locator()).getService1Soap();
			if (service1Soap != null) {
				if (_endpoint != null)
					((Stub) service1Soap)._setProperty("service.endpoint.address",
							_endpoint);
				else
					_endpoint = (String) ((Stub) service1Soap)
							._getProperty("service.endpoint.address");
			}

		} catch (ServiceException serviceException) {
		}
	}

	public String getEndpoint() {
		return _endpoint;
	}

	public void setEndpoint(String endpoint) {
		_endpoint = endpoint;
		if (service1Soap != null)
			((Stub) service1Soap)._setProperty("service.endpoint.address", _endpoint);

	}

	public Service1Soap getService1Soap() {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap;
	}

	public String getPoint(String emp_no, String flag) throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.getPoint(emp_no, flag);
	}

	public String usePoint(String transNo_prNo, String id, String prodname,
			String useamount, String flag) throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.usePoint(transNo_prNo, id, prodname, useamount, flag);
	}

	public String usePointOK(String result, String trans_no, String flag)
			throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.usePointOK(result, trans_no, flag);
	}

	public String cancelPoint(String transNo_prNo, String useamount, String id,
			String flag) throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.cancelPoint(transNo_prNo, useamount, id, flag);
	}

	public String getPointCW(String emp_no, String flag) throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.getPointCW(emp_no, flag);
	}

	public String setPointCW(String emp_no, String use_point, String ac_sid,
			String ac_status, String ac_add_rea, String wj_order_no, String flag)
			throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.setPointCW(emp_no, use_point, ac_sid, ac_status, ac_add_rea, wj_order_no, flag);
	}

	public String ZMM_GSYS_REQ_STATUS_DISPLAY(String request_id, String flag)
			throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.ZMM_GSYS_REQ_STATUS_DISPLAY(request_id, flag);
	}

	public String ZMM_GSYS_GIREQUEST_CHECK(String i_Afnam, String i_Mblnr,
			String i_Status, String xmlData, String flag) throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.ZMM_GSYS_GIREQUEST_CHECK(i_Afnam, i_Mblnr, i_Status, xmlData, flag);
	}

	public String ZMM_GSYS_REREQUEST_DISPLAY(String i_BUDAT_FROM, String i_BUDAT_TO,
			String i_BUKRS, String i_ENAME, String i_MBLNR, String i_ORGEH,
			String i_PERNR, String i_STEXT, String i_ZCODE, String flag)
			throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.ZMM_GSYS_REREQUEST_DISPLAY(i_BUDAT_FROM, i_BUDAT_TO, i_BUKRS, i_ENAME, i_MBLNR, i_ORGEH,
				i_PERNR, i_STEXT, i_ZCODE, flag);
	}

	public String ZMM_GSYS_REREQUEST_CHECK(String i_Afnam, String i_Remblnr,
			String i_Status, String xmlData, String flag) throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.ZMM_GSYS_REREQUEST_CHECK(i_Afnam, i_Remblnr, i_Status, xmlData, flag);
	}

	public String ZMM_GSYS_REREQUEST_IV_CHECK(String i_Bukrs, String i_Mblnr,
			String i_Orgeh, String i_Pernr, String i_Matnr, String flag)
			throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.ZMM_GSYS_REREQUEST_IV_CHECK(i_Bukrs, i_Mblnr, i_Orgeh, i_Pernr, i_Matnr, flag);
	}

	public String ZMM_GSYS_GIREQUEST_DISPLAY(String i_Maktx, String i_Matnr,
			String i_Orgeh, String i_Zcode, String flag) throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.ZMM_GSYS_GIREQUEST_DISPLAY(i_Maktx, i_Matnr, i_Orgeh, i_Zcode, flag);
	}

	public String ZMM_GSYS_ZCODE_DISPLAY(String flag) throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.ZMM_GSYS_ZCODE_DISPLAY(flag);
	}

	public String fnc(String xmlData1) throws RemoteException {
		if (service1Soap == null)
			_initService1SoapProxy();
		return service1Soap.fnc(xmlData1);
	}

}
