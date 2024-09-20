<%@ page import="org.jetel.util.DirectMemoryUtils" %>
<%@ page import="java.lang.management.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.io.*" %>
<h2>Memory</h2>
<table class="infoTable" border="1">
<tr>
	<th>Name</th>
	<th>Type</th>
	<th colspan="5">Usage</th>
</tr>
<tr>
	<th colspan="2" />
	<th />
	<th>Initial</th>
	<th>Used</th>
	<th>Committed</th>
	<th>Max</th>
</tr>
<%
	MemoryMXBean memBean = ManagementFactory.getMemoryMXBean();
	MemoryUsage heap = memBean.getHeapMemoryUsage();
	MemoryUsage nonHeap = memBean.getNonHeapMemoryUsage();
%>
<tr>
	<th rowspan="2">Summary</th>
	<td><%= MemoryType.HEAP %></td>
	<td />
	<td><%= FileUtils.byteCountToDisplaySize(heap.getInit()) %></td>
	<td><%= FileUtils.byteCountToDisplaySize(heap.getUsed()) %></td>
	<td><%= FileUtils.byteCountToDisplaySize(heap.getCommitted()) %></td>
	<td><%= FileUtils.byteCountToDisplaySize(heap.getMax()) %></td>
</tr>
<tr>
	<td><%= MemoryType.NON_HEAP %></td>
	<td />
	<td><%= FileUtils.byteCountToDisplaySize(nonHeap.getInit()) %></td>
	<td><%= FileUtils.byteCountToDisplaySize(nonHeap.getUsed()) %></td>
	<td><%= FileUtils.byteCountToDisplaySize(nonHeap.getCommitted()) %></td>
	<td><%= FileUtils.byteCountToDisplaySize(nonHeap.getMax()) %></td>
</tr>
<%
	Iterator<MemoryPoolMXBean> it = ManagementFactory.getMemoryPoolMXBeans().iterator();
	while (it.hasNext()) {
		MemoryPoolMXBean pool = it.next();
%>
		<tr>
			<th rowspan="2"><%= pool.getName() %></th>
			<td rowspan="2"><%= pool.getType() %></td>
			<td>Usage</td>
			<td><%= FileUtils.byteCountToDisplaySize(pool.getUsage().getInit()) %></td>
			<td><%= FileUtils.byteCountToDisplaySize(pool.getUsage().getUsed()) %></td>
			<td><%= FileUtils.byteCountToDisplaySize(pool.getUsage().getCommitted()) %></td>
			<td><%= FileUtils.byteCountToDisplaySize(pool.getUsage().getMax()) %></td>
		</tr>
		<tr>
			<td>Peak</td>
			<td><%= FileUtils.byteCountToDisplaySize(pool.getPeakUsage().getInit()) %></td>
			<td><%= FileUtils.byteCountToDisplaySize(pool.getPeakUsage().getUsed()) %></td>
			<td><%= FileUtils.byteCountToDisplaySize(pool.getPeakUsage().getCommitted()) %></td>
			<td><%= FileUtils.byteCountToDisplaySize(pool.getPeakUsage().getMax()) %></td>
		</tr>
<% 	}
%>
<tr>
	<th>Direct Memory</th>
	<td />
	<td />
	<td />
	<td><%= FileUtils.byteCountToDisplaySize(DirectMemoryUtils.getDirectMemoryUsage()) %></td>
	<td><%= FileUtils.byteCountToDisplaySize(DirectMemoryUtils.getDirectMemoryTotalCapacity()) %></td>
	<td />
</tr>
</table>
