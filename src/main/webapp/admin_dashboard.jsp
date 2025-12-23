<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.donorflow.config.DBClass" %>

<%
    String role = (String) session.getAttribute("uRole");
    if(role == null || !"ADMIN".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin Dashboard - DonorFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans min-h-screen">

    <nav class="bg-gray-900 text-white p-4 shadow-md sticky top-0 z-50">
        <div class="container mx-auto flex justify-between items-center">
            <span class="text-xl font-bold text-red-500">DonorFlow <span class="text-white">Admin</span></span>
            <div class="flex gap-4 items-center">
                <span class="text-gray-400 text-sm">Administrator Mode</span>
                <a href="LogoutServlet" class="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded text-sm transition">Logout</a>
            </div>
        </div>
    </nav>

    <main class="container mx-auto p-6 max-w-7xl">

        <% if(request.getParameter("msg") != null) { %>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-6 font-bold text-center shadow-sm">
                ✅ <%= request.getParameter("msg") %>
            </div>
        <% } %>
        <% if(request.getParameter("error") != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-6 font-bold text-center shadow-sm">
                ❌ <%= request.getParameter("error") %>
            </div>
        <% } %>

        <% Connection con = DBClass.getConnection(); %>

        <div class="bg-white rounded-lg shadow p-6 mb-8">
            <h3 class="text-lg font-bold text-gray-800 mb-4 border-b pb-2">🩸 Live Blood Stock</h3>
            <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-8 gap-4">
                <%
                    ResultSet rsStock = con.createStatement().executeQuery("SELECT * FROM blood_stock");
                    while(rsStock.next()) {
                        int units = rsStock.getInt("units_available");
                        String colorClass = (units > 5) ? "bg-green-100 text-green-800" : (units > 0) ? "bg-yellow-100 text-yellow-800" : "bg-red-100 text-red-800";
                %>
                <div class="<%= colorClass %> p-4 rounded-xl text-center border border-gray-200 shadow-sm transition hover:scale-105">
                    <span class="block text-xl font-black"><%= rsStock.getString("blood_group") %></span>
                    <span class="block text-sm font-medium"><%= units %> Units</span>
                </div>
                <% } %>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">

            <div class="bg-white rounded-lg shadow overflow-hidden h-fit">
                <div class="bg-red-50 p-4 border-b border-red-100">
                    <h3 class="font-bold text-red-800">Pending Donations</h3>
                </div>
                <table class="w-full text-left text-sm">
                    <thead class="bg-gray-50 text-gray-600 border-b">
                        <tr><th class="p-3">User</th><th>Group</th><th>Date</th><th class="text-right p-3">Action</th></tr>
                    </thead>
                    <tbody class="divide-y">
                        <%
                            // Make sure 'donation_id' matches your DB column
                            String sqlDon = "SELECT d.*, u.full_name, u.blood_group FROM donations d JOIN users u ON d.user_id = u.user_id WHERE d.status='Pending' ORDER BY d.donation_id DESC";
                            ResultSet rsDon = con.createStatement().executeQuery(sqlDon);
                            boolean hasDon = false;
                            while(rsDon.next()) { hasDon = true;
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="p-3"><%= rsDon.getString("full_name") %></td>
                            <td class="p-3 font-bold text-red-600"><%= rsDon.getString("blood_group") %></td>
                            <td class="p-3 text-xs text-gray-500"><%= rsDon.getString("donation_date") %></td>
                            <td class="p-3 flex justify-end gap-2">

                                <form action="AdminActionServlet" method="post">
                                    <input type="hidden" name="action" value="approveDonation">
                                    <input type="hidden" name="id" value="<%= rsDon.getInt("donation_id") %>">
                                    <button class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600 shadow-sm font-bold text-xs">✔ Approve</button>
                                </form>

                                <form action="AdminActionServlet" method="post">
                                    <input type="hidden" name="action" value="rejectDonation">
                                    <input type="hidden" name="id" value="<%= rsDon.getInt("donation_id") %>">
                                    <button class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 shadow-sm font-bold text-xs">✘ Reject</button>
                                </form>
                            </td>
                        </tr>
                        <% } if(!hasDon) { %> <tr><td colspan="4" class="p-4 text-center text-gray-400">No pending donations.</td></tr> <% } %>
                    </tbody>
                </table>
            </div>

            <div class="bg-white rounded-lg shadow overflow-hidden h-fit">
                <div class="bg-yellow-50 p-4 border-b border-yellow-100">
                    <h3 class="font-bold text-yellow-800">Pending Requests</h3>
                </div>
                <table class="w-full text-left text-sm">
                    <thead class="bg-gray-50 text-gray-600 border-b">
                        <tr><th class="p-3">User</th><th>Need</th><th>Units</th><th class="text-right p-3">Action</th></tr>
                    </thead>
                    <tbody class="divide-y">
                        <%
                            String sqlReq = "SELECT r.*, u.full_name FROM requests r JOIN users u ON r.user_id = u.user_id WHERE r.status='Pending' ORDER BY r.req_id DESC";
                            ResultSet rsReq = con.createStatement().executeQuery(sqlReq);
                            boolean hasReq = false;
                            while(rsReq.next()) { hasReq = true;
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="p-3"><%= rsReq.getString("full_name") %></td>
                            <td class="p-3 font-bold text-red-600"><%= rsReq.getString("blood_group") %></td>
                            <td class="p-3"><%= rsReq.getInt("units_needed") %></td>
                            <td class="p-3 flex justify-end gap-2">

                                <form action="AdminActionServlet" method="post">
                                    <input type="hidden" name="action" value="approveRequest">
                                    <input type="hidden" name="id" value="<%= rsReq.getInt("req_id") %>">
                                    <button class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600 shadow-sm font-bold text-xs">✔ Approve</button>
                                </form>

                                <form action="AdminActionServlet" method="post">
                                    <input type="hidden" name="action" value="rejectRequest">
                                    <input type="hidden" name="id" value="<%= rsReq.getInt("req_id") %>">
                                    <button class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 shadow-sm font-bold text-xs">✘ Reject</button>
                                </form>
                            </td>
                        </tr>
                        <% } if(!hasReq) { %> <tr><td colspan="4" class="p-4 text-center text-gray-400">No pending requests.</td></tr> <% } %>
                    </tbody>
                </table>
            </div>

        </div>

        <div class="bg-white rounded-lg shadow overflow-hidden mb-8">
            <div class="bg-blue-50 p-4 border-b border-blue-100">
                <h3 class="font-bold text-blue-800">👥 Registered Users Directory</h3>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm">
                    <thead class="bg-gray-50 text-gray-600 border-b">
                        <tr>
                            <th class="p-3">ID</th>
                            <th class="p-3">Full Name</th>
                            <th class="p-3">Blood Group</th>
                            <th class="p-3">City</th>
                            <th class="p-3">Phone</th>
                            <th class="p-3">Email</th>
                            <th class="p-3">Last Donation</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y">
                        <%
                            String sqlUsers = "SELECT * FROM users WHERE role='USER' ORDER BY user_id DESC";
                            ResultSet rsUsers = con.createStatement().executeQuery(sqlUsers);
                            while(rsUsers.next()) {
                                String lastDon = rsUsers.getString("last_donation_date");
                                if(lastDon == null) lastDon = "-";
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="p-3 text-gray-500">#<%= rsUsers.getInt("user_id") %></td>
                            <td class="p-3 font-bold"><%= rsUsers.getString("full_name") %></td>
                            <td class="p-3 text-red-600 font-bold"><%= rsUsers.getString("blood_group") %></td>
                            <td class="p-3"><%= rsUsers.getString("city") %></td>
                            <td class="p-3"><%= rsUsers.getString("phone_number") %></td>
                            <td class="p-3 text-gray-500"><%= rsUsers.getString("email") %></td>
                            <td class="p-3 text-gray-500"><%= lastDon %></td>
                        </tr>
                        <% } con.close(); %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</body>
</html>