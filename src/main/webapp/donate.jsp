<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("uId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Donate Blood - Eligibility Check</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        input { transition: all 0.2s ease-in-out; }
    </style>
    <script>
        window.onload = function() {
            let today = new Date().toISOString().split('T')[0];
            document.getElementById("dateInput").setAttribute('min', today);
        };

        function showError(inputId, message) {
            let input = document.getElementById(inputId);
            let errText = document.getElementById("err-" + inputId);
            input.classList.add("border-red-500", "bg-red-50");
            input.classList.remove("border-gray-300");
            errText.innerText = message;
            errText.classList.remove("hidden");
        }

        function clearErrors() {
            let inputs = document.querySelectorAll("input");
            inputs.forEach(i => {
                i.classList.remove("border-red-500", "bg-red-50");
                i.classList.add("border-gray-300");
            });
            let errs = document.querySelectorAll("[id^='err-']");
            errs.forEach(e => e.classList.add("hidden"));
            document.getElementById("globalError").classList.add("hidden");
        }

        async function submitDonation(event) {
            event.preventDefault();
            clearErrors();

            let hasError = false;

            // --- 1. Get Values ---
            let weightInput = document.getElementById("weight");
            let ageInput = document.getElementById("age");
            let dateInput = document.getElementById("dateInput");
            let cityInput = document.getElementById("cityArea");
            let unitsInput = document.getElementById("units");

            let weight = parseInt(weightInput.value);
            let age = parseInt(ageInput.value);
            let dateVal = dateInput.value;
            let cityVal = cityInput.value;
            let unitsVal = parseInt(unitsInput.value);

            // --- 2. Validation ---
            if (!weightInput.value) { showError("weight", "Weight is required"); hasError = true; }
            else if (weight < 50) { showError("weight", "Min weight is 50kg"); hasError = true; }

            if (!ageInput.value) { showError("age", "Age is required"); hasError = true; }
            else if (age < 18 || age > 65) { showError("age", "Must be 18-65 years old"); hasError = true; }

            if (!dateVal) { showError("dateInput", "Date is required"); hasError = true; }
            else {
                let selectedDate = new Date(dateVal);
                let today = new Date();
                today.setHours(0,0,0,0);
                if(selectedDate < today) { showError("dateInput", "Please select a future date"); hasError = true; }
            }

            if (!cityVal) { showError("cityArea", "City is required"); hasError = true; }

            let tattoos = document.querySelector('input[name="q_tattoo"]:checked').value;
            let alcohol = document.querySelector('input[name="q_alcohol"]:checked').value;
            let surgery = document.querySelector('input[name="q_surgery"]:checked').value;
            let infection = document.querySelector('input[name="q_infection"]:checked').value;

            if (tattoos === "yes" || alcohol === "yes" || surgery === "yes" || infection === "yes") {
                let box = document.getElementById("globalError");
                box.innerText = "❌ You are not eligible due to medical safety rules.";
                box.classList.remove("hidden");
                hasError = true;
            }

            if(hasError) return;

            // --- 3. SEND AS JSON ---
            let btn = document.getElementById("submitBtn");
            btn.innerText = "Processing...";
            btn.disabled = true;

            let jsonData = {
                date: dateVal,
                location: cityVal,
                units: unitsVal
            };

            try {
                let response = await fetch("DonateServlet", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(jsonData)
                });

                let result = await response.json();

                if(result.status === "success") {
                    alert("✅ Donation Scheduled! Downloading your Slip...");

                    // --- FIX IS HERE: Pointing to DocServlet ---
                    window.open("DocServlet?type=donation&doc=slip&id=" + result.donationId, "_blank");

                    window.location.href = "user_dashboard.jsp";
                } else {
                    let box = document.getElementById("globalError");
                    box.innerText = "❌ " + result.message;
                    box.classList.remove("hidden");
                    btn.innerText = "✅ Submit & Schedule Donation";
                    btn.disabled = false;
                }
            } catch (e) {
                console.error(e);
                let box = document.getElementById("globalError");
                box.innerText = "❌ Server Error. Please try again.";
                box.classList.remove("hidden");
                btn.innerText = "✅ Submit & Schedule Donation";
                btn.disabled = false;
            }
        }
    </script>
