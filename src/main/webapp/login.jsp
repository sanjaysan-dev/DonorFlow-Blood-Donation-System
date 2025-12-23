<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DonorFlow - Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        input { transition: all 0.2s ease-in-out; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">

    <nav class="bg-red-600 text-white shadow-md p-4 sticky top-0 z-50">
        <div class="container mx-auto flex justify-between items-center">
            <a href="index.jsp" class="flex items-center gap-2 text-2xl font-bold cursor-pointer">DonorFlow</a>
            <div class="hidden md:flex space-x-6 font-medium items-center">
                <a href="index.jsp" class="hover:text-red-200 transition">Home</a>
                <a href="register.jsp" class="bg-white text-red-600 px-4 py-2 rounded-full hover:bg-red-100 transition shadow-sm">Join Us</a>
            </div>
        </div>
    </nav>

    <main class="flex-grow flex items-center justify-center px-4">
        <div class="bg-white p-8 rounded-2xl shadow-xl w-full max-w-sm border border-gray-100">

            <div class="text-center mb-8">
                <h2 class="text-3xl font-bold text-gray-800">Welcome Back</h2>
                <p class="text-gray-500">Login to search for blood or donate.</p>
            </div>

            <div id="globalError" class="hidden bg-red-100 border border-red-400 text-red-700 px-4 py-2 rounded mb-4 text-sm text-center"></div>

            <div id="successBanner" class="hidden bg-green-100 border border-green-400 text-green-700 px-4 py-2 rounded mb-4 text-sm text-center">
                Login Verified! Redirecting...
            </div>

            <form onsubmit="loginUser(event)" id="loginForm" class="space-y-4">

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                    <input type="email" id="email" placeholder="user@example.com"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 transition">
                    <p id="err-email" class="text-red-500 text-xs mt-1 hidden"></p>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                    <input type="password" id="password" placeholder="••••••••"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 transition">
                    <p id="err-password" class="text-red-500 text-xs mt-1 hidden"></p>
                </div>

                <button type="submit" id="loginBtn" class="w-full bg-red-600 text-white py-3 rounded-lg font-bold hover:bg-red-700 transition shadow-md">
                    Login
                </button>
            </form>

            <p class="mt-6 text-center text-gray-600">
                New User? <a href="register.jsp" class="text-red-600 font-bold hover:underline">Register Here</a>
            </p>
        </div>
    </main>

    <footer class="bg-gray-900 text-white p-6 mt-auto text-center text-gray-400">
        &copy; 2025 DonorFlow.
    </footer>

    <script>
        // Helper: Show specific input error
        function showError(inputId, message) {
            let input = document.getElementById(inputId);
            let errText = document.getElementById("err-" + inputId);

            input.classList.add("border-red-500", "bg-red-50");
            input.classList.remove("border-gray-300");

            errText.innerText = message;
            errText.classList.remove("hidden");
        }

        // Helper: Clear all errors
        function clearErrors() {
            document.querySelectorAll("input").forEach(i => {
                i.classList.remove("border-red-500", "bg-red-50");
                i.classList.add("border-gray-300");
            });
            document.querySelectorAll("[id^='err-']").forEach(e => e.classList.add("hidden"));
            document.getElementById("globalError").classList.add("hidden");
        }

        function loginUser(event) {
            event.preventDefault();
            clearErrors();

            let email = document.getElementById("email").value.trim();
            let password = document.getElementById("password").value;
            let hasError = false;

            // --- 1. FRONTEND VALIDATION ---
            if (email === "" || !email.includes("@")) {
                showError("email", "Please enter a valid email address.");
                hasError = true;
            }
            if (password === "") {
                showError("password", "Password cannot be empty.");
                hasError = true;
            }

            if (hasError) return;

            // --- 2. SEND TO SERVER ---
            let btn = document.getElementById("loginBtn");
            btn.innerText = "Verifying...";
            btn.disabled = true;
            btn.classList.add("opacity-50", "cursor-not-allowed");

            let formData = {
                email: email,
                password: password
            };

            fetch("LoginServlet", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === "success") {
                    // Success!
                    document.getElementById("successBanner").classList.remove("hidden");
                    setTimeout(() => {
                        window.location.href = data.redirectUrl; // Redirect to user/admin dashboard
                    }, 1000);
                } else {
                    // Failure (Wrong Password)
                    let globalErr = document.getElementById("globalError");
                    globalErr.innerText = data.message;
                    globalErr.classList.remove("hidden");

                    // Reset Button
                    btn.innerText = "Login";
                    btn.disabled = false;
                    btn.classList.remove("opacity-50", "cursor-not-allowed");
                }
            })
            .catch(error => {
                console.error("Error:", error);
                document.getElementById("globalError").innerText = "Server Error. Check Connection.";
                document.getElementById("globalError").classList.remove("hidden");

                btn.innerText = "Login";
                btn.disabled = false;
                btn.classList.remove("opacity-50", "cursor-not-allowed");
            });
        }

        // Check for URL params (e.g., from Register success)
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');
        if (msg) {
            let banner = document.getElementById("successBanner");
            banner.innerText = msg;
            banner.classList.remove("hidden");
        }
    </script>
</body>
</html>