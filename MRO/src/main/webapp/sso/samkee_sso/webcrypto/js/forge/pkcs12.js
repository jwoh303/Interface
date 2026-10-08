/**
 * Javascript implementation of PKCS#12.
 *
 * @author Dave Longley
 * @author Stefan Siegl <stesie@brokenpipe.de>
 *
 * Copyright (c) 2010-2014 Digital Bazaar, Inc.
 * Copyright (c) 2012 Stefan Siegl <stesie@brokenpipe.de>
 *
 * The ASN.1 representation of PKCS#12 is as follows
 * (see ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-12/pkcs-12-tc1.pdf for details)
 *
 * PFX ::= SEQUENCE {
 *   version  INTEGER {v3(3)}(v3,...),
 *   authSafe ContentInfo,
 *   macData  MacData OPTIONAL
 * }
 *
 * MacData ::= SEQUENCE {
 *   mac DigestInfo,
 *   macSalt OCTET STRING,
 *   iterations INTEGER DEFAULT 1
 * }
 * Note: The iterations default is for historical reasons and its use is
 * deprecated. A higher value, like 1024, is recommended.
 *
 * DigestInfo is defined in PKCS#7 as follows:
 *
 * DigestInfo ::= SEQUENCE {
 *   digestAlgorithm DigestAlgorithmIdentifier,
 *   digest Digest
 * }
 *
 * DigestAlgorithmIdentifier ::= AlgorithmIdentifier
 *
 * The AlgorithmIdentifier contains an Object Identifier (OID) and parameters
 * for the algorithm, if any. In the case of SHA1 there is none.
 *
 * AlgorithmIdentifer ::= SEQUENCE {
 *    algorithm OBJECT IDENTIFIER,
 *    parameters ANY DEFINED BY algorithm OPTIONAL
 * }
 *
 * Digest ::= OCTET STRING
 *
 *
 * ContentInfo ::= SEQUENCE {
 *   contentType ContentType,
 *   content     [0] EXPLICIT ANY DEFINED BY contentType OPTIONAL
 * }
 *
 * ContentType ::= OBJECT IDENTIFIER
 *
 * AuthenticatedSafe ::= SEQUENCE OF ContentInfo
 * -- Data if unencrypted
 * -- EncryptedData if password-encrypted
 * -- EnvelopedData if public key-encrypted
 *
 *
 * SafeContents ::= SEQUENCE OF SafeBag
 *
 * SafeBag ::= SEQUENCE {
 *   bagId     BAG-TYPE.&id ({PKCS12BagSet})
 *   bagValue  [0] EXPLICIT BAG-TYPE.&Type({PKCS12BagSet}{@bagId}),
 *   bagAttributes SET OF PKCS12Attribute OPTIONAL
 * }
 *
 * PKCS12Attribute ::= SEQUENCE {
 *   attrId ATTRIBUTE.&id ({PKCS12AttrSet}),
 *   attrValues SET OF ATTRIBUTE.&Type ({PKCS12AttrSet}{@attrId})
 * } -- This type is compatible with the X.500 type ’Attribute’
 *
 * PKCS12AttrSet ATTRIBUTE ::= {
 *   friendlyName | -- from PKCS #9
 *   localKeyId, -- from PKCS #9
 *   ... -- Other attributes are allowed
 * }
 *
 * CertBag ::= SEQUENCE {
 *   certId    BAG-TYPE.&id   ({CertTypes}),
 *   certValue [0] EXPLICIT BAG-TYPE.&Type ({CertTypes}{@certId})
 * }
 *
 * x509Certificate BAG-TYPE ::= {OCTET STRING IDENTIFIED BY {certTypes 1}}
 *   -- DER-encoded X.509 certificate stored in OCTET STRING
 *
 * sdsiCertificate BAG-TYPE ::= {IA5String IDENTIFIED BY {certTypes 2}}
 * -- Base64-encoded SDSI certificate stored in IA5String
 *
 * CertTypes BAG-TYPE ::= {
 *   x509Certificate |
 *   sdsiCertificate,
 *   ... -- For future extensions
 * }
 */
