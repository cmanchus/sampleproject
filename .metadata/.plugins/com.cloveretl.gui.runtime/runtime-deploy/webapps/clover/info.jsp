<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.context.ApplicationContext" %>
<%@ page import="com.cloveretl.server.facade.api.misc.*" %>
<%@ page import="com.cloveretl.server.facade.api.*" %>
<%@ page import="com.cloveretl.server.persistent.*" %>
<%@ page import="com.cloveretl.server.worker.commons.facade.api.*" %>
<%@ page import="com.cloveretl.server.worker.commons.persistent.*" %>
<%@ page import="com.cloveretl.server.worker.commons.utils.DateUtils" %>
<%@ page import="java.lang.management.*" %>
<%@ page import="javax.servlet.jsp.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.jetel.data.Defaults" %>
<%@ page import="org.jetel.plugin.Plugins" %>
<%@ page import="org.jetel.plugin.PluginDescriptor" %>
<%@ page import="org.jetel.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CloverDX Runtime Status</title>
<style type="text/css">
h1 {
	font-size: 1.5em;
	background-color: #eeeeee;
	color: #1d4f78;
	margin: 0;
	padding: 0.5em;
}

h2 {
	margin: 2em 0 1em 0;
	font-size: 1.2em;
	background: #d4e5f3;
	padding: 0.5em;
	color: #1d4f78;
}

body {
	font-family: "Segoe UI", Tahoma, Helvetica, sans-serif;
	font-size: 11pt;
}

pre {
	margin: 4px 4px;
	font-family: "SourceCodePro", Menlo, Monaco, "Lucida Console", "DejaVu Sans Mono", monospace;
	font-size: 10pt;
	white-space: pre-wrap;
}

table.infoTable {
	border-collapse: collapse;
}

table.infoTable  th, .infoTable table td {
    background: none repeat scroll 0 0 #FFFFEE;
    border: 1px solid #888888;
    padding: 0.3em;
	padding-left: 0.5em;
}

table.infoTable th {
    background: none repeat scroll 0 0 #777777;
    color: white;
    padding: 0.2em 0.5em;
	text-align: left;
}
table.infoTable td {
    padding: 0.2em 0.3em;
}
</style>
</head>
<body>
<%!
private void printTable(Map<String, String> mapx, JspWriter out, String ... headers) throws Exception {
	out.println("<table border='1' class='infoTable'>");
	
	if (headers != null) {
		out.println("<tr>");
		for (String header : headers) {
			out.print("<th>" + header + "</th>");
		}
		out.println("</tr>");
	}
	List<Map.Entry<String,String>> list = new ArrayList<Map.Entry<String,String>>(mapx.size());
	TreeMap<String,String> m = new TreeMap<String,String>(mapx);
	list.addAll(m.entrySet());

	for (Map.Entry<String,String> entry : list) {
	  out.println("<tr><td>" + entry.getKey() + "</td><td>" + entry.getValue() + "</td></tr>");
	}// for
	out.println("</table>");
}
%>

<h1>CloverDX Runtime <%=JetelVersion.getVersion() %> Status</h1>

<p>Generated: <%= new Date() %></p>

<p><button type="button" onclick="document.location.reload(true);">Refresh Status</button></p>

<%@include file="memory.jsp" %>
<%@include file="threadDump.jsp" %>

<h2>System Properties</h2>
<%
RuntimeMXBean runtimeMXB = ManagementFactory.getRuntimeMXBean();
Map<String,String> p = new TreeMap<String, String>(runtimeMXB.getSystemProperties());
printTable(p, out, "Property", "Value");
%>

<h2>Environment Variables</h2>
<%
Map<String, String> envProperties = new TreeMap<String, String>(System.getenv());
printTable(envProperties, out, "Variable", "Value");
%>

<h2>Runtime Properties</h2>
<%
ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
ServerFacade facade = (ServerFacade)ctx.getBean(ServerFacade.BEAN_NAME);
String sessionToken = (String)request.getAttribute("sToken");
Map<String, String> serverProps = facade.getConfigProperties();
printTable(serverProps, out, "Property", "Value");
%>

<h2>Clover Properties</h2>
<%
Properties pp = Defaults.getPropertiesSnapshot();
Map<String, String> pmap = new HashMap<String, String>((Map) pp);
printTable(pmap, out, "Property", "Value");
%>

