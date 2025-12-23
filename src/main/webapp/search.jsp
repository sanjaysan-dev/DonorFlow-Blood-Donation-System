<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.donorflow.config.DBClass" %>
<%@ page import="java.time.LocalDate" %>

<%
    // Security Check: User must be logged in to see personal details like Phone Number
    if(session.getAttribute("uId") == null) {
        response.sendRedirect("login.jsp?msg=Please Login to Search Donors");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Find Donors - DonorFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 font-sans min-h-screen">

    <nav class="bg-red-600 text-white p-4 shadow mb-8 sticky top-0 z-50">
        <div class="container mx-auto flex justify-between items-center">
            <span class="font-bold text-xl flex items-center gap-2">
                🔍 DonorFlow Search
            </span>
            <a href="user_dashboard.jsp" class="bg-white text-red-600 px-4 py-1 rounded-full text-sm font-bold hover:bg-red-50 transition">
                Back to Dashboard
            </a>
        </div>
    </nav>

    <main class="container mx-auto p-6 max-w-5xl">

        <div class="bg-white p-6 rounded-xl shadow-md mb-8 border border-gray-100">
            <h2 class="text-xl font-bold text-gray-800 mb-4">Filter Donors</h2>

            <form action="search.jsp" method="get" class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">

                <div class="md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-1">City / Location</label>
                    <input type="text" name="city" placeholder="Type a city (e.g. Vellore)"
                           value="<%= request.getParameter("city") != null ? request.getParameter("city") : "" %>"
                           class="w-full p-3 border rounded-lg bg-gray-50 focus:ring-2 focus:ring-red-500 outline-none">
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Blood Group</label>
                    <select name="group" class="w-full p-3 border rounded-lg bg-gray-50 focus:ring-2 focus:ring-red-500 outline-none">
                        <option value="">All Groups</option>
                        <%
                            String[] groups = {"O+", "A+", "B+", "AB+", "O-", "A-", "B-", "AB-"};
                            String selectedGroup = request.getParameter("group");
                            for(String g : groups) {
                                String selected = (g.equals(selectedGroup)) ? "selected" : "";
                        %>
                            <option value="<%= g %>" <%= selected %>><%= g %></option>
                        <% } %>
                    </select>
                </div>

                <button type="submit" class="bg-red-600 text-white p-3 rounded-lg font-bold hover:bg-red-700 transition shadow-md">
                    Apply Filters
                </button>
            </form>
        </div>

        <div class="bg-white rounded-xl shadow-lg overflow-hidden border border-gray-200">
            <div class="bg-gray-100 px-6 py-4 border-b flex justify-between items-center">
                <h3 class="font-bold text-gray-700">Eligible Donors List (Safe < 90 Days)</h3>
                <span class="text-xs text-gray-400">Showing top 50 results</span>
            </div>

            <table class="w-full text-left border-collapse">
                <thead class="bg-gray-50 text-gray-600 border-b text-sm uppercase tracking-wider">
                    <tr>
                        <th class="p-4">Donor Name</th>
                        <th class="p-4">Group</th>
                        <th class="p-4">City</th>
                        <th class="p-4">Contact</th>
                        <th class="p-4">Status</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 text-sm">
                    <%
                        Connection con = DBClass.getConnection();

                        // 1. Base Query: Always check 90-Day Rule
                        String safeDate = LocalDate.now().minusDays(90).toString();

                        // "Show users where Last Donation is NULL (never donated) OR Older than 90 days"
                        String sql = "SELECT full_name, blood_group, city, phone_number, last_donation_date FROM users " +
                                     "WHERE role = 'USER' AND    (last_donation_date IS NULL OR last_donation_date < ?)";

                        // 2. Dynamic Filtering Logic
                        String sCity = request.getParameter("city");
                        String sGroup = request.getParameter("group");

                        // If City is typed, add to SQL
                        if(sCity != null && !sCity.trim().isEmpty()) {
                            sql += " AND city LIKE ?";
                        }
                        // If Group is selected, add to SQL
                        if(sGroup != null && !sGroup.trim().isEmpty()) {
                            sql += " AND blood_group = ?";
                        }

                        // Order alphabetically and limit to prevent crashing
                        sql += " ORDER BY full_name ASC LIMIT 50";

                        PreparedStatement ps = con.prepareStatement(sql);

                        // 3. Set Parameters Dynamically (Ordering matters!)
                        int paramIndex = 1;
                        ps.setString(paramIndex++, safeDate); // The 90-day date is always parameter #1

                        if(sCity != null && !sCity.trim().isEmpty()) {
                            ps.setString(paramIndex++, "%" + sCity + "%");
                        }
                        if(sGroup != null && !sGroup.trim().isEmpty()) {
                            ps.setString(paramIndex++, sGroup);
                        }

                        ResultSet rs = ps.executeQuery();
                        boolean found = false;

                        while(rs.next()) {
                            found = true;
                    %>
                    <tr class="hover:bg-red-50 transition cursor-pointer">
                        <td class="p-4 font-bold text-gray-800">
                            <%= rs.getString("full_name") %>
                        </td>
                        <td class="p-4">
                            <span class="bg-red-100 text-red-700 px-2 py-1 rounded font-bold border border-red-200">
                                <%= rs.getString("blood_group") %>
                            </span>
                        </td>
                        <td class="p-4 text-gray-600"><%= rs.getString("city") %></td>
                        <td class="p-4 font-medium text-blue-600">
                            📞 <%= rs.getString("phone_number") %>
                        </td>
                        <td class="p-4">
                            <span class="flex items-center gap-1 text-green-600 font-bold text-xs">
                                ✅ Available
                            </span>
                        </td>
                    </tr>
                    <%
                        }
                        if(!found) {
                    %>
                        <tr>
                            <td colspan="5" class="p-8 text-center">
                                <div class="text-gray-400 text-lg">No eligible donors found matching these filters.</div>
                                <div class="text-gray-300 text-sm mt-1">Try clearing the city or group.</div>
                            </td>
                        </tr>
                    <%
                        }
                        con.close();
                    %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>