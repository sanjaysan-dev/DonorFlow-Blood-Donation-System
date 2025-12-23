<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DonorFlow - Register</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* Custom Transition for smooth border color change */
        input, select { transition: all 0.2s ease-in-out; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">

    <nav class="bg-red-600 text-white shadow-md p-4 sticky top-0 z-50">
        <div class="container mx-auto flex justify-between items-center">
            <a href="index.jsp" class="flex items-center gap-2 text-2xl font-bold cursor-pointer">DonorFlow</a>
            <div class="hidden md:flex space-x-6 font-medium items-center">
                <a href="index.jsp" class="hover:text-red-200 transition">Home</a>
                <a href="login.jsp" class="hover:text-red-200 transition">Login</a>
            </div>
        </div>
    </nav>

    <main class="flex-grow flex items-center justify-center px-4 py-10">
        <div class="bg-white p-8 rounded-2xl shadow-xl w-full max-w-md border border-gray-100 relative">

            <h2 class="text-3xl font-bold text-center text-gray-800 mb-6">Create Account</h2>

            <div id="successBanner" class="hidden bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4 text-center">
                <p class="font-bold">Registration Successful!</p>
                <p class="text-sm">Redirecting to Login...</p>
            </div>

            <div id="errorBanner" class="hidden bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4 text-center"></div>

            <form onsubmit="registerUser(event)" class="space-y-4" id="regForm">

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Full Name</label>
                    <input type="text" name="fullName" id="fullName" placeholder="John Doe"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                    <p id="err-fullName" class="text-red-500 text-xs mt-1 hidden"></p>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Phone Number</label>
                    <input type="tel" name="phoneNumber" id="phoneNumber" placeholder="9876543210"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                    <p id="err-phoneNumber" class="text-red-500 text-xs mt-1 hidden"></p>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Email Address</label>
                    <input type="email" name="email" id="email" placeholder="john@example.com"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                    <p id="err-email" class="text-red-500 text-xs mt-1 hidden"></p>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                    <input type="password" name="password" id="password" placeholder="Create Password"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                    <p id="err-password" class="text-red-500 text-xs mt-1 hidden"></p>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Confirm Password</label>
                    <input type="password" id="confirmPassword" placeholder="Repeat Password"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                    <p id="err-confirmPassword" class="text-red-500 text-xs mt-1 hidden"></p>
                </div>

                <div class="flex gap-4">
                    <div class="w-1/2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Blood Group</label>
                        <select name="bloodGroup" id="bloodGroup" class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                            <option value="">Select</option>
                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="O+">O+</option>
                            <option value="O-">O-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                            <option value="Rh-null">Rh-null</option>
                        </select>
                        <p id="err-bloodGroup" class="text-red-500 text-xs mt-1 hidden"></p>
                    </div>
                    <div class="w-1/2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">City</label>
                        <input type="text" name="city" id="city" placeholder="Vellore"
                               class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                        <p id="err-city" class="text-red-500 text-xs mt-1 hidden"></p>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Last Donation Date <span class="text-gray-400 font-normal">(Optional)</span></label>
                    <input type="date" name="lastDonateDate" id="lastDonateDate"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
                </div>

                <button type="submit" id="submitBtn" class="w-full bg-red-600 text-white py-3 rounded-lg font-bold hover:bg-red-700 transition shadow-md">
                    Register Now
                </button>
            </form>

            <p class="mt-4 text-center text-gray-600">Already a member? <a href="login.jsp" class="text-red-600 font-bold hover:underline">Login</a></p>
        </div>
    </main>

    <footer class="bg-gray-900 text-white p-6 mt-auto text-center text-gray-400">
        &copy; 2025 DonorFlow.
    </footer>

    <script>

        const today = new Date().toISOString().split('T')[0];

        // Set the 'max' attribute of the calendar to Today
        document.getElementById("lastDonateDate").setAttribute('max', today);
        // Helper: Show Error on specific field
        function showError(inputId, message) {
            let input = document.getElementById(inputId);
            let errorText = document.getElementById('err-' + inputId);

            // 1. Turn border Red
            input.classList.add('border-red-500', 'bg-red-50');
            input.classList.remove('border-gray-300');

            // 2. Show Error Text
            errorText.innerText = message;
            errorText.classList.remove('hidden');
        }

        // Helper: Clear all errors
        function clearErrors() {
            let inputs = document.querySelectorAll('input, select');
            let messages = document.querySelectorAll('[id^="err-"]');
            let globalErr = document.getElementById('errorBanner');

            inputs.forEach(i => {
                i.classList.remove('border-red-500', 'bg-red-50');
                i.classList.add('border-gray-300');
            });

            messages.forEach(m => m.classList.add('hidden'));
            globalErr.classList.add('hidden');
        }

        function registerUser(event) {
            event.preventDefault();
            clearErrors(); // Reset everything first

            let hasError = false;

            // --- 1. GET VALUES ---
            let fullName = document.getElementById("fullName").value.trim();
            let phone = document.getElementById("phoneNumber").value.trim();
            let email = document.getElementById("email").value.trim();
            let password = document.getElementById("password").value;
            let confirmPass = document.getElementById("confirmPassword").value;
            let bloodGroup = document.getElementById("bloodGroup").value;
            let city = document.getElementById("city").value.trim();
            let lastDonateDate = document.getElementById("lastDonateDate").value;

            // --- 2. VALIDATION (Using showError helper) ---

            // Name
            if (!/^[a-zA-Z\s]+$/.test(fullName)) {
                showError("fullName", "Invalid Name! Alphabets only.");
                hasError = true;
            }

            // Phone
            if (!/^[6-9]\d{9}$/.test(phone)) {
                showError("phoneNumber", "Invalid! Must be 10 digits (Start 6-9).");
                hasError = true;
            }

            // Email (Basic Check)
            if (email === "" || !email.includes("@")) {
                showError("email", "Please enter a valid email.");
                hasError = true;
            }

            // Blood Group
            if (bloodGroup === "") {
                showError("bloodGroup", "Please select a blood group.");
                hasError = true;
            }

            // Password Strength
            let passPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
            if (!passPattern.test(password)) {
                showError("password", "Weak! Need 8+ chars, Upper, Lower, Number & Special.");
                hasError = true;
            }

            // Password Match
            if (password !== confirmPass) {
                showError("confirmPassword", "Passwords do not match.");
                hasError = true;
            }

            // City
            if (city.length < 3) {
                showError("city", "City name too short.");
                hasError = true;
            }

            // Stop if errors exist
            if (hasError) return;

            // --- 3. SEND DATA (If all good) ---
            let formData = {
                fullName: fullName,
                phoneNumber: phone,
                email: email,
                password: password,
                bloodGroup: bloodGroup,
                city: city,
                lastDonateDate: lastDonateDate
            };

            // Disable button to prevent double click
            let btn = document.getElementById("submitBtn");
            btn.innerText = "Processing...";
            btn.disabled = true;
            btn.classList.add("opacity-50", "cursor-not-allowed");

            fetch("RegisterServlet", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === "success") {
                    // --- SUCCESS UI ---
                    // Hide Form, Show Success Banner
                    document.getElementById("regForm").classList.add("hidden");
                    document.getElementById("successBanner").classList.remove("hidden");

                    // Redirect after 1.5 seconds
                    setTimeout(() => {
                        window.location.href = "login.jsp?msg=" + encodeURIComponent(data.message);
                    }, 1500);

                } else {
                    // Server Error (e.g., Email exists)
                    let globalErr = document.getElementById('errorBanner');
                    globalErr.innerText = data.message;
                    globalErr.classList.remove('hidden');

                    // Reset button
                    btn.innerText = "Register Now";
                    btn.disabled = false;
                    btn.classList.remove("opacity-50", "cursor-not-allowed");
                }
            })
            .catch(error => {
                console.error("Error:", error);
                document.getElementById('errorBanner').innerText = "Server Error. Check Console.";
                document.getElementById('errorBanner').classList.remove('hidden');
            });
        }
    </script>
</body>
</html>