<h2>Clover Plugins</h2>

<table border="1" class="infoTable">
<tr>
<th>Plugin ID</th>
<th>Descriptor Info</th>
</tr>
<%
	TreeMap<String, PluginDescriptor> plugins = new TreeMap<String, PluginDescriptor>(Plugins.getPluginDescriptors());
	for (Map.Entry<String, PluginDescriptor> e : plugins.entrySet()) {
%>
	<tr>
		<td><%= e.getKey() %></td>
		<td><pre class="pre" style="padding: 0; margin: 0;"><%= e.getValue() %></pre></td>
	</tr>
<% }%>
</table>

<h2>Java Virtual Machine</h2>
<% 
RuntimeMXBean r = ManagementFactory.getRuntimeMXBean();;
%>
<table border='1' class="infoTable">
<tr><td>Name</td><td><%=r.getName()%></td></tr>
<tr><td>Input arguments</td><td><%=r.getInputArguments()%></td></tr>
<tr><td>Classpath</td><td><%=r.getClassPath()%></td></tr>
<% if (r.isBootClassPathSupported()) { %>
<tr><td>Boot classpath</td><td><%=r.getBootClassPath()%></td></tr>
<% }%>
<tr><td>Library path</td><td><%=r.getLibraryPath()%></td></tr>
<tr><td>SpecName</td><td><%=r.getSpecName()%></td></tr>
<tr><td>SpecVendor</td><td><%=r.getSpecVendor()%></td></tr>
<tr><td>SpecVersion</td><td><%=r.getSpecVersion()%></td></tr>
<tr><td>VmName</td><td><%=r.getVmName()%></td></tr>
<tr><td>VmVendor</td><td><%=r.getVmVendor()%></td></tr>
<tr><td>VmVersion</td><td><%=r.getVmVersion()%></td></tr>
<tr><td>Uptime</td><td><%=DateUtils.getDurationString(r.getUptime())%></td></tr>
<tr><td>StartTime</td><td><%=new Date(r.getStartTime())%></td></tr>
</table>

<h2>Operating System</h2>
<% 
OperatingSystemMXBean o = ManagementFactory.getOperatingSystemMXBean();
%>

<table border='1' class="infoTable">
<tr><td>Name</td><td><%=o.getName()%></td></tr>
<tr><td>Architecture</td><td><%=o.getArch()%></td></tr>
<tr><td>Version</td><td><%=o.getVersion()%></td></tr>
<tr><td>Available processors</td><td><%=o.getAvailableProcessors()%></td></tr>
</table>		

<h2>Sandboxes</h2>
<%
	List<Sandbox> sandboxes = facade.getSandboxesList(sessionToken);
	Map<String, String> sinfo = new TreeMap<String, String>();
	for (Sandbox sandbox : sandboxes) {
		sinfo.put(sandbox.getCode(), sandbox.getRootPath());
	}
	printTable(sinfo, out, "Code", "File System Path");
%>

<h2>TempSpaces</h2>

<table border="1" class="infoTable">
<tr>
	<th>File System Path</th>
	<th>Total Space</th>
	<th>Free Space</th>
</tr>
<%
	List<TempSpaceInfo> tempspaces = facade.getAllTempSpaces(sessionToken);
	for (TempSpaceInfo tsi : tempspaces) {
		%>
		<tr>
		<td><%= tsi.getResolvedPath() %></td>
		<td><%= FileUtils.byteCountToDisplaySize(tsi.getTotalSpace()) %></td>
		<td><%= FileUtils.byteCountToDisplaySize(tsi.getFreeSpace()) %></td>
		</tr>
		<%
	}
%>
</table>

<h2>Running Jobs</h2>
<table border="1" class="infoTable">
<tr>
	<th>Run ID</th>
	<th>Sandbox</th>
	<th>Job File</th>
	<th>Job Type</th>
	<th>Status</th>
</tr>
<%
	List<JobInfo> jobs = facade.getRunningJobsInfo(sessionToken);
	for (JobInfo job : jobs) {
		%>
		<tr>
		<td><%= job.getRunId() %></td>
		<td><%= job.getSandboxCode() %></td>
		<td><%= job.getFile() %></td>
		<td><%= job.getJobType() %></td>
		<td><%= job.getStatus() %></td>
		</tr>
		<%
	}
%>
</table>

</body>
</html>