</head>
<body class="bg-gray-50 font-sans min-h-screen py-10">

    <div class="max-w-3xl mx-auto bg-white p-8 rounded-xl shadow-lg border-t-4 border-red-600">
        <div class="text-center mb-8">
            <h2 class="text-3xl font-bold text-gray-800">Donor Eligibility Form 📋</h2>
            <p class="text-gray-500">Please answer honestly. Safe blood saves lives.</p>
        </div>

        <form onsubmit="submitDonation(event)">
            <h3 class="text-lg font-bold text-red-600 border-b pb-2 mb-4">1. Physical Check</h3>
            <div class="grid grid-cols-2 gap-6 mb-6">
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Current Weight (kg)</label>
                    <input type="number" id="weight" placeholder="e.g. 65" class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                    <p id="err-weight" class="text-red-500 text-xs mt-1 hidden font-bold"></p>
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Age</label>
                    <input type="number" id="age" placeholder="e.g. 24" class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                    <p id="err-age" class="text-red-500 text-xs mt-1 hidden font-bold"></p>
                </div>
            </div>

            <h3 class="text-lg font-bold text-red-600 border-b pb-2 mb-4">2. Medical Screening</h3>
            <div class="bg-blue-50 border-l-4 border-blue-500 text-blue-800 p-4 rounded shadow-sm mb-6 flex items-start gap-3">
                <svg class="w-6 h-6 text-blue-500 mt-1 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
                <div>
                    <p class="font-bold text-sm">Important Medical Note</p>
                    <p class="text-sm mt-1">This screening is for pre-qualification only. Final eligibility is determined by authorized hospital staff.</p>
                </div>
            </div>

            <div class="space-y-4 mb-6 text-sm text-gray-800">
                <div class="flex justify-between items-center bg-gray-50 p-3 rounded hover:bg-gray-100 transition">
                    <span>Have you had a <b>tattoo or piercing</b> in the last 6 months?</span>
                    <div class="flex gap-4"><label><input type="radio" name="q_tattoo" value="yes"> Yes</label><label><input type="radio" name="q_tattoo" value="no" checked> No</label></div>
                </div>
                <div class="flex justify-between items-center bg-gray-50 p-3 rounded hover:bg-gray-100 transition">
                    <span>Have you consumed <b>alcohol</b> in the last 24 hours?</span>
                    <div class="flex gap-4"><label><input type="radio" name="q_alcohol" value="yes"> Yes</label><label><input type="radio" name="q_alcohol" value="no" checked> No</label></div>
                </div>
                <div class="flex justify-between items-center bg-gray-50 p-3 rounded hover:bg-gray-100 transition">
                    <span>Have you had <b>major surgery</b> in the last 6 months?</span>
                    <div class="flex gap-4"><label><input type="radio" name="q_surgery" value="yes"> Yes</label><label><input type="radio" name="q_surgery" value="no" checked> No</label></div>
                </div>
                <div class="flex justify-between items-center bg-gray-50 p-3 rounded hover:bg-gray-100 transition">
                    <span>Do you have HIV, Hepatitis, or any chronic blood disease?</span>
                    <div class="flex gap-4"><label><input type="radio" name="q_infection" value="yes"> Yes</label><label><input type="radio" name="q_infection" value="no" checked> No</label></div>
                </div>
            </div>

            <h3 class="text-lg font-bold text-red-600 border-b pb-2 mb-4">3. Appointment Details</h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Preferred Date</label>
                    <input type="date" id="dateInput" class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                    <p id="err-dateInput" class="text-red-500 text-xs mt-1 hidden font-bold"></p>
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">City / Area</label>
                    <input type="text" id="cityArea" placeholder="e.g. Vellore" class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                    <p id="err-cityArea" class="text-red-500 text-xs mt-1 hidden font-bold"></p>
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Units to Donate</label>
                    <input type="number" id="units" value="1" min="1" max="3" class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                    <p class="text-xs text-gray-500 mt-1">Min: 1, Max: 3</p>
                </div>
            </div>

            <div id="globalError" class="hidden bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4 font-bold text-center text-sm"></div>

            <button type="submit" id="submitBtn" class="w-full bg-red-600 text-white font-bold py-4 rounded-lg hover:bg-red-700 transition shadow-lg text-lg">
                ✅ Submit & Schedule Donation
            </button>
            <a href="user_dashboard.jsp" class="block text-center text-gray-500 text-sm mt-4 hover:underline">Cancel</a>
        </form>
    </div>
</body>
</html>