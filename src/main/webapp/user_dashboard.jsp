<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.donorflow.config.DBClass" %>

<%
    String userName = (String) session.getAttribute("uName");
    Integer userId = (Integer) session.getAttribute("uId");

    if(userId == null) {
        response.sendRedirect("login.jsp?msg=Please Login First");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Dashboard - DonorFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        input, select { transition: all 0.2s ease-in-out; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">

    <nav class="bg-red-600 text-white shadow-md p-4 sticky top-0 z-50">
        <div class="container mx-auto flex justify-between items-center">
            <span class="text-2xl font-bold">DonorFlow</span>
            <div class="flex gap-4 items-center">
                <span class="text-red-100 text-sm">Welcome, <%= userName %></span>
                <a href="LogoutServlet" class="bg-red-800 hover:bg-red-900 px-3 py-1 rounded text-sm transition">Logout</a>
            </div>
        </div>
    </nav>

    <main class="flex-grow container mx-auto p-6 max-w-6xl">

        <% if(request.getParameter("msg") != null) { %>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-6">
                <%= request.getParameter("msg") %>
            </div>
        <% } %>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-white p-6 rounded-xl shadow border-l-4 border-red-500 hover:shadow-lg transition">
                <h3 class="font-bold text-gray-800 mb-4">Donate Blood</h3>
                <p class="text-gray-500 mb-8 text-sm">Eligible? Schedule a donation now.</p>
                <a href="donate.jsp" class="block mt-4 text-center bg-red-600 text-white py-2 rounded font-bold hover:bg-red-700">Donate Now 🩸</a>
            </div>
            <div class="bg-white p-6 rounded-xl shadow border-l-4 border-blue-500 hover:shadow-lg transition">
                <h3 class="font-bold text-gray-800 mb-4">Find Blood</h3>
                <p class="text-gray-500 mb-8 text-sm">Search donors & stock availability.</p>
                <a href="search.jsp" class="block mt-4 text-center bg-blue-600 text-white py-2 rounded font-bold hover:bg-blue-700">Search 🔍</a>
            </div>

            <div class="bg-white p-6 rounded-xl shadow border-l-4 border-green-500">
                <h3 class="font-bold text-gray-800 mb-2">Request Blood</h3>
                <div class="space-y-2">
                    <input type="text" id="reqCity" placeholder="City" class="w-full p-2 border rounded text-sm">
                    <p id="err-reqCity" class="text-red-500 text-xs hidden"></p>

                    <div class="flex gap-2">
                        <select id="reqGroup" class="w-1/2 p-2 border rounded text-sm">
                            <option>O+</option><option>A+</option><option>B+</option><option>AB+</option>
                            <option>O-</option><option>A-</option><option>B-</option><option>AB-</option>
                            <option>Rh-null</option>
                        </select>
                        <input type="number" id="reqUnits" value="1" min="1" max="10" class="w-1/2 p-2 border rounded text-sm">
                    </div>

                    <p id="reqGlobalErr" class="text-red-600 text-xs hidden text-center"></p>
                    <button onclick="submitRequest()" id="reqBtn" class="w-full bg-green-500 text-white py-2 rounded font-bold text-sm hover:bg-green-600">Post Request</button>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">

            <% Connection con = DBClass.getConnection(); %>

            <div>
                <h3 class="text-lg font-bold mb-3 text-gray-700 border-b pb-2">🩸 My Donations</h3>
                <div class="bg-white rounded-xl shadow overflow-hidden border border-gray-200">
                    <table class="w-full text-left text-sm">
                        <thead class="bg-green-50 text-green-800">
                            <tr><th class="p-3">Date</th><th class="p-3">Status</th><th class="p-3 text-center">Docs</th></tr>
                        </thead>
                        <tbody class="divide-y">
                            <%
                                PreparedStatement ps1 = con.prepareStatement("SELECT * FROM donations WHERE user_id=? ORDER BY donation_date DESC");
                                ps1.setInt(1, userId);
                                ResultSet rs1 = ps1.executeQuery();
                                boolean hasDon = false;
                                while(rs1.next()) { hasDon = true;
                                    String st = rs1.getString("status");
                                    // Make sure this matches your DB column (donation_id vs don_id vs id)
                                    int dId = rs1.getInt("donation_id");
                                    String color = "Pending".equals(st) ? "text-yellow-600" : "Approved".equals(st) ? "text-green-600" : "text-red-600";
                            %>
                            <tr>
                                <td class="p-3"><%= rs1.getString("donation_date") %><br><span class="text-xs text-gray-500"><%= rs1.getString("camp_location") %></span></td>
                                <td class="p-3 font-bold <%= color %>"><%= st %></td>
                                <td class="p-3 flex justify-center gap-2">

                                    <a href="DocServlet?type=donation&doc=slip&id=<%=dId%>" target="_blank"
                                       class="flex items-center gap-1 bg-gray-100 border border-gray-300 text-gray-700 px-2 py-1 rounded hover:bg-gray-200 transition text-xs font-bold">
                                       📝 Slip
                                    </a>

                                    <% if("Approved".equals(st)) { %>
                                        <a href="DocServlet?type=donation&doc=cert&id=<%=dId%>" target="_blank"
                                           class="flex items-center gap-1 bg-green-100 border border-green-300 text-green-700 px-2 py-1 rounded hover:bg-green-200 transition text-xs font-bold">
                                           ✅ Cert
                                        </a>
                                    <% } %>

                                </td>
                            </tr>
                            <% } if(!hasDon) { %> <tr><td colspan="3" class="p-4 text-center text-gray-400">No donations yet.</td></tr> <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div>
                <h3 class="text-lg font-bold mb-3 text-gray-700 border-b pb-2">🚑 My Requests</h3>
                <div class="bg-white rounded-xl shadow overflow-hidden border border-gray-200">
                    <table class="w-full text-left text-sm">
                        <thead class="bg-red-50 text-red-800">
                            <tr><th class="p-3">Details</th><th class="p-3">Status</th><th class="p-3 text-center">Docs</th></tr>
                        </thead>
                        <tbody class="divide-y">
                            <%
                                PreparedStatement ps2 = con.prepareStatement("SELECT * FROM requests WHERE user_id=? ORDER BY req_id DESC");
                                ps2.setInt(1, userId);
                                ResultSet rs2 = ps2.executeQuery();
                                boolean hasReq = false;
                                while(rs2.next()) { hasReq = true;
                                    String st = rs2.getString("status");
                                    int rId = rs2.getInt("req_id");
                                    String color = "Pending".equals(st) ? "text-yellow-600" : "Approved".equals(st) ? "text-green-600" : "text-red-600";
                            %>
                            <tr>
                                <td class="p-3"><span class="font-bold"><%= rs2.getString("blood_group") %></span> <span class="text-gray-500 text-xs">(<%= rs2.getInt("units_needed") %> units)</span></td>
                                <td class="p-3 font-bold <%= color %>"><%= st %></td>
                                <td class="p-3 flex justify-center gap-2">

                                    <a href="DocServlet?type=request&doc=slip&id=<%=rId%>" target="_blank"
                                       class="flex items-center gap-1 bg-gray-100 border border-gray-300 text-gray-700 px-2 py-1 rounded hover:bg-gray-200 transition text-xs font-bold">
                                       📝 Slip
                                    </a>

                                    <% if("Approved".equals(st)) { %>
                                        <a href="DocServlet?type=request&doc=cert&id=<%=rId%>" target="_blank"
                                           class="flex items-center gap-1 bg-blue-100 border border-blue-300 text-blue-700 px-2 py-1 rounded hover:bg-blue-200 transition text-xs font-bold">
                                           ✅ Appr
                                        </a>
                                    <% } %>
                                </td>
                            </tr>
                            <% } if(!hasReq) { %> <tr><td colspan="3" class="p-4 text-center text-gray-400">No requests made.</td></tr> <% } con.close(); %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <script>
        function showError(id, msg) {
            let el = document.getElementById(id);
            let err = document.getElementById("err-" + id);
            el.classList.add("border-red-500", "bg-red-50");
            err.innerText = msg;
            err.classList.remove("hidden");
        }
        function clearErrors() {
            document.querySelectorAll("input, select").forEach(i => i.classList.remove("border-red-500", "bg-red-50"));
            document.querySelectorAll("[id^='err-']").forEach(e => e.classList.add("hidden"));
        }
        async function submitRequest() {
            clearErrors();
            let city = document.getElementById("reqCity").value.trim();
            let group = document.getElementById("reqGroup").value;
            let units = document.getElementById("reqUnits").value;
            if(!city) return showError("reqCity", "City required");
            if(units < 1) return showError("reqUnits", "Invalid units");

            let btn = document.getElementById("reqBtn");
            btn.innerText = "Processing..."; btn.disabled = true;

            try {
                let res = await fetch("RequestServlet", {
                    method: "POST", headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ city, bloodGroup: group, units: parseInt(units) })
                });
                let result = await res.json();
                if(result.status === "success") { alert("✅ " + result.message); location.reload(); }
                else {
                    document.getElementById("reqGlobalErr").innerText = result.message;
                    document.getElementById("reqGlobalErr").classList.remove("hidden");
                    btn.innerText = "Post Request"; btn.disabled = false;
                }
            } catch(e) { console.error(e); }
        }
    </script>
</body>
</html>