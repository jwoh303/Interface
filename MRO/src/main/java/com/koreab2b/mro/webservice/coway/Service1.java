/**
 * Service1.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.coway;

import java.net.URL;
import javax.xml.rpc.Service;
import javax.xml.rpc.ServiceException;

public interface Service1 extends Service {
	public String getService1SoapAddress();

	public Service1Soap getService1Soap() throws javax.xml.rpc.ServiceException;

	public Service1Soap getService1Soap(URL portAddress) throws ServiceException;
}