!function(){function s(V){var L=V.asn1,B=V.pki,O=V.pkcs12=V.pkcs12||{},p={name:"ContentInfo",tagClass:L.Class.UNIVERSAL,type:L.Type.SEQUENCE,constructed:!0,value:[{name:"ContentInfo.contentType",tagClass:L.Class.UNIVERSAL,type:L.Type.OID,constructed:!1,capture:"contentType"},{name:"ContentInfo.content",tagClass:L.Class.CONTEXT_SPECIFIC,constructed:!0,captureAsn1:"content"}]},u={name:"PFX",tagClass:L.Class.UNIVERSAL,type:L.Type.SEQUENCE,constructed:!0,value:[{name:"PFX.version",tagClass:L.Class.UNIVERSAL,type:L.Type.INTEGER,constructed:!1,capture:"version"},p,{name:"PFX.macData",tagClass:L.Class.UNIVERSAL,type:L.Type.SEQUENCE,constructed:!0,optional:!0,captureAsn1:"mac",value:[{name:"PFX.macData.mac",tagClass:L.Class.UNIVERSAL,type:L.Type.SEQUENCE,constructed:!0,value:[{name:"PFX.macData.mac.digestAlgorithm",tagClass:L.Class.UNIVERSAL,type:L.Type.SEQUENCE,constructed:!0,value:[{name:"PFX.macData.mac.digestAlgorithm.algorithm",tagClass:L.Class.UNIVERSAL,type:L.Type.OID,constructed:!1,capture:"macAlgorithm"},{name:"PFX.macData.mac.digestAlgorithm.parameters",tagClass:L.Class.UNIVERSAL,captureAsn1:"macAlgorithmParameters"}]},{name:"PFX.macData.mac.digest",tagClass:L.Class.UNIVERSAL,type:L.Type.OCTETSTRING,constructed:!1,capture:"macDigest"}]},{name:"PFX.macData.macSalt",tagClass:L.Class.UNIVERSAL,type:L.Type.OCTETSTRING,constructed:!1,capture:"macSalt"},{name:"PFX.macData.iterations",tagClass:L.Class.UNIVERSAL,type:L.Type.INTEGER,constructed:!1,optional:!0,capture:"macIterations"}]}]},y={name:"SafeBag",tagClass:L.Class.UNIVERSAL,type:L.Type.SEQUENCE,constructed:!0,value:[{name:"SafeBag.bagId",tagClass:L.Class.UNIVERSAL,type:L.Type.OID,constructed:!1,capture:"bagId"},{name:"SafeBag.bagValue",tagClass:L.Class.CONTEXT_SPECIFIC,constructed:!0,captureAsn1:"bagValue"},{name:"SafeBag.bagAttributes",tagClass:L.Class.UNIVERSAL,type:L.Type.SET,constructed:!0,optional:!0,capture:"bagAttributes"}]},l={name:"Attribute",tagClass:L.Class.UNIVERSAL,type:L.Type.SEQUENCE,constructed:!0,value:[{name:"Attribute.attrId",tagClass:L.Class.UNIVERSAL,type:L.Type.OID,constructed:!1,capture:"oid"},{name:"Attribute.attrValues",tagClass:L.Class.UNIVERSAL,type:L.Type.SET,constructed:!0,capture:"values"}]},T={name:"CertBag",tagClass:L.Class.UNIVERSAL,type:L.Type.SEQUENCE,constructed:!0,value:[{name:"CertBag.certId",tagClass:L.Class.UNIVERSAL,type:L.Type.OID,constructed:!1,capture:"certId"},{name:"CertBag.certValue",tagClass:L.Class.CONTEXT_SPECIFIC,constructed:!0,value:[{name:"CertBag.certValue[0]",tagClass:L.Class.UNIVERSAL,type:L.Class.OCTETSTRING,constructed:!1,capture:"cert"}]}]};function S(e,t,a,r){for(var s=[],n=0;n<e.length;n++)for(var o=0;o<e[n].safeBags.length;o++){var c=e[n].safeBags[o];void 0!==r&&c.type!==r||(null!==t?void 0!==c.attributes[t]&&0<=c.attributes[t].indexOf(a)&&s.push(c):s.push(c))}return s}function I(e){if(e.composed||e.constructed){for(var t=V.util.createBuffer(),a=0;a<e.value.length;++a)t.putBytes(e.value[a].value);e.composed=e.constructed=!1,e.value=t.getBytes()}return e}function f(e,t){var a={},r=[];if(!L.validate(e,V.pkcs7.asn1.encryptedDataValidator,a,r))throw(s=new Error("Cannot read EncryptedContentInfo.")).errors=r,s;var s,n=L.derToOid(a.contentType);if(n!==B.oids.data)throw(s=new Error("PKCS#12 EncryptedContentInfo ContentType is not Data.")).oid=n,s;n=L.derToOid(a.encAlgorithm);var o=B.pbe.getCipher(n,a.encParameter,t),c=I(a.encryptedContentAsn1),l=V.util.createBuffer(c.value);if(o.update(l),!o.finish())throw new Error("Failed to decrypt PKCS#12 SafeContents.");return o.output.getBytes()}function g(e,a,t){if(!a&&0===e.length)return[];if((e=L.fromDer(e,a)).tagClass!==L.Class.UNIVERSAL||e.type!==L.Type.SEQUENCE||!0!==e.constructed)throw new Error("PKCS#12 SafeContents expected to be a SEQUENCE OF SafeBag.");for(var r=[],s=0;s<e.value.length;s++){var n=e.value[s],o={},c=[];if(!L.validate(n,y,o,c))throw(E=new Error("Cannot read SafeBag.")).errors=c,E;var l,i,d={type:L.derToOid(o.bagId),attributes:N(o.bagAttributes)};r.push(d);var C=o.bagValue.value[0];switch(d.type){case B.oids.pkcs8ShroudedKeyBag:if(null===(C=B.decryptPrivateKeyInfo(C,t)))throw new Error("Unable to decrypt PKCS#8 ShroudedKeyBag, wrong password?");case B.oids.keyBag:try{d.key=B.privateKeyFromAsn1(C),d.asn1=C}catch(e){d.key=null,d.asn1=C}continue;case B.oids.certBag:l=T,i=function(){if(L.derToOid(o.certId)!==B.oids.x509Certificate){var e=new Error("Unsupported certificate type, only X.509 supported.");throw e.oid=L.derToOid(o.certId),e}var t=L.fromDer(o.cert,a);try{d.cert=B.certificateFromAsn1(t,!0)}catch(e){d.cert=null,d.asn1=t}};break;default:var E;throw(E=new Error("Unsupported PKCS#12 SafeBag type.")).oid=d.type,E}if(void 0!==l&&!L.validate(C,l,o,c))throw(E=new Error("Cannot read PKCS#12 "+l.name)).errors=c,E;i()}return r}function N(e){var t={};if(void 0!==e)for(var a=0;a<e.length;++a){var r={},s=[];if(!L.validate(e[a],l,r,s)){var n=new Error("Cannot read PKCS#12 BagAttribute.");throw n.errors=s,n}var o=L.derToOid(r.oid);if(void 0!==B.oids[o]){t[B.oids[o]]=[];for(var c=0;c<r.values.length;++c)t[B.oids[o]].push(r.values[c].value)}}return t}O.pkcs12FromAsn1=function(e,t,a){"string"==typeof t?(a=t,t=!0):void 0===t&&(t=!0);var r={};if(!L.validate(e,u,r,[]))throw(s=new Error("Cannot read PKCS#12 PFX. ASN.1 object is not an PKCS#12 PFX.")).errors=s;var s,n={version:r.version.charCodeAt(0),safeContents:[],getBags:function(e){var t,a={};return"localKeyId"in e?t=e.localKeyId:"localKeyIdHex"in e&&(t=V.util.hexToBytes(e.localKeyIdHex)),void 0===t&&!("friendlyName"in e)&&"bagType"in e&&(a[e.bagType]=S(n.safeContents,null,null,e.bagType)),void 0!==t&&(a.localKeyId=S(n.safeContents,"localKeyId",t,e.bagType)),"friendlyName"in e&&(a.friendlyName=S(n.safeContents,"friendlyName",e.friendlyName,e.bagType)),a},getBagsByFriendlyName:function(e,t){return S(n.safeContents,"friendlyName",e,t)},getBagsByLocalKeyId:function(e,t){return S(n.safeContents,"localKeyId",e,t)}};if(3!==r.version.charCodeAt(0))throw(s=new Error("PKCS#12 PFX of version other than 3 not supported.")).version=r.version.charCodeAt(0),s;if(L.derToOid(r.contentType)!==B.oids.data)throw(s=new Error("Only PKCS#12 PFX in password integrity mode supported.")).oid=L.derToOid(r.contentType),s;var o=r.content.value[0];if(o.tagClass!==L.Class.UNIVERSAL||o.type!==L.Type.OCTETSTRING)throw new Error("PKCS#12 authSafe content data is not an OCTET STRING.");if(o=I(o),r.mac){var c=null,l=0,i=L.derToOid(r.macAlgorithm);switch(i){case B.oids.sha1:c=V.md.sha1.create(),l=20;break;case B.oids.sha256:c=V.md.sha256.create(),l=32;break;case B.oids.sha384:c=V.md.sha384.create(),l=48;break;case B.oids.sha512:c=V.md.sha512.create(),l=64;break;case B.oids.md5:c=V.md.md5.create(),l=16}if(null===c)throw new Error("PKCS#12 uses unsupported MAC algorithm: "+i);var d=new V.util.ByteBuffer(r.macSalt),C="macIterations"in r?parseInt(V.util.bytesToHex(r.macIterations),16):1,E=O.generateKey(a,d,3,C,l,c),y=V.hmac.create();if(y.start(c,E),y.update(o.value),y.getMac().getBytes()!==r.macDigest)throw new Error("PKCS#12 MAC could not be verified. Invalid password?")}return function(e,t,a,r){if((t=L.fromDer(t,a)).tagClass!==L.Class.UNIVERSAL||t.type!==L.Type.SEQUENCE||!0!==t.constructed)throw new Error("PKCS#12 AuthenticatedSafe expected to be a SEQUENCE OF ContentInfo");for(var s=0;s<t.value.length;s++){var n=t.value[s],o={},c=[];if(!L.validate(n,p,o,c)){var l=new Error("Cannot read ContentInfo.");throw l.errors=c,l}var i={encrypted:!1},d=null,C=o.content.value[0];switch(L.derToOid(o.contentType)){case B.oids.data:if(C.tagClass!==L.Class.UNIVERSAL||C.type!==L.Type.OCTETSTRING)throw new Error("PKCS#12 SafeContents Data is not an OCTET STRING.");d=I(C).value;break;case B.oids.encryptedData:d=f(C,r),i.encrypted=!0;break;default:var l=new Error("Unsupported PKCS#12 contentType.");throw l.contentType=L.derToOid(o.contentType),l}i.safeBags=g(d,a,r),e.safeContents.push(i)}}(n,o.value,t,a),n},O.toPkcs12Asn1=function(e,t,a,r){(r=r||{}).saltSize=r.saltSize||8,r.count=r.count||2048,r.algorithm=r.algorithm||r.encAlgorithm||"aes128","useMac"in r||(r.useMac=!0),"localKeyId"in r||(r.localKeyId=null),"generateLocalKeyId"in r||(r.generateLocalKeyId=!0);var s,n=r.localKeyId;if(null!==n)n=V.util.hexToBytes(n);else if(r.generateLocalKeyId)if(t){var o=V.util.isArray(t)?t[0]:t;"string"==typeof o&&(o=B.certificateFromPem(o)),(v=V.md.sha1.create()).update(L.toDer(B.certificateToAsn1(o)).getBytes()),n=v.digest().getBytes()}else n=V.random.getBytes(20);var c=[];null!==n&&c.push(L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.OID,!1,L.oidToDer(B.oids.localKeyId).getBytes()),L.create(L.Class.UNIVERSAL,L.Type.SET,!0,[L.create(L.Class.UNIVERSAL,L.Type.OCTETSTRING,!1,n)])])),"friendlyName"in r&&c.push(L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.OID,!1,L.oidToDer(B.oids.friendlyName).getBytes()),L.create(L.Class.UNIVERSAL,L.Type.SET,!0,[L.create(L.Class.UNIVERSAL,L.Type.BMPSTRING,!1,r.friendlyName)])])),0<c.length&&(s=L.create(L.Class.UNIVERSAL,L.Type.SET,!0,c));var l=[],i=[];null!==t&&(i=V.util.isArray(t)?t:[t]);for(var d=[],C=0;C<i.length;++C){"string"==typeof(t=i[C])&&(t=B.certificateFromPem(t));var E=0===C?s:void 0,y=B.certificateToAsn1(t),p=L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.OID,!1,L.oidToDer(B.oids.certBag).getBytes()),L.create(L.Class.CONTEXT_SPECIFIC,0,!0,[L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.OID,!1,L.oidToDer(B.oids.x509Certificate).getBytes()),L.create(L.Class.CONTEXT_SPECIFIC,0,!0,[L.create(L.Class.UNIVERSAL,L.Type.OCTETSTRING,!1,L.toDer(y).getBytes())])])]),E]);d.push(p)}if(0<d.length){var u=L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,d),T=L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.OID,!1,L.oidToDer(B.oids.data).getBytes()),L.create(L.Class.CONTEXT_SPECIFIC,0,!0,[L.create(L.Class.UNIVERSAL,L.Type.OCTETSTRING,!1,L.toDer(u).getBytes())])]);l.push(T)}var S=null;if(null!==e){var I=e;S=null===a?L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.OID,!1,L.oidToDer(B.oids.keyBag).getBytes()),L.create(L.Class.CONTEXT_SPECIFIC,0,!0,[I]),s]):L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.OID,!1,L.oidToDer(B.oids.pkcs8ShroudedKeyBag).getBytes()),L.create(L.Class.CONTEXT_SPECIFIC,0,!0,[B.encryptPrivateKeyInfo(I,a,r)]),s]);var f=L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[S]),g=L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.OID,!1,L.oidToDer(B.oids.data).getBytes()),L.create(L.Class.CONTEXT_SPECIFIC,0,!0,[L.create(L.Class.UNIVERSAL,L.Type.OCTETSTRING,!1,L.toDer(f).getBytes())])]);l.push(g)}var N,m=L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,l);if(r.useMac){var v=V.md.sha1.create(),A=new V.util.ByteBuffer(V.random.getBytes(r.saltSize)),U=r.count,h=(e=O.generateKey(a,A,3,U,20),V.hmac.create());h.start(v,e),h.update(L.toDer(m).getBytes());var R=h.getMac();N=L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.OID,!1,L.oidToDer(B.oids.sha1).getBytes()),L.create(L.Class.UNIVERSAL,L.Type.NULL,!1,"")]),L.create(L.Class.UNIVERSAL,L.Type.OCTETSTRING,!1,R.getBytes())]),L.create(L.Class.UNIVERSAL,L.Type.OCTETSTRING,!1,A.getBytes()),L.create(L.Class.UNIVERSAL,L.Type.INTEGER,!1,L.integerToDer(U).getBytes())])}return L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.INTEGER,!1,L.integerToDer(3).getBytes()),L.create(L.Class.UNIVERSAL,L.Type.SEQUENCE,!0,[L.create(L.Class.UNIVERSAL,L.Type.OID,!1,L.oidToDer(B.oids.data).getBytes()),L.create(L.Class.CONTEXT_SPECIFIC,0,!0,[L.create(L.Class.UNIVERSAL,L.Type.OCTETSTRING,!1,L.toDer(m).getBytes())])]),N])},O.generateKey=V.pbe.generatePkcs12Key}var n,o="pkcs12";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),s(forge);var a=!0;define=function(e,t){t(require,module)}}var r=define;define=function(e,t){return n="string"==typeof e?t.slice(2):e.slice(2),a?(delete define,r.apply(null,Array.prototype.slice.call(arguments,0))):(define=r,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./asn1","./hmac","./oids","./pkcs7asn1","./pbe","./random","./rsa","./sha1","./util","./x509"],function(){(function(r,e){e.exports=function(e){var t=n.map(function(e){return r(e)}).concat(s);if((e=e||{}).defined=e.defined||{},e.defined[o])return e[o];e.defined[o]=!0;for(var a=0;a<t.length;++a)t[a](e);return e[o]}}).apply(null,Array.prototype.slice.call(arguments,0))})}();