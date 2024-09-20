<%@ page import="org.springframework.context.ApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.cloveretl.server.facade.api.listing.RunRecordFilter" %>
<%@ page import="com.cloveretl.server.InitializationDoneServlet" %>
<%@ page import="com.cloveretl.server.Msg" %>
<%@ page import="com.cloveretl.server.facade.api.misc.*" %>
<%@ page import="com.cloveretl.server.facade.api.*" %>
<%@ page import="com.cloveretl.server.persistent.NodeStatus.Status" %>
<%@ page import="com.cloveretl.server.worker.commons.facade.api.*" %>
<%@ page import="com.cloveretl.server.facade.api.resp.LocalInternalStatus" %>
<%@ page import="com.cloveretl.server.facade.api.resp.NodeInfo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.PrintWriter" %>

<%@ page trimDirectiveWhitespaces="true" %>

<%!
public boolean isWorkerRunning(LocalInternalStatus status) {
	List<NodeInfo> nodeInfos = status.getClusterNodesInfoList();
	for (NodeInfo info: nodeInfos) {
		if (status.getClusterNodeId().equals(info.getNodeId())) {
			return !info.isNoAvailableWorker();
		}
	}
	return false;
}
%>
<%
response.reset();
response.setHeader("Cache-Control", "no-cache; no-store; must-revalidate");
response.setHeader("Strict-Transport-Security", "max-age=63072000; includeSubDomains");
response.setHeader("X-XSS-Protection", "1; mode=block");
response.setHeader("Content-Security-Policy", "default-src 'self'; script-src 'none'; object-src 'none'; base-uri 'none'; img-src 'self'; style-src 'none'");
response.setHeader("X-Content-Type-Options", "nosniff");
response.setHeader("X-Frame-Options", "DENY");
if (Boolean.TRUE.equals(application.getAttribute(InitializationDoneServlet.APP_ATTRIBUTE_KEY_CLOVER_INITIALIZED))) {
	response.setContentType("text/plain");
	ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
	ServerFacade facade = (ServerFacade)ctx.getBean(ServerFacade.BEAN_NAME);
	Status status = facade.getLocalInternalStatus().getNodeRun().getStatus();
	if (Status.READY.equals(status)) {
		if (!isWorkerRunning(facade.getLocalInternalStatus())) {
			response.setStatus(503);
			response.setIntHeader("status-code", 503);
			response.getWriter().write("NO AVAILABLE WORKER");
		} else {
			Response<Boolean> healthCheck = facade.isNodeHealthy();
			if (healthCheck.getBean()) {
				response.setStatus(200);
				response.setIntHeader("status-code", 200);
				response.getWriter().write("OK");
			} else {
				response.setStatus(503);
				response.setIntHeader("status-code", 503);
				PrintWriter writer = response.getWriter();
				for (Message message : healthCheck.getMessages()) {
					writer.write(Msg.getMsg(message) + "\n");
				}
			}
		}
	} else {
		response.setStatus(503);
		response.setIntHeader("status-code", 503);
		/*
		 * When changing response content, be advised that ETL runtime manager checks content
		 * of the response ('SUSPENDED' state).
		 */
		response.getWriter().write(facade.getLocalInternalStatus().getNodeRun().getStatus().toString());
	}
} else {
	Object failure = application.getAttribute(InitializationDoneServlet.APP_ATTRIBUTE_KEY_INITIALIZATION_FAILED_EXCEPTION);
	if (failure instanceof Throwable) {
		response.setStatus(500);
		response.setContentType("text/plain");
		response.setIntHeader("status-code", 500);
		((Throwable)failure).printStackTrace(response.getWriter());
	} else {
		response.setStatus(503);
		response.setContentType("text/plain");
		response.setIntHeader("status-code", 503);
		response.getWriter().write("CloverDX Server not initialized yet");
	}
}
%>