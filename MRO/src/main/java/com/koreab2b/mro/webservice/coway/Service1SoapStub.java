/**
 * Service1SoapStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.coway;

import java.net.URL;
import java.util.Enumeration;
import java.rmi.RemoteException;

import javax.xml.namespace.QName;

import org.apache.axis.client.Stub;
import org.apache.axis.client.Service;
import org.apache.axis.client.Call;
import org.apache.axis.description.OperationDesc;
import org.apache.axis.description.ParameterDesc;

public class Service1SoapStub extends Stub implements com.koreab2b.mro.webservice.coway.Service1Soap {
	static OperationDesc[] _operations;

	static {
		_operations = new OperationDesc[14];
		_initOperationDesc1();
		_initOperationDesc2();
	}

	private static void _initOperationDesc1() {
		OperationDesc oper;
		ParameterDesc param;
		oper = new OperationDesc();
		oper.setName("GetPoint");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"emp_no"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "GetPointResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[0] = oper;

		oper = new OperationDesc();
		oper.setName("UsePoint");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"trans_no"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(
				new QName("http://tempuri.org/", "id"),
				ParameterDesc.IN, new QName(
						"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"prodname"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"useamount"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "UsePointResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[1] = oper;

		oper = new OperationDesc();
		oper.setName("UsePointOK");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"result"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"trans_no"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "UsePointOKResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[2] = oper;

		oper = new OperationDesc();
		oper.setName("CancelPoint");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"trans_no"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"useamount"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(
				new QName("http://tempuri.org/", "id"),
				ParameterDesc.IN, new QName(
						"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "CancelPointResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[3] = oper;

		oper = new OperationDesc();
		oper.setName("GetPointCW");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"emp_no"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "GetPointCWResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[4] = oper;

		oper = new OperationDesc();
		oper.setName("SetPointCW");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"emp_no"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"use_point"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"ac_sid"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"ac_status"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"ac_add_rea"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"wj_order_no"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "SetPointCWResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[5] = oper;

		oper = new OperationDesc();
		oper.setName("ZMM_GSYS_REQ_STATUS_DISPLAY");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"request_id"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "ZMM_GSYS_REQ_STATUS_DISPLAYResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[6] = oper;

		oper = new OperationDesc();
		oper.setName("ZMM_GSYS_GIREQUEST_CHECK");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Afnam"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Mblnr"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Status"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"xmlData"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "ZMM_GSYS_GIREQUEST_CHECKResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[7] = oper;

		oper = new OperationDesc();
		oper.setName("ZMM_GSYS_REREQUEST_DISPLAY");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_BUDAT_FROM"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_BUDAT_TO"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_BUKRS"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_ENAME"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_MBLNR"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_ORGEH"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_PERNR"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_STEXT"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_ZCODE"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "ZMM_GSYS_REREQUEST_DISPLAYResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[8] = oper;

		oper = new OperationDesc();
		oper.setName("ZMM_GSYS_REREQUEST_CHECK");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Afnam"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Remblnr"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Status"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"xmlData"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "ZMM_GSYS_REREQUEST_CHECKResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[9] = oper;

	}

	private static void _initOperationDesc2() {
		OperationDesc oper;
		ParameterDesc param;
		oper = new OperationDesc();
		oper.setName("ZMM_GSYS_REREQUEST_IV_CHECK");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Bukrs"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Mblnr"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Orgeh"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Pernr"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Matnr"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "ZMM_GSYS_REREQUEST_IV_CHECKResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[10] = oper;

		oper = new OperationDesc();
		oper.setName("ZMM_GSYS_GIREQUEST_DISPLAY");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Maktx"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Matnr"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Orgeh"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"I_Zcode"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "ZMM_GSYS_GIREQUEST_DISPLAYResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[11] = oper;

		oper = new OperationDesc();
		oper.setName("ZMM_GSYS_ZCODE_DISPLAY");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"flag"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "ZMM_GSYS_ZCODE_DISPLAYResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[12] = oper;

		oper = new OperationDesc();
		oper.setName("fnc");
		param = new ParameterDesc(new QName("http://tempuri.org/",
				"xmlData1"), ParameterDesc.IN, new QName(
				"http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
		oper.setReturnClass(String.class);
		oper.setReturnQName(new QName("http://tempuri.org/", "fncResult"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[13] = oper;

	}

	public Service1SoapStub() throws org.apache.axis.AxisFault {
		this(null);
	}

	public Service1SoapStub(URL endpointURL, Service service) throws org.apache.axis.AxisFault {
		this(service);
		super.cachedEndpoint = endpointURL;
	}

	public Service1SoapStub(Service service) throws org.apache.axis.AxisFault {
		if (service == null) {
			super.service = new Service();
		} else {
			super.service = service;
		}
		((Service) super.service).setTypeMappingVersion("1.2");
	}

	protected Call createCall() throws RemoteException {
		try {
			Call _call = super._createCall();
			if (super.maintainSessionSet) {
				_call.setMaintainSession(super.maintainSession);
			}
			if (super.cachedUsername != null) {
				_call.setUsername(super.cachedUsername);
			}
			if (super.cachedPassword != null) {
				_call.setPassword(super.cachedPassword);
			}
			if (super.cachedEndpoint != null) {
				_call.setTargetEndpointAddress(super.cachedEndpoint);
			}
			if (super.cachedTimeout != null) {
				_call.setTimeout(super.cachedTimeout);
			}
			if (super.cachedPortName != null) {
				_call.setPortName(super.cachedPortName);
			}
			Enumeration<Object> keys = super.cachedProperties.keys();
			while (keys.hasMoreElements()) {
				String key = (String) keys.nextElement();
				_call.setProperty(key, super.cachedProperties.get(key));
			}
			return _call;
		} catch (Throwable _t) {
			throw new org.apache.axis.AxisFault("Failure trying to get the Call object", _t);
		}
	}

	public String getPoint(String emp_no, String flag) throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[0]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/GetPoint");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "GetPoint"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { emp_no, flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String usePoint(String trans_no, String id, String prodname,
			String useamount, String flag) throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[1]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/UsePoint");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "UsePoint"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { trans_no, id, prodname, useamount, flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String usePointOK(String result, String trans_no, String flag)
			throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[2]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/UsePointOK");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "UsePointOK"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { result, trans_no, flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String cancelPoint(String trans_no, String useamount, String id,
			String flag) throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[3]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/CancelPoint");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "CancelPoint"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { trans_no, useamount, id, flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String getPointCW(String emp_no, String flag) throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[4]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/GetPointCW");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "GetPointCW"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { emp_no, flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String setPointCW(String emp_no, String use_point, String ac_sid,
			String ac_status, String ac_add_rea, String wj_order_no, String flag)
			throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[5]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/SetPointCW");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "SetPointCW"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { emp_no, use_point, ac_sid, ac_status,
					ac_add_rea, wj_order_no, flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String ZMM_GSYS_REQ_STATUS_DISPLAY(String request_id, String flag)
			throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[6]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/ZMM_GSYS_REQ_STATUS_DISPLAY");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "ZMM_GSYS_REQ_STATUS_DISPLAY"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { request_id, flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String ZMM_GSYS_GIREQUEST_CHECK(String i_Afnam, String i_Mblnr,
			String i_Status, String xmlData, String flag) throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[7]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/ZMM_GSYS_GIREQUEST_CHECK");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "ZMM_GSYS_GIREQUEST_CHECK"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { i_Afnam, i_Mblnr, i_Status, xmlData, flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String ZMM_GSYS_REREQUEST_DISPLAY(String i_BUDAT_FROM, String i_BUDAT_TO,
			String i_BUKRS, String i_ENAME, String i_MBLNR, String i_ORGEH,
			String i_PERNR, String i_STEXT, String i_ZCODE, String flag)
			throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[8]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/ZMM_GSYS_REREQUEST_DISPLAY");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "ZMM_GSYS_REREQUEST_DISPLAY"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { i_BUDAT_FROM, i_BUDAT_TO, i_BUKRS, i_ENAME,
					i_MBLNR, i_ORGEH, i_PERNR, i_STEXT, i_ZCODE, flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String ZMM_GSYS_REREQUEST_CHECK(String i_Afnam, String i_Remblnr,
			String i_Status, String xmlData, String flag) throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[9]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/ZMM_GSYS_REREQUEST_CHECK");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "ZMM_GSYS_REREQUEST_CHECK"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call
					.invoke(new Object[] { i_Afnam, i_Remblnr, i_Status, xmlData, flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String ZMM_GSYS_REREQUEST_IV_CHECK(String i_Bukrs, String i_Mblnr,
			String i_Orgeh, String i_Pernr, String i_Matnr, String flag)
			throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[10]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/ZMM_GSYS_REREQUEST_IV_CHECK");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "ZMM_GSYS_REREQUEST_IV_CHECK"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { i_Bukrs, i_Mblnr, i_Orgeh, i_Pernr, i_Matnr,
					flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String ZMM_GSYS_GIREQUEST_DISPLAY(String i_Maktx, String i_Matnr,
			String i_Orgeh, String i_Zcode, String flag) throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[11]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/ZMM_GSYS_GIREQUEST_DISPLAY");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "ZMM_GSYS_GIREQUEST_DISPLAY"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { i_Maktx, i_Matnr, i_Orgeh, i_Zcode, flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String ZMM_GSYS_ZCODE_DISPLAY(String flag) throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[12]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/ZMM_GSYS_ZCODE_DISPLAY");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "ZMM_GSYS_ZCODE_DISPLAY"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { flag });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public String fnc(String xmlData1) throws RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[13]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("http://tempuri.org/fnc");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://tempuri.org/", "fnc"));

		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { xmlData1 });

			if (_resp instanceof RemoteException) {
				throw (RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (String) _resp;
				} catch (Exception _exception) {
					return (String) org.apache.axis.utils.JavaUtils.convert(_resp, String.class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

}
