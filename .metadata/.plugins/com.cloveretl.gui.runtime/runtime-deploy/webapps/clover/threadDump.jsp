<%@ page import="java.lang.management.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.cloveretl.server.utils.LogUtils" %>
<h2>Threads</h2>
<%
ThreadMXBean bean = ManagementFactory.getThreadMXBean();
ThreadInfo[] tis = bean.getThreadInfo(bean.getAllThreadIds(), true, true);
%>
<p>Thread count: <%= tis.length %></p>
<script type="text/javascript">
//<![CDATA[
function showHideThreads(button) {
	var container = document.getElementById("threads");
	if (container.style.display == "none") {
		container.style.display = "block";
		button.innerHTML = "Hide &lt;&lt;";
	} else {
		container.style.display = "none";
		button.innerHTML = "Show &gt;&gt;";
	}
}
//]]>
</script>
<button type="button" onclick="showHideThreads(this);">Show &gt;&gt;</button>
<div id="threads" style="display: none;">
<%
	for (ThreadInfo ti : tis) {
		out.println("<pre>" + ti + "</pre>");
	}
%>
</div>