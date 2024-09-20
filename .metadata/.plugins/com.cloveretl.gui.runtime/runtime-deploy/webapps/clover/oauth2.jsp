<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.context.ApplicationContext" %>
<%@ page import="com.google.api.client.auth.oauth2.AuthorizationCodeResponseUrl" %>
<%@ page import="com.cloveretl.server.oauth2.OAuth2Manager" %>
<%@ page import="org.jetel.oauth2.OAuth2Utils" %>
<%@ page import="com.cloveretl.server.facade.api.exceptions.CloverServerException" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
StringBuffer fullUrlBuf = request.getRequestURL(); // reconstruct full URL of the incoming request
if (request.getQueryString() != null) {
	fullUrlBuf.append('?').append(request.getQueryString());
}
AuthorizationCodeResponseUrl authResponse = null;
boolean success = false;
String errorType = null;
String errorDescription = null;
String errorUri = null;
ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
OAuth2Manager oAuth2Manager = ctx.getBean(OAuth2Manager.BEAN_NAME, OAuth2Manager.class);
try {
	authResponse = new AuthorizationCodeResponseUrl(fullUrlBuf.toString());
} catch (IllegalArgumentException e) {
	// happens when redirect doesn't contain required query parameters
	errorDescription = "Missing required parameters for callback - 'error' or 'code'";
}
if (authResponse != null) {
	if (authResponse.getError() == null) {
		String authCode = authResponse.getCode();
		String state = authResponse.getState();
		try {
			oAuth2Manager.handleCallback(state, authCode);
			success = true;
		} catch (CloverServerException e) {
			errorDescription = org.jetel.util.ExceptionUtils.getMessage(e);
		}
	} else {
		errorType = authResponse.getError();
		errorDescription = authResponse.getErrorDescription();
		errorUri = authResponse.getErrorUri();
	}
}
String title = success ? OAuth2Utils.AUTHORIZATION_SUCCESS_TITLE : "OAuth2 authorization failed";
if (!success) {
	oAuth2Manager.logCallbackFailure(errorType, errorDescription, errorUri);
}
%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link rel="icon" href="data:image/x-icon;base64,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" type="image/x-icon" />
  <title><%= title %></title>

  <style>
    body,
    html {
      height: 100%;
      margin: 0;
      padding: 0;
      font-family: "Inter", Helvetica, sans-serif;
    }

    html {
      background: #cfcfcf;
    }

    * {
      box-sizing: border-box;
    }

    a {
      color: #3C91DD;
    }

    a:hover {
      text-decoration: none;
    }

    /* 
     * Colored borders
     */
    .result {
      height: 100%;
      min-height: 0;
      border: 7px solid #999;
      background: #fff;
    }

    @media (min-width: 800px) {
      .result {
        height: 90vh;
        width: 700px;
        margin: 5vh auto 0 auto;
        border-radius: 5px;
        box-shadow: 0 0 20px rgba(51, 51, 51, 0.24);
      }
    }

    .result--ok {
      border: 7px solid #35B863;
    }

    .result--fail {
      border: 7px solid #FF7474;
    }

    .scroll {
      overflow: auto;
      height: 100%;
    }

    .wrapper {
      display: flex;
      flex-direction: column;
      min-height: 100%;
      height: 100%;
    }

    /* 
     * Logo
     */
    .logo {
      flex: 1 1 150px;
      min-height: 120px;
      max-height: 260px;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .logo svg {
      width: 213px;
      height: 46px;
      overflow: hidden;
    }

    /* 
     * Status icon and title
     */
    .status {
      flex: 1 1 auto;
      min-height: 160px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }

    @media (max-width: 500px) {
      .status {
        margin: 0 30px;
      }
    }

    .status__icon {
      margin-bottom: 20px;
    }

    .status__title {
      font-size: 20px;
      font-weight: bold;
      text-align: center;
    }
    
    /* 
     * Note - page closing
     */
    .note {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
    }

    /* 
     * Error messages
     */
    .error {
      flex: 1 1 auto;
      align-self: stretch;
      display: flex;
      flex-direction: column;
      justify-content: flex-end;
      margin: 0 50px;
      padding-bottom: 40px;
    }

    @media (max-width: 500px) {
      .error {
        margin: 0 30px;
      }
    }

    .error__message {
      align-self: stretch;
      margin-top: 20px;
      font-size: 14px;
    }

    .error__message:first-of-type {
      margin-top: 0;
      padding-top: 40px;
      border-top: 4px solid #F5F3F3;
    }

    .message__title {
      font-weight: bold;
      margin-bottom: 5px;
    }

    .message__body {
      line-height: 18px;
      white-space: pre-wrap;
    }
  </style>
</head>

<body class="result <%= success ? "result--ok" : "result--fail" %>">
  <div class="scroll">
    <div class="wrapper">
      <div class="logo">
        <svg xmlns="http://www.w3.org/2000/svg" width="213.259" height="46.264" viewBox="0 0 213.259 46.264">
          <g id="Logo" transform="translate(-942.968 -643.028)">
            <path d="M966.093,663.2h-.026a2.206,2.206,0,0,1-1.609-.694l-9.662-9.743a4.63,4.63,0,0,1,1.311-7.465l.022-.01a22.994,22.994,0,0,1,9.97-2.259h0a23,23,0,0,1,9.971,2.259l.022.01a4.63,4.63,0,0,1,1.311,7.465l-9.662,9.743a2.2,2.2,0,0,1-1.609.694h-.04Zm0,5.921h-.026a2.205,2.205,0,0,0-1.609.694l-9.662,9.744a4.629,4.629,0,0,0,1.311,7.465l.022.011a23,23,0,0,0,9.97,2.259h0a23.005,23.005,0,0,0,9.971-2.259l.022-.011a4.629,4.629,0,0,0,1.311-7.465l-9.662-9.744a2.2,2.2,0,0,0-1.609-.694h-.04Zm-2.953-2.966v-.027a2.209,2.209,0,0,0-.694-1.609l-9.743-9.662a4.629,4.629,0,0,0-7.465,1.311l-.01.022a22.994,22.994,0,0,0-2.259,9.971h0a23,23,0,0,0,2.259,9.971l.01.021a4.629,4.629,0,0,0,7.465,1.311l9.743-9.661a2.21,2.21,0,0,0,.694-1.61v-.037Zm5.922.012v.025a2.207,2.207,0,0,0,.694,1.61l9.743,9.661a4.629,4.629,0,0,0,7.465-1.311l.01-.021a23,23,0,0,0,2.259-9.971h0a22.993,22.993,0,0,0-2.259-9.971l-.01-.022a4.629,4.629,0,0,0-7.465-1.311l-9.743,9.662a2.207,2.207,0,0,0-.694,1.609v.04Z" transform="translate(0 0)" fill="#35b863"/>
            <path d="M1126.4,687.838h-6.056l-6.707-17.04h6.194l3.593,11.052h.1l3.593-11.052h5.988Z" transform="translate(-58.788 -9.565)" fill="#333"/>
            <rect width="5.714" height="24.26" transform="translate(1025.82 654.012)" fill="#333"/>
            <path d="M1102.419,678.962a9.209,9.209,0,0,1-.753,3.781,8.478,8.478,0,0,1-2.053,2.875,9.4,9.4,0,0,1-3.011,1.83,10.583,10.583,0,0,1-7.305,0,9.143,9.143,0,0,1-3.011-1.83,8.587,8.587,0,0,1-2.036-2.875,9.212,9.212,0,0,1-.752-3.781,9.1,9.1,0,0,1,.752-3.764,8.459,8.459,0,0,1,2.036-2.84,8.857,8.857,0,0,1,3.011-1.779,11.133,11.133,0,0,1,7.305,0,9.094,9.094,0,0,1,3.011,1.779,8.352,8.352,0,0,1,2.053,2.84,9.093,9.093,0,0,1,.753,3.764m-5.406,0a4.877,4.877,0,0,0-.274-1.608,4.244,4.244,0,0,0-.787-1.386,4.019,4.019,0,0,0-1.267-.975,3.929,3.929,0,0,0-4.738.975,4.173,4.173,0,0,0-.753,1.386,5.163,5.163,0,0,0,0,3.216,4.4,4.4,0,0,0,.77,1.42,3.773,3.773,0,0,0,1.266,1.01,4.236,4.236,0,0,0,3.49,0,3.782,3.782,0,0,0,1.266-1.01,4.383,4.383,0,0,0,.77-1.42,5.145,5.145,0,0,0,.256-1.608" transform="translate(-48.405 -9.277)" fill="#333"/>
            <path d="M1162.329,679.236v.684a6.015,6.015,0,0,1-.034.65h-12.353a2.971,2.971,0,0,0,.428,1.3,3.7,3.7,0,0,0,.923,1.01,4.537,4.537,0,0,0,2.72.907,4.717,4.717,0,0,0,2.258-.5,4.459,4.459,0,0,0,1.505-1.283l3.9,2.464a7.9,7.9,0,0,1-3.165,2.686,10.489,10.489,0,0,1-4.568.941,10.9,10.9,0,0,1-3.627-.6,8.8,8.8,0,0,1-2.994-1.745,8.068,8.068,0,0,1-2.019-2.823,9.445,9.445,0,0,1-.736-3.832,9.6,9.6,0,0,1,.718-3.781,8.547,8.547,0,0,1,1.951-2.874,8.7,8.7,0,0,1,2.908-1.831,9.957,9.957,0,0,1,3.627-.65,9.184,9.184,0,0,1,3.455.633,7.52,7.52,0,0,1,2.7,1.831,8.457,8.457,0,0,1,1.762,2.908,11.206,11.206,0,0,1,.634,3.9m-5.167-2.156a3.367,3.367,0,0,0-.838-2.292,3.166,3.166,0,0,0-2.515-.958,4.255,4.255,0,0,0-1.505.257,3.906,3.906,0,0,0-1.2.7,3.483,3.483,0,0,0-.822,1.044,3.054,3.054,0,0,0-.342,1.249Z" transform="translate(-69.441 -9.278)" fill="#333"/>
            <path d="M1199.555,659.837h8.314a16.419,16.419,0,0,1,4.654.684,12.5,12.5,0,0,1,4.208,2.156,11.053,11.053,0,0,1,3.045,3.764,12.053,12.053,0,0,1,1.164,5.509,11.7,11.7,0,0,1-1.164,5.389,11.256,11.256,0,0,1-3.045,3.764,13.081,13.081,0,0,1-4.208,2.224,15.346,15.346,0,0,1-4.654.735h-8.314Zm3.387,21.248h4.243a12.874,12.874,0,0,0,4.056-.616,9.375,9.375,0,0,0,3.216-1.78,7.956,7.956,0,0,0,2.1-2.874,9.5,9.5,0,0,0,.753-3.866,9.775,9.775,0,0,0-.753-3.969,7.811,7.811,0,0,0-2.1-2.857,9.322,9.322,0,0,0-3.216-1.745,13.23,13.23,0,0,0-4.056-.6h-4.243Z" transform="translate(-88.381 -5.79)" fill="#333"/>
            <path d="M1231.453,684.026l16.561-24.225h3.969l-16.356,24.225Z" transform="translate(-99.368 -5.777)" fill="#333"/>
            <path d="M1240.661,667.675l-5.384-7.875h-3.969l7.322,10.845Z" transform="translate(-99.318 -5.777)" fill="#333"/>
            <path d="M1248.687,683.95l4.963,7.351h4.175l-7.094-10.377Z" transform="translate(-105.304 -13.053)" fill="#333"/>
            <path d="M1050.339,676.815a7.394,7.394,0,0,1-5.254,2.183v0c-.058,0-.115,0-.174,0a6.892,6.892,0,0,1-2.772-.548,6.387,6.387,0,0,1-2.173-1.522,7,7,0,0,1-1.42-2.344,8.5,8.5,0,0,1-.513-3.011,8.261,8.261,0,0,1,.513-2.959,7.086,7.086,0,0,1,1.438-2.344,6.616,6.616,0,0,1,2.206-1.557,6.933,6.933,0,0,1,2.823-.564l.072,0v0a7.391,7.391,0,0,1,5.054,1.991l3.736-3.736a9.666,9.666,0,0,0-4.02-2.652,14.966,14.966,0,0,0-10.214-.017,12.36,12.36,0,0,0-4.175,2.549,11.724,11.724,0,0,0-2.788,4.021,14.192,14.192,0,0,0-.017,10.47,11.966,11.966,0,0,0,6.86,6.672,14.189,14.189,0,0,0,5.183.924,12.976,12.976,0,0,0,5.44-1.078,11.525,11.525,0,0,0,3.969-2.926Z" transform="translate(-30.552 -5.449)" fill="#333"/>
            <path d="M1187.967,670.132c-.07-.012-.142-.022-.221-.03a6.394,6.394,0,0,0-.669-.035,4.754,4.754,0,0,0-2.77.827,5.556,5.556,0,0,0-1.849,2.136h-.068v-2.464h-5.406v17.019h5.611V678.85a4.245,4.245,0,0,1,.206-1.194,3.747,3.747,0,0,1,.667-1.263,3.854,3.854,0,0,1,1.232-.99,4.006,4.006,0,0,1,1.9-.41c.227,0,.989.012,1.367.031Z" transform="translate(-80.606 -9.313)" fill="#333"/>
            <text transform="translate(1154.227 654.954)" fill="#333" font-size="1" font-family="MyriadPro-Regular, Myriad Pro"><tspan x="0" y="0">TM</tspan></text>
          </g>
        </svg>
      </div>
      
      <div class="status">
        <div class="status__icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="29.063" height="29.063" viewBox="0 0 29.063 29.063">
            <c:choose>
              <c:when test="<%= success %>">
                <path d="M29.531-11.25A14.531,14.531,0,0,0,15-25.781,14.531,14.531,0,0,0,.469-11.25,14.531,14.531,0,0,0,15,3.281,14.531,14.531,0,0,0,29.531-11.25ZM13.319-3.556a.938.938,0,0,1-1.326,0L5.9-9.65a.938.938,0,0,1,0-1.326L7.225-12.3a.938.938,0,0,1,1.326,0l4.1,4.105,8.792-8.792a.937.937,0,0,1,1.326,0L24.1-15.663a.938.938,0,0,1,0,1.326Z" transform="translate(-0.469 25.781)" fill="#35b863"/>
              </c:when>
              <c:otherwise>
                <path d="M15-25.781A14.529,14.529,0,0,0,.469-11.25,14.529,14.529,0,0,0,15,3.281,14.529,14.529,0,0,0,29.531-11.25,14.529,14.529,0,0,0,15-25.781ZM22.125-7.436a.7.7,0,0,1,0,1L19.8-4.125a.7.7,0,0,1-1,0L15-7.969,11.186-4.125a.7.7,0,0,1-1,0L7.875-6.445a.7.7,0,0,1,0-1l3.844-3.809L7.875-15.064a.7.7,0,0,1,0-1l2.32-2.32a.7.7,0,0,1,1,0L15-14.531l3.814-3.844a.7.7,0,0,1,1,0l2.32,2.32a.7.7,0,0,1,0,1l-3.85,3.809Z" transform="translate(-0.469 25.781)" fill="red"/>
              </c:otherwise>
            </c:choose>
          </svg>
        </div>
  
        <div class="status__title">
          <c:choose>
            <c:when test="<%= success %>">
              Connection has been authorized
            </c:when>
            <c:otherwise>
              Connection authorization failed
            </c:otherwise>
          </c:choose>
        </div>
  
        <c:choose>
          <c:when test="<%= success %>">
            <div class="note">
              You may close this page
            </div>
          </c:when>
          <c:otherwise>
            <div class="error">
              <c:if test="<%= errorType != null %>">
                <div class="error__message">
                  <div class="message__title">
                    Error:
                  </div>
                  <div class="message__body"><%= errorType %></div>
                </div>
              </c:if>
  
              <div class="error__message">
                <div class="message__title">
                  Error Description:
                </div>
                <div class="message__body"><%= errorDescription %></div>
              </div>
  
              <c:if test="<%= errorUri != null %>">
                <div class="error__message">
                  <div class="message__title">
                    Error URI:
                  </div>
                  <div class="message__body"><a href="<%= errorUri %>"><%= errorUri %></a></div>
                </div>
              </c:if>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</body>
</html